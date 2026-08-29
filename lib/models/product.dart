import 'package:flutter/material.dart';

class Product {
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
  final List<Color> availableColors;
  final List<String> availableSizes;

  const Product({
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
    this.availableColors = const [Colors.black, Colors.blue, Colors.grey],
    this.availableSizes = const ['S', 'M', 'L', 'XL'],
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}

class CartItem {
  final Product product;
  int quantity;
  String selectedColorName;
  String selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColorName = 'Default',
    this.selectedSize = 'M',
  });

  double get totalPrice => product.price * quantity;
}

class OrderItem {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final String shippingAddress;

  OrderItem({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    this.status = 'Processing',
    required this.shippingAddress,
  });
}

final List<Product> sampleProducts = [
  const Product(
    id: 'p1',
    name: 'Wireless Noise-Canceling Headphones',
    category: 'Electronics',
    price: 199.99,
    originalPrice: 249.99,
    rating: 4.8,
    reviewCount: 320,
    description:
        'Experience immersive sound quality with active noise cancellation, 30-hour battery life, and ultra-comfortable ear cushions.',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80',
    icon: Icons.headphones,
    availableColors: [Colors.black, Colors.white, Colors.indigo],
    availableSizes: ['Standard'],
  ),
  const Product(
    id: 'p2',
    name: 'Smart Fitness Watch Series X',
    category: 'Electronics',
    price: 149.50,
    originalPrice: 179.99,
    rating: 4.6,
    reviewCount: 185,
    description:
        'Track heart rate, sleep quality, GPS routes, and stay connected with instant smart notifications and 7-day battery life.',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80',
    icon: Icons.watch,
    availableColors: [Colors.black, Colors.blueGrey, Colors.pinkAccent],
    availableSizes: ['38mm', '42mm', '44mm'],
  ),
  const Product(
    id: 'p3',
    name: 'Premium Leather Urban Sneakers',
    category: 'Fashion',
    price: 89.99,
    originalPrice: 119.99,
    rating: 4.7,
    reviewCount: 94,
    description:
        'Crafted from genuine leather with memory foam insoles, these sneakers offer supreme comfort and timeless style.',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&q=80',
    icon: Icons.downhill_skiing,
    availableColors: [Colors.red, Colors.white, Colors.black],
    availableSizes: ['40', '41', '42', '43', '44'],
  ),
  const Product(
    id: 'p4',
    name: 'Minimalist Ergonomic Backpack',
    category: 'Fashion',
    price: 65.00,
    originalPrice: 79.99,
    rating: 4.9,
    reviewCount: 412,
    description:
        'Water-resistant, padded 15.6-inch laptop compartment, hidden anti-theft pocket, and ergonomic shoulder straps for modern commuters.',
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&q=80',
    icon: Icons.backpack,
    availableColors: [Colors.grey, Colors.black, Colors.brown],
    availableSizes: ['One Size'],
  ),
  const Product(
    id: 'p5',
    name: '4K Ultra HD Action Camera',
    category: 'Electronics',
    price: 129.99,
    originalPrice: 159.99,
    rating: 4.5,
    reviewCount: 156,
    description:
        'Capture adventures in crisp 4K at 60fps with electronic image stabilization, waterproof up to 30m with included housing.',
    imageUrl: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500&q=80',
    icon: Icons.camera_alt,
    availableColors: [Colors.black, Colors.grey],
    availableSizes: ['Standard'],
  ),
  const Product(
    id: 'p6',
    name: 'Organic Cotton Casual Hoodie',
    category: 'Fashion',
    price: 49.99,
    originalPrice: 59.99,
    rating: 4.4,
    reviewCount: 88,
    description:
        'Super soft 100% organic cotton hoodie with a double-layered hood and fleece interior for everyday warmth and relaxed fit.',
    imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=500&q=80',
    icon: Icons.checkroom,
    availableColors: [Colors.indigo, Colors.grey, Colors.amber],
    availableSizes: ['S', 'M', 'L', 'XL', 'XXL'],
  ),
  const Product(
    id: 'p7',
    name: 'Smart Ceramic Coffee Mug',
    category: 'Home',
    price: 39.99,
    originalPrice: 49.99,
    rating: 4.7,
    reviewCount: 203,
    description:
        'Keep your favorite hot beverages at your precise preferred drinking temperature for up to 2 hours on a single charge.',
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&q=80',
    icon: Icons.local_cafe,
    availableColors: [Colors.white, Colors.black, Colors.cyan],
    availableSizes: ['350ml', '500ml'],
  ),
  const Product(
    id: 'p8',
    name: 'High-Velocity Mechanical Keyboard',
    category: 'Electronics',
    price: 109.00,
    originalPrice: 129.99,
    rating: 4.9,
    reviewCount: 510,
    description:
        'Tactile mechanical switches, customizable RGB backlighting per key, hot-swappable sockets, and detachable Type-C cable.',
    imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500&q=80',
    icon: Icons.keyboard,
    availableColors: [Colors.black, Colors.white],
    availableSizes: ['Tenkeyless', 'Full Size'],
  ),
];
