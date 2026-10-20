import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_colors.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';

/// Centralised Material 3 [ThemeData] for light and dark modes.
abstract final class AppTheme {
  static const String fontFamily = 'Poppins';

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = _scheme(brightness);
    final base = ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      fontFamily: fontFamily,
    );
    final textTheme = _textTheme(base.textTheme);

    final roundedMd = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    OutlineInputBorder inputBorder([BorderSide side = BorderSide.none]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: side,
        );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHigh,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: inputBorder(),
        enabledBorder: inputBorder(),
        disabledBorder: inputBorder(),
        focusedBorder: inputBorder(
          BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: inputBorder(BorderSide(color: scheme.error)),
        focusedErrorBorder: inputBorder(
          BorderSide(color: scheme.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: roundedMd,
          textStyle: textTheme.titleMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: roundedMd,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      chipTheme: ChipThemeData(
        showCheckmark: false,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        color: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.surfaceContainerHigh,
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? scheme.onPrimary
                : scheme.onSurface,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer,
        selectedLabelTextStyle: textTheme.labelMedium,
        unselectedLabelTextStyle: textTheme.labelMedium,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: scheme.primary,
        textColor: scheme.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: roundedMd,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: roundedMd,
        selectedColor: scheme.primary,
      ),
    );
  }

  /// Vibrant coral accents on near-neutral surfaces: the brand colour stays
  /// on buttons, tags and prices, while cards and backgrounds stay calm so
  /// product photos keep their own colours.
  static ColorScheme _scheme(Brightness brightness) {
    final accents = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );
    final neutral = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    );
    return accents.copyWith(
      surface: neutral.surface,
      surfaceDim: neutral.surfaceDim,
      surfaceBright: neutral.surfaceBright,
      surfaceContainerLowest: neutral.surfaceContainerLowest,
      surfaceContainerLow: neutral.surfaceContainerLow,
      surfaceContainer: neutral.surfaceContainer,
      surfaceContainerHigh: neutral.surfaceContainerHigh,
      surfaceContainerHighest: neutral.surfaceContainerHighest,
      onSurface: neutral.onSurface,
      onSurfaceVariant: neutral.onSurfaceVariant,
      outline: neutral.outline,
      outlineVariant: neutral.outlineVariant,
      inverseSurface: neutral.inverseSurface,
      onInverseSurface: neutral.onInverseSurface,
    );
  }

  /// One type scale for the whole app, tuned for Poppins.
  ///
  /// Poppins has a large x-height, so sizes sit a step below Material's
  /// Roboto defaults and only four weights are used: 400 for reading text,
  /// 500 for labels, 600 for titles and 700 for headlines. Line heights are
  /// set explicitly because Poppins' built-in line spacing is tall.
  static TextTheme _textTheme(TextTheme base) {
    TextStyle? style(
      TextStyle? s,
      double size,
      double height,
      FontWeight weight, {
      double letterSpacing = 0,
    }) => s?.copyWith(
      fontSize: size,
      height: height / size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
    );
    const regular = FontWeight.w400;
    const medium = FontWeight.w500;
    const semiBold = FontWeight.w600;
    const bold = FontWeight.w700;
    return base.copyWith(
      displayLarge: style(base.displayLarge, 48, 56, bold, letterSpacing: -1),
      displayMedium: style(base.displayMedium, 40, 48, bold, letterSpacing: -1),
      displaySmall: style(base.displaySmall, 32, 40, bold, letterSpacing: -0.5),
      headlineLarge: style(
        base.headlineLarge,
        28,
        36,
        bold,
        letterSpacing: -0.5,
      ),
      headlineMedium: style(
        base.headlineMedium,
        24,
        32,
        bold,
        letterSpacing: -0.3,
      ),
      headlineSmall: style(base.headlineSmall, 20, 28, semiBold),
      titleLarge: style(base.titleLarge, 18, 26, semiBold),
      titleMedium: style(base.titleMedium, 15, 22, semiBold),
      titleSmall: style(base.titleSmall, 14, 20, medium),
      bodyLarge: style(base.bodyLarge, 15, 22, regular),
      bodyMedium: style(base.bodyMedium, 14, 20, regular),
      bodySmall: style(base.bodySmall, 12, 18, regular),
      labelLarge: style(base.labelLarge, 14, 20, medium),
      labelMedium: style(base.labelMedium, 12, 16, medium),
      labelSmall: style(base.labelSmall, 11, 16, medium, letterSpacing: 0.2),
    );
  }
}
