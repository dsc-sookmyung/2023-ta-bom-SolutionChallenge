import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/components/base_outlined_button.dart';
import 'package:good_to_go/models/order_model.dart';
import 'package:good_to_go/screens/review/screens/write_review_screen.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:intl/intl.dart';

class PastOrder extends StatelessWidget {
  final OrderModel orderModel;
  final void Function() callback;
  final f = NumberFormat('###,###,###,###');

  PastOrder({
    super.key,
    required this.callback,
    required this.orderModel,
  });

  String formatMenuText() {
    if (orderModel.orderMenuList.length == 1) {
      return orderModel.orderMenuList[0].name;
    }
    return "${orderModel.orderMenuList[0].name} 외 ${orderModel.orderMenuList.length - 1}개";
  }

  bool isTwoDaysDidntPast(createdAt) {
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(createdAt * 1000);
    final Duration times = DateTime.now().difference(date);
    if (times.inHours < 48) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: callback,
          child: Container(
            decoration: BoxDecoration(
              color: GrayScale.g100,
              borderRadius: const BorderRadius.all(Radius.circular(6)).r,
            ),
            child: Padding(
              padding: EdgeInsets.all(18.w),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 12.w),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6)).r,
                      child: Container(
                        height: 70.w,
                        width: 70.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: FractionalOffset.topCenter,
                            image: NetworkImage(orderModel.storeImgUrl),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 60.w,
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
                                  orderModel.storeName,
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
                                  height: 5.h,
                                ),
                                Text(
                                  formatMenuText(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: nanumSquareNeo,
                                    fontSize: 10.sp,
                                    fontVariations: const [
                                      FontVariation('wght', 500),
                                    ],
                                    color: GrayScale.g600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${f.format(orderModel.totalPrice)}원',
                              style: TextStyle(
                                fontFamily: nanumSquareNeo,
                                fontSize: 13.sp,
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
                  ),
                ],
              ),
            ),
          ),
        ),
        if (orderModel.state == "packed" &&
            isTwoDaysDidntPast(orderModel.createdAt) &&
            !orderModel.isReviewWritten)
          Column(
            children: [
              SizedBox(
                height: 6.h,
              ),
              BaseOutlinedButton(
                color: GrayScale.g600,
                "리뷰 작성하기(2일 이내 가능)",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WriteReviewScreen(
                            storeId: orderModel.storeId,
                            orderId: orderModel.id))),
              ),
            ],
          ),
      ],
    );
  }
}
