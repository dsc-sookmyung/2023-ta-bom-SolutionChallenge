import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/models/order_model.dart';
import 'package:good_to_go_restaurant/provider/user_provider.dart';
import 'package:good_to_go_restaurant/screens/order/components/new_order.dart';
import 'package:good_to_go_restaurant/screens/order/components/past_order.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';
import 'package:good_to_go_restaurant/utilities/variables.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = [
    const Tab(text: "새로운 주문"),
    const Tab(text: "과거 주문"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeId = context.read<UserProvider>().storeId;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48.h,
        bottom: TabBar(
          controller: _tabController,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          indicator: BoxDecoration(
              borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))
                  .r,
              color: AppColor.g600),
          labelColor: Colors.white,
          labelStyle: TextStyle(
            fontFamily: AppFont.nanumSquareNeo,
            fontSize: 13.sp,
            fontVariations: const [
              FontVariation('wght', 700),
            ],
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: AppFont.nanumSquareNeo,
            fontSize: 13.sp,
            fontVariations: const [
              FontVariation('wght', 600),
            ],
          ),
          unselectedLabelColor: AppColor.g200,
          tabs: _tabs,
        ),
        title: const Text(
          "주문 관리",
        ),
        titleTextStyle: TextStyle(
          fontFamily: AppFont.nanumSquareNeo,
          fontSize: 13.sp,
          fontVariations: const [
            FontVariation('wght', 600),
          ],
          color: AppColor.g800,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: AppColor.g600,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('restrt_id', isEqualTo: storeId)
                  .where('state', isNotEqualTo: OrderType.packed.name)
                  .orderBy('state')
                  .orderBy("created_at", descending: true)
                  .withConverter<OrderModel>(
                    fromFirestore: (snapshots, _) =>
                        OrderModel.fromJsonForFireStore(
                            snapshots.data()!, snapshots.id),
                    toFirestore: (message, _) => message.toJson(),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.none:
                    return const Center(
                      child: Text("연결이 없습니다."),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      debugPrint(snapshot.error.toString());
                      throw Error();
                    }
                    if (!snapshot.hasData) {
                      return const Text("해당하는 데이터가 없습니다.");
                    } else {
                      if (snapshot.data!.size == 0) {
                        return Center(
                            child: Text(
                          "새로운 주문이 없습니다",
                          style: TextStyle(
                            fontFamily: AppFont.nanumSquareNeo,
                            fontSize: 12.sp,
                            fontVariations: const [
                              FontVariation('wght', 500),
                            ],
                            color: Colors.white,
                          ),
                        ));
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 32.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: ListView.separated(
                                itemCount: snapshot.data!.size,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 24.h,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  final OrderModel order =
                                      snapshot.data!.docs[index].data();
                                  return NewOrder(
                                    changeState: () async {
                                      if (order.state ==
                                          OrderType.checking.name) {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order.id)
                                            .update({
                                          'state': OrderType.cooking.name
                                        });
                                      } else if (order.state ==
                                          OrderType.cooking.name) {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order.id)
                                            .update({
                                          'state': OrderType.cooked.name
                                        });
                                      } else if (order.state ==
                                          OrderType.cooked.name) {
                                        final packedTime =
                                            Timestamp.fromDate(DateTime.now());
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order.id)
                                            .update({
                                          'state': OrderType.packed.name,
                                          'packed_time': packedTime,
                                        });
                                      }
                                    },
                                    createdAt: order.createdAt,
                                    orderMenuList: order.orderMenuList,
                                    orderNumber: order.orderNumber,
                                    requirements: order.requirements,
                                    state: order.state,
                                    totalPrice: order.totalPrice,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                          ],
                        ),
                      );
                    }
                }
              },
            ),
          ),
          Container(
            color: AppColor.g600,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('restrt_id', isEqualTo: storeId)
                  .where('state', isEqualTo: OrderType.packed.name)
                  .orderBy("created_at", descending: true)
                  .withConverter<OrderModel>(
                    fromFirestore: (snapshots, _) =>
                        OrderModel.fromJsonForFireStore(
                            snapshots.data()!, snapshots.id),
                    toFirestore: (message, _) => message.toJson(),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.none:
                    return const Center(
                      child: Text("연결이 없습니다."),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      debugPrint(snapshot.error.toString());
                      throw Error();
                    }
                    if (!snapshot.hasData) {
                      return const Text("해당하는 데이터가 없습니다.");
                    } else {
                      if (snapshot.data!.size == 0) {
                        return Center(
                            child: Text(
                          "새로운 주문이 없습니다",
                          style: TextStyle(
                            fontFamily: AppFont.nanumSquareNeo,
                            fontSize: 12.sp,
                            fontVariations: const [
                              FontVariation('wght', 500),
                            ],
                            color: Colors.white,
                          ),
                        ));
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 32.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: ListView.separated(
                                itemCount: snapshot.data!.size,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 24.h,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  final OrderModel order =
                                      snapshot.data!.docs[index].data();
                                  return PastOrder(
                                    createdAt: order.createdAt,
                                    orderMenuList: order.orderMenuList,
                                    orderNumber: order.orderNumber,
                                    requirements: order.requirements,
                                    state: order.state,
                                    totalPrice: order.totalPrice,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                          ],
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
