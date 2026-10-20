import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/l10n/locale_cubit.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';

/// System / English / हिन्दी picker for the app language.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.watch<LocaleCubit>().state;
    final selected = locale?.languageCode ?? 'system';

    ButtonSegment<String> segment(String value, String label) => ButtonSegment(
      value: value,
      label: Text(label, maxLines: 1, softWrap: false),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              segment('system', l10n.languageSystem),
              segment('en', l10n.languageEnglish),
              segment('hi', l10n.languageHindi),
            ],
            selected: {selected},
            onSelectionChanged: (selection) {
              final code = selection.first;
              unawaited(
                context.read<LocaleCubit>().select(
                  code == 'system' ? null : Locale(code),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
