import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/utilities/variables.dart';

import '../utilities/colors.dart';
import '../utilities/fonts.dart';

class PrePareContainerDialog extends StatelessWidget {
  const PrePareContainerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.r))),
      scrollable: true,
      title: const Text(
        "어떤 용기를 준비해야 할지 \n잘 모르겠나요?",
      ),
      titleTextStyle: TextStyle(
        fontFamily: nanumSquareNeo,
        fontSize: 15.sp,
        height: 1.65,
        fontVariations: const [
          FontVariation('wght', 600),
        ],
        color: GrayScale.g900,
      ),
      insetPadding: EdgeInsets.all(30.w),
      titlePadding:
          EdgeInsets.only(right: 24.w, left: 24.w, top: 40.h, bottom: 32.h),
      contentPadding: EdgeInsets.only(right: 24.w, left: 24.w, bottom: 20.h),
      content: Column(children: [
        for (var info in Variables.prepareContainerTexts
            .sublist(1, Variables.prepareContainerTexts.length)) ...[
          PrepareContainerInfo(info: info),
          SizedBox(
            height: 28.h,
          )
        ]
      ]),
    );
  }
}

class PrepareContainerInfo extends StatelessWidget {
  const PrepareContainerInfo({
    super.key,
    required this.info,
  });

  final Map<String, dynamic> info;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: SvgPicture.asset(info["imgPath"]),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                info["name"],
                style: TextStyle(
                  fontFamily: nanumSquareNeo,
                  fontSize: 12.sp,
                  fontVariations: const [
                    FontVariation('wght', 700),
                  ],
                  color: GrayScale.g900,
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                info["explain"],
                style: TextStyle(
                  fontFamily: nanumSquareNeo,
                  fontSize: 12.sp,
                  height: 1.5,
                  fontVariations: const [
                    FontVariation('wght', 400),
                  ],
                  color: GrayScale.g700,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
