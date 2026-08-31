import 'package:flutter/material.dart';
import '../../core/widgets/add_to_cart_popup.dart';
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

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
                    ),
                  ),
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
                      'Discover Luxury Collections',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: (widget.isDarkMode ? Colors.white : Colors.black).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: widget.onToggleTheme,
                    icon: Icon(
                      widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: widget.isDarkMode ? const Color(0xFFCFFF04) : theme.colorScheme.primary,
                    ),
                    tooltip: 'Toggle Theme',
                  ),
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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (val) => widget.catalogController.updateSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search products, specs, collections...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.catalogController.searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () => widget.catalogController.updateSearchQuery(''),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  filled: true,
                  fillColor: theme.cardColor.withValues(alpha: 0.85),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
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

                IconData categoryIcon;
                switch (cat.toLowerCase()) {
                  case 'electronics':
                    categoryIcon = Icons.devices_rounded;
                    break;
                  case 'footwear':
                  case 'shoes':
                    categoryIcon = Icons.roller_skating_rounded;
                    break;
                  case 'accessories':
                    categoryIcon = Icons.watch_rounded;
                    break;
                  case 'apparel':
                  case 'clothing':
                    categoryIcon = Icons.checkroom_rounded;
                    break;
                  default:
                    categoryIcon = Icons.grid_view_rounded;
                }

                final isDark = theme.brightness == Brightness.dark;
                const accentLime = Color(0xFFCFFF04);

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: FilterChip(
                      avatar: Icon(
                        categoryIcon,
                        size: 16,
                        color: isSelected
                            ? (isDark ? Colors.black : Colors.white)
                            : theme.colorScheme.primary,
                      ),
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => widget.catalogController.selectCategory(cat),
                      selectedColor: isDark ? accentLime : theme.colorScheme.primary,
                      backgroundColor: theme.cardColor.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.15),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? (isDark ? Colors.black : Colors.white)
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                        fontSize: 12,
                      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} Products Found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
                    onToggleWishlist: () {
                      widget.wishlistController.toggleWishlist(product.id);
                      final nowWishlisted = widget.wishlistController.isWishlisted(product.id);
                      showWishlistPopup(
                        context,
                        productName: product.name,
                        isWishlisted: nowWishlisted,
                      );
                    },
                    onAddToCart: () {
                      widget.cartController.addToCart(product);
                      showAddToCartPopup(
                        context,
                        productName: product.name,
                        imageUrl: product.imageUrl,
                        price: product.price,
                      );
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
    ),
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
}
