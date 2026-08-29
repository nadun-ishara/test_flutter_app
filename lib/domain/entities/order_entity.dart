import 'cart_item_entity.dart';

class OrderEntity {
  final String id;
  final DateTime date;
  final List<CartItemEntity> items;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String paymentMethod;

  OrderEntity({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    this.status = 'Processing',
    required this.shippingAddress,
    this.paymentMethod = 'Credit Card',
  });
}
