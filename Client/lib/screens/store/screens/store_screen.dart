import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:good_to_go/components/app_bar.dart';
import 'package:good_to_go/components/base_outlined_button.dart';
import 'package:good_to_go/models/store_model.dart';
import 'package:good_to_go/provider/cart_provider.dart';
import 'package:good_to_go/screens/order/screens/cart_screen.dart';
import 'package:good_to_go/screens/review/screens/reviews_screen.dart';
import 'package:good_to_go/screens/store/components/menu.dart';
import 'package:good_to_go/screens/store/components/opening_hour_widget.dart';
import 'package:good_to_go/screens/store/screens/menu_screen.dart';
import 'package:good_to_go/services/store_service.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatefulWidget {
  final String storeId;
  const StoreScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final appBarTitle = "가게 정보";
  late Future<StoreModel> _store;
  dynamic trailingIcon;

  @override
  void initState() {
    super.initState();
    _store = StoreService.getStoreById(widget.storeId);
    trailingIcon = SvgPicture.asset('assets/icons/arrow_drop_up.svg');
  }

  @override
  Widget build(BuildContext context) {
    var storeSubInfoTextStyle = TextStyle(
      fontFamily: nanumSquareNeo,
      fontSize: 13.sp,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
      color: primaryColor,
    );

    var storeInfoTextStyle = TextStyle(
      fontFamily: nanumSquareNeo,
      fontSize: 12.sp,
      height: 1.65,
      fontVariations: const [
        FontVariation('wght', 600),
      ],
      color: GrayScale.g700,
    );

    return Scaffold(
      appBar: DefaultAppBar(appBarTitle),
      floatingActionButton: Visibility(
        visible: context.watch<CartProvider>().menusInCart.isNotEmpty,
        child: SizedBox(
          width: 56.w,
          height: 56.w,
          child: FloatingActionButton(
            elevation: 5,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            child:
                SvgPicture.asset(width: 24.w, "assets/icons/shopping_cart.svg"),
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _store,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                StoreModel data = snapshot.data!;
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15).w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 22.h,
                          ),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)).r,
                            child: Container(
                              height: 120.h,
                              width: 330.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.center,
                                  image: NetworkImage(data.imgUrl),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.name,
                                      style: FontStyle.headlineStyle),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/star.svg'),
                                          SizedBox(width: 2.w),
                                          Text(
                                            data.starRating.toString(),
                                            style: storeSubInfoTextStyle,
                                          ),
                                          SizedBox(width: 8.w),
                                          SvgPicture.asset(
                                              'assets/icons/chat.svg'),
                                          SizedBox(width: 2.w),
                                          Text(
                                            data.reviewCount.toString(),
                                            style: storeSubInfoTextStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryLightColor,
                                  borderRadius: BorderRadius.circular(6).r,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    launchUrl(
                                        Uri.parse("tel:${data.telephone}"));
                                  },
                                  icon:
                                      SvgPicture.asset('assets/icons/call.svg'),
                                  iconSize: 24.sp,
                                  padding: const EdgeInsets.all(12).h,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                          BaseOutlinedButton("${data.reviewCount}개의 리뷰 보기", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewsScreen(
                                        starRating: data.starRating,
                                        reviewCount: data.reviewCount,
                                        storeId: data.id,
                                      )),
                            );
                          }),
                          SizedBox(
                            height: 32.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "가게 정보",
                                style: FontStyle.captionStyle,
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset('assets/icons/alarm.svg'),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        "조리시간",
                                        style: FontStyle.subCaptionStyle,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        '${data.spentTime}분',
                                        style: storeInfoTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset('assets/icons/map.svg'),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        "위치",
                                        style: FontStyle.subCaptionStyle,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        data.address,
                                        style: storeInfoTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/calendar_month.svg'),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        "영업일",
                                        style: FontStyle.subCaptionStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              if (data.state == "closed") const StoreClosed(),
                              SizedBox(
                                height: 6.h,
                              ),
                              OpeningHourWidget(data.openingHours),
                            ],
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          Card(
                            color: primaryLightColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)).r,
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.zero,
                            child: ExpansionTile(
                              tilePadding:
                                  const EdgeInsets.fromLTRB(18, 2, 18, 2).w,
                              initiallyExpanded: true,
                              backgroundColor: primaryLightColor,
                              collapsedBackgroundColor: primaryLightColor,
                              iconColor: primaryColor,
                              collapsedIconColor: primaryColor,
                              leading: Padding(
                                padding: EdgeInsets.only(top: 2.2.h),
                                child: SvgPicture.asset(
                                    'assets/icons/volume_down.svg'),
                              ),
                              trailing: trailingIcon,
                              onExpansionChanged: (isExpanded) => setState(() =>
                                  isExpanded
                                      ? trailingIcon = SvgPicture.asset(
                                          'assets/icons/arrow_drop_up.svg')
                                      : trailingIcon = SvgPicture.asset(
                                          'assets/icons/arrow_drop_down.svg')),
                              title: Text(
                                '${data.owner} 사장님의 한 마디',
                                style: TextStyle(
                                  fontFamily: nanumSquareNeo,
                                  fontSize: 12.sp,
                                  fontVariations: const [
                                    FontVariation('wght', 700),
                                  ],
                                  color: primaryColor,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 18)
                                          .w,
                                  child: Text(
                                    data.description,
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 12.sp,
                                      height: 1.65,
                                      fontVariations: const [
                                        FontVariation('wght', 400),
                                      ],
                                      color: GrayScale.g700,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Text(
                            "메뉴",
                            style: FontStyle.captionStyle,
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                        ],
                      ),
                    ),
                    StickyHeader(
                      header: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15)
                            .w, /*
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: data.menuList.length,
                          separatorBuilder: (context, index) => SizedBox(
                            width: 6.w,
                          ),
                          itemBuilder: (context, index) {
                            return MenuChip(data.menuList[index].category);
                          },
                        ),*/
                      ),
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15).w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 12.h,
                            ),
                            ListView.separated(
                                itemCount: data.menuList.length,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 20.h,
                                    ),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        data.menuList[index].category,
                                        style: FontStyle.subCaptionStyle,
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      ListView.separated(
                                          itemCount: data
                                              .menuList[index].menuList.length,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                                height: 14.h,
                                              ),
                                          itemBuilder:
                                              (BuildContext context, int idx) {
                                            return Column(
                                              children: [
                                                Menu(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MenuScreen(
                                                                  data
                                                                      .menuList[
                                                                          index]
                                                                      .menuList[
                                                                          idx]
                                                                      .id!,
                                                                  data.state),
                                                        ),
                                                      );
                                                    },
                                                    name: data.menuList[index]
                                                        .menuList[idx].name,
                                                    description: data
                                                        .menuList[index]
                                                        .menuList[idx]
                                                        .description!,
                                                    imgUrl: data.menuList[index]
                                                        .menuList[idx].imgUrl!,
                                                    container: data
                                                        .menuList[index]
                                                        .menuList[idx]
                                                        .container,
                                                    price: data.menuList[index]
                                                        .menuList[idx].price)
                                              ],
                                            );
                                          }),
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}

class StoreClosed extends StatelessWidget {
  const StoreClosed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: const BorderRadius.all(Radius.circular(6)).r,
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(children: [
          Container(
            margin: EdgeInsets.only(right: 6.w),
            child: SvgPicture.asset(
              "assets/icons/info.svg",
              width: 16.w,
            ),
          ),
          Text(
            "현재 이 가게는 영업을 종료했습니다.",
            style: TextStyle(
              fontFamily: nanumSquareNeo,
              fontSize: 10.sp,
              fontVariations: const [
                FontVariation('wght', 700),
              ],
              color: primaryColor,
            ),
          ),
        ]),
      ),
    );
  }
}
