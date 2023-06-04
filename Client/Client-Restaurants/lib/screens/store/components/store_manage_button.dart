import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';

class StoreManageButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final IconData icon;

  const StoreManageButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: AppColor.blueLight,
          borderRadius: BorderRadius.circular(12).r,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 28.w,
                  color: AppColor.blue,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: AppFont.nanumSquareNeo,
                    fontSize: 13.sp,
                    fontVariations: const [
                      FontVariation('wght', 700),
                    ],
                    color: AppColor.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
