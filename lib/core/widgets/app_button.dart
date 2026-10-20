import 'package:flutter/material.dart';
import 'package:shopsphere/core/l10n/l10n.dart';

/// Primary full-width button that swaps its label for a spinner while busy.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    // The button is disabled while loading, so draw the spinner in the
    // primary colour to stay visible on the disabled background.
    final spinnerColor = Theme.of(context).colorScheme.primary;
    final child = isLoading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: spinnerColor,
            ),
          )
        : Text(label);

    return SizedBox(
      width: double.infinity,
      child: icon == null || isLoading
          ? FilledButton(
              onPressed: isLoading ? null : onPressed,
              child: Semantics(
                label: isLoading ? context.l10n.loading : null,
                child: child,
              ),
            )
          : FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: child,
            ),
    );
  }
}
