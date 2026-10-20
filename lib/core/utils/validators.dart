/// Why a form field is invalid. The UI turns it into translated text.
enum FieldError { required, tooShort }

/// Form field rules. Each returns the [FieldError], or `null` if valid.
abstract final class Validators {
  static const int usernameMinLength = 3;
  static const int passwordMinLength = 6;

  static FieldError? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return FieldError.required;
    if (text.length < usernameMinLength) return FieldError.tooShort;
    return null;
  }

  static FieldError? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return FieldError.required;
    if (text.length < passwordMinLength) return FieldError.tooShort;
    return null;
  }
}
