/// Form field validators. Each returns an error message, or `null` if valid.
abstract final class Validators {
  static const int usernameMinLength = 3;
  static const int passwordMinLength = 6;

  static String? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your username';
    if (text.length < usernameMinLength) {
      return 'Username must be at least $usernameMinLength characters';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Please enter your password';
    if (text.length < passwordMinLength) {
      return 'Password must be at least $passwordMinLength characters';
    }
    return null;
  }
}
