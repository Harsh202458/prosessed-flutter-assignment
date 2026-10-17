import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
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
    title: 'Beauty picks up to 20% off',
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
    // Two banners side by side on tablets, one on phones.
    final fraction = context.windowSize.isCompact ? 1.0 : 0.5;
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

  static double _height(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? s) =>
        scaler.scale(s?.fontSize ?? 14) * (s?.height ?? 1.3);
    return AppSpacing.lg * 2 +
        line(text.labelMedium) +
        AppSpacing.xs +
        line(text.titleLarge) * 2 +
        AppSpacing.md +
        line(text.labelLarge) +
        AppSpacing.sm * 2;
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
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        promo.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: foreground,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: foreground,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
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
                CircleAvatar(
                  radius: 36,
                  backgroundColor: foreground.withValues(alpha: 0.12),
                  child: Icon(promo.icon, size: 36, color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
