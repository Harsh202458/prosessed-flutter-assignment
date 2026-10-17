// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      brand: json['brand'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReviewModel>[],
      availabilityStatus: json['availabilityStatus'] as String?,
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'discountPercentage': instance.discountPercentage,
      'rating': instance.rating,
      'stock': instance.stock,
      'thumbnail': instance.thumbnail,
      'description': instance.description,
      'category': instance.category,
      'brand': instance.brand,
      'images': instance.images,
      'reviews': instance.reviews,
      'availabilityStatus': instance.availabilityStatus,
    };

_ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => _ReviewModel(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String? ?? '',
  reviewerName: json['reviewerName'] as String? ?? 'Anonymous',
  date: json['date'] as String?,
);

Map<String, dynamic> _$ReviewModelToJson(_ReviewModel instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'comment': instance.comment,
      'reviewerName': instance.reviewerName,
      'date': instance.date,
    };
