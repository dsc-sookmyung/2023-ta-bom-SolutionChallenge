import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/utilities/functions.dart';
import 'package:intl/intl.dart';

class Menu extends StatelessWidget {
  final String name, description, imgUrl;
  final int price, container;
  final void Function() onPressed;
  final f = NumberFormat('###,###,###,###');

  Menu(
      {required this.name,
      required this.description,
      required this.imgUrl,
      required this.container,
      required this.price,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: GrayScale.g100,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(18).w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SizedBox(
                  height: 80.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: nanumSquareNeo,
                                  fontSize: 13.sp,
                                  fontVariations: const [
                                    FontVariation('wght', 500),
                                  ],
                                  color: GrayScale.g800,
                                ),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              if (container != 0)
                                Functions.getContainerSvg(container, 20.w)!,
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: nanumSquareNeo,
                              fontSize: 10.sp,
                              height: 1.5,
                              fontVariations: const [
                                FontVariation('wght', 400),
                              ],
                              color: GrayScale.g600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${f.format(price)}원',
                        style: TextStyle(
                          fontFamily: nanumSquareNeo,
                          fontSize: 12.sp,
                          fontVariations: const [
                            FontVariation('wght', 700),
                          ],
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 28.w),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(6)).r,
                  child: Container(
                    height: 80.w,
                    width: 80.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter,
                        image: NetworkImage(imgUrl),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
