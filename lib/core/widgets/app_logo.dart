import 'package:flutter/material.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';

/// The ShopSphere mark: a rounded tile with a shopping bag.
class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 72, this.inverted = false, super.key});

  final double size;

  /// Light tile with a brand-coloured bag, for use on a primary background.
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: context.l10n.logoLabel,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: inverted ? scheme.onPrimary : scheme.primary,
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
        child: Icon(
          Icons.shopping_bag_rounded,
          size: size * 0.55,
          color: inverted ? scheme.primary : scheme.onPrimary,
        ),
      ),
    );
  }
}

/// Coral hero panel with the logo, name and tagline, used on auth screens.
class BrandPanel extends StatelessWidget {
  const BrandPanel({this.expanded = false, super.key});

  /// Fill the available height (side-by-side layout) instead of hugging the
  /// content (stacked layout).
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLogo(size: 56, inverted: true),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'ShopSphere',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: scheme.onPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.l10n.appTagline,
          style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onPrimary),
        ),
      ],
    );

    return ClipRRect(
      borderRadius: expanded
          ? BorderRadius.zero
          : const BorderRadius.vertical(
              bottom: Radius.circular(AppRadius.xl * 1.5),
            ),
      child: ColoredBox(
        color: scheme.primary,
        child: Stack(
          children: [
            Positioned(
              right: -60,
              top: -40,
              child: _Bubble(size: 200, color: scheme.onPrimary),
            ),
            Positioned(
              right: 60,
              bottom: -70,
              child: _Bubble(size: 140, color: scheme.onPrimary),
            ),
            SafeArea(
              bottom: false,
              right: !expanded,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xxl,
                  AppSpacing.xl,
                  AppSpacing.xxl,
                ),
                child: expanded
                    ? SizedBox.expand(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: content,
                        ),
                      )
                    : SizedBox(width: double.infinity, child: content),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
      ),
    ),
  );
}
