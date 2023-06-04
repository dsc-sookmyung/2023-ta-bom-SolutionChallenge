import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/components/base_app_bar.dart';
import 'package:good_to_go_restaurant/models/review_model.dart';
import 'package:good_to_go_restaurant/screens/review/components/review.dart';
import 'package:good_to_go_restaurant/services/review_service.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';

class ReviewScreen extends StatelessWidget {
  final String imgUrl =
      'https://image.ajunews.com/content/image/2023/05/01/20230501110501250478.jpg';
  final String storeId = "2pyCnBFjP8IvQl7Gjhjs";
  final bool _isLoading = true;

  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar("리뷰 관리"),
      backgroundColor: AppColor.g50,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(children: [
          SizedBox(
            height: 16.h,
          ),
          FutureBuilder(
              future: ReviewService.getReviewsByStoreId(storeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  throw Error();
                }
                if (!snapshot.hasData) {
                  return const Text("no data");
                } else {
                  return ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final ReviewModel review = snapshot.data![index];
                      return Review(
                          id: review.id,
                          reviewText: review.reviewText,
                          emoji: review.emoji,
                          userName: review.userName,
                          userImgUrl: review.userImgUrl,
                          reviewImgUrl: review.imgUrl,
                          starRating: review.starRating.toDouble(),
                          createdAt: review.createdAt);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 12.h,
                      );
                    },
                  );
                }
              }),
          SizedBox(
            height: 36.h,
          )
        ]),
      ),
    );
  }
}
