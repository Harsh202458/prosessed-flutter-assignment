import 'package:flutter/material.dart';

/// Fades and lifts [child] in once when it is first built. Skipped entirely
/// when the user has asked the OS to reduce motion.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({required this.child, this.delayFactor = 0, super.key});

  final Widget child;

  /// 0–1: how far into the animation this item starts, for staggering.
  final double delayFactor;

  static const Duration duration = Duration(milliseconds: 420);

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    final start = delayFactor.clamp(0.0, 0.6);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - value)),
          child: child,
        ),
      ),
    );
  }
}
