import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({required this.slug, required this.name, this.imageUrl});

  final String slug;
  final String name;

  /// A representative product photo; DummyJSON has no category images.
  final String? imageUrl;

  @override
  List<Object?> get props => [slug, name, imageUrl];
}
