import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:good_to_go/models/review_model.dart';
import 'package:good_to_go/models/user_model.dart';
import 'package:good_to_go/services/user_service.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  static const String baseUrl = "http://34.64.188.192:8080";
  static const String review = "review";
  static const String restrt = "restrt";
  static const String user = "user";

  static Future<List<ReviewModel>> getReviewsByUserId(userId) async {
    List<ReviewModel> reviewInstances = [];
    final url = Uri.parse('$baseUrl/$review/$user/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body["data"] != null) {
        for (var review in body["data"]) {
          reviewInstances.add(ReviewModel.fromJson(review));
        }
      }
      return reviewInstances;
    }
    throw Error();
  }

  static Future<List<ReviewModel>> getReviewsByStoreId(resId) async {
    List<ReviewModel> reviewInstances = [];
    final url = Uri.parse('$baseUrl/$review/$restrt/$resId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body["data"] != null) {
        for (var review in body["data"]) {
          final UserModel user =
              await UserService.getUserById(review["user_id"]);
          reviewInstances.add(ReviewModel.fromJsonWithUser(review, user));
        }
      }
      return reviewInstances;
    }
    throw Error();
  }

  static Future<int> postReview(data) async {
    final url = Uri.parse('$baseUrl/$review');
    var request = http.MultipartRequest("POST", url);
    request.fields['user_id'] = data['user_id'];
    request.fields['review_text'] = data['review_text'];
    request.fields['star_rating'] = data['star_rating'];
    request.fields['restrt_id'] = data['restrt_id'];
    request.fields['order_id'] = data['order_id'];
    request.fields['emoji'] = data['emoji'];
    request.files.add(await http.MultipartFile.fromPath('img', data['img']));
    final response = await request.send();
    if (response.statusCode == 200) {
      debugPrint('review 데이터를 성공적으로 post했습니다.');
      return response.statusCode;
    }
    throw Error();
  }
}
