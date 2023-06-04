import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/models/food_category_model.dart';
import 'package:good_to_go/models/store_model.dart';
import 'package:good_to_go/screens/login/screens/userLocation_screen.dart';
import 'package:good_to_go/screens/store/screens/store_screen.dart';
import 'package:good_to_go/services/store_service.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:good_to_go/utilities/variables.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:good_to_go/api.dart';

import '../components/menu_category.dart';
import '../components/store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _address;
  Position? _currentPosition;
  User? _user;

  //final List<FoodCategory> _foodCategoryList = [];
  List<FoodCategory> _foodCategoryList = [];


  Future<List<StoreModel>> _storeModelList = Future.value([]);

  final Map<MarkerId, Marker> _markers = {};
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  GoogleMapController? _controller;

  late BitmapDescriptor _markerImage;

  _HomeScreenState() {
    _storeModelList = StoreService.getStores();
    final Map<MarkerId, Marker> markers = {};
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getUser();
    _initFoodCategories();

    _getFoodCategories().then((categories) {
      setState(() {
        _foodCategoryList = categories;
        _foodCategoryList[0].isSelected = true;
      });
    });

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(1, 1)),
      'assets/images/location_marker.png',
    ).then((image) => _markerImage = image);
  }

  void _initFoodCategories() {
    for (var i = 0; i < Variables.foodCategories.length; i++) {
      _foodCategoryList.add(FoodCategory(
        id: Variables.foodCategories[i]["id"]!,
        name: Variables.foodCategories[i]["text"]!,
        assetName: Variables.foodCategories[i]["assetName"]!,
      ));
    }
    _foodCategoryList[0].isSelected = true;
  }

  void _callBackForTapGesture(int index, bool isNearby) async {
    _storeModelList = StoreService.getStoresByCategory(index);
    final stores = await _storeModelList;

    if (_currentPosition != null) {
      stores.removeWhere((store) {
        final distance = Geolocator.distanceBetween(
          store.geoPoint.latitude,
          store.geoPoint.longitude,
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        return distance > 10000;
      });
    }

    for (var category in _foodCategoryList) {
      category.isSelected = false;
    }
    _foodCategoryList[index].isSelected = !_foodCategoryList[index].isSelected;

    setState(() {});
  }





  String getStateText(String state) {
    print(state);
    if (Variables.storeStates.containsKey(state)) {
      return (Variables.storeStates[state]!);
    }
    throw Error();
  }

  //사용자 아이디 받기
  void _getUser() async {
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Location permission denied"),
          content: const Text(
              "Location permission has been permanently denied, cannot proceed."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Location permission denied"),
            content: const Text(
                "Location permission was not granted, cannot proceed."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        _getCurrentLocation();
      }
    } else {
      _getCurrentLocation();
    }
  }

  // 가까운 가게 거리계산
  Future<List<StoreModel>> _filterStoresByDistance(
      List<StoreModel> stores, Position position) async {
    final filteredStores = stores.where((store) {
      print('test');
      print(store.geoPoint.latitude);
      print(store.geoPoint.longitude);
      print(position.latitude);
      print(position.longitude);

      final distance = Geolocator.distanceBetween(
        store.geoPoint.latitude,
        store.geoPoint.longitude,
        position.latitude,
        position.longitude,
      );
      return distance <= 10000; // 1000=1km
    }).toList();
    return filteredStores;
  }


  Future<void> _getCurrentLocation() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('로그인 되어 있지 않습니다.');
      return;
    }

    String url =
        'http://34.64.188.192:8080/user/loc/${user.uid}';
    try {
      Uri uri = Uri.parse(url);
      var response = await http.get(uri);
      var data = json.decode(response.body);

      double latitude = double.parse(data['data']['lat']);
      double longitude = double.parse(data['data']['lon']);

      print('Latitude: $latitude, Longitude: $longitude');
      Position newPosition = Position(
        latitude: latitude,
        longitude: longitude,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: DateTime.now(),
      );
      setState(() {
        _currentPosition = newPosition;
      });
      await _getAddressFromLatLng();
      _moveCameraToPosition(newPosition);
      _updateMarker(newPosition);

      final stores = await StoreService.getStoresByCategory(
          _foodCategoryList.indexWhere((category) => category.isSelected));

      // 현재 위치로부터의 거리 기준 가게
      final filteredStores = await _filterStoresByDistance(stores, newPosition);

      setState(() {
        _storeModelList = Future.value(filteredStores);
      });

      print('성공');
    } catch (e) {
      print(e);
      print('실패');
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      final Placemark place = placemarks[0];
      setState(() {
        _address = '${place.name} ${place.locality}, ${place.country}';
      });
    } catch (e) {
      print(e);
    }
  }


  void _moveCameraToPosition(Position position) async {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18,
          ),
        ),
      );
    }
  }

  void _updateMarker(Position newPosition) {
    const MarkerId markerId = MarkerId('currentLocation');
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(newPosition.latitude, newPosition.longitude),
      icon: _markerImage,
      infoWindow: const InfoWindow(title: '현재 위치'),
    );
    setState(() {
      _markers[markerId] = marker;
    });
  }

  Future<BitmapDescriptor> getStoreIcon(category) async {
    String imgPath = "";
    if (category == 1) {
      imgPath = 'assets/icons/map_menu_category/rice_map.png';
    } else if (category == 2) {
      imgPath = 'assets/icons/map_menu_category/dumpling_map.png';
    } else if (category == 3) {
      imgPath = 'assets/icons/map_menu_category/onigiri_map.png';
    } else if (category == 4) {
      imgPath = 'assets/icons/map_menu_category/cooking_map.png';
    } else if (category == 5) {
      imgPath = 'assets/icons/map_menu_category/bowl_map.png';
    } else if (category == 6) {
      imgPath = 'assets/icons/map_menu_category/burger_map.png';
    } else if (category == 7) {
      imgPath = 'assets/icons/map_menu_category/sausage_map.png';
    } else if (category == 8) {
      imgPath = 'assets/icons/map_menu_category/sate_map.png';
    } else if (category == 9) {
      imgPath = 'assets/icons/map_menu_category/donuts_map.png';
    }
    final BitmapDescriptor bitmapDescriptor =
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(1, 1)),
      imgPath,
    );
    return bitmapDescriptor;
  }

  void _addMarkersToMap(List<StoreModel> stores) async {
    for (final store in stores) {
      final markerId = MarkerId(store.id);
      final marker = Marker(
        markerId: markerId,
        position: LatLng(store.geoPoint.latitude, store.geoPoint.longitude),
        icon: await getStoreIcon(store.category),
        infoWindow: InfoWindow(title: store.name),
      );
      _markers[markerId] = marker;
    }
  }

  Future<LatLngBounds> _onCameraIdle() async {
    if (_controller != null) {
      return await _controller!.getVisibleRegion();
    }
    throw Exception("Controller is null");
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }


  Future<bool> _isCategoryNearby(FoodCategory category) async {
    final stores = await _storeModelList;
    final nearbyStores = stores.where((store) {
      final distance = Geolocator.distanceBetween(
        store.geoPoint.latitude,
        store.geoPoint.longitude,
        _currentPosition?.latitude ?? 0,
        _currentPosition?.longitude ?? 0,
      );
      return distance <= 10000; // 1000=1km
    });

    final nearbyStoreIds = nearbyStores.map((store) => store.id).toSet();

    return stores.any((store) {
      return nearbyStoreIds.contains(store.id) && store.category == category.name;
    });
  }


  Future<List<FoodCategory>> _getFoodCategories() async {
    final foodCategories = <FoodCategory>[];
    for (var i = 0; i < Variables.foodCategories.length; i++) {
      foodCategories.add(
        FoodCategory(
          id: Variables.foodCategories[i]["id"]!,
          name: Variables.foodCategories[i]["text"]!,
          assetName: Variables.foodCategories[i]["assetName"]!,
        ),
      );
    }
    foodCategories[0].isSelected = true;
    return foodCategories;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 130.h,
        maxHeight: 700.h,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r), topRight: Radius.circular(6.r)),
        panelBuilder: (controller) => SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      width: 20.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: GrayScale.g300,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                    ),
                    SizedBox(
                      height: 34.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 77.w,
                child: FutureBuilder<List<FoodCategory>>(
                  future: _getFoodCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          final category = snapshot.data![index];
                          return FutureBuilder<bool>(
                            future: _isCategoryNearby(category),
                            builder: (context, snapshot) {
                              final isNearby = snapshot.data ?? false;
                              return MenuCategory(
                                name: category.name,
                                assetName: category.assetName,
                                isSelected: _foodCategoryList[index].isSelected,
                                isNearby: isNearby,
                                callback: () =>
                                    _callBackForTapGesture(index, isNearby),
                              );
                            },
                          );
                        }),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10.w,
                          );
                        },
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        itemCount: snapshot.data!.length,
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 28.h,
              ),
              FutureBuilder(
                  future: _storeModelList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Container(
                          margin: EdgeInsets.only(top: 200.h),
                          child: Text(
                            textAlign: TextAlign.center,
                            "가게가 없습니다.\n포장 한 번 용기내 해보려 했는데...\n지구를 지키는 일은 정말 힘들군요.",
                            style: FontStyle.emptyNotificationTextStyle,
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          children: [
                            ListView.separated(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: ((context, index) {
                                  return Store(
                                      name: snapshot.data![index].name,
                                      starRating:
                                      snapshot.data![index].starRating,
                                      imgUrl: snapshot.data![index].imgUrl,
                                      state: getStateText(
                                          snapshot.data![index].state),
                                      callback: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StoreScreen(
                                                storeId: snapshot
                                                    .data![index].id,
                                              )),
                                        );
                                      });
                                }),
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 14.h,
                                  );
                                },
                                itemCount: snapshot.data!.length),
                            SizedBox(
                              height: 32.h,
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  onCameraIdle: () async {
                    final visibleRegion = await _onCameraIdle();
                    final stores = await StoreService.getStores();
                    final filteredStores = stores.where((store) {
                      final storeLocation =
                      LatLng(store.geoPoint.latitude, store.geoPoint.longitude);
                      return visibleRegion.contains(storeLocation);
                    }).toList();
                    setState(() {
                      _storeModelList = Future.value(filteredStores);
                    });
                    _addMarkersToMap(filteredStores);
                  },
                  mapType: MapType.normal,
                  initialCameraPosition: _currentPosition != null
                      ? CameraPosition(
                    target: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 18,
                  )
                      : const CameraPosition(
                    target: LatLng(
                      37.5665,
                      126.9780,
                    ),
                    zoom: 18,
                  ),
                  markers: _markers.values.toSet(),
                )),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 22.h, left: 40.w),
            child: SizedBox(
              width: 56.w,
              height: 56.w,
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.home, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserLocationPage()),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h, right: 16.w),
            child: SizedBox(
              width: 56.w,
              height: 56.w,
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.my_location, color: Colors.black),
                onPressed: () async {
                  final position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );
                  setState(() {
                    _currentPosition = position;
                  });
                  await _getAddressFromLatLng();
                  _moveCameraToPosition(position);
                  _updateMarker(position);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}