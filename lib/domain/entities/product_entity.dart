import 'package:flutter/material.dart';

enum Product3DType {
  headphones,
  smartwatch,
  sneakers,
  backpack,
  camera,
  hoodie,
  mug,
  keyboard,
}

class ProductEntity {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl;
  final IconData icon;
  final Product3DType type3D;
  final List<Color> availableColors;
  final List<String> availableSizes;
  final Color primaryColor3D;
  final Color accentColor3D;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.type3D,
    this.availableColors = const [Colors.black, Colors.indigo, Colors.teal],
    this.availableSizes = const ['S', 'M', 'L', 'XL'],
    this.primaryColor3D = const Color(0xFF6366F1),
    this.accentColor3D = const Color(0xFFEC4899),
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}
