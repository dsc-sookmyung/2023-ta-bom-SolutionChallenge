import 'dart:ui';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/components/base_outlined_button.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';

class NowOrder extends StatefulWidget {
  final String storeName, storeImgUrl;
  String state;
  final bool isReviewWritten;
  final String id;
  final String storeId;
  final void Function() callback;

  NowOrder({
    super.key,
    required this.storeName,
    required this.storeImgUrl,
    required this.state,
    required this.id,
    required this.callback,
    required this.storeId,
    required this.isReviewWritten,
  });

  @override
  State<NowOrder> createState() => _NowOrderState();
}

class _NowOrderState extends State<NowOrder> {
  bool isPacked = false;
  final List<Map<String, String>> cookState = [
    {
      "text": "주문 접수",
      "state": "yet",
      "imgUrl": "assets/icons/receipt.svg",
    },
    {
      "text": "요리 중",
      "state": "yet",
      "imgUrl": "assets/icons/cooking.svg",
    },
    {
      "text": "포장하러 GO",
      "state": "yet",
      "imgUrl": "assets/icons/acute.svg",
    }
  ];

  void getCookState() {
    if (widget.state == "checking") {
      cookState[0]["state"] = "activate";
    } else if (widget.state == "accepted") {
      cookState[0]["state"] = "finish";
      cookState[1]["state"] = "activate";
    } else if (widget.state == "cooked") {
      cookState[0]["state"] = "finish";
      cookState[1]["state"] = "finish";
      cookState[2]["state"] = "activate";
    } else if (widget.state == "packed") {
      cookState[0]["state"] = "finish";
      cookState[1]["state"] = "finish";
      cookState[2]["state"] = "finish";
      isPacked = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCookState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)).r,
              child: Container(
                height: 70.w,
                width: 70.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.topCenter,
                    image: NetworkImage(widget.storeImgUrl),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              widget.storeName,
              style: TextStyle(
                fontFamily: nanumSquareNeo,
                fontSize: 13.sp,
                fontVariations: const [
                  FontVariation('wght', 600),
                ],
                color: GrayScale.g900,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)).r,
          child: Container(
            decoration: const BoxDecoration(
              color: GrayScale.g200,
            ),
            child: Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.w, horizontal: 35.w),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: 31.h,
                        child: DottedLine(
                          direction: Axis.horizontal,
                          lineLength: double.infinity,
                          lineThickness: 3.0.h,
                          dashLength: 3.0.h,
                          dashColor: GrayScale.g300,
                          dashGapLength: 3.0.h,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var data in cookState) ...[
                            CookStatus(
                                state: data["state"]!,
                                text: data["text"]!,
                                imgUrl: data["imgUrl"]!)
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                if (isPacked)
                  Positioned.fill(
                    child: Container(
                      color: const Color.fromARGB(230, 167, 180, 190),
                      child: Center(
                          child: Text(
                        "포장까지 완료 되었습니다.",
                        style: TextStyle(
                          fontFamily: nanumSquareNeo,
                          fontSize: 12.sp,
                          fontVariations: const [
                            FontVariation('wght', 700),
                          ],
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        BaseOutlinedButton(
          "상세한 주문 내역 보기",
          widget.callback,
          color: GrayScale.g600,
        ),
      ],
    );
  }
}

class CookStatus extends StatefulWidget {
  final String imgUrl;
  final String text;
  final String state;

  const CookStatus({
    super.key,
    required this.state,
    required this.text,
    required this.imgUrl,
  });

  @override
  State<CookStatus> createState() => _CookStatusState();
}

class _CookStatusState extends State<CookStatus> {
  Color backgroundColor = GrayScale.g300;

  Color iconColor = GrayScale.g200;
  void getColor() {
    if (widget.state == "yet") {
      backgroundColor = GrayScale.g300;
      iconColor = GrayScale.g200;
    } else if (widget.state == "activate") {
      backgroundColor = primaryColor;
      iconColor = primaryLightColor;
    } else if (widget.state == "finish") {
      backgroundColor = GrayScale.g600;
      iconColor = GrayScale.g500;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getColor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(6)).r,
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: SvgPicture.asset(
              widget.imgUrl,
              width: 40.w,
              height: 40.w,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          widget.text,
          style: TextStyle(
            fontFamily: nanumSquareNeo,
            fontSize: 10.sp,
            fontVariations: const [
              FontVariation('wght', 700),
            ],
            color: backgroundColor,
          ),
        ),
      ],
    );
  }
}
