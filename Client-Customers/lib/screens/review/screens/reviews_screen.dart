import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/models/review_model.dart';
import 'package:good_to_go/services/review_service.dart';
import 'package:good_to_go/utilities/styles.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/fonts.dart';
import '../components/review.dart';

class ReviewsScreen extends StatelessWidget {
  final appBarTitle = "리뷰 보기";
  final num starRating;
  final int reviewCount;
  final String storeId;
  late Future<List<ReviewModel>> _reviews;

  ReviewsScreen(
      {required this.starRating,
      required this.reviewCount,
      super.key,
      required this.storeId}) {
    _reviews = ReviewService.getReviewsByStoreId(storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(appBarTitle),
      body: SafeArea(
        child: FutureBuilder(
          future: _reviews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                throw Error();
              } else {
                List<ReviewModel> data = snapshot.data!;
                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "아직 작성된 리뷰가 없습니다.\n가게에서 음식 주문 후 리뷰를 작성할 수 있습니다.",
                      style: FontStyle.emptyNotificationTextStyle,
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15).w,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 22.h,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: GrayScale.g200,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22).h,
                            child: Column(
                              children: [
                                Text(
                                  starRating.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: nanumSquareNeo,
                                    fontSize: 32.sp,
                                    fontVariations: const [
                                      FontVariation('wght', 700),
                                    ],
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                RatingBar(
                                  initialRating: starRating.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  itemCount: 5,
                                  glow: false,
                                  itemSize: 15.w,
                                  ratingWidget: RatingWidget(
                                    full: SvgPicture.asset(
                                      'assets/icons/star_filled.svg',
                                      width: 15.w,
                                    ),
                                    half: SvgPicture.asset(
                                      'assets/icons/star_half.svg',
                                      width: 15.w,
                                    ),
                                    empty: SvgPicture.asset(
                                      'assets/icons/star_line.svg',
                                      width: 15.w,
                                    ),
                                  ),
                                  itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 0.5)
                                      .w,
                                  onRatingUpdate: (rating) {},
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: reviewCount.toString(),
                                        style: TextStyle(
                                          fontFamily: nanumSquareNeo,
                                          fontSize: 10.sp,
                                          fontVariations: const [
                                            FontVariation('wght', 700),
                                          ],
                                          color: primaryColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "개 리뷰의 평균 평점입니다.",
                                        style: TextStyle(
                                          fontFamily: nanumSquareNeo,
                                          fontSize: 10.sp,
                                          fontVariations: const [
                                            FontVariation('wght', 500),
                                          ],
                                          color: GrayScale.g600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Review(
                                reviewText: data[index].reviewText,
                                userName: data[index].userName!,
                                userImgUrl: data[index].userImgUrl!,
                                reviewImgUrl: data[index].imgUrl,
                                starRating: data[index].starRating.toDouble(),
                                emoji: data[index].emoji,
                                createdAt: data[index].createdAt);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 28.h,
                            );
                          },
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              throw Error();
            }
          },
        ),
      ),
    );
  }
}
