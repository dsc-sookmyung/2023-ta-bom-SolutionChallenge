import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/models/order_model.dart';
import 'package:good_to_go/services/order_service.dart';
import 'package:good_to_go/utilities/styles.dart';

import '../components/now_order.dart';
import '../components/past_order.dart';
import 'checkout_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrderScreen> {
  final appBarTitle = "주문";
  late List<OrderModel> _orderModelList;
  final List<OrderModel> _pastOrderList = [];
  final List<OrderModel> _nowOrderList = [];

  bool isLoading = true;
  late String uid;

  void fetchData() async {
    _orderModelList = await OrderService.getOrders(
      userId: uid,
    );

    if (_orderModelList.isNotEmpty) {
      for (var element in _orderModelList) {
        final DateTime date =
            DateTime.fromMicrosecondsSinceEpoch(element.createdAt * 1000);
        final Duration times = DateTime.now().difference(date);

        if (element.state != "packed" && times.inHours < 24) {
          _nowOrderList.add(element);
        } else {
          _pastOrderList.add(element);
        }
      }
    }
    isLoading = false;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    uid = user.uid;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(appBarTitle),
      body: SafeArea(
        child: !isLoading
            ? _orderModelList.isEmpty
                ? Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "아직 주문한 적이 없습니다.\n지금 바로 주문하러 가볼까요?",
                      style: FontStyle.emptyNotificationTextStyle,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15).w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 22.h,
                          ),
                          if (_nowOrderList.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "현재 주문",
                                  style: FontStyle.captionStyle,
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                ListView.separated(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    return NowOrder(
                                        isReviewWritten: _nowOrderList[index]
                                            .isReviewWritten,
                                        storeId: _nowOrderList[index].storeId,
                                        storeName:
                                            _nowOrderList[index].storeName,
                                        storeImgUrl:
                                            _nowOrderList[index].storeImgUrl,
                                        state: _nowOrderList[index].state,
                                        id: _nowOrderList[index].id,
                                        callback: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckoutScreen(
                                                        shouldPop: true,
                                                        orderId:
                                                            _nowOrderList[index]
                                                                .id))));
                                  }),
                                  separatorBuilder: ((context, index) {
                                    return SizedBox(
                                      height: 32.h,
                                    );
                                  }),
                                  itemCount: _nowOrderList.length,
                                ),
                                SizedBox(
                                  height: 32.h,
                                ),
                              ],
                            ),
                          if (_pastOrderList.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "과거 주문",
                                  style: FontStyle.captionStyle,
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                ListView.separated(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    /*
                                    if (!isLastPage &&
                                        index ==
                                            _orderModelList.length -
                                                _nextPageTrigger) {
                                      fetchData();
                                    }
                                    if (index == _orderModelList.length) {
                                      Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child:
                                            const CircularProgressIndicator(),
                                      );
                                    }*/
                                    return PastOrder(
                                      orderModel: _pastOrderList[index],
                                      callback: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutScreen(
                                                      shouldPop: true,
                                                      orderId:
                                                          _pastOrderList[index]
                                                              .id))),
                                    );
                                  }),
                                  separatorBuilder: ((context, index) {
                                    return SizedBox(
                                      height: 24.h,
                                    );
                                  }),
                                  itemCount: _pastOrderList.length,
                                ),
                                SizedBox(
                                  height: 32.h,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
