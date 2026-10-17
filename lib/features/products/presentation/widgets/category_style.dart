import 'package:flutter/material.dart';

/// Display helpers for DummyJSON category slugs.
abstract final class CategoryStyle {
  static const Map<String, IconData> _icons = {
    'beauty': Icons.face_retouching_natural_outlined,
    'fragrances': Icons.spa_outlined,
    'furniture': Icons.chair_outlined,
    'groceries': Icons.local_grocery_store_outlined,
    'home-decoration': Icons.home_outlined,
    'kitchen-accessories': Icons.kitchen_outlined,
    'laptops': Icons.laptop_outlined,
    'mens-shirts': Icons.checkroom_outlined,
    'mens-shoes': Icons.hiking_outlined,
    'mens-watches': Icons.watch_outlined,
    'mobile-accessories': Icons.headphones_outlined,
    'motorcycle': Icons.two_wheeler_outlined,
    'skin-care': Icons.water_drop_outlined,
    'smartphones': Icons.smartphone_outlined,
    'sports-accessories': Icons.sports_basketball_outlined,
    'sunglasses': Icons.wb_sunny_outlined,
    'tablets': Icons.tablet_android_outlined,
    'tops': Icons.checkroom_outlined,
    'vehicle': Icons.directions_car_outlined,
    'womens-bags': Icons.shopping_bag_outlined,
    'womens-dresses': Icons.checkroom_outlined,
    'womens-jewellery': Icons.diamond_outlined,
    'womens-shoes': Icons.hiking_outlined,
    'womens-watches': Icons.watch_outlined,
  };

  static IconData iconFor(String slug) => _icons[slug] ?? Icons.sell_outlined;

  /// `home-decoration` → `Home Decoration`
  static String labelFor(String slug) => slug
      .split('-')
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
