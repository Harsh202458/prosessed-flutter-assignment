import 'package:flutter/material.dart';

/// Brand colours. Everything else is derived from [seed] by Material 3.
abstract final class AppColors {
  /// Deep indigo-violet brand colour.
  static const Color seed = Color(0xFF4F46E5);

  /// Discount badges and sale prices.
  static const Color sale = Color(0xFFE11D48);

  /// Rating stars.
  static const Color rating = Color(0xFFF59E0B);

  /// "In stock" indicator.
  static const Color success = Color(0xFF16A34A);
}
