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
    this.inCart = 0,
    this.errorMessage,
  });

  final ProductDetailsStatus status;
  final Product? product;

  /// Units to add to the cart, always within 1…[available].
  final int quantity;

  /// Units of this product already in the cart.
  final int inCart;
  final String? errorMessage;

  /// Stock that can still be added once the cart is taken into account.
  int get available {
    final left = (product?.stock ?? 0) - inCart;
    return left < 0 ? 0 : left;
  }

  bool get canAdd => available > 0;
  bool get canDecrement => quantity > 1;
  bool get canIncrement => quantity < available;

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    Product? product,
    int? quantity,
    int? inCart,
    String? errorMessage,
  }) => ProductDetailsState(
    status: status ?? this.status,
    product: product ?? this.product,
    quantity: quantity ?? this.quantity,
    inCart: inCart ?? this.inCart,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    product,
    quantity,
    inCart,
    errorMessage,
  ];
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
    emit(ProductDetailsState(inCart: state.inCart));

    final result = await _getProductDetails(id);
    emit(
      result.fold(
        (failure) => ProductDetailsState(
          status: failure is NotFoundFailure
              ? ProductDetailsStatus.notFound
              : ProductDetailsStatus.failure,
          inCart: state.inCart,
          errorMessage: failure.message,
        ),
        (product) => ProductDetailsState(
          status: ProductDetailsStatus.success,
          product: product,
          inCart: state.inCart,
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

  /// Keeps the selectable quantity within what's left after the cart.
  void syncCartQuantity(int inCart) {
    final next = state.copyWith(inCart: inCart);
    final max = next.available < 1 ? 1 : next.available;
    emit(next.copyWith(quantity: state.quantity.clamp(1, max)));
  }
}
