import 'package:flutter/material.dart';
import '../../core/widgets/glassmorphic_card.dart';

class PromoBanner3D extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onTapExplore;

  const PromoBanner3D({
    super.key,
    required this.onClose,
    required this.onTapExplore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphicCard(
        padding: const EdgeInsets.all(16),
        borderRadius: 24,
        borderColor: theme.colorScheme.primary.withValues(alpha: 0.4),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          '🔥 SPECIAL PROMO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get 20% OFF Your First Order',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Use promo code WELCOME20 or TEST10 at checkout!',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: onClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
