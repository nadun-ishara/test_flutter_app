import 'package:flutter/material.dart';
import '../../core/widgets/particle_background.dart';
import '../controllers/cart_controller.dart';
import '../controllers/catalog_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../widgets/glass_bottom_nav.dart';
import 'cart_page.dart';
import 'catalog_page.dart';
import 'orders_page.dart';
import 'wishlist_page.dart';

class MainNavigationPage extends StatefulWidget {
  final CatalogController catalogController;
  final CartController cartController;
  final WishlistController wishlistController;
  final OrderController orderController;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const MainNavigationPage({
    super.key,
    required this.catalogController,
    required this.cartController,
    required this.wishlistController,
    required this.orderController,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.catalogController.addListener(_onStateChange);
    widget.cartController.addListener(_onStateChange);
    widget.wishlistController.addListener(_onStateChange);
    widget.orderController.addListener(_onStateChange);

    widget.catalogController.loadProducts();
  }

  @override
  void dispose() {
    widget.catalogController.removeListener(_onStateChange);
    widget.cartController.removeListener(_onStateChange);
    widget.wishlistController.removeListener(_onStateChange);
    widget.orderController.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleBackground(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                CatalogPage(
                  catalogController: widget.catalogController,
                  cartController: widget.cartController,
                  wishlistController: widget.wishlistController,
                  onToggleTheme: widget.onToggleTheme,
                  isDarkMode: widget.isDarkMode,
                ),
                WishlistPage(
                  wishlistController: widget.wishlistController,
                  catalogController: widget.catalogController,
                  cartController: widget.cartController,
                ),
                CartPage(
                  cartController: widget.cartController,
                  orderController: widget.orderController,
                  onOrderPlaced: () {
                    setState(() => _currentIndex = 3);
                  },
                ),
                OrdersPage(
                  orderController: widget.orderController,
                ),
              ],
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GlassBottomNav(
                selectedIndex: _currentIndex,
                onDestinationSelected: (idx) {
                  setState(() => _currentIndex = idx);
                },
                wishlistCount: widget.wishlistController.itemCount,
                cartCount: widget.cartController.totalItemCount,
                orderCount: widget.orderController.orders.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
