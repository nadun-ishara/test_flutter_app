import 'package:flutter/material.dart';
import '../../core/widgets/add_to_cart_popup.dart';
import '../controllers/cart_controller.dart';
import '../controllers/catalog_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../widgets/product_3d_grid_item.dart';
import 'product_detail_3d_page.dart';

class WishlistPage extends StatelessWidget {
  final WishlistController wishlistController;
  final CatalogController catalogController;
  final CartController cartController;

  const WishlistPage({
    super.key,
    required this.wishlistController,
    required this.catalogController,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wishlistProducts = wishlistController.getWishlistProducts(catalogController.products);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Wishlist',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${wishlistProducts.length} Saved Items',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Grid
          Expanded(
            child: wishlistProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Your Wishlist is Empty',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tap the heart icon on any product to save it here',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                    physics: const BouncingScrollPhysics(),
                    itemCount: wishlistProducts.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      childAspectRatio: 0.60,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final product = wishlistProducts[index];
                      return Product3DGridItem(
                        product: product,
                        isWishlisted: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetail3DPage(
                                product: product,
                                cartController: cartController,
                                wishlistController: wishlistController,
                              ),
                            ),
                          );
                        },
                        onToggleWishlist: () {
                          wishlistController.toggleWishlist(product.id);
                          final nowWishlisted = wishlistController.isWishlisted(product.id);
                          showWishlistPopup(
                            context,
                            productName: product.name,
                            isWishlisted: nowWishlisted,
                          );
                        },
                        onAddToCart: () {
                          cartController.addToCart(product);
                          showAddToCartPopup(
                            context,
                            productName: product.name,
                            imageUrl: product.imageUrl,
                            price: product.price,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
