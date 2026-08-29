import 'package:flutter/material.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../core/widgets/particle_background.dart';
import '../../domain/entities/product_entity.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

class ProductDetail3DPage extends StatefulWidget {
  final ProductEntity product;
  final CartController cartController;
  final WishlistController wishlistController;

  const ProductDetail3DPage({
    super.key,
    required this.product,
    required this.cartController,
    required this.wishlistController,
  });

  @override
  State<ProductDetail3DPage> createState() => _ProductDetail3DPageState();
}

class _ProductDetail3DPageState extends State<ProductDetail3DPage> {
  late Color _selectedColor;
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.primaryColor3D;
    _selectedSize = widget.product.availableSizes.isNotEmpty
        ? widget.product.availableSizes.first
        : 'M';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWishlisted = widget.wishlistController.isWishlisted(widget.product.id);

    return Scaffold(
      body: ParticleBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Action Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filledTonal(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    IconButton.filledTonal(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? Colors.redAccent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.wishlistController.toggleWishlist(widget.product.id);
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Product Image Display
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.product.primaryColor3D.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Center(
                          child: Icon(
                            widget.product.icon,
                            size: 80,
                            color: widget.product.primaryColor3D,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Product Info & Controls Sheet
              Expanded(
                flex: 6,
                child: GlassmorphicCard(
                  borderRadius: 32,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Price Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.category.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: widget.product.primaryColor3D,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.product.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${widget.product.price.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              if (widget.product.hasDiscount)
                                Text(
                                  '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        widget.product.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                      ),

                      const SizedBox(height: 16),

                      // Color Customizer Palette
                      Row(
                        children: [
                          const Text(
                            'Color Accent:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: widget.product.availableColors.map((color) {
                              final isSelected = _selectedColor == color;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedColor = color),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(color: Colors.white, width: 3)
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Size Selector
                      Row(
                        children: [
                          const Text(
                            'Size / Variant:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget.product.availableSizes.map((size) {
                                  final isSelected = _selectedSize == size;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(size),
                                      selected: isSelected,
                                      onSelected: (_) => setState(() => _selectedSize = size),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.cartController.addToCart(
                              widget.product,
                              color: _selectedColor,
                              size: _selectedSize,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.product.name} added to cart!'),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text(
                            'ADD TO CART',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
