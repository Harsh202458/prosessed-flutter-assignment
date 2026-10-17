import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';

/// The ShopSphere mark: a rounded tile with a shopping bag.
class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 72, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'ShopSphere logo',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [scheme.primary, scheme.tertiary],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Icon(
          Icons.shopping_bag_rounded,
          size: size * 0.55,
          color: scheme.onPrimary,
        ),
      ),
    );
  }
}
