import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';

class InfoScaffold extends StatelessWidget {
  final String caption;
  final String text;

  const InfoScaffold({
    super.key,
    required this.caption,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: TextStyle(
            fontFamily: AppFont.nanumSquareNeo,
            fontSize: 11.sp,
            fontVariations: const [
              FontVariation('wght', 600),
            ],
            color: AppColor.g300,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppFont.nanumSquareNeo,
            fontSize: 16.sp,
            fontVariations: const [
              FontVariation('wght', 800),
            ],
            color: AppColor.g800,
          ),
        ),
      ],
    );
  }
}
