import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/components/base_filled_button.dart';
import 'package:good_to_go/components/base_outlined_button.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:good_to_go/components/base_scaffold.dart';
import 'package:good_to_go/api.dart';

class UserLocationPage extends StatefulWidget {
  const UserLocationPage({Key? key}) : super(key: key);

  @override
  _UserLocationPageState createState() => _UserLocationPageState();
}

class _UserLocationPageState extends State<UserLocationPage> {
  String? _address;
  Position? _currentPosition;
  User? _user;

  //구글지도 사용을 위한 추가
  late BitmapDescriptor _markerImage;
  final Map<MarkerId, Marker> _markers = {};
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getUser();
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(5.w, 5.w)),
      'assets/images/location_marker.png',
    ).then((image) => _markerImage = image);
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

  //서버에 저장
  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
    await _getAddressFromLatLng();
    _saveLocationToServer(position);
    _moveCameraToPosition(position);
    _updateMarker(position);
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

  Future<void> _saveLocationToServer(Position position) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in.');
      return;
    }

    String url =
        'http://34.64.188.192:8080/user/loc/${user.uid}';
    String address = _address ?? '';
    var data = {
      'address': address,
      'lon': position.longitude.toString(),
      'lat': position.latitude.toString(),
    };
    try {
      Uri uri = Uri.parse(url);
      var response = await http.post(uri, body: data);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<String> _getAddressFromLatLngUsingGoogleAPI(
      double latitude, double longitude) async {
    String? address;
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      address = '${place.name} ${place.locality}, ${place.country}';
    } catch (e) {
      print(e);
    }
    if (address == null) {
      //위도 경도 한국으로 설정
      String lat = latitude.toString();
      String lng = longitude.toString();
      String apiKey = Api.googleMapsApiKey;
      String url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
      try {
        Uri uri = Uri.parse(url);
        var response = await http.get(uri);
        var data = json.decode(response.body);
        address = data['results'][0]['formatted_address'];
      } catch (e) {
        print(e);
      }
    }
    return address ?? '';
  }

  void _searchAddress(String query) async {
    try {
      List<Location> locations = await locationFromAddress(
        query,
        localeIdentifier: 'ko',
      );
      if (locations.isNotEmpty) {
        setState(() {
          _currentPosition = Position(
            latitude: locations[0].latitude,
            longitude: locations[0].longitude,
            altitude: 0.0,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );
        });
        await _getAddressFromLatLng();
        //지도 핀 움직이게 설정
        _moveCameraToPosition(_currentPosition!);
        _updateMarker(_currentPosition!);
      } else {
        String apiKey = Api.googleMapsApiKey;
        String url =
            'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$apiKey';
        Uri uri = Uri.parse(url);
        var response = await http.get(uri);
        var data = json.decode(response.body);
        if (data['status'] == 'OK') {
          var result = data['results'][0];
          setState(() {
            _address = result['formatted_address'];
            var location = result['geometry']['location'];
            _currentPosition = Position(
              latitude: location['lat'],
              longitude: location['lng'],
              altitude: 0.0,
              timestamp: DateTime.now(),
              accuracy: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
            );
          });
        } else {
          setState(() {
            _address = null;
            _currentPosition = null;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  //지도 생성
  void _moveCameraToPosition(Position position) async {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          ),
        ),
      );
    }
  }

  void _updateMarker(Position position) {
    MarkerId markerId = const MarkerId('current_location');
    Marker marker = Marker(
      markerId: markerId,
      icon: _markerImage,
      position: LatLng(position.latitude, position.longitude),
    );
    setState(() {
      _markers[markerId] = marker;
    });
  }

  void _handleTap(LatLng latLng) async {
    Position newPosition = Position(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      accuracy: _currentPosition!.accuracy,
      altitude: _currentPosition!.altitude,
      heading: _currentPosition!.heading,
      speed: _currentPosition!.speed,
      speedAccuracy: _currentPosition!.speedAccuracy,
      timestamp: _currentPosition!.timestamp,
    );
    setState(() {
      _currentPosition = newPosition;
    });
    await _getAddressFromLatLng();
    _updateMarker(newPosition);
  }

  void _onMapCreated(GoogleMapController controller) {
    if (_controller == null) {
      _controller = controller;
      _mapController.complete(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar('위치 검색'),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SizedBox(height: 22.h),
                    Container(
                      decoration: BoxDecoration(
                        color: GrayScale.g200,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 13.h, horizontal: 10.w),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/help.svg',
                              width: 16.w,
                              height: 16.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '장소를 검색하거나 현재 위치 찾기 버튼을 눌러 위치를 설정하세요.',
                              style: TextStyle(
                                color: GrayScale.g600,
                                fontFamily: nanumSquareNeo,
                                fontSize: 10.sp,
                                fontVariations: const [
                                  FontVariation('wght', 600),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      decoration: InputDecoration(
                        hintText: '주소를 검색해 주세요.',
                        hintStyle: FontStyle.hintTextInTextFieldStyle,
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: textFieldDefaultBorderStyle,
                        enabledBorder: textFieldDefaultBorderStyle,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 18.h),
                      ),
                      style: FontStyle.textInTextFieldStyle,
                      keyboardType: TextInputType.text,
                      onSubmitted: _searchAddress,
                    ),
                    SizedBox(height: 8.h),
                    BaseOutlinedButton(
                      '현재 위치 찾기',
                      _getCurrentLocation,
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
              Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition?.latitude ?? 37.5665,
                      _currentPosition?.longitude ?? 126.9780,
                    ),
                    zoom: 15,
                  ),
                  onTap: _handleTap,
                  markers: Set<Marker>.of(
                    _currentPosition == null
                        ? []
                        : [
                            Marker(
                              markerId: const MarkerId('current_position'),
                              icon: _markerImage,
                              position: LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                            ),
                          ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    BaseFilledButton(
                      '시작하기',
                      () {
                        if (_currentPosition != null) {
                          _saveLocationToServer(_currentPosition!)
                              .then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  //builder: (context) => const MapScreen()),
                                  builder: (context) => const BaseScaffold()),
                            );
                          });
                        }
                      },
                    ),
                    SizedBox(height: 31.h),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
