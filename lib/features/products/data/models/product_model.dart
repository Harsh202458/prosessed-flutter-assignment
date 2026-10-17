import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/review.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// List responses use `select=` and omit most fields, so everything beyond
/// the card essentials has a default.
@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String title,
    required double price,
    @Default(0) double discountPercentage,
    @Default(0) double rating,
    @Default(0) int stock,
    @Default('') String thumbnail,
    @Default('') String description,
    @Default('') String category,
    String? brand,
    @Default(<String>[]) List<String> images,
    @Default(<ReviewModel>[]) List<ReviewModel> reviews,
    String? availabilityStatus,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

@freezed
abstract class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required int rating,
    @Default('') String comment,
    @Default('Anonymous') String reviewerName,
    String? date,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

extension ProductModelX on ProductModel {
  Product toEntity() => Product(
    id: id,
    title: title,
    description: description,
    category: category,
    price: price,
    discountPercentage: discountPercentage,
    rating: rating,
    stock: stock,
    brand: (brand?.trim().isEmpty ?? true) ? null : brand,
    thumbnail: thumbnail,
    images: images,
    reviews: [for (final r in reviews) r.toEntity()],
    availabilityStatus: availabilityStatus,
  );
}

extension ReviewModelX on ReviewModel {
  Review toEntity() => Review(
    rating: rating,
    comment: comment,
    reviewerName: reviewerName,
    date: date == null ? null : DateTime.tryParse(date!),
  );
}
