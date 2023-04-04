import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';

class Store extends StatelessWidget {
  final String name;
  final String imgUrl;
  final String state;
  final num starRating;
  final Function() callback;

  Store({
    super.key,
    required this.name,
    required this.starRating,
    required this.imgUrl,
    required this.callback,
    required this.state,
  });

  final TextStyle storeCaptionStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 10.sp,
    fontVariations: const [
      FontVariation('wght', 500),
    ],
    color: GrayScale.g600,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 260.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.topCenter,
                  image: NetworkImage(imgUrl),
                ),
              ),
            ),
            Container(
              color: GrayScale.g100,
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: nanumSquareNeo,
                          fontSize: 13.sp,
                          fontVariations: const [
                            FontVariation('wght', 600),
                          ],
                          color: GrayScale.g900,
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Row(
                        children: [
                          Text(
                            state,
                            style: storeCaptionStyle,
                          ),
                          const PaddingBetweenStoreCaption(),
                          Text(
                            "100m(1분 이내)",
                            style: storeCaptionStyle,
                          ),
                          const PaddingBetweenStoreCaption(),
                          SvgPicture.asset(
                            'assets/icons/star_filled.svg',
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            starRating.toString(),
                            style: storeCaptionStyle,
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaddingBetweenStoreCaption extends StatelessWidget {
  const PaddingBetweenStoreCaption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: 2.5.w,
        height: 2.5.w,
        decoration: const BoxDecoration(
          color: GrayScale.g300,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
