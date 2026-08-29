import 'package:flutter/material.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';

class OrderController extends ChangeNotifier {
  final OrderRepository orderRepository;

  OrderController({required this.orderRepository});

  List<OrderEntity> get orders => orderRepository.getOrders();

  Future<OrderEntity?> placeOrder({
    required List<CartItemEntity> cartItems,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    if (cartItems.isEmpty) return null;

    final newOrder = OrderEntity(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      date: DateTime.now(),
      items: List.from(cartItems),
      totalAmount: totalAmount,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: 'Processing',
    );

    final placedOrder = await orderRepository.createOrder(newOrder);
    notifyListeners();
    return placedOrder;
  }
}
