import 'package:equatable/equatable.dart';
import 'package:shopsphere/features/products/domain/entities/review.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    this.description = '',
    this.category = '',
    this.brand,
    this.images = const [],
    this.reviews = const [],
    this.availabilityStatus,
  });

  final int id;
  final String title;
  final String description;
  final String category;

  /// List price before the discount.
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;

  /// Absent on some products (e.g. groceries).
  final String? brand;
  final String thumbnail;
  final List<String> images;
  final List<Review> reviews;
  final String? availabilityStatus;

  double get discountedPrice => price * (1 - discountPercentage / 100);
  bool get hasDiscount => discountPercentage > 0;
  bool get isInStock => stock > 0;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    price,
    discountPercentage,
    rating,
    stock,
    brand,
    thumbnail,
    images,
    reviews,
    availabilityStatus,
  ];
}
