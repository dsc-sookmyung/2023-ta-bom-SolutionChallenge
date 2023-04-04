import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';

class MenuCategory extends StatelessWidget {
  final String name;
  final String assetName;
  final bool isSelected;
  final bool isNearby;
  final Function() callback;

  MenuCategory({
    Key? key,
    required this.name,
    required this.assetName,
    required this.isSelected,
    required this.isNearby,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSelected
        ? primaryLightColor
        : isNearby
        ? primaryLightColor.withOpacity(0.5)
        : GrayScale.g200;

    Color textColor = isSelected
        ? primaryColor
        : isNearby
        ? primaryColor.withOpacity(0.5)
        : GrayScale.g500;

    return GestureDetector(
      onTap: callback,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
            ),
            child: Padding(
              padding: EdgeInsets.all(7.w),
              child: SvgPicture.asset(
                "assets/icons/menu_category/$assetName",
                width: 44.w,
                height: 44.w,
              ),
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontFamily: nanumSquareNeo,
              fontSize: 10.sp,
              fontVariations: const [
                FontVariation('wght', 600),
              ],
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
