import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/utils/greeting.dart';
import 'package:shopsphere/features/products/presentation/widgets/category_style.dart';

void main() {
  test('dayPartOf picks the right part of the day', () {
    expect(dayPartOf(DateTime(2026, 1, 1, 8)), DayPart.morning);
    expect(dayPartOf(DateTime(2026, 1, 1, 13)), DayPart.afternoon);
    expect(dayPartOf(DateTime(2026, 1, 1, 21)), DayPart.evening);
    expect(dayPartOf(DateTime(2026, 1, 1, 2)), DayPart.evening);
  });

  test(
    'CategoryStyle turns slugs into labels and falls back to a tag icon',
    () {
      expect(CategoryStyle.labelFor('home-decoration'), 'Home Decoration');
      expect(CategoryStyle.labelFor('beauty'), 'Beauty');
      expect(CategoryStyle.iconFor('unknown-slug'), Icons.sell_outlined);
      expect(
        CategoryStyle.labelFor('home-decoration', languageCode: 'hi'),
        'घर की सजावट',
      );
    },
  );
}
