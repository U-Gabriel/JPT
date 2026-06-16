import 'package:flutter/material.dart';
import '../services/shopping_service.dart';

class CartProvider with ChangeNotifier {
  int _cartCount = 0;
  final ShoppingService _shopService = ShoppingService();

  int get cartCount => _cartCount;

  // Charge le compte initial depuis l'API
  Future<void> loadCartCount(String token) async {
    if (token.isEmpty) return;
    _cartCount = await _shopService.getCartCount();
    notifyListeners();
  }

  // Met à jour manuellement (après un ajout réussi)
  void updateCount(int count) {
    _cartCount = count;
    notifyListeners();
  }

  // Alternative : incrémentation locale
  void increment(int qty) {
    _cartCount += qty;
    notifyListeners();
  }
}