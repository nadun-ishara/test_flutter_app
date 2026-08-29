import 'package:flutter/material.dart';
import 'product_entity.dart';

class CartItemEntity {
  final ProductEntity product;
  int quantity;
  Color selectedColor;
  String selectedColorName;
  String selectedSize;

  CartItemEntity({
    required this.product,
    this.quantity = 1,
    required this.selectedColor,
    this.selectedColorName = 'Default',
    this.selectedSize = 'M',
  });

  double get totalPrice => product.price * quantity;
}
