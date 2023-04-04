import 'package:flutter/material.dart';
import 'package:good_to_go/models/menu_model.dart';

class CartProvider with ChangeNotifier {
  final List<MenuModel> _menusInCart = [];
  late String _storeInCartId;
  List<MenuModel> get menusInCart => _menusInCart;
  String get storeId => _storeInCartId;

  int getCartItemsTotalPrice() {
    int price = 0;
    for (var element in _menusInCart) {
      price += element.totalPrice;
    }
    return price;
  }

  bool isTheStoreIdSame(String id) {
    if (_menusInCart.isEmpty) {
      _storeInCartId = id;
    }
    if (_storeInCartId == id) {
      return true;
    }
    return false;
  }

  void addMenuToCart(MenuModel menu) {
    if (_menusInCart.isEmpty) {
      _storeInCartId = menu.storeId!;
    }
    _menusInCart.add(menu);
    notifyListeners();
  }

  void removeMenuInCart(String uuid) {
    _menusInCart.removeWhere((element) => element.uuid == uuid);
    if (_menusInCart.isEmpty) {
      _storeInCartId = "";
    }
    notifyListeners();
  }

  void clearMenuInCart() {
    _menusInCart.clear();
    _storeInCartId = "";
  }
}
