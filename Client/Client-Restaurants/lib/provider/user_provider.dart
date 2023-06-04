import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _storeId;

  User? get user => _user;
  String? get storeId => _storeId;

  void setStoreId(String id) {
    _storeId = id;
    notifyListeners();
  }
}
