import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/features/products/domain/entities/category.dart';
import 'package:shopsphere/features/products/domain/usecases/get_categories.dart';

enum CategoriesStatus { loading, success, failure }

final class CategoriesState extends Equatable {
  const CategoriesState({
    this.status = CategoriesStatus.loading,
    this.categories = const [],
  });

  final CategoriesStatus status;
  final List<Category> categories;

  @override
  List<Object?> get props => [status, categories];
}

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._getCategories) : super(const CategoriesState());

  final GetCategories _getCategories;

  Future<void> load() async {
    emit(const CategoriesState());
    final result = await _getCategories();
    emit(
      result.fold(
        (_) => const CategoriesState(status: CategoriesStatus.failure),
        (categories) => CategoriesState(
          status: CategoriesStatus.success,
          categories: categories,
        ),
      ),
    );
  }
}
