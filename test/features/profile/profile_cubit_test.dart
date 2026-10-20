import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/profile/domain/usecases/get_profile.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';

class _MockGetProfile extends Mock implements GetProfile {}

void main() {
  late _MockGetProfile getProfile;

  const user = User(
    id: 1,
    username: 'emilys',
    email: 'emily.johnson@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    image: '',
    phone: '+81 965-431-3024',
  );

  setUp(() => getProfile = _MockGetProfile());

  blocTest<ProfileCubit, ProfileState>(
    'emits [loading, success] with the signed-in user',
    setUp: () => when(
      () => getProfile(),
    ).thenAnswer((_) async => const Success(user)),
    build: () => ProfileCubit(getProfile),
    act: (cubit) => cubit.load(),
    expect: () => const [
      ProfileState(status: ProfileStatus.loading),
      ProfileState(status: ProfileStatus.success, user: user),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'emits failure with a retryable message when offline',
    setUp: () => when(
      () => getProfile(),
    ).thenAnswer((_) async => const Err(NetworkFailure())),
    build: () => ProfileCubit(getProfile),
    act: (cubit) => cubit.load(),
    expect: () => [
      const ProfileState(status: ProfileStatus.loading),
      ProfileState(
        status: ProfileStatus.failure,
        errorMessage: const NetworkFailure().message,
      ),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'keeps the last user visible when a refresh fails',
    setUp: () => when(
      () => getProfile(),
    ).thenAnswer((_) async => const Err(ServerFailure())),
    build: () => ProfileCubit(getProfile),
    seed: () => const ProfileState(status: ProfileStatus.success, user: user),
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      expect(cubit.state.status, ProfileStatus.failure);
      expect(cubit.state.user, user);
    },
  );

  blocTest<ProfileCubit, ProfileState>(
    'forgets the user on reset (sign-out)',
    build: () => ProfileCubit(getProfile),
    seed: () => const ProfileState(status: ProfileStatus.success, user: user),
    act: (cubit) => cubit.reset(),
    expect: () => const [ProfileState()],
  );
}
