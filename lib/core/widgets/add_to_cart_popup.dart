import 'dart:ui';
import 'package:flutter/material.dart';

void showAddToCartPopup(
  BuildContext context, {
  required String productName,
  required String imageUrl,
  double? price,
  VoidCallback? onViewCart,
}) {
  showTopNotification(
    context,
    title: 'Added to Cart',
    subtitle: productName,
    icon: Icons.check_circle_rounded,
    iconColor: const Color(0xFFCFFF04),
    accentColor: const Color(0xFFCFFF04),
  );
}

void showWishlistPopup(
  BuildContext context, {
  required String productName,
  required bool isWishlisted,
}) {
  showTopNotification(
    context,
    title: isWishlisted ? 'Saved to Wishlist' : 'Removed from Wishlist',
    subtitle: productName,
    icon: isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
    iconColor: isWishlisted ? const Color(0xFFFF4B6E) : const Color(0xFF8E8C9E),
    accentColor: isWishlisted ? const Color(0xFFFF4B6E) : const Color(0xFF8E8C9E),
  );
}

void showTopNotification(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required Color iconColor,
  required Color accentColor,
}) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return _TopGlassToast(
        title: title,
        subtitle: subtitle,
        icon: icon,
        iconColor: iconColor,
        accentColor: accentColor,
        onDismiss: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        },
      );
    },
  );

  overlayState.insert(overlayEntry);
}

class _TopGlassToast extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color accentColor;
  final VoidCallback onDismiss;

  const _TopGlassToast({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.accentColor,
    required this.onDismiss,
  });

  @override
  State<_TopGlassToast> createState() => _TopGlassToastState();
}

class _TopGlassToastState extends State<_TopGlassToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Auto dismiss after 2.2 seconds
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + 10;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      top: topPadding,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF141522).withValues(alpha: 0.88)
                        : const Color(0xFF0F172A).withValues(alpha: 0.90),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.15),
                        blurRadius: 15,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.iconColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: widget.accentColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              widget.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
