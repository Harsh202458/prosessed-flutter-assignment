import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/usecases/get_product_details.dart';

enum ProductDetailsStatus { loading, success, notFound, failure }

final class ProductDetailsState extends Equatable {
  const ProductDetailsState({
    this.status = ProductDetailsStatus.loading,
    this.product,
    this.quantity = 1,
    this.errorMessage,
  });

  final ProductDetailsStatus status;
  final Product? product;

  /// Units to add to the cart, always within 1…stock.
  final int quantity;
  final String? errorMessage;

  bool get canDecrement => quantity > 1;
  bool get canIncrement => quantity < (product?.stock ?? 0);

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    Product? product,
    int? quantity,
    String? errorMessage,
  }) => ProductDetailsState(
    status: status ?? this.status,
    product: product ?? this.product,
    quantity: quantity ?? this.quantity,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, product, quantity, errorMessage];
}

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._getProductDetails)
    : super(const ProductDetailsState());

  final GetProductDetails _getProductDetails;

  /// [id] comes from the route and may be malformed, e.g. `/products/abc`.
  Future<void> load(int? id) async {
    if (id == null) {
      emit(const ProductDetailsState(status: ProductDetailsStatus.notFound));
      return;
    }
    emit(const ProductDetailsState());

    final result = await _getProductDetails(id);
    emit(
      result.fold(
        (failure) => ProductDetailsState(
          status: failure is NotFoundFailure
              ? ProductDetailsStatus.notFound
              : ProductDetailsStatus.failure,
          errorMessage: failure.message,
        ),
        (product) => ProductDetailsState(
          status: ProductDetailsStatus.success,
          product: product,
        ),
      ),
    );
  }

  void increment() {
    if (state.canIncrement) emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrement() {
    if (state.canDecrement) emit(state.copyWith(quantity: state.quantity - 1));
  }

  /// Back to 1 after the selection was added to the cart.
  void resetQuantity() => emit(state.copyWith(quantity: 1));
}
