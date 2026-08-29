import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    super.originalPrice,
    required super.rating,
    required super.reviewCount,
    required super.description,
    required super.imageUrl,
    required super.icon,
    required super.type3D,
    super.availableColors,
    super.availableSizes,
    super.primaryColor3D,
    super.accentColor3D,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      icon: Icons.shopping_bag,
      type3D: Product3DType.values.firstWhere(
        (e) => e.name == json['type3D'],
        orElse: () => Product3DType.headphones,
      ),
      primaryColor3D: Color(json['primaryColor3D'] as int? ?? 0xFF6366F1),
      accentColor3D: Color(json['accentColor3D'] as int? ?? 0xFFEC4899),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'imageUrl': imageUrl,
      'type3D': type3D.name,
      'primaryColor3D': primaryColor3D.toARGB32(),
      'accentColor3D': accentColor3D.toARGB32(),
    };
  }
}
