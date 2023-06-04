import 'package:good_to_go/models/options_model.dart';

import 'food_container_model.dart';

class MenuModel {
  final int price;
  final int container;
  final String name;
  String? id;
  String? description;
  String? detailCategory;
  String? storeId;
  String? imgUrl;
  List<dynamic> optionsList = [];
  int count = 0;
  int menuPrice = 0;
  int totalPrice = 0;
  String uuid = "";
  List<FoodContainer> containers = [];
  List<FoodContainer> totalContainers = [];

  void updateTotalContainers() {
    List<FoodContainer> list = [];
    for (var i = 0; i < count; i++) {
      for (var element in containers) {
        list.add(element);
      }
    }
    totalContainers = list;
  }

  void updateTotalPrice() {
    totalPrice = count * menuPrice;
  }

  MenuModel.fromJsonForOrder(Map<String, dynamic> json)
      : uuid = json['orderMenuId'],
        price = json['price'],
        name = json['name'],
        count = json['amount'],
        container = json['container'] {
    final List<OptionsModel> options = [];
    for (var i = 0; i < json["menu_option"].length; i++) {
      options.add(OptionsModel.fromJson(json["menu_option"][i]));
    }
    optionsList = options;
  }

  MenuModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        price = json['price'],
        name = json['name'],
        description = json['description'],
        detailCategory = json['detail_category'],
        storeId = json['restrt_id'],
        container = json['container'],
        imgUrl = json['img'],
        optionsList = json['option_id'];

  MenuModel.fromJsonWithOptions(
      Map<String, dynamic> json, List<OptionsModel> optionsListData)
      : id = json['id'],
        price = json['price'],
        name = json['name'],
        description = json['description'],
        detailCategory = json['detail_category'],
        storeId = json['restrt_id'],
        container = json['container'],
        imgUrl = json['img'],
        optionsList = optionsListData;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['menu_id'] = id;
    data['amount'] = count;
    data['price'] = totalPrice;
    final List<Map<String, dynamic>> optionsInOrderList = [];
    for (var options in optionsList) {
      optionsInOrderList.add(options.toJson());
    }
    data['options'] = optionsInOrderList;
    return data;
  }
}
