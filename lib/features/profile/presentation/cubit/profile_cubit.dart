import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/profile/domain/usecases/get_profile.dart';

enum ProfileStatus { initial, loading, success, failure }

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  final ProfileStatus status;
  final User? user;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, user, errorMessage];
}

/// App-wide signed-in user: shown on the profile tab and in the home
/// greeting. Loaded on sign-in and reset on sign-out.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfile) : super(const ProfileState());

  final GetProfile _getProfile;

  Future<void> load() async {
    if (state.status == ProfileStatus.loading) return;
    // Keep showing the previous user while refreshing.
    emit(ProfileState(status: ProfileStatus.loading, user: state.user));

    final result = await _getProfile();
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(ProfileState(status: ProfileStatus.success, user: data));
      case Err(:final failure):
        emit(
          ProfileState(
            status: ProfileStatus.failure,
            user: state.user,
            errorMessage: failure.message,
          ),
        );
    }
  }

  void reset() => emit(const ProfileState());
}
