part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.obscurePassword = true,
  });

  final LoginStatus status;
  final String? errorMessage;
  final bool obscurePassword;

  bool get isSubmitting => status == LoginStatus.submitting;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool? obscurePassword,
  }) => LoginState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    obscurePassword: obscurePassword ?? this.obscurePassword,
  );

  @override
  List<Object?> get props => [status, errorMessage, obscurePassword];
}
