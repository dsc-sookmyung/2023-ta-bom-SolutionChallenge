import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//font styles
class FontStyle {
  static var appBarTitleStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 13.sp,
    fontVariations: const [
      FontVariation('wght', 600),
    ],
    color: GrayScale.g800,
  );

  static var headlineStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 20.sp,
    fontVariations: const [
      FontVariation('wght', 700),
    ],
    color: GrayScale.g900,
  );

  static var captionStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 10.sp,
    fontVariations: const [
      FontVariation('wght', 700),
    ],
    color: GrayScale.g900,
  );

  static var subCaptionStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 10.sp,
    fontVariations: const [
      FontVariation('wght', 700),
    ],
    color: GrayScale.g600,
  );

  static var emptyNotificationTextStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 12.sp,
    height: 1.65,
    fontVariations: const [
      FontVariation('wght', 700),
    ],
    color: GrayScale.g700,
  );

  static var baseButtonStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 12.sp,
    fontVariations: const [
      FontVariation('wght', 700),
    ],
  );

  static var textInTextFieldStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 12.sp,
    height: 1.65,
    fontVariations: const [
      FontVariation('wght', 500),
    ],
    color: GrayScale.g900,
  );

  static var hintTextInTextFieldStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 12.sp,
    height: 1.65,
    fontVariations: const [
      FontVariation('wght', 400),
    ],
    color: GrayScale.g400,
  );

  static var onboardingTitleTextStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 18.sp,
    height: 1.65,
    fontVariations: const [
      FontVariation('wght', 700),
    ],
    color: GrayScale.g800,
  );

  static var onboardingContentTextStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 12.sp,
    height: 1.65,
    fontVariations: const [
      FontVariation('wght', 500),
    ],
    color: GrayScale.g700,
  );
}

var textFieldDefaultBorderStyle = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(6)).r,
  borderSide: const BorderSide(
    width: 1,
    color: GrayScale.g300,
  ),
);

