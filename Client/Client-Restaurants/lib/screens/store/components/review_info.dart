import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';

import 'info_scaffold.dart';

class ReviewInfo extends StatelessWidget {
  final num rating;
  final int reviewCount;
  const ReviewInfo({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColor.g100,
          ),
          borderRadius: BorderRadius.circular(12).r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 18.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/img_chat.png',
              width: 40.w,
            ),
            SizedBox(
              width: 16.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoScaffold(
                  caption: "평균 평점",
                  text: rating.toString(),
                ),
                SizedBox(
                  height: 16.h,
                ),
                InfoScaffold(
                  caption: "총 리뷰 개수",
                  text: '${reviewCount.toString()}개',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
