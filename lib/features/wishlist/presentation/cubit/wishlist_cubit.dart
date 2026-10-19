import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/wishlist/domain/repositories/wishlist_repository.dart';

final class WishlistState extends Equatable {
  const WishlistState({this.products = const [], this.isLoaded = false});

  /// Newest first.
  final List<Product> products;
  final bool isLoaded;

  bool contains(int productId) => products.any((p) => p.id == productId);

  @override
  List<Object?> get props => [products, isLoaded];
}

/// App-wide wishlist, saved to the device after every change.
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit(this._repository) : super(const WishlistState());

  final WishlistRepository _repository;

  Future<void> load() async {
    final result = await _repository.load();
    emit(
      WishlistState(
        products: switch (result) {
          Success(:final data) => data,
          Err() => const [],
        },
        isLoaded: true,
      ),
    );
  }

  /// Adds [product] if it isn't saved yet, otherwise removes it. Returns
  /// whether it is saved afterwards.
  Future<bool> toggle(Product product) async {
    final saved = !state.contains(product.id);
    await _update(
      saved
          ? [product, ...state.products]
          : [
              for (final p in state.products)
                if (p.id != product.id) p,
            ],
    );
    return saved;
  }

  Future<void> remove(int productId) => _update([
    for (final p in state.products)
      if (p.id != productId) p,
  ]);

  Future<void> clear() async {
    emit(const WishlistState(isLoaded: true));
    await _repository.clear();
  }

  Future<void> _update(List<Product> products) async {
    emit(WishlistState(products: products, isLoaded: true));
    // A failed save only means the change won't survive a restart.
    await _repository.save(products);
  }
}
