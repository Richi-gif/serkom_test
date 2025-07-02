import 'package:flutter/material.dart';
import 'package:praktikum_1/service/cart/helper/cart_helper.dart';
import 'package:praktikum_1/service/cart/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  final CartHelper _cartHelper = CartHelper();
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Ambil semua item dari database
  Future<void> fetchCartItems() async {
    final data = await _cartHelper.getCartItems();
    _cartItems = data.map((e) => CartItem.fromMap(e)).toList();
    notifyListeners();
  }

  // Tambah item ke cart
  Future<void> addCartItem(CartItem item) async {
    await _cartHelper.insertCartItem(item.toMap());
    await fetchCartItems(); // Refresh data
  }

  // Update item di cart
  Future<void> updateCartItem(int id, int quantity) async {
    await _cartHelper.updateCartItem(id, quantity);
    await fetchCartItems();
  }

  // Hapus item dari cart
  Future<void> removeCartItem(int id) async {
    await _cartHelper.deleteCartItem(id);
    await fetchCartItems();
  }

  // Hapus semua item di cart
  Future<void> clearCart() async {
    await _cartHelper.clearCart();
    _cartItems = [];
    notifyListeners();
  }
}
