import 'dart:convert';

import 'package:good_to_go/models/menu_model.dart';
import 'package:good_to_go/models/options_model.dart';
import 'package:http/http.dart' as http;

class MenuService {
  static const String baseUrl = "http://34.64.188.192:8080";
  static const String restrt = "restrt";
  static const String menuList = "menu-list";
  static const String menu = "menu";

  static Future<List<MenuModel>> getMenus(resId) async {
    List<MenuModel> menuInstances = [];
    final url = Uri.parse('$baseUrl/$restrt/$menuList/$resId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      for (var menu in body["data"]) {
        menuInstances.add(MenuModel.fromJson(menu));
      }
      return menuInstances;
    }
    throw Error();
  }

  static Future<MenuModel> getMenu(menuId) async {
    final url = Uri.parse('$baseUrl/$restrt/$menu/$menuId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<OptionsModel> optionsList = [];
      for (var options in body["data"]["option"]) {
        optionsList.add(OptionsModel.fromJson(options));
      }
      return MenuModel.fromJsonWithOptions(body["data"]["menu"], optionsList);
    }
    throw Error();
  }
}
