import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/utils/validators.dart';

void main() {
  group('Validators.username', () {
    test('rejects empty and whitespace-only input', () {
      expect(Validators.username(null), isNotNull);
      expect(Validators.username('   '), isNotNull);
    });

    test('rejects input shorter than the minimum length', () {
      expect(Validators.username('ab'), contains('at least'));
    });

    test('accepts a valid username', () {
      expect(Validators.username('emilys'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects empty input', () {
      expect(Validators.password(''), isNotNull);
    });

    test('rejects input shorter than the minimum length', () {
      expect(Validators.password('12345'), contains('at least'));
    });

    test('accepts a valid password', () {
      expect(Validators.password('emilyspass'), isNull);
    });
  });
}
