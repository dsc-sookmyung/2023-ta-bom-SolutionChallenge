import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';

class AppStyle {
  static TextStyle buttonTextStyle = TextStyle(
    fontFamily: AppFont.nanumSquareNeo,
    fontSize: 13.sp,
    fontVariations: const [
      FontVariation('wght', 700),
    ],
    color: Colors.white,
  );

  static TextStyle textInTextFieldStyle = TextStyle(
    fontFamily: AppFont.nanumSquareNeo,
    fontSize: 12.sp,
    fontVariations: const [
      FontVariation('wght', 600),
    ],
    color: AppColor.g800,
  );

  static TextStyle hintTextInTextFieldStyle = TextStyle(
    fontFamily: AppFont.nanumSquareNeo,
    fontSize: 12.sp,
    fontVariations: const [
      FontVariation('wght', 500),
    ],
    color: AppColor.g300,
  );

  static TextStyle appBarTitleTextStyle = TextStyle(
    fontFamily: AppFont.nanumSquareNeo,
    fontSize: 13.sp,
    fontVariations: const [
      FontVariation('wght', 600),
    ],
    color: AppColor.g800,
  );

  static TextStyle captionTextStyle = TextStyle(
    fontFamily: AppFont.nanumSquareNeo,
    fontSize: 12.sp,
    fontVariations: const [
      FontVariation('wght', 700),
    ],
    color: AppColor.g900,
  );

  static OutlineInputBorder textFieldDefaultBorderStyle = OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(10)).r,
    borderSide: const BorderSide(
      width: 1,
      color: AppColor.g100,
    ),
  );
}
