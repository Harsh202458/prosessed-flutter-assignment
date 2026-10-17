import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopsphere/core/widgets/shimmer_box.dart';

/// Cached product photo with a shimmer placeholder and a broken-image
/// fallback.
class ProductImage extends StatelessWidget {
  const ProductImage({
    required this.url,
    this.fit = BoxFit.contain,
    this.semanticLabel,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (url.isEmpty) return _Fallback(color: scheme.onSurfaceVariant);

    return Semantics(
      image: true,
      label: semanticLabel,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (_, _) => const AppShimmer(child: ShimmerBox()),
        errorWidget: (_, _, _) => _Fallback(color: scheme.onSurfaceVariant),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Center(
    child: Icon(Icons.image_not_supported_outlined, color: color, size: 32),
  );
}
