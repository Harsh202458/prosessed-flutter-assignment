import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/category.dart';
import 'package:shopsphere/features/products/domain/usecases/get_categories.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';

class _MockGetCategories extends Mock implements GetCategories {}

void main() {
  late _MockGetCategories getCategories;

  setUp(() => getCategories = _MockGetCategories());

  const categories = [Category(slug: 'beauty', name: 'Beauty')];

  blocTest<CategoriesCubit, CategoriesState>(
    'emits [loading, success] with the categories',
    setUp: () => when(
      () => getCategories(),
    ).thenAnswer((_) async => const Success(categories)),
    build: () => CategoriesCubit(getCategories),
    act: (cubit) => cubit.load(),
    expect: () => const [
      CategoriesState(),
      CategoriesState(status: CategoriesStatus.success, categories: categories),
    ],
  );

  blocTest<CategoriesCubit, CategoriesState>(
    'emits failure when categories cannot be loaded',
    setUp: () => when(
      () => getCategories(),
    ).thenAnswer((_) async => const Err(NetworkFailure())),
    build: () => CategoriesCubit(getCategories),
    act: (cubit) => cubit.load(),
    expect: () => const [
      CategoriesState(),
      CategoriesState(status: CategoriesStatus.failure),
    ],
  );
}
