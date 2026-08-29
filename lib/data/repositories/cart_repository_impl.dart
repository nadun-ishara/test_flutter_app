import 'package:flutter/material.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItemEntity> _items = [];

  @override
  List<CartItemEntity> getCartItems() => List.unmodifiable(_items);

  @override
  void addToCart(ProductEntity product, {Color? color, String? colorName, String? size}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItemEntity(
        product: product,
        quantity: 1,
        selectedColor: color ?? product.primaryColor3D,
        selectedColorName: colorName ?? 'Default',
        selectedSize: size ?? (product.availableSizes.isNotEmpty ? product.availableSizes.first : 'M'),
      ));
    }
  }

  @override
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  @override
  void updateQuantity(String productId, int delta) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
    }
  }

  @override
  void clearCart() {
    _items.clear();
  }
}
