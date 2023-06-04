import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/components/base_app_bar.dart';
import 'package:good_to_go_restaurant/models/revenue_model.dart';
import 'package:good_to_go_restaurant/models/store_model.dart';
import 'package:good_to_go_restaurant/provider/user_provider.dart';
import 'package:good_to_go_restaurant/screens/review/screens/review_screen.dart';
import 'package:good_to_go_restaurant/services/store_service.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';
import 'package:good_to_go_restaurant/utilities/styles.dart';
import 'package:provider/provider.dart';

import '../components/revenue_info.dart';
import '../components/review_info.dart';
import '../components/store_manage_button.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late Future<StoreModel> _store;
  late Future<RevenueModel> _revenue;
  int maxRevenue = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    dynamic storeId = context.read<UserProvider>().storeId;
    if (storeId == null) {
      FirebaseFirestore.instance
          .collection('restaurants')
          .where("owner_uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get()
          .then((querySnapshot) {
        storeId = querySnapshot.docs[0].id;
        _store = StoreService.getStoreById(storeId);
        _revenue = StoreService.getStoreRevenuById(storeId);
        isLoading = false;
        setState(() {});
      });
    } else {
      _store = StoreService.getStoreById(storeId);
      _revenue = StoreService.getStoreRevenuById(storeId);
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar("내 가게"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: _store,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.none:
                    return const Center(
                      child: Text("연결이 없습니다."),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      debugPrint(snapshot.error.toString());
                      throw Error();
                    }
                    if (!snapshot.hasData) {
                      return const Text("해당하는 데이터가 없습니다.");
                    }
                    final StoreModel store = snapshot.data!;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20).w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  store.name,
                                  style: TextStyle(
                                    fontFamily: AppFont.nanumSquareNeo,
                                    fontSize: 20.sp,
                                    fontVariations: const [
                                      FontVariation('wght', 700),
                                    ],
                                    color: AppColor.g900,
                                  ),
                                ),
                                StoreOpenState(
                                  state: store.state,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StoreManageButton(
                                  icon: Icons.store_rounded,
                                  onTap: () {},
                                  text: '가게 정보',
                                ),
                                StoreManageButton(
                                  icon: Icons.restaurant_menu_rounded,
                                  onTap: () {},
                                  text: '메뉴 관리',
                                ),
                                StoreManageButton(
                                  icon: Icons.comment_rounded,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ReviewScreen())),
                                  text: '리뷰 관리',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 36.h,
                            ),
                            Text(
                              "가게 평가",
                              style: AppStyle.captionTextStyle,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            ReviewInfo(
                              rating: store.starRating,
                              reviewCount: store.reviewCount,
                            ),
                            SizedBox(
                              height: 36.h,
                            ),
                            FutureBuilder(
                                future: _revenue,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    case ConnectionState.none:
                                      return const Center(
                                        child: Text("연결이 없습니다."),
                                      );
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      if (snapshot.hasError) {
                                        debugPrint(snapshot.error.toString());
                                        throw Error();
                                      }
                                      if (!snapshot.hasData) {
                                        return const Text("해당하는 데이터가 없습니다.");
                                      }
                                      final RevenueModel revenue =
                                          snapshot.data!;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "매출",
                                            style: AppStyle.captionTextStyle,
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          RevenueInfo(
                                            caption: '오늘 수입',
                                            imgPath:
                                                'assets/images/img_wallet.png',
                                            profit: revenue.todayRevenue,
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          RevenueInfo(
                                            caption: '이번 달 총 매출',
                                            imgPath:
                                                'assets/images/img_calendar.png',
                                            profit: revenue.monthRevenue,
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 22.h,
                                                horizontal: 18.w),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: AppColor.g100,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12)
                                                        .r),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '월 별 매출',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFont.nanumSquareNeo,
                                                    fontSize: 11.sp,
                                                    fontVariations: const [
                                                      FontVariation(
                                                          'wght', 600),
                                                    ],
                                                    color: AppColor.g300,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 210.h,
                                                  child: ListView.separated(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (maxRevenue <
                                                          revenue.lastSixRevenueList[
                                                                  index][
                                                              'total_revenue']) {
                                                        maxRevenue = revenue
                                                                .lastSixRevenueList[
                                                            index]['total_revenue'];
                                                      }
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          RevenueBar(
                                                              id: revenue
                                                                      .lastSixRevenueList[
                                                                  index]['id'],
                                                              totalRevenue: revenue
                                                                          .lastSixRevenueList[
                                                                      index][
                                                                  'total_revenue'],
                                                              maxRevenue:
                                                                  maxRevenue),
                                                        ],
                                                      );
                                                    },
                                                    itemCount: revenue
                                                        .lastSixRevenueList
                                                        .length,
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return SizedBox(
                                                        width: 16.w,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 32.h,
                                          ),
                                        ],
                                      );
                                  }
                                })
                          ],
                        ),
                      ),
                    );
                }
              }),
    );
  }
}

class RevenueBar extends StatelessWidget {
  final String id;
  final int totalRevenue;
  final int maxRevenue;

  List<String> splitStringByLength(String str) =>
      [str.substring(0, 4), str.substring(4)];

  String _getMonthText(String id) {
    List<String> text = splitStringByLength(id);
    return '${text[0]}년\n${text[1]}월';
  }

  const RevenueBar({
    super.key,
    required this.id,
    required this.totalRevenue,
    required this.maxRevenue,
  });

  double _getHeight() {
    if (totalRevenue == 0 || maxRevenue == 0) {
      return 0;
    } else {
      return (totalRevenue / maxRevenue) * 140;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.blue,
            borderRadius: BorderRadius.circular(12).r,
          ),
          height: _getHeight(),
          width: 20.w,
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          _getMonthText(id),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFont.nanumSquareNeo,
            fontSize: 10.sp,
            height: 1.2,
            fontVariations: const [
              FontVariation('wght', 600),
            ],
            color: AppColor.g300,
          ),
        ),
      ],
    );
  }
}

class StoreOpenState extends StatelessWidget {
  final String state;
  const StoreOpenState({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: state == 'open' ? AppColor.primaryColor : AppColor.g500,
        borderRadius: BorderRadius.circular(100).r,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
        child: Text(
          state == 'open' ? '영업 중' : '마감',
          style: TextStyle(
            fontFamily: AppFont.nanumSquareNeo,
            fontSize: 11.sp,
            fontVariations: const [
              FontVariation('wght', 700),
            ],
            color: state == 'open' ? AppColor.primaryLightColor : AppColor.g100,
          ),
        ),
      ),
    );
  }
}
