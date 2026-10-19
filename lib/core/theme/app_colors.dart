import 'package:flutter/material.dart';

/// Brand colours. The rest of the palette is generated from [seed] by
/// Material 3, which keeps text/background pairs at accessible contrast.
abstract final class AppColors {
  /// Warm coral brand colour.
  static const Color seed = Color(0xFFFF6B57);

  /// Rating stars.
  static const Color rating = Color(0xFFF5A524);

  /// Behind product photos, light in both themes: the photos are shot on
  /// white and dark products vanish on a dark background.
  static const Color productPhoto = Color(0xFFF7F3F2);
}
