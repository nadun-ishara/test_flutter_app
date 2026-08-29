import 'package:flutter/material.dart';
import '../entities/cart_item_entity.dart';
import '../entities/product_entity.dart';

abstract class CartRepository {
  List<CartItemEntity> getCartItems();
  void addToCart(ProductEntity product, {Color? color, String? colorName, String? size});
  void removeFromCart(String productId);
  void updateQuantity(String productId, int delta);
  void clearCart();
}
