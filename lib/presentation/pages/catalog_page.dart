import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../controllers/cart_controller.dart';
import '../controllers/catalog_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../widgets/product_3d_grid_item.dart';
import '../widgets/promo_banner_3d.dart';
import 'product_detail_3d_page.dart';

class CatalogPage extends StatefulWidget {
  final CatalogController catalogController;
  final CartController cartController;
  final WishlistController wishlistController;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const CatalogPage({
    super.key,
    required this.catalogController,
    required this.cartController,
    required this.wishlistController,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool _bannerVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = widget.catalogController.products;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App Bar Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NovaShop',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Clean Architecture Mobile App',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onToggleTheme,
                  icon: Icon(
                    widget.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  ),
                  tooltip: 'Toggle Theme',
                ),
              ],
            ),
          ),
        ),

        // Promo Banner
        if (_bannerVisible)
          SliverToBoxAdapter(
            child: PromoBanner3D(
              onClose: () => setState(() => _bannerVisible = false),
              onTapExplore: () {},
            ),
          ),

        // Search Bar Input
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              onChanged: (val) => widget.catalogController.updateSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search products, specs, categories...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: widget.catalogController.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => widget.catalogController.updateSearchQuery(''),
                      )
                    : null,
                filled: true,
                fillColor: theme.cardColor.withValues(alpha: 0.8),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),

        // Category Chips Horizontal Scroll
        SliverToBoxAdapter(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.catalogController.categories.length,
              itemBuilder: (context, index) {
                final cat = widget.catalogController.categories[index];
                final isSelected = widget.catalogController.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => widget.catalogController.selectCategory(cat),
                    selectedColor: theme.colorScheme.primary.withValues(alpha: 0.25),
                    checkmarkColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Count & Sort Option Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} Products Found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                DropdownButton<String>(
                  value: widget.catalogController.sortBy,
                  underline: const SizedBox(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Popular', child: Text('Popular')),
                    DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                    DropdownMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                    DropdownMenuItem(value: 'Rating', child: Text('Top Rated')),
                  ],
                  onChanged: (val) {
                    if (val != null) widget.catalogController.updateSortBy(val);
                  },
                ),
              ],
            ),
          ),
        ),

        // Product Grid
        if (products.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('No items match your query', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: widget.catalogController.clearFilters,
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  final isWishlisted = widget.wishlistController.isWishlisted(product.id);

                  return Product3DGridItem(
                    product: product,
                    isWishlisted: isWishlisted,
                    onTap: () => _openProductDetail(context, product),
                    onToggleWishlist: () => widget.wishlistController.toggleWishlist(product.id),
                    onAddToCart: () {
                      widget.cartController.addToCart(product);
                      _showSnackBar(context, '${product.name} added to Cart!');
                    },
                  );
                },
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.60,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
            ),
          ),
      ],
    );
  }

  void _openProductDetail(BuildContext context, ProductEntity product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetail3DPage(
          product: product,
          cartController: widget.cartController,
          wishlistController: widget.wishlistController,
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
