import 'dart:convert';

import 'package:good_to_go_restaurant/models/store_model.dart';
import 'package:http/http.dart' as http;

import '../models/revenue_model.dart';

class StoreService {
  static const String baseUrl = "http://34.64.188.192:8080";
  static const String restrt = "restrt";
  static const String revenue = "revenue";

  static Future<StoreModel> getStoreById(resId) async {
    final url = Uri.parse('$baseUrl/$restrt/$resId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final storeModel = StoreModel.fromJson(body["data"]);
      return storeModel;
    }
    throw Error();
  }

  static Future<RevenueModel> getStoreRevenuById(resId) async {
    final url = Uri.parse('$baseUrl/$restrt/$revenue/$resId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final revenueModel = RevenueModel.fromJson(body["data"]);
      return revenueModel;
    }
    throw Error();
  }
}
