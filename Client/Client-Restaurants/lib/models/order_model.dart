import 'package:cloud_firestore/cloud_firestore.dart';

import 'menu_model.dart';

class OrderModel {
  final String id, userId, storeId, requirements, paymentMethod, previewText;
  final int totalPrice;
  late List<MenuModel> orderMenuList;
  final Timestamp createdAt;
  Timestamp? packedAt;
  final int orderNumber;
  final bool isReviewWritten;
  String state;

  OrderModel.fromJsonForFireStore(Map<String, dynamic> json, this.id)
      : userId = json["user_id"],
        storeId = json["restrt_id"],
        requirements = json["requirements"],
        paymentMethod = json["payment_method"],
        previewText = json["preview_text"],
        totalPrice = json["total_price"],
        orderNumber = json["order_number"],
        createdAt = json['created_at'],
        packedAt = json['packed_time'],
        state = json["state"],
        isReviewWritten = json["check_review"] {
    final List<MenuModel> orderMenus = [];
    for (var menu in json["orderMenuList"]) {
      orderMenus.add(MenuModel.fromJson(menu));
    }
    orderMenuList = orderMenus;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['restrt_id'] = storeId;
    data['user_id'] = userId;
    data['requirements'] = requirements;
    data['payment_method'] = paymentMethod;
    data['preview_text'] = previewText;
    data['total_price'] = totalPrice;
    return data;
  }
}
