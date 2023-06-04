import 'dart:convert';

import 'package:good_to_go_restaurant/models/review_model.dart';
import 'package:good_to_go_restaurant/models/user_model.dart';
import 'package:good_to_go_restaurant/services/user_service.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  static const String baseUrl = "http://34.64.188.192:8080";
  static const String review = "review";
  static const String restrt = "restrt";
  static const String emoji = "emoji";

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

  static Future<void> postEmoji(String reviewId, String content) async {
    final url = Uri.parse('$baseUrl/$review/$emoji/$reviewId');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final data = {
      "emoji": content,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return;
    }

    throw Error();
  }
}
