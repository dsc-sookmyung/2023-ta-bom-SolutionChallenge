import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';

class CardItem extends StatelessWidget {
  final String imgUrl =
      'https://image.ajunews.com/content/image/2023/05/01/20230501110501250478.jpg';
  const CardItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColor.g100,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10).r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    width: 44.w,
                    height: 44.w,
                    fit: BoxFit.cover,
                    imageUrl: imgUrl,
                    placeholder: (context, url) => Container(
                      color: AppColor.g200,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  '메뉴',
                  style: TextStyle(
                    fontFamily: AppFont.nanumSquareNeo,
                    fontSize: 12.sp,
                    fontVariations: const [
                      FontVariation('wght', 600),
                    ],
                    color: AppColor.g700,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.more_vert_rounded,
              size: 20.w,
              color: AppColor.g700,
            ),
          ],
        ),
      ),
    );
  }
}
