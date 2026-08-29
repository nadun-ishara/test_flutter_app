import 'package:flutter/material.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_timeline_card.dart';

class OrdersPage extends StatelessWidget {
  final OrderController orderController;

  const OrdersPage({super.key, required this.orderController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orders = orderController.orders;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order History',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${orders.length} Past Orders',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('No Orders Placed Yet', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        const Text(
                          'Checkout items from your 3D Cart to track orders here',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return OrderTimelineCard(order: orders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
