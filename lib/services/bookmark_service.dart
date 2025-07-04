import 'package:flutter/material.dart';
import 'package:gas_com/models/product_model.dart';

class BookmarkService extends ChangeNotifier {
  final List<int> _bookmarkedProductIds = [];

  List<int> get bookmarkedProductIds => _bookmarkedProductIds;

  bool isBookmarked(GroupedProduct product) {
    if (product.variations.isEmpty) return false;
    return _bookmarkedProductIds.contains(product.variations.first.id);
  }

  void toggleBookmark(GroupedProduct product) {
    if (product.variations.isEmpty) return;
    final productId = product.variations.first.id;
    if (_bookmarkedProductIds.contains(productId)) {
      _bookmarkedProductIds.remove(productId);
    } else {
      _bookmarkedProductIds.add(productId);
    }
    notifyListeners();
  }
}