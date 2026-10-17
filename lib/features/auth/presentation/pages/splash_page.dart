import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/app_logo.dart';

/// Shown while the stored session is checked; the router moves on once
/// `AuthBloc` leaves the unknown state.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 96),
            const SizedBox(height: AppSpacing.lg),
            Text('ShopSphere', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xxl),
            const SizedBox.square(
              dimension: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
