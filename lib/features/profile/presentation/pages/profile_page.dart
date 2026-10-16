import 'package:flutter/material.dart';
import 'package:shopsphere/core/widgets/empty_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const EmptyView(
        icon: Icons.person_outline_rounded,
        title: 'Profile',
        message: 'Sign in to see your details.',
      ),
    );
  }
}
