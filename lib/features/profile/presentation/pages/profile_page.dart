import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/widgets/empty_view.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: EmptyView(
        icon: Icons.person_outline_rounded,
        title: 'Profile',
        message: 'Your details will appear here.',
        action: OutlinedButton.icon(
          onPressed: () =>
              context.read<AuthBloc>().add(const AuthLogoutRequested()),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Log out'),
        ),
      ),
    );
  }
}
