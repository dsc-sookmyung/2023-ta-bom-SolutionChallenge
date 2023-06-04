import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';

class AccountItem extends StatelessWidget {
  final String text;
  final String? secondText;

  const AccountItem({
    super.key,
    required this.text,
    this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: AppFont.nanumSquareNeo,
                fontSize: 13.sp,
                fontVariations: const [
                  FontVariation('wght', 500),
                ],
                color: AppColor.g800,
              ),
            ),
            if (secondText != null)
              Text(
                secondText!,
                style: TextStyle(
                  fontFamily: AppFont.nanumSquareNeo,
                  fontSize: 13.sp,
                  fontVariations: const [
                    FontVariation('wght', 600),
                  ],
                  color: AppColor.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
