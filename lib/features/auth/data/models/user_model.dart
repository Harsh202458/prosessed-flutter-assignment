import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    @Default('') String image,
    String? phone,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toEntity() => User(
    id: id,
    username: username,
    email: email,
    firstName: firstName,
    lastName: lastName,
    image: image,
    phone: phone,
  );
}
