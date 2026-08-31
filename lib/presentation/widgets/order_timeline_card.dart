import 'package:flutter/material.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../domain/entities/order_entity.dart';

class OrderTimelineCard extends StatefulWidget {
  final OrderEntity order;

  const OrderTimelineCard({super.key, required this.order});

  @override
  State<OrderTimelineCard> createState() => _OrderTimelineCardState();
}

class _OrderTimelineCardState extends State<OrderTimelineCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const accentLime = Color(0xFFCFFF04);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassmorphicCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID & Date Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.local_shipping_rounded,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.id,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.order.date.day}/${widget.order.date.month}/${widget.order.date.year} • ${widget.order.paymentMethod}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.order.status,
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Live Order Status Stepper Bar
            _buildStatusStepper(context),

            const Divider(height: 24, thickness: 0.8),

            // Item count, total & Expand Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.order.items.length} Product(s)',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${widget.order.totalAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isDark ? accentLime : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _isExpanded ? 'Hide Details' : 'View Items',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Expandable Items Drawer
            if (_isExpanded) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  children: widget.order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.product.imageUrl,
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                width: 42,
                                height: 42,
                                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                child: Icon(item.product.icon, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Qty: ${item.quantity}',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 10),

            // Address Row
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.order.shippingAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStepper(BuildContext context) {
    final steps = ['Confirmed', 'Processing', 'Shipped', 'Delivered'];
    int currentStep = 1; // Processing

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentStep;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? const Color(0xFF10B981) : Colors.grey.withValues(alpha: 0.2),
                      border: Border.all(
                        color: isCompleted ? const Color(0xFF10B981) : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? const Color(0xFF10B981) : Colors.grey,
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: index < currentStep ? const Color(0xFF10B981) : Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
