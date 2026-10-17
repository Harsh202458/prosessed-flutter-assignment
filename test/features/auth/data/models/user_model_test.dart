import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/features/auth/data/models/auth_tokens_model.dart';
import 'package:shopsphere/features/auth/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('UserModel', () {
    test('parses the login response (no phone)', () {
      final user = UserModel.fromJson(fixture('login_response.json'));

      expect(user.id, 1);
      expect(user.username, 'emilys');
      expect(user.phone, isNull);
      expect(user.toEntity().fullName, 'Emily Johnson');
    });

    test('parses the /auth/me response and ignores unknown fields', () {
      final user = UserModel.fromJson(fixture('me_response.json'));

      expect(user.email, 'emily.johnson@x.dummyjson.com');
      expect(user.phone, '+81 965-431-3024');
      expect(user.image, startsWith('https://'));
    });
  });

  test('AuthTokensModel parses both tokens from the login response', () {
    final tokens = AuthTokensModel.fromJson(fixture('login_response.json'));

    expect(tokens.accessToken, 'fake-access-token');
    expect(tokens.refreshToken, 'fake-refresh-token');
  });
}
