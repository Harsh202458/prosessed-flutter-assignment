import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_colors.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

enum _PromoTone { primary, tertiary, secondary }

class _Promo {
  const _Promo({
    required this.eyebrow,
    required this.title,
    required this.categorySlug,
    required this.icon,
    required this.tone,
  });

  final String eyebrow;
  final String title;
  final String categorySlug;
  final IconData icon;
  final _PromoTone tone;
}

const _promos = [
  _Promo(
    eyebrow: 'Glow-up week',
    title: 'Beauty bestsellers on sale',
    categorySlug: 'beauty',
    icon: Icons.face_retouching_natural_outlined,
    tone: _PromoTone.primary,
  ),
  _Promo(
    eyebrow: 'Just landed',
    title: 'The latest smartphones',
    categorySlug: 'smartphones',
    icon: Icons.smartphone_outlined,
    tone: _PromoTone.tertiary,
  ),
  _Promo(
    eyebrow: 'Make it cosy',
    title: 'Furniture for every room',
    categorySlug: 'furniture',
    icon: Icons.chair_outlined,
    tone: _PromoTone.secondary,
  ),
];

/// Auto-advancing promo banners; tapping one filters to its category.
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({required this.onShop, super.key});

  final ValueChanged<String> onShop;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  static const Duration _interval = Duration(seconds: 5);

  PageController? _controller;
  double _viewportFraction = 1;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Two banners side by side only when the list has the full width: on
    // phones, and in master-detail mode, it shows one at a time.
    final fraction = context.windowSize == WindowSize.medium ? 0.5 : 1.0;
    if (_controller == null || fraction != _viewportFraction) {
      final page = _controller?.hasClients ?? false
          ? _controller!.page?.round() ?? 0
          : 0;
      _controller?.dispose();
      _viewportFraction = fraction;
      _controller = PageController(
        viewportFraction: fraction,
        initialPage: page,
      );
    }
    _restartTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (MediaQuery.disableAnimationsOf(context)) return;
    _timer = Timer.periodic(_interval, (_) => _advance());
  }

  void _advance() {
    final controller = _controller;
    if (controller == null || !controller.hasClients) return;
    final visible = (1 / _viewportFraction).round();
    final lastPage = _promos.length - visible;
    final current = controller.page?.round() ?? 0;
    unawaited(
      controller.animateToPage(
        current >= lastPage ? 0 : current + 1,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  /// Promo headline: between titleMedium and titleLarge so two lines fit
  /// without the banner dominating the screen.
  static TextStyle? titleStyle(TextTheme text) =>
      text.titleMedium?.copyWith(fontSize: 18, height: 1.25);

  static double _height(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? s) =>
        scaler.scale(s?.fontSize ?? 14) * (s?.height ?? 1.3);
    return AppSpacing.md * 2 +
        line(text.labelMedium) +
        AppSpacing.xxs +
        line(titleStyle(text)) * 2 +
        AppSpacing.sm +
        line(text.labelLarge) +
        AppSpacing.xs * 2 +
        // Headroom for sub-pixel rounding of the measured text.
        AppSpacing.xs;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    return Column(
      children: [
        SizedBox(
          height: _height(context),
          child: NotificationListener<UserScrollNotification>(
            onNotification: (_) {
              _restartTimer();
              return false;
            },
            child: PageView.builder(
              controller: controller,
              padEnds: false,
              itemCount: _promos.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? AppSpacing.lg : AppSpacing.xs,
                  right: index == _promos.length - 1
                      ? AppSpacing.lg
                      : AppSpacing.xs,
                ),
                child: _PromoBanner(
                  promo: _promos[index],
                  onTap: () => widget.onShop(_promos[index].categorySlug),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SmoothPageIndicator(
          controller: controller,
          count: _promos.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            spacing: 4,
            activeDotColor: Theme.of(context).colorScheme.primary,
            dotColor: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.promo, required this.onTap});

  final _Promo promo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (background, foreground) = switch (promo.tone) {
      _PromoTone.primary => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      _PromoTone.tertiary => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      _PromoTone.secondary => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
    };

    return Semantics(
      button: true,
      label: '${promo.eyebrow}. ${promo.title}. Shop now',
      excludeSemantics: true,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo.eyebrow,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: foreground,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        promo.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _PromoCarouselState.titleStyle(
                          theme.textTheme,
                        )?.copyWith(color: foreground),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: foreground,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            'Shop now',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: background,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _PromoImage(promo: promo, accent: foreground),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A real product photo from the promo's category (the same photo its
/// category chip uses), with the icon as a fallback while it loads.
class _PromoImage extends StatelessWidget {
  const _PromoImage({required this.promo, required this.accent});

  final _Promo promo;
  final Color accent;

  static const double _size = 92;

  @override
  Widget build(BuildContext context) {
    final imageUrl = context.select<CategoriesCubit, String?>(
      (cubit) => cubit.state.categories
          .where((c) => c.slug == promo.categorySlug)
          .firstOrNull
          ?.imageUrl,
    );
    final fallback = Icon(promo.icon, size: 36, color: accent);

    return ExcludeSemantics(
      child: Container(
        width: _size,
        height: _size,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: const BoxDecoration(
          color: AppColors.productPhoto,
          shape: BoxShape.circle,
        ),
        child: imageUrl == null
            ? fallback
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
