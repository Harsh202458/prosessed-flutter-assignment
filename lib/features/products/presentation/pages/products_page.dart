import 'package:flutter/material.dart';
import 'package:shopsphere/core/widgets/empty_view.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShopSphere')),
      body: const EmptyView(
        icon: Icons.storefront_outlined,
        title: 'Products',
        message: 'The catalogue is on its way.',
      ),
    );
  }
}
