import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/theme/theme_cubit.dart';

/// System / Light / Dark picker for the app theme.
class AppearanceSelector extends StatelessWidget {
  const AppearanceSelector({super.key});

  /// Narrower than this, the icons are dropped so labels stay on one line.
  static const double _minWidthForIcons = 400;

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final withIcons = constraints.maxWidth >= _minWidthForIcons;
            ButtonSegment<ThemeMode> segment(
              ThemeMode value,
              String label,
              IconData icon,
            ) => ButtonSegment(
              value: value,
              icon: withIcons ? Icon(icon) : null,
              label: Text(label, maxLines: 1, softWrap: false),
            );

            return SizedBox(
              width: double.infinity,
              child: SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  segment(
                    ThemeMode.system,
                    'System',
                    Icons.brightness_auto_outlined,
                  ),
                  segment(ThemeMode.light, 'Light', Icons.light_mode_outlined),
                  segment(ThemeMode.dark, 'Dark', Icons.dark_mode_outlined),
                ],
                selected: {mode},
                onSelectionChanged: (selection) =>
                    context.read<ThemeCubit>().select(selection.first),
              ),
            );
          },
        ),
      ),
    );
  }
}
