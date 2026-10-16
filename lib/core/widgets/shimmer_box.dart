import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';

/// Theme-aware shimmer wrapper for skeleton placeholders.
class AppShimmer extends StatelessWidget {
  const AppShimmer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHighest,
      highlightColor: scheme.surfaceContainerLow,
      child: child,
    );
  }
}

/// A rounded grey block used inside [AppShimmer] to sketch content.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    this.width,
    this.height,
    this.radius = AppRadius.sm,
    super.key,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
