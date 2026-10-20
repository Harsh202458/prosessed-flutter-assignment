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

  /// Hindi names. Product data itself stays in English, as the API returns.
  static const Map<String, String> _hindi = {
    'beauty': 'सौंदर्य',
    'fragrances': 'सुगंध',
    'furniture': 'फ़र्नीचर',
    'groceries': 'किराना',
    'home-decoration': 'घर की सजावट',
    'kitchen-accessories': 'रसोई का सामान',
    'laptops': 'लैपटॉप',
    'mens-shirts': 'पुरुषों की शर्ट',
    'mens-shoes': 'पुरुषों के जूते',
    'mens-watches': 'पुरुषों की घड़ियाँ',
    'mobile-accessories': 'मोबाइल एक्सेसरीज़',
    'motorcycle': 'मोटरसाइकिल',
    'skin-care': 'त्वचा की देखभाल',
    'smartphones': 'स्मार्टफ़ोन',
    'sports-accessories': 'खेल का सामान',
    'sunglasses': 'धूप के चश्मे',
    'tablets': 'टैबलेट',
    'tops': 'टॉप्स',
    'vehicle': 'वाहन',
    'womens-bags': 'महिलाओं के बैग',
    'womens-dresses': 'महिलाओं की ड्रेस',
    'womens-jewellery': 'महिलाओं के गहने',
    'womens-shoes': 'महिलाओं के जूते',
    'womens-watches': 'महिलाओं की घड़ियाँ',
  };

  static IconData iconFor(String slug) => _icons[slug] ?? Icons.sell_outlined;

  /// `home-decoration` → `Home decoration`, `mens-shirts` → `Men's shirts`
  /// (or the Hindi name for `hi`). Sentence case matches every other label
  /// in the app.
  static String labelFor(String slug, {String languageCode = 'en'}) {
    if (languageCode == 'hi') {
      final hindi = _hindi[slug];
      if (hindi != null) return hindi;
    }
    return _sentenceCase(slug);
  }

  static const _possessives = {'mens': "men's", 'womens': "women's"};

  static String _sentenceCase(String slug) {
    final words = slug
        .split('-')
        .where((word) => word.isNotEmpty)
        .map((word) => _possessives[word] ?? word)
        .join(' ');
    if (words.isEmpty) return words;
    return '${words[0].toUpperCase()}${words.substring(1)}';
  }
}
