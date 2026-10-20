import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/utils/validators.dart';

void main() {
  group('Validators.username', () {
    test('rejects empty and whitespace-only input', () {
      expect(Validators.username(null), FieldError.required);
      expect(Validators.username('   '), FieldError.required);
    });

    test('rejects input shorter than the minimum length', () {
      expect(Validators.username('ab'), FieldError.tooShort);
    });

    test('accepts a valid username', () {
      expect(Validators.username('emilys'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects empty input', () {
      expect(Validators.password(''), FieldError.required);
    });

    test('rejects input shorter than the minimum length', () {
      expect(Validators.password('12345'), FieldError.tooShort);
    });

    test('accepts a valid password', () {
      expect(Validators.password('emilyspass'), isNull);
    });
  });
}
