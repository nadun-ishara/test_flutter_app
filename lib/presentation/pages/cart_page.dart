import 'package:flutter/material.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import '../widgets/cart_item_card.dart';

class CartPage extends StatefulWidget {
  final CartController cartController;
  final OrderController orderController;
  final VoidCallback onOrderPlaced;

  const CartPage({
    super.key,
    required this.cartController,
    required this.orderController,
    required this.onOrderPlaced,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _promoTextCtrl = TextEditingController();
  final TextEditingController _addressCtrl =
      TextEditingController(text: '742 Cyberpunk Ave, Neo-Tokyo, NT 90210');
  String _paymentMethod = 'Credit Card';

  @override
  void dispose() {
    _promoTextCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = widget.cartController;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3D Cart',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${cart.totalItemCount} Items',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                if (cart.items.isNotEmpty)
                  TextButton.icon(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                    label: const Text('Clear', style: TextStyle(color: Colors.redAccent)),
                    onPressed: cart.clearCart,
                  ),
              ],
            ),
          ),

          // Items List & Summary
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('Your Cart is Empty', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        const Text(
                          'Add 3D items from the store to test checkout',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                    children: [
                      // Cart Items list
                      ...cart.items.map(
                        (item) => CartItemCard(
                          item: item,
                          onIncrement: () => cart.updateQuantity(item.product.id, 1),
                          onDecrement: () => cart.updateQuantity(item.product.id, -1),
                          onRemove: () => cart.removeFromCart(item.product.id),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Promo Code Card
                      GlassmorphicCard(
                        padding: const EdgeInsets.all(12),
                        borderRadius: 20,
                        child: Row(
                          children: [
                            const Icon(Icons.discount_outlined, color: Colors.amber),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _promoTextCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Enter Promo (e.g. WELCOME20)',
                                  border: InputBorder.none,
                                  isDense: true,
                                  errorText: cart.promoErrorMessage,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (cart.appliedPromo != null) {
                                  cart.removePromo();
                                  _promoTextCtrl.clear();
                                } else {
                                  cart.applyPromo(_promoTextCtrl.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cart.appliedPromo != null
                                    ? Colors.redAccent
                                    : theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(cart.appliedPromo != null ? 'Remove' : 'Apply'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Price Receipt Summary Glass Card
                      GlassmorphicCard(
                        borderRadius: 24,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildPriceRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
                            if (cart.appliedPromo != null)
                              _buildPriceRow(
                                'Discount (${cart.appliedPromo!.code})',
                                '-\$${cart.discount.toStringAsFixed(2)}',
                                color: const Color(0xFF10B981),
                              ),
                            _buildPriceRow(
                              'Shipping',
                              cart.shipping == 0 ? 'FREE' : '\$${cart.shipping.toStringAsFixed(2)}',
                            ),
                            _buildPriceRow('Tax (8%)', '\$${cart.tax.toStringAsFixed(2)}'),
                            const Divider(height: 20),
                            _buildPriceRow(
                              'Grand Total',
                              '\$${cart.grandTotal.toStringAsFixed(2)}',
                              isBold: true,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Checkout Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () => _openCheckoutModal(context),
                          icon: const Icon(Icons.payment_rounded),
                          label: const Text(
                            'PROCEED TO 3D CHECKOUT',
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 15 : 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              fontSize: isBold ? 18 : 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _openCheckoutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return GlassmorphicCard(
            borderRadius: 32,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Checkout Confirmation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Address Input
                  const Text('Shipping Address:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _addressCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Payment Method Selection
                  const Text('Payment Option:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          avatar: const Icon(Icons.credit_card, size: 16),
                          label: const Text('Credit Card'),
                          selected: _paymentMethod == 'Credit Card',
                          onSelected: (_) => setModalState(() => _paymentMethod = 'Credit Card'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          avatar: const Icon(Icons.account_balance_wallet, size: 16),
                          label: const Text('Cyber Pay'),
                          selected: _paymentMethod == 'Cyber Pay',
                          onSelected: (_) => setModalState(() => _paymentMethod = 'Cyber Pay'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        final order = await widget.orderController.placeOrder(
                          cartItems: widget.cartController.items,
                          totalAmount: widget.cartController.grandTotal,
                          shippingAddress: _addressCtrl.text,
                          paymentMethod: _paymentMethod,
                        );

                        if (order != null) {
                          widget.cartController.clearCart();
                          if (ctx.mounted) Navigator.of(ctx).pop();
                          widget.onOrderPlaced();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'CONFIRM & PAY \$${widget.cartController.grandTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
