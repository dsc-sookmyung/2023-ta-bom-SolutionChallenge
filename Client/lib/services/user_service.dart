import 'dart:convert';
import 'package:good_to_go/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://34.64.188.192:8080";
  static const String user = "user";

  static Future<UserModel> getUserById(userId) async {
    final url = Uri.parse('$baseUrl/$user/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return UserModel.fromJson(body["data"]);
    }
    throw Error();
  }
}
