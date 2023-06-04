import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/components/base_filled_button.dart';
import 'package:good_to_go/components/base_scaffold.dart';
import 'package:good_to_go/models/order_model.dart';
import 'package:good_to_go/models/review_model.dart';
import 'package:good_to_go/provider/user_provider.dart';
import 'package:good_to_go/services/order_service.dart';
import 'package:good_to_go/services/review_service.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/variables.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class RecapScreen extends StatefulWidget {
  const RecapScreen({super.key});

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  bool isLoading = true;
  late String levelTitle;

  List<ContainerForCount> containers = [];

  late List<OrderModel> orderModelList;
  late List<ReviewModel> reviewModelList;
  late int totalReviewCount = 0;

  String getLevelTitle() {
    for (var level in Variables.userLevelStates.reversed) {
      if (reviewModelList.length >= level["count"]) {
        return level["name"];
      }
    }
    return Variables.userLevelStates.last["name"];
  }

  void initData(userId) async {
    reviewModelList = await ReviewService.getReviewsByUserId(userId);
    totalReviewCount = reviewModelList.length;
    if (reviewModelList.length > 5) {
      reviewModelList = reviewModelList.sublist(0, 5);
    }

    orderModelList = await OrderService.getOrders(
      userId: userId,
      page: 1,
      size: 10,
      packed: 1,
    );
    orderModelList =
        orderModelList.where((element) => element.state == "packed").toList();

    if (orderModelList.length > 10) {
      orderModelList = orderModelList.sublist(0, 10);
    }

    levelTitle = getLevelTitle();
    initContainerData();
    isLoading = false;
    setState(() {});
  }

  void initContainerData() {
    for (var data in Variables.prepareContainerTexts) {
      containers
          .add(ContainerForCount(data["id"], data["name"], data["imgPath"]));
    }
    for (var order in orderModelList) {
      for (var menu in order.orderMenuList) {
        containers
            .firstWhere(
              (element) => element.containerNum == menu.container,
            )
            .increaseCount(number: menu.count);

        for (var options in menu.optionsList) {
          for (var option in options.optionList) {
            containers
                .firstWhere(
                  (element) => element.containerNum == option.container,
                )
                .increaseCount(number: menu.count);
          }
        }
      }
    }
    containers = containers.sublist(1, containers.length);
    containers.sort(((a, b) => b.count.compareTo(a.count)));
  }

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;

    initData(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 48.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text:
                              "$levelTitle ${context.read<UserProvider>().user!.displayName!}",
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 24.sp,
                            height: 1.50,
                            color: primaryColor,
                            fontVariations: const [
                              FontVariation('wght', 700),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: "은 \n총 ",
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 24.sp,
                            height: 1.50,
                            color: GrayScale.g800,
                            fontVariations: const [
                              FontVariation('wght', 600),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: totalReviewCount.toString(),
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 24.sp,
                            height: 1.50,
                            color: secondaryColor,
                            fontVariations: const [
                              FontVariation('wght', 700),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: "번 환경보호를 \n인증했습니다.",
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 24.sp,
                            height: 1.50,
                            color: GrayScale.g800,
                            fontVariations: const [
                              FontVariation('wght', 600),
                            ],
                          ),
                        ),
                      ])),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    reviewModelList.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: BaseFilledButton("지금 바로 주문하고 리뷰 쓰러 가기", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BaseScaffold(),
                                ),
                              );
                            }),
                          )
                        : SizedBox(
                            height: 160.h,
                            child: Stack(
                              children: [
                                LoopAnimationBuilder(
                                  tween: Tween(
                                      begin: -MediaQuery.of(context).size.width,
                                      end: 0.0),
                                  duration: Duration(
                                      seconds: reviewModelList.length * 3),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(value, 0),
                                      child: child,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      for (var review in reviewModelList) ...[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(right: 15.w),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                          Radius.circular(6))
                                                      .r,
                                              child: Image.network(
                                                review.imgUrl,
                                                width: 120.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                                LoopAnimationBuilder(
                                  tween: Tween(
                                      begin: 0.0,
                                      end: MediaQuery.of(context).size.width),
                                  duration: Duration(
                                      seconds: reviewModelList.length * 3),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(value, 0),
                                      child: child,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      for (var review in reviewModelList) ...[
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(right: 15.w),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                          Radius.circular(6))
                                                      .r,
                                              child: Image.network(
                                                review.imgUrl,
                                                width: 120.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 32.h,
                    ),
                    if (orderModelList.isNotEmpty)
                      Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/tree_background.svg',
                            width: MediaQuery.of(context).size.width,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 32.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: "최근 ",
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 24.sp,
                                      height: 1.50,
                                      color: GrayScale.g800,
                                      fontVariations: const [
                                        FontVariation('wght', 600),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: orderModelList.length.toString(),
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 24.sp,
                                      height: 1.50,
                                      color: secondaryColor,
                                      fontVariations: const [
                                        FontVariation('wght', 700),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: "번 동안\n",
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 24.sp,
                                      height: 1.50,
                                      color: GrayScale.g800,
                                      fontVariations: const [
                                        FontVariation('wght', 600),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${context.read<UserProvider>().user!.displayName!}님",
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 24.sp,
                                      height: 1.50,
                                      color: primaryColor,
                                      fontVariations: const [
                                        FontVariation('wght', 700),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: "이 낸 용기입니다\n",
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 24.sp,
                                      height: 1.50,
                                      color: GrayScale.g800,
                                      fontVariations: const [
                                        FontVariation('wght', 600),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: containers.first.name,
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 24.sp,
                                      height: 1.50,
                                      color: const Color(0xff418CFC),
                                      fontVariations: const [
                                        FontVariation('wght', 700),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: "를 가장 많이\n사용하셨군요?",
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 24.sp,
                                      height: 1.50,
                                      color: GrayScale.g800,
                                      fontVariations: const [
                                        FontVariation('wght', 600),
                                      ],
                                    ),
                                  ),
                                ])),
                                SizedBox(
                                  height: 70.h,
                                ),
                                Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.w),
                                            child: SvgPicture.asset(
                                              containers.first.imgUrl,
                                              width: 80.w,
                                              height: 80.w,
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Text(
                                      "${containers.first.name}를 가장 많이 사용하셨습니다",
                                      style: TextStyle(
                                        fontFamily: nanumSquareNeo,
                                        fontSize: 13.sp,
                                        color: GrayScale.g100,
                                        fontVariations: const [
                                          FontVariation('wght', 600),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 28.h,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18.r))),
                                  child: Padding(
                                    padding: EdgeInsets.all(18.w),
                                    child: Wrap(
                                      runSpacing: 8.h,
                                      children: [
                                        for (var data in containers) ...[
                                          ContainerCountWidget(
                                              imgUrl: data.imgUrl,
                                              count: data.count,
                                              maxCount: containers.first.count)
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    Container(
                      color: GrayScale.g900,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 160.h, bottom: 32.h),
                            child: SvgPicture.asset(
                              'assets/images/happy_earth.svg',
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 32.h),
                            child: Column(
                              children: [
                                Text(
                                  "${context.read<UserProvider>().user!.displayName!}님 오늘도\n어스를 지킬 용기를\n내봐요!",
                                  style: TextStyle(
                                    fontFamily: nanumSquareNeo,
                                    fontSize: 24.sp,
                                    height: 1.50,
                                    color: Colors.white,
                                    fontVariations: const [
                                      FontVariation('wght', 700),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 80.w, left: 30.w),
                                  child: Stack(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/talk_balloon.svg',
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 12.w, left: 12.w),
                                        child: CircleAvatar(
                                          radius: 31.w,
                                          backgroundImage: NetworkImage(
                                            '${context.read<UserProvider>().user!.photoURL}',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
    );
  }
}

class ContainerCountWidget extends StatelessWidget {
  final String imgUrl;
  final int count, maxCount;
  const ContainerCountWidget({
    super.key,
    required this.imgUrl,
    required this.count,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imgUrl,
          width: 36.w,
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Row(
            children: [
              if (count != 0)
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(18.r))),
                  width: (count / maxCount) * 210.w,
                  height: 14.h,
                ),
              if (count != 0)
                SizedBox(
                  width: 12.w,
                ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontFamily: nanumSquareNeo,
                  fontSize: 13.sp,
                  color: GrayScale.g700,
                  fontVariations: const [
                    FontVariation('wght', 600),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContainerForCount {
  final int containerNum;
  final String imgUrl;
  final String name;
  int count = 0;
  ContainerForCount(this.containerNum, this.name, this.imgUrl);

  void increaseCount({int number = 1}) {
    count = count + number;
  }
}
