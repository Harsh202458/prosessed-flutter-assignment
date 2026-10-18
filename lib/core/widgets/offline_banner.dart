import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/network/connectivity_cubit.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';

/// Thin strip that slides in while the device is offline.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final online = context.watch<ConnectivityCubit>().state;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AnimatedSize(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: online
          ? const SizedBox(width: double.infinity)
          : Semantics(
              liveRegion: true,
              child: Material(
                color: scheme.inverseSurface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 18,
                        color: scheme.onInverseSurface,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          "You're offline. Showing saved products.",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: scheme.onInverseSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
