import 'package:good_to_go/models/menu_model.dart';

class MenusModel {
  late String category;
  late List<MenuModel> menuList;

  MenusModel.fromJson(Map<String, dynamic> json) {
    category = json['detail_category'];
    List<MenuModel> menus = [];
    for (var menu in json['menuList']) {
      menus.add(MenuModel.fromJson(menu));
    }
    menuList = menus;
  }
}
