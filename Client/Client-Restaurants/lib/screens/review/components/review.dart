import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/services/review_service.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';
import 'package:good_to_go_restaurant/utilities/variables.dart';

class Review extends StatefulWidget {
  final String id, reviewText, reviewImgUrl, userName, userImgUrl;
  String? emoji;
  final double starRating;
  final int createdAt;

  Review({
    super.key,
    this.emoji,
    required this.id,
    required this.reviewText,
    required this.userName,
    required this.userImgUrl,
    required this.reviewImgUrl,
    required this.starRating,
    required this.createdAt,
  });

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final TextEditingController _controller = TextEditingController();

  bool showEmojis = false;

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
          color: AppColor.g50,
          borderRadius: const BorderRadius.all(Radius.circular(6)).r,
        ),
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: 20.sp,
          ),
        ),
      );
    }
    return Container(
      width: 36.w,
      height: 36.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.g200,
        borderRadius: const BorderRadius.all(Radius.circular(6)).r,
      ),
      child: const Icon(Icons.support_agent_rounded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12).r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    width: 32.w,
                    height: 32.w,
                    fit: BoxFit.cover,
                    imageUrl: widget.userImgUrl,
                    placeholder: (context, url) => Container(
                      color: AppColor.g100,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: TextStyle(
                                  fontFamily: AppFont.nanumSquareNeo,
                                  fontSize: 12.sp,
                                  color: AppColor.g900,
                                  fontVariations: const [
                                    FontVariation('wght', 500),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                getDateText(widget.createdAt),
                                style: TextStyle(
                                  fontFamily: AppFont.nanumSquareNeo,
                                  fontSize: 10.sp,
                                  color: AppColor.g500,
                                  fontVariations: const [
                                    FontVariation('wght', 500),
                                  ],
                                ),
                              )
                            ],
                          ),
                          (widget.emoji != null && widget.emoji != '')
                              ? getEmoji(widget.emoji!)
                              : OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColor.blueLight,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6).r,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 8.w),
                                    side: const BorderSide(
                                        width: 0, color: AppColor.g50),
                                  ),
                                  onPressed: () {
                                    showEmojis = !showEmojis;

                                    setState(() {});
                                  },
                                  child: Text(
                                    showEmojis ? '닫기' : '반응 보내기',
                                    style: TextStyle(
                                      fontFamily: AppFont.nanumSquareNeo,
                                      fontSize: 10.sp,
                                      height: 1.3,
                                      fontVariations: const [
                                        FontVariation('wght', 500),
                                      ],
                                      color: AppColor.blue,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      RatingBar(
                        initialRating: widget.starRating,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        glow: false,
                        itemSize: 16.w,
                        ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star_rate_rounded,
                            color: AppColor.primaryColor,
                          ),
                          half: const Icon(
                            Icons.star_half_rounded,
                            color: AppColor.primaryColor,
                          ),
                          empty: const Icon(
                            Icons.star_outline_rounded,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.reviewText,
                              style: TextStyle(
                                fontFamily: AppFont.nanumSquareNeo,
                                fontSize: 12.sp,
                                height: 1.65,
                                fontVariations: const [
                                  FontVariation('wght', 500),
                                ],
                                color: AppColor.g800,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: CachedNetworkImage(
                                width: 68.w,
                                height: 68.w,
                                fit: BoxFit.cover,
                                imageUrl: widget.reviewImgUrl,
                                placeholder: (context, url) => Container(
                                  color: AppColor.g100,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showEmojis)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12).r,
              color: Colors.white,
            ),
            child: GridView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 0.w,
                vertical: 0.h,
              ),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 4.h,
                crossAxisSpacing: 4.w,
              ),
              children: [
                for (var emojiData in AppVariables.emojis)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      padding: EdgeInsets.zero,
                      side: const BorderSide(width: 1, color: AppColor.g50),
                    ),
                    onPressed: () async {
                      await ReviewService.postEmoji(widget.id, emojiData);
                      widget.emoji = emojiData;
                      showEmojis = false;
                      setState(() {});
                    },
                    child: Text(
                      emojiData,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
