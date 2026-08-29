import '../entities/order_entity.dart';

abstract class OrderRepository {
  List<OrderEntity> getOrders();
  Future<OrderEntity> createOrder(OrderEntity order);
}
