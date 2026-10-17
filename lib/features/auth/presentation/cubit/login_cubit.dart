import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/auth/domain/usecases/login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login) : super(const LoginState());

  final Login _login;

  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  Future<void> submit({
    required String username,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));

    final result = await _login(username: username, password: password);

    emit(
      result.fold(
        (failure) => state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ),
        (_) => state.copyWith(status: LoginStatus.success),
      ),
    );
  }
}
