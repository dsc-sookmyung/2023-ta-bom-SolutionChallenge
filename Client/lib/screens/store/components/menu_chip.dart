import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuChip extends StatelessWidget {
  final String category;
  const MenuChip(
    this.category, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: primaryLightColor,
      labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(6)).r,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(category),
      labelStyle: TextStyle(
        fontFamily: nanumSquareNeo,
        fontSize: 10.sp,
        fontVariations: const [
          FontVariation('wght', 700),
        ],
        color: primaryColor,
      ),
    );
  }
}
