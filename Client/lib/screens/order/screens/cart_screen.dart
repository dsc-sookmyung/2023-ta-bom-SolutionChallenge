import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/components/base_filled_button.dart';
import 'package:good_to_go/models/menu_model.dart';
import 'package:good_to_go/models/options_model.dart';
import 'package:good_to_go/models/order_model.dart';
import 'package:good_to_go/models/store_model.dart';
import 'package:good_to_go/provider/cart_provider.dart';
import 'package:good_to_go/provider/user_provider.dart';
import 'package:good_to_go/screens/order/screens/checkout_screen.dart';
import 'package:good_to_go/services/order_service.dart';
import 'package:good_to_go/services/store_service.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/cart_item.dart';

enum PaymentMethod { googlePay, cash }

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String appBarTitle = "장바구니";

  final TextEditingController _textController = TextEditingController();

  late PaymentMethod paymentMethod;
  late String storeImgUrl;
  late String storeName;

  bool isPaymentMethodIsSelected = false;
  bool isLoading = true;

  final NumberFormat f = NumberFormat('###,###,###,###');

  initStoreData() async {
    final StoreModel store =
        await StoreService.getStoreById(context.read<CartProvider>().storeId);
    storeImgUrl = store.imgUrl;
    storeName = store.name;
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (context.read<CartProvider>().menusInCart.isNotEmpty) {
      initStoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(appBarTitle),
      body: context.watch<CartProvider>().menusInCart.isEmpty
          ? Center(
              child: Text(
                textAlign: TextAlign.center,
                "장바구니가 비었습니다.\n뒤로가기를 누른 다음 먹고 싶은 메뉴를 담아 주세요.",
                style: FontStyle.emptyNotificationTextStyle,
              ),
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15).w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 22.h,
                          ),
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))
                                        .r,
                                child: Container(
                                  height: 70.w,
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(storeImgUrl),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                storeName,
                                style: TextStyle(
                                  fontFamily: nanumSquareNeo,
                                  fontSize: 13.sp,
                                  fontVariations: const [
                                    FontVariation('wght', 600),
                                  ],
                                  color: GrayScale.g900,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            "주문한 메뉴",
                            style: FontStyle.captionStyle,
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          ListView.separated(
                            itemCount: context
                                .watch<CartProvider>()
                                .menusInCart
                                .length,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => CartItem(
                                name: context
                                    .read<CartProvider>()
                                    .menusInCart[index]
                                    .name,
                                optionsList: context
                                    .read<CartProvider>()
                                    .menusInCart[index]
                                    .optionsList as List<OptionsModel>,
                                count: context
                                    .read<CartProvider>()
                                    .menusInCart[index]
                                    .count,
                                price: context
                                    .read<CartProvider>()
                                    .menusInCart[index]
                                    .totalPrice,
                                containerList: context
                                    .read<CartProvider>()
                                    .menusInCart[index]
                                    .totalContainers,
                                callback: () {
                                  context.read<CartProvider>().removeMenuInCart(
                                      context
                                          .read<CartProvider>()
                                          .menusInCart[index]
                                          .uuid);
                                }),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 14.h,
                            ),
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          Text(
                            "요청사항",
                            style: FontStyle.captionStyle,
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          TextField(
                            controller: _textController,
                            style: FontStyle.textInTextFieldStyle,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: '요청 사항을 작성해 주세요.',
                              hintStyle: FontStyle.hintTextInTextFieldStyle,
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: textFieldDefaultBorderStyle,
                              enabledBorder: textFieldDefaultBorderStyle,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 18.w, vertical: 18.h),
                            ),
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          Row(
                            children: [
                              Text(
                                "결제 수단",
                                style: FontStyle.captionStyle,
                              ),
                              Text(
                                " (필수)",
                                style: TextStyle(
                                  fontFamily: nanumSquareNeo,
                                  fontSize: 10.sp,
                                  fontVariations: const [
                                    FontVariation('wght', 700),
                                  ],
                                  color: primaryColor,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Row(
                            children: [
                              /*
                          PaymentItem(
                            method: PaymentMethod.googlePay,
                            child:
                                SvgPicture.asset("assets/icons/googlepay.svg"),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),*/
                              GestureDetector(
                                onTap: () {
                                  isPaymentMethodIsSelected =
                                      !isPaymentMethodIsSelected;
                                  setState(() {});
                                },
                                child: Container(
                                  width: 120.w,
                                  height: 80.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isPaymentMethodIsSelected
                                        ? primaryLightColor
                                        : GrayScale.g100,
                                    borderRadius: const BorderRadius.all(
                                            Radius.circular(6))
                                        .r,
                                  ),
                                  child: Text(
                                    "현금결제",
                                    style: TextStyle(
                                      fontFamily: nanumSquareNeo,
                                      fontSize: 20.sp,
                                      fontVariations: const [
                                        FontVariation('wght', 600),
                                      ],
                                      color: isPaymentMethodIsSelected
                                          ? primaryColor
                                          : GrayScale.g600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "총 결제 금액",
                                style: TextStyle(
                                  fontFamily: nanumSquareNeo,
                                  fontSize: 12.sp,
                                  fontVariations: const [
                                    FontVariation('wght', 700),
                                  ],
                                  color: GrayScale.g900,
                                ),
                              ),
                              Text(
                                '${f.format(context.read<CartProvider>().getCartItemsTotalPrice())}원',
                                style: TextStyle(
                                  fontFamily: nanumSquareNeo,
                                  fontSize: 20.sp,
                                  fontVariations: const [
                                    FontVariation('wght', 700),
                                  ],
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          BaseFilledButton(
                              isDisable: !isPaymentMethodIsSelected,
                              "${f.format(context.read<CartProvider>().getCartItemsTotalPrice())}원 결제하기",
                              () async {
                            //메뉴 레스트 option 선택된 거 없는 options 제거하기
                            final List<MenuModel> orderMenuList =
                                context.read<CartProvider>().menusInCart;
                            for (var menuIdx = 0;
                                menuIdx < orderMenuList.length;
                                menuIdx++) {
                              for (var optionsIdx = 0;
                                  optionsIdx <
                                      orderMenuList[menuIdx].optionsList.length;
                                  optionsIdx++) {
                                orderMenuList[menuIdx].optionsList.removeWhere(
                                    (element) => element.checkedCount == 0);
                              }
                            }
                            final OrderModel orderModel = OrderModel(
                                userId: context.read<UserProvider>().user!.uid,
                                storeId: context.read<CartProvider>().storeId,
                                requirements: _textController.text == ""
                                    ? '(없음)'
                                    : _textController.text,
                                paymentMethod: "현금 결제",
                                totalPrice: context
                                    .read<CartProvider>()
                                    .getCartItemsTotalPrice(),
                                orderMenuList: orderMenuList);
                            final String orderId = await OrderService.postOrder(
                                orderModel.toJson());

                            if (context.mounted) {
                              context.read<CartProvider>().clearMenuInCart();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('주문 접수를 요청했습니다.'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: GrayScale.g800,
                              ));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CheckoutScreen(orderId: orderId)),
                                  (route) => false);
                            }
                          }),
                          SizedBox(
                            height: 32.h,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}

class PaymentItem extends StatefulWidget {
  final Widget child;
  final PaymentMethod method;
  bool isSelected = false;

  PaymentItem({
    super.key,
    required this.child,
    required this.method,
  });

  @override
  State<PaymentItem> createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSelected = !isSelected;
        setState(() {});
      },
      child: Container(
        width: 120.w,
        height: 80.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryLightColor : GrayScale.g100,
          borderRadius: const BorderRadius.all(Radius.circular(6)).r,
        ),
        child: widget.child,
      ),
    );
  }
}
