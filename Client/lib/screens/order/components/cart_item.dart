import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/models/food_container_model.dart';
import 'package:good_to_go/models/options_model.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/functions.dart';
import 'package:intl/intl.dart';

class CartItem extends StatelessWidget {
  final String name;
  final List<OptionsModel> optionsList;
  final int count, price;
  final List<FoodContainer> containerList;
  final Function()? callback;

  final NumberFormat f = NumberFormat('###,###,###,###');
  CartItem({
    super.key,
    required this.name,
    required this.optionsList,
    required this.count,
    required this.price,
    required this.containerList,
    required this.callback,
  });

  String getOptionText() {
    String text = "";
    for (var options in optionsList) {
      String optionText = "";
      bool isAnyOptionChecked = false;
      optionText += '${options.optionName}: ';
      for (var option in options.optionList) {
        if (option.isChecked) {
          optionText += '${option.name}, ';
          isAnyOptionChecked = true;
        }
      }
      if (isAnyOptionChecked) {
        text += '$optionText\n';
      }
    }

    text = text.trim();
    if (text.endsWith(',')) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GrayScale.g100,
        borderRadius: const BorderRadius.all(Radius.circular(6)).r,
      ),
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 13.sp,
                            fontVariations: const [
                              FontVariation('wght', 600),
                            ],
                            color: GrayScale.g700,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          getOptionText(),
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 10.sp,
                            height: 1.5,
                            fontVariations: const [
                              FontVariation('wght', 500),
                            ],
                            color: GrayScale.g600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "총 $count개",
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 10.sp,
                            fontVariations: const [
                              FontVariation('wght', 500),
                            ],
                            color: GrayScale.g600,
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          '${f.format(price)}원',
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 13.sp,
                            fontVariations: const [
                              FontVariation('wght', 600),
                            ],
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)).r,
                      ),
                      child: GridView(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.all(6.w),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          mainAxisSpacing: 0.h,
                        ),
                        children: [
                          for (var containerNum in containerList)
                            if (containerNum.containerNum != 0)
                              Functions.getContainerSvg(
                                  containerNum.containerNum, 24.w)!,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.w),
              child: GestureDetector(
                  onTap: callback,
                  child: SvgPicture.asset('assets/icons/delete.svg')),
            ),
          ],
        ),
      ),
    );
  }
}
