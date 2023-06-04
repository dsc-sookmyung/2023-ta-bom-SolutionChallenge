import 'dart:convert';

import 'package:good_to_go/models/menus_model.dart';
import 'package:good_to_go/models/store_model.dart';
import 'package:http/http.dart' as http;

class StoreService {
  static const String baseUrl = "http://34.64.188.192:8080";
  static const String restrt = "restrt";
  static const String category = "category";

  static Future<List<StoreModel>> getStoresByCategory(categoryId) async {
    List<StoreModel> storeInstances = [];
    final url = Uri.parse('$baseUrl/$restrt/$category/$categoryId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body["data"] != null) {
        for (var store in body["data"]) {
          storeInstances.add(StoreModel.fromJson(store));
        }
      }
      return storeInstances;
    }
    throw Error();
  }

  static Future<List<StoreModel>> getStores() async {
    List<StoreModel> storeInstances = [];
    final url = Uri.parse('$baseUrl/$restrt');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body["data"] != null) {
        for (var store in body["data"]) {
          storeInstances.add(StoreModel.fromJson(store));
        }
      }
      return storeInstances;
    }
    throw Error();
  }

  static Future<StoreModel> getStoreById(resId) async {
    final url = Uri.parse('$baseUrl/$restrt/$resId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<MenusModel> menuList = [];
      for (var menus in body["data"]["menu_list"]) {
        menuList.add(MenusModel.fromJson(menus));
      }
      final storeModel = StoreModel.fromJsonWithMenu(body["data"], menuList);
      return storeModel;
    }
    throw Error();
  }
}
