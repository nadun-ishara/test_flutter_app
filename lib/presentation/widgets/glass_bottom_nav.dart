import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final int wishlistCount;
  final int cartCount;
  final int orderCount;

  const GlassBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.wishlistCount,
    required this.cartCount,
    required this.orderCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Exact color codes from the provided SVG specification
    const activeColor = Color(0xFFCFFF04); // Vibrant SVG Liquid Lime
    const inactiveColor = Color(0xFF6F6D82); // Exact SVG Muted Slate/Purple

    final items = [
      _NavItemData(
        label: 'Shops',
        icon: Icons.storefront_outlined,
        selectedIcon: Icons.storefront_rounded,
      ),
      _NavItemData(
        label: 'Wishlist',
        icon: Icons.favorite_outline_rounded,
        selectedIcon: Icons.favorite_rounded,
        badgeCount: wishlistCount,
      ),
      _NavItemData(
        label: 'Cart',
        icon: Icons.shopping_bag_outlined,
        selectedIcon: Icons.shopping_bag_rounded,
        badgeCount: cartCount,
      ),
      _NavItemData(
        label: 'Orders',
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
        badgeCount: orderCount,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF12131E).withValues(alpha: 0.70)
                    : const Color(0xFF1E202E).withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = selectedIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDestinationSelected(index),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? activeColor.withValues(alpha: 0.14)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          border: isSelected
                              ? Border.all(
                                  color: activeColor.withValues(alpha: 0.35),
                                  width: 1.0,
                                )
                              : Border.all(color: Colors.transparent),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: activeColor.withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    spreadRadius: -2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Centered Icon with Badge Overlay
                            SizedBox(
                              height: 24,
                              width: 36,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    isSelected ? item.selectedIcon : item.icon,
                                    color: isSelected ? activeColor : inactiveColor,
                                    size: 22,
                                  ),
                                  if (item.badgeCount > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: activeColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 14,
                                          minHeight: 14,
                                        ),
                                        child: Text(
                                          '${item.badgeCount}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            height: 1.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),

                            // Precise Label Alignment
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? activeColor : inactiveColor,
                                letterSpacing: isSelected ? 0.2 : 0.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int badgeCount;

  _NavItemData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount = 0,
  });
}


