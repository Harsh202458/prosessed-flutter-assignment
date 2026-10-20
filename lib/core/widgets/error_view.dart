import 'package:flutter/material.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';

/// Full-area error state with an optional retry action.
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    this.title,
    this.icon = Icons.cloud_off_rounded,
    this.onRetry,
    this.actionLabel,
    super.key,
  });

  /// Defaults to a generic "Something went wrong".
  final String? title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  /// Defaults to "Retry".
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.errorContainer,
                child: Icon(
                  icon,
                  size: 40,
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title ?? context.l10n.somethingWentWrong,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(actionLabel ?? context.l10n.retry),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
