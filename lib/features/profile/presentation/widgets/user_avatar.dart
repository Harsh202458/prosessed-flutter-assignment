import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopsphere/core/l10n/l10n.dart';

/// Circular avatar that falls back to the user's initials.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.imageUrl,
    required this.name,
    this.radius = 44,
    super.key,
  });

  final String imageUrl;
  final String name;
  final double radius;

  String get _initials => name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fallback = CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      child: Text(
        _initials,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: scheme.onPrimaryContainer,
        ),
      ),
    );

    return Semantics(
      image: true,
      label: context.l10n.profilePhotoOf(name),
      excludeSemantics: true,
      child: imageUrl.isEmpty
          ? fallback
          : CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, image) => CircleAvatar(
                radius: radius,
                backgroundColor: scheme.primaryContainer,
                backgroundImage: image,
              ),
              placeholder: (_, _) => fallback,
              errorWidget: (_, _, _) => fallback,
            ),
    );
  }
}
