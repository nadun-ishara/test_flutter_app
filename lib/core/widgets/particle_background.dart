import 'package:flutter/material.dart';

class ParticleBackground extends StatelessWidget {
  final Widget child;

  const ParticleBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Background Mesh Gradients
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.6, -0.6),
                radius: 1.2,
                colors: isDark
                    ? [
                        const Color(0xFF1E1B4B).withValues(alpha: 0.5),
                        const Color(0xFF070913),
                      ]
                    : [
                        const Color(0xFFE0E7FF).withValues(alpha: 0.7),
                        const Color(0xFFF8FAFC),
                      ],
              ),
            ),
          ),
        ),

        // Static Ambient Glowing Orbs
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -100,
          left: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary.withValues(alpha: isDark ? 0.2 : 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Child Content
        child,
      ],
    );
  }
}
