import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopsphere/features/products/domain/entities/category.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String slug,
    required String name,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

extension CategoryModelX on CategoryModel {
  Category toEntity() => Category(slug: slug, name: name);
}
