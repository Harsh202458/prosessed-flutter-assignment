import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/error_view.dart';
import 'package:shopsphere/core/widgets/message_banner.dart';
import 'package:shopsphere/core/widgets/shimmer_box.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shopsphere/features/profile/presentation/widgets/appearance_selector.dart';
import 'package:shopsphere/features/profile/presentation/widgets/user_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.logout_rounded),
        title: const Text('Log out?'),
        content: const Text(
          "You'll need to sign in again. Your cart on this device will be "
          'cleared.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) authBloc.add(const AuthLogoutRequested());
  }

  Future<void> _refresh(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) {
            return state.status == ProfileStatus.failure
                ? ErrorView(
                    title: "Couldn't load your profile",
                    message: state.errorMessage ?? '',
                    onRetry: () =>
                        unawaited(context.read<ProfileCubit>().load()),
                  )
                : const _ProfileSkeleton();
          }
          return RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProfileHeader(user: user),
                        if (state.status == ProfileStatus.failure) ...[
                          const SizedBox(height: AppSpacing.lg),
                          MessageBanner(
                            tone: BannerTone.error,
                            message:
                                "Couldn't refresh your profile. "
                                '${state.errorMessage ?? ''}',
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl),
                        _Section(
                          title: 'Contact details',
                          children: [
                            _InfoTile(
                              icon: Icons.mail_outline_rounded,
                              label: 'Email',
                              value: user.email,
                            ),
                            _InfoTile(
                              icon: Icons.phone_outlined,
                              label: 'Phone',
                              value: user.phone ?? 'Not provided',
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _Section(
                          title: 'Account',
                          children: [
                            _InfoTile(
                              icon: Icons.alternate_email_rounded,
                              label: 'Username',
                              value: user.username,
                            ),
                            _InfoTile(
                              icon: Icons.badge_outlined,
                              label: 'Customer ID',
                              value: '#${user.id}',
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.xs,
                            bottom: AppSpacing.sm,
                          ),
                          child: Text(
                            'Appearance',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const AppearanceSelector(),
                        const SizedBox(height: AppSpacing.xl),
                        OutlinedButton.icon(
                          onPressed: () => unawaited(_confirmLogout(context)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Log out'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scheme.surface, width: 4),
            ),
            child: UserAvatar(imageUrl: user.image, name: user.fullName),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '@${user.username}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        Card(
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 56),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading profile',
      child: AppShimmer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: const [
            ShimmerBox(height: 200, radius: AppRadius.xl),
            SizedBox(height: AppSpacing.xl),
            ShimmerBox(height: 16, width: 140),
            SizedBox(height: AppSpacing.sm),
            ShimmerBox(height: 140, radius: AppRadius.lg),
          ],
        ),
      ),
    );
  }
}
