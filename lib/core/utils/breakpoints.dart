import 'package:flutter/widgets.dart';

/// Material 3 window size classes used for adaptive layouts.
enum WindowSize {
  /// Phones in portrait (< 600 dp): 2-column grid, bottom navigation bar.
  compact,

  /// Large phones in landscape and small tablets (600–1024 dp): 3–4 columns,
  /// navigation rail.
  medium,

  /// Tablets in landscape (> 1024 dp): master–detail.
  expanded;

  static const double mediumMin = 600;
  static const double expandedMin = 1024;

  static WindowSize fromWidth(double width) {
    if (width >= expandedMin) return WindowSize.expanded;
    if (width >= mediumMin) return WindowSize.medium;
    return WindowSize.compact;
  }

  bool get isCompact => this == WindowSize.compact;
  bool get isExpanded => this == WindowSize.expanded;

  /// Product grid columns for a content area of [width] dp: 2 on phones,
  /// 3–4 on tablets.
  static int gridColumns(double width) {
    if (width < mediumMin) return 2;
    if (width < 840) return 3;
    return 4;
  }
}

extension WindowSizeContext on BuildContext {
  WindowSize get windowSize =>
      WindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}
