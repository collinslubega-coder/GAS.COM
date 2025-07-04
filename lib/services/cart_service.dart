import 'package:flutter/material.dart';
import 'package:gas_com/models/product_model.dart';

// This service now correctly manages the state of the shopping cart.
class CartService extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  // **THE FIX IS HERE:**
  // The missing 'addItem' method is now correctly defined.
  void addItem(ProductModel product) {
    _items.add(product);
    // This notifies any listening widgets that the cart has changed.
    notifyListeners();
  }

  // The 'removeItem' method is also included for when we make the cart screen functional.
  void removeItem(ProductModel product) {
    _items.remove(product);
    notifyListeners();
  }

  // Calculates the total price of all items in the cart.
  double get subtotal {
    return _items.fold(0, (sum, item) => sum + (double.tryParse(item.price) ?? 0.0));
  }
  
  // Clears all items from the cart.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}