import 'package:flutter/material.dart';
import 'package:shopsphere/core/widgets/empty_view.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: const EmptyView(
        icon: Icons.shopping_bag_outlined,
        title: 'Your cart is empty',
        message: 'Items you add will show up here.',
      ),
    );
  }
}
