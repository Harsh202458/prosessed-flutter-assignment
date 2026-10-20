import 'package:flutter/widgets.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/l10n/app_localizations.dart';

export 'package:shopsphere/l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension FailureText on AppLocalizations {
  /// Translates a failure message for display.
  ///
  /// The domain layer is pure Dart and only knows English defaults, so known
  /// messages are mapped here; anything else (for example a message the API
  /// returned) is shown as-is.
  String errorText(String? message) {
    final known = <String, String>{
      const ServerFailure().message: errorServer,
      const NetworkFailure().message: errorNetwork,
      const TimeoutFailure().message: errorTimeout,
      const BadRequestFailure().message: errorBadRequest,
      const UnauthorizedFailure().message: errorSessionExpired,
      const NotFoundFailure().message: errorNotFound,
      const ParseFailure().message: errorParse,
      const CacheFailure().message: errorCache,
      const UnknownFailure().message: errorUnknown,
      const InvalidCredentialsFailure().message: errorInvalidCredentials,
    };
    if (message == null || message.isEmpty) return errorUnknown;
    return known[message] ?? message;
  }
}
