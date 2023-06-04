import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/components/base_filled_button.dart';
import 'package:good_to_go_restaurant/models/menu_model.dart';
import 'package:good_to_go_restaurant/models/options_model.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';
import 'package:good_to_go_restaurant/utilities/variables.dart';
import 'package:intl/intl.dart';

class NewOrder extends StatelessWidget {
  final Timestamp createdAt;
  final String state;
  final int totalPrice;
  final int orderNumber;
  final String requirements;
  final List<MenuModel> orderMenuList;
  final void Function() changeState;

  const NewOrder({
    super.key,
    required this.createdAt,
    required this.state,
    required this.totalPrice,
    required this.orderNumber,
    required this.requirements,
    required this.orderMenuList,
    required this.changeState,
  });

  String _formatTimeStamp(Timestamp timestamp) {
    final int createdInNum =
        (timestamp.seconds * 1000 + timestamp.nanoseconds / 1000000).round();
    final DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(createdInNum * 1000);
    String dateString = DateFormat.jm().format(date);
    return dateString;
  }

  String _getButtonText(state) {
    if (state == OrderType.checking.name) return "주문 수락하기";
    if (state == OrderType.cooking.name) return "요리 완료 알리기";
    if (state == OrderType.cooked.name) return "손님이 포장을 완료했습니다";
    return '포장 완료';
  }

  Color _getStateTextColor(state) {
    if (state == OrderType.checking.name) return AppColor.primaryColor;
    if (state == OrderType.cooking.name) return AppColor.green;
    if (state == OrderType.cooked.name) return AppColor.blue;
    return AppColor.g400;
  }

  Color _getStateBackgroundColor(state) {
    if (state == OrderType.checking.name) return AppColor.primaryLightColor;
    if (state == OrderType.cooking.name) return AppColor.greenLight;
    if (state == OrderType.cooked.name) return AppColor.blueLight;
    return AppColor.g50;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTimeStamp(createdAt),
                  style: TextStyle(
                    fontFamily: AppFont.nanumSquareNeo,
                    fontSize: 18.sp,
                    fontVariations: const [
                      FontVariation('wght', 800),
                    ],
                    color: AppColor.g900,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _getStateBackgroundColor(state),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                    child: Text(
                      AppVariables.orderStates[state]!,
                      style: TextStyle(
                        fontFamily: AppFont.nanumSquareNeo,
                        fontSize: 13.sp,
                        fontVariations: const [
                          FontVariation('wght', 700),
                        ],
                        color: _getStateTextColor(state),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            ListView.separated(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return NewOrderMenu(
                    name: orderMenuList[index].name,
                    count: orderMenuList[index].count,
                    optionsList: orderMenuList[index].optionsList,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 12.h,
                  );
                },
                itemCount: orderMenuList.length),
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 10.h),
              child: const Divider(
                thickness: 3,
                color: AppColor.g50,
              ),
            ),
            Text(
              "총 결제 금액: ${NumberFormat('###,###,###,###').format(totalPrice)}원\n주문 번호: $orderNumber",
              style: TextStyle(
                fontFamily: AppFont.nanumSquareNeo,
                fontSize: 12.sp,
                height: 1.6,
                fontVariations: const [
                  FontVariation('wght', 500),
                ],
                color: AppColor.g300,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Requirement(
              text: requirements,
            ),
            if (state != OrderType.packed.name)
              SizedBox(
                height: 24.h,
              ),
            if (state != OrderType.packed.name)
              BaseFilledButton(_getButtonText(state), changeState),
          ],
        ),
      ),
    );
  }
}

class Requirement extends StatelessWidget {
  final String text;

  const Requirement({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: AppColor.g50,
          ),
          borderRadius: BorderRadius.circular(12).r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "요청 사항",
              style: TextStyle(
                fontFamily: AppFont.nanumSquareNeo,
                fontSize: 12.sp,
                height: 1.6,
                fontVariations: const [
                  FontVariation('wght', 500),
                ],
                color: AppColor.g400,
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: AppFont.nanumSquareNeo,
                  fontSize: 12.sp,
                  height: 1.6,
                  fontVariations: const [
                    FontVariation('wght', 600),
                  ],
                  color: AppColor.g600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewOrderMenu extends StatelessWidget {
  final String name;
  final int count;
  final List<OptionsModel> optionsList;

  const NewOrderMenu({
    super.key,
    required this.name,
    required this.count,
    required this.optionsList,
  });

  String _getOptionsText(List<OptionsModel> optionsList) {
    String text = "";
    for (var options in optionsList) {
      text = '$text- ${options.optionName}: ';
      for (var option in options.optionList) {
        text = '$text${option.name}, ';
        text = text.trim();
        if (text.endsWith(',')) {
          text = text.substring(0, text.length - 1);
        }
      }
      text = '$text\n';
    }
    text = text.trim();
    if (text.endsWith(',')) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontFamily: AppFont.nanumSquareNeo,
                fontSize: 12.sp,
                fontVariations: const [
                  FontVariation('wght', 700),
                ],
                color: AppColor.g700,
              ),
            ),
            Text(
              '${count.toString()}개',
              style: TextStyle(
                fontFamily: AppFont.nanumSquareNeo,
                fontSize: 12.sp,
                fontVariations: const [
                  FontVariation('wght', 600),
                ],
                color: AppColor.g600,
              ),
            ),
          ],
        ),
        if (optionsList.isNotEmpty)
          SizedBox(
            height: 4.h,
          ),
        if (optionsList.isNotEmpty)
          Text(
            _getOptionsText(optionsList),
            style: TextStyle(
              fontFamily: AppFont.nanumSquareNeo,
              fontSize: 12.sp,
              height: 1.6,
              fontVariations: const [
                FontVariation('wght', 500),
              ],
              color: AppColor.g400,
            ),
          ),
      ],
    );
  }
}
