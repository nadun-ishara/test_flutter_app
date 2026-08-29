import 'package:flutter/material.dart';

class Tilt3DCard extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  const Tilt3DCard({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}
