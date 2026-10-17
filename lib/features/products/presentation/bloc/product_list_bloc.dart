import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/utils/event_transformers.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';
import 'package:shopsphere/features/products/domain/usecases/get_products.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc(this._getProducts) : super(const ProductListState()) {
    on<ProductListStarted>(
      (_, emit) => _reload(state.query, emit),
      transformer: restartable(),
    );
    on<ProductListRefreshed>(_onRefreshed, transformer: restartable());
    on<ProductSearchChanged>(
      _onSearchChanged,
      transformer: debounceRestartable(),
    );
    on<ProductCategorySelected>(
      (event, emit) => _reload(state.query.withCategory(event.slug), emit),
      transformer: restartable(),
    );
    on<ProductSortChanged>(
      (event, emit) => _reload(state.query.withSort(event.sort), emit),
      transformer: restartable(),
    );
    on<ProductListNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
  }

  final GetProducts _getProducts;

  /// Bumped on every reset of the list. A response whose generation is out
  /// of date belongs to an older query and is dropped, so a slow request can
  /// never overwrite newer results.
  int _generation = 0;

  Future<void> _reload(
    ProductQuery query,
    Emitter<ProductListState> emit,
  ) async {
    final generation = ++_generation;
    emit(
      ProductListState(status: ProductListStatus.loading, query: query),
    );

    final result = await _getProducts(query: query);
    if (generation != _generation) return;

    emit(
      result.fold(
        (failure) => state.copyWith(
          status: ProductListStatus.failure,
          errorMessage: failure.message,
        ),
        (page) => state.copyWith(
          status: page.products.isEmpty
              ? ProductListStatus.empty
              : ProductListStatus.success,
          products: page.products,
          hasReachedEnd: !page.hasMore,
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    ProductListRefreshed event,
    Emitter<ProductListState> emit,
  ) async {
    if (state.products.isEmpty) return _reload(state.query, emit);

    final generation = ++_generation;
    emit(state.copyWith(isRefreshing: true));

    final result = await _getProducts(query: state.query);
    if (generation != _generation) return;

    emit(
      result.fold(
        (failure) => state.copyWith(
          isRefreshing: false,
          refreshError: failure.message,
        ),
        (page) => state.copyWith(
          status: page.products.isEmpty
              ? ProductListStatus.empty
              : ProductListStatus.success,
          products: page.products,
          hasReachedEnd: !page.hasMore,
          isLoadingMore: false,
          isRefreshing: false,
        ),
      ),
    );
  }

  Future<void> _onSearchChanged(
    ProductSearchChanged event,
    Emitter<ProductListState> emit,
  ) async {
    final query = state.query.withSearch(event.query);
    if (query == state.query && state.status != ProductListStatus.initial) {
      return;
    }
    await _reload(query, emit);
  }

  Future<void> _onNextPageRequested(
    ProductListNextPageRequested event,
    Emitter<ProductListState> emit,
  ) async {
    if (state.status != ProductListStatus.success ||
        state.hasReachedEnd ||
        state.isLoadingMore ||
        state.isRefreshing) {
      return;
    }

    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getProducts(
      query: state.query,
      skip: state.products.length,
    );
    if (generation != _generation) return;

    emit(
      result.fold(
        (failure) => state.copyWith(
          isLoadingMore: false,
          loadMoreError: failure.message,
        ),
        (page) => state.copyWith(
          products: [...state.products, ...page.products],
          hasReachedEnd: !page.hasMore,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
