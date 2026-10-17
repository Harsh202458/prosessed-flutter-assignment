import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';

part 'product_page_model.freezed.dart';
part 'product_page_model.g.dart';

@freezed
abstract class ProductPageModel with _$ProductPageModel {
  const factory ProductPageModel({
    required List<ProductModel> products,
    required int total,
    required int skip,
    required int limit,
  }) = _ProductPageModel;

  factory ProductPageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductPageModelFromJson(json);
}

extension ProductPageModelX on ProductPageModel {
  ProductPage toEntity() => ProductPage(
    products: [for (final p in products) p.toEntity()],
    total: total,
    skip: skip,
  );
}
