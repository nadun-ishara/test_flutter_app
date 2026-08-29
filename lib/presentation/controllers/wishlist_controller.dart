import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class WishlistController extends ChangeNotifier {
  final Set<String> _wishlistProductIds = {};

  Set<String> get wishlistIds => _wishlistProductIds;
  int get itemCount => _wishlistProductIds.length;

  bool isWishlisted(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  void toggleWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    notifyListeners();
  }

  List<ProductEntity> getWishlistProducts(List<ProductEntity> allProducts) {
    return allProducts.where((p) => _wishlistProductIds.contains(p.id)).toList();
  }
}
