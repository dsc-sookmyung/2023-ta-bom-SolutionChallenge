import 'package:good_to_go/models/menu_model.dart';

class OrderModel {
  final String storeName,
      storeImgUrl,
      id,
      userId,
      storeId,
      requirements,
      paymentMethod;
  final int totalPrice;
  late List<MenuModel> orderMenuList;
  late int createdAt;
  late int orderNumber;
  String state = "checking";
  bool isReviewWritten;

  OrderModel(
      {required this.userId,
      required this.storeId,
      required this.requirements,
      required this.paymentMethod,
      required this.totalPrice,
      required this.orderMenuList})
      : storeName = "",
        storeImgUrl = "",
        id = "",
        isReviewWritten = false;

  OrderModel.fromJson(Map<String, dynamic> json)
      : userId = json["user_id"],
        storeId = json["restrt_id"],
        requirements = json["requirements"],
        paymentMethod = json["payment_method"],
        totalPrice = json["total_price"],
        createdAt = json['created_at']['_seconds'] * 1000 +
            (json['created_at']['_nanoseconds'] / 1000000).round(),
        orderNumber = json["order_number"],
        state = json["state"],
        storeName = json["restrt_name"],
        storeImgUrl = json["restrt_img"],
        id = json["id"],
        isReviewWritten = json["check_review"] {
    final List<MenuModel> orderMenus = [];
    for (var menu in json["orderMenuList"]) {
      orderMenus.add(MenuModel.fromJsonForOrder(menu));
    }

    orderMenuList = orderMenus;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['restrt_id'] = storeId;
    data['user_id'] = userId;
    data['requirements'] = requirements;
    data['payment_method'] = paymentMethod;
    data['total_price'] = totalPrice;
    final List<Map<String, dynamic>> menusInCart = [];
    for (var menu in orderMenuList) {
      menusInCart.add(menu.toJson());
    }
    data['orderMenuList'] = menusInCart;
    return data;
  }
}
