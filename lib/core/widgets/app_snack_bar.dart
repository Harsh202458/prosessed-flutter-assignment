import 'package:flutter/material.dart';

/// Shows a short, auto-dismissing snackbar, replacing any visible one.
///
/// Flutter keeps snackbars that have an action on screen until tapped
/// (`persist` defaults to true). Every tab shares the root messenger, so a
/// lingering one would follow the user around and cover buttons; this
/// helper always opts out of that.
void showAppSnackBar(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        persist: false,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(label: actionLabel, onPressed: onAction)
            : null,
      ),
    );
}

void hideAppSnackBar(BuildContext context) =>
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
