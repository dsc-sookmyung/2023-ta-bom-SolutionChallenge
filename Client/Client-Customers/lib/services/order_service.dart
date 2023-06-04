import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:good_to_go/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const String https = "http";
  static const String baseUrl = "34.64.188.192:8080";
  static const String order = "order";
  static const String user = "user";

  static Future<List<OrderModel>> getOrders(
      {page, size, packed, required userId}) async {
    Uri url;
    Map<String, String> queryParameters = {};
    if (page != null) {
      queryParameters['page'] = page.toString();
    }
    if (size != null) {
      queryParameters['size'] = size.toString();
    }
    if (packed != null) {
      queryParameters['packed'] = packed.toString();
    }
    if (queryParameters != {}) {
      url = Uri.http(
        baseUrl,
        '/$order/$user/$userId',
        queryParameters,
      );
    } else {
      url = Uri.parse('$https://$baseUrl/$order/$user/$userId');
    }

    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<OrderModel> orderInstances = [];
      final Map<String, dynamic> body = jsonDecode(response.body);
      for (var order in body["data"]) {
        orderInstances.add(OrderModel.fromJson(order));
      }
      return orderInstances;
    }
    throw Error();
  }

  static Future<OrderModel> getOrder(orderId) async {
    final url = Uri.parse('$https://$baseUrl/$order/$orderId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final orderModel = OrderModel.fromJson(body["data"]);
      return orderModel;
    }
    throw Error();
  }

  static Future<String> postOrder(Map<String, dynamic> data) async {
    final url = Uri.parse('$https://$baseUrl/$order');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      debugPrint('order데이터를 성공적으로 post했습니다.');
      final Map<String, dynamic> body = jsonDecode(response.body);
      return body["data"]["id"];
    }
    throw Error();
  }
}
