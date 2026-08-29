import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final List<OrderEntity> _orders = [];

  @override
  List<OrderEntity> getOrders() => List.unmodifiable(_orders);

  @override
  Future<OrderEntity> createOrder(OrderEntity order) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _orders.insert(0, order);
    return order;
  }
}
