import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/components/base_filled_button.dart';
import 'package:good_to_go/components/base_scaffold.dart';
import 'package:good_to_go/components/prepare_container_widget.dart';
import 'package:good_to_go/models/food_container_model.dart';
import 'package:good_to_go/models/order_model.dart';
import 'package:good_to_go/provider/user_provider.dart';
import 'package:good_to_go/services/order_service.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:good_to_go/utilities/variables.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final String orderId;
  final bool shouldPop;

  const CheckoutScreen(
      {super.key, required this.orderId, this.shouldPop = false});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final String appBarTitle = "주문내역";
  late OrderModel _order;
  late String paymentText;
  final List<FoodContainer> containerList = [];
  bool isLoading = true;
  String orderMenuText = "";

  final numberFormat = NumberFormat('###,###,###,###');

  String getDate(int createdAt) {
    final DateTime date = DateTime.fromMicrosecondsSinceEpoch(createdAt * 1000);
    return DateFormat("yyyy. MM. dd HH:mm").format(date);
  }

  void initData() async {
    _order = await OrderService.getOrder(widget.orderId);
    initContainerAndText();
    isLoading = false;
    setState(() {});
  }

  void initContainerAndText() {
    String text = "";
    for (var menu in _order.orderMenuList) {
      text = '$text${menu.name}(${menu.count}개)\n';
      if (menu.container != 0) {
        for (var i = 0; i < menu.count; i++) {
          containerList.add(FoodContainer(menu.uuid, menu.container));
        }
      }
      for (var options in menu.optionsList) {
        text = '$text- ${options.optionName}: ';
        for (var option in options.optionList) {
          text = '$text${option.name}, ';
          if (option.container != 0) {
            for (var i = 0; i < menu.count; i++) {
              containerList.add(FoodContainer(option.id, option.container));
            }
          }
          text = text.trim();
          if (text.endsWith(',')) {
            text = text.substring(0, text.length - 1);
          }
        }
        text = '$text\n';
      }
    }
    text = text.trim();
    if (text.endsWith(',')) {
      text = text.substring(0, text.length - 1);
    }
    orderMenuText = text;
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(appBarTitle),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15).w,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 22.h,
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)).r,
                          child: Container(
                            height: 70.w,
                            width: 70.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.topCenter,
                                image: NetworkImage(_order.storeImgUrl),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          _order.storeName,
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
                          height: 28.h,
                        ),
                        PrepareContainerWdiget(containerList: containerList),
                        SizedBox(
                          height: 28.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "주문자 정보",
                              style: FontStyle.captionStyle,
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: GrayScale.g100,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))
                                        .r,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18).w,
                                child: Wrap(
                                  runSpacing: 8.h,
                                  children: [
                                    OrderInfo(
                                        "닉네임",
                                        context
                                            .read<UserProvider>()
                                            .user!
                                            .displayName!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 28.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "주문 정보",
                              style: FontStyle.captionStyle,
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: GrayScale.g100,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))
                                        .r,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18).w,
                                child: Wrap(
                                  runSpacing: 8.h,
                                  children: [
                                    OrderInfo(
                                        "주문 번호", _order.orderNumber.toString()),
                                    OrderInfo("주문 상태",
                                        Variables.orderStates[_order.state]!),
                                    OrderInfo(
                                        "결제 일시", getDate(_order.createdAt)),
                                    OrderInfo("메뉴", orderMenuText),
                                    OrderInfo("결제 금액",
                                        '${numberFormat.format(_order.totalPrice)}원'),
                                    OrderInfo("결제 수단", _order.paymentMethod),
                                    OrderInfo("요청 사항", _order.requirements),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 28.h,
                            ),
                            BaseFilledButton('확인', () {
                              widget.shouldPop
                                  ? Navigator.pop(context)
                                  : Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BaseScaffold()),
                                      (route) => false);
                            }),
                            SizedBox(
                              height: 32.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class OrderInfo extends StatelessWidget {
  final String title, content;

  final orderInfoTextStyle = TextStyle(
    fontFamily: nanumSquareNeo,
    fontSize: 12.sp,
    height: 1.65,
    fontVariations: const [
      FontVariation('wght', 500),
    ],
    color: GrayScale.g700,
  );

  OrderInfo(this.title, this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: orderInfoTextStyle,
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.only(left: 8.w),
            child: Text(
              content,
              style: orderInfoTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
