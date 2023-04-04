import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/fonts.dart';

class Review extends StatelessWidget {
  final String reviewText, reviewImgUrl, userName, userImgUrl;
  String? emoji;
  final double starRating;
  final int createdAt;

  Review({
    super.key,
    this.emoji,
    required this.reviewText,
    required this.userName,
    required this.userImgUrl,
    required this.reviewImgUrl,
    required this.starRating,
    required this.createdAt,
  });

  String getDateText(int createdAt) {
    final DateTime today = DateTime.now();
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(createdAt * 1000);
    int differenceDay = int.parse(today.difference(date).inDays.toString());
    if (differenceDay == 0) {
      int differenceHour = int.parse(today.difference(date).inHours.toString());
      if (differenceHour == 0) {
        int differenceMinutes =
            int.parse(today.difference(date).inMinutes.toString());
        return "$differenceMinutes분 전";
      }
      return "$differenceHour시간 전";
    } else if (differenceDay == 1) {
      return "하루 전";
    } else if (differenceDay == 2) {
      return "이틀 전";
    }
    return "$differenceDay일 전";
  }

  Widget getEmoji(String? emoji) {
    if (emoji != null && emoji != "") {
      return Container(
        width: 36.w,
        height: 36.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryLightColor,
          borderRadius: const BorderRadius.all(Radius.circular(6)).r,
        ),
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
      );
    }
    return Container(
      width: 36.w,
      height: 36.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GrayScale.g200,
        borderRadius: const BorderRadius.all(Radius.circular(6)).r,
      ),
      child: SvgPicture.asset(width: 24.w, 'assets/icons/contact_support.svg'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18.w,
                  backgroundImage: NetworkImage(userImgUrl),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontFamily: nanumSquareNeo,
                        fontSize: 12.sp,
                        color: GrayScale.g900,
                        fontVariations: const [
                          FontVariation('wght', 400),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        RatingBar(
                          initialRating: starRating,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          glow: false,
                          itemSize: 13.w,
                          ratingWidget: RatingWidget(
                            full: SvgPicture.asset(
                              'assets/icons/star_filled.svg',
                              width: 11.w,
                            ),
                            half: SvgPicture.asset(
                              'assets/icons/star_half.svg',
                              width: 11.w,
                            ),
                            empty: SvgPicture.asset(
                              'assets/icons/star_line.svg',
                              width: 11.w,
                            ),
                          ),
                          itemPadding: const EdgeInsets.only(right: 1.5).w,
                          onRatingUpdate: (rating) {},
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          getDateText(createdAt),
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 10.sp,
                            color: GrayScale.g500,
                            fontVariations: const [
                              FontVariation('wght', 500),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            getEmoji(emoji),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)).r,
          child: Container(
            height: 260.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: FractionalOffset.center,
                image: NetworkImage(reviewImgUrl),
              ),
            ),
          ),
        ),
        Container(
          height: 10.h,
        ),
        Container(
          decoration: BoxDecoration(
            color: GrayScale.g100,
            borderRadius: const BorderRadius.all(Radius.circular(6)).r,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18).w,
            child: Text(
              reviewText,
              style: TextStyle(
                fontFamily: nanumSquareNeo,
                fontSize: 12.sp,
                height: 1.65,
                fontVariations: const [
                  FontVariation('wght', 500),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
