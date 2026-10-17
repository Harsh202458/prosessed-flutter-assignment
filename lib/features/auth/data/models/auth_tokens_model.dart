import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens_model.freezed.dart';
part 'auth_tokens_model.g.dart';

/// Tokens returned by `/auth/login` and `/auth/refresh`.
@freezed
abstract class AuthTokensModel with _$AuthTokensModel {
  const factory AuthTokensModel({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokensModel;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);
}
