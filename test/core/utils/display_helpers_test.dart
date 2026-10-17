import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/utils/greeting.dart';
import 'package:shopsphere/features/products/presentation/widgets/category_style.dart';

void main() {
  test('greetingFor picks the right part of the day', () {
    expect(greetingFor(DateTime(2026, 1, 1, 8)), 'Good morning');
    expect(greetingFor(DateTime(2026, 1, 1, 13)), 'Good afternoon');
    expect(greetingFor(DateTime(2026, 1, 1, 21)), 'Good evening');
    expect(greetingFor(DateTime(2026, 1, 1, 2)), 'Good evening');
  });

  test(
    'CategoryStyle turns slugs into labels and falls back to a tag icon',
    () {
      expect(CategoryStyle.labelFor('home-decoration'), 'Home Decoration');
      expect(CategoryStyle.labelFor('beauty'), 'Beauty');
      expect(CategoryStyle.iconFor('unknown-slug'), Icons.sell_outlined);
    },
  );
}
