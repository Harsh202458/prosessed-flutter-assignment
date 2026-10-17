import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/app_logo.dart';
import 'package:shopsphere/core/widgets/message_banner.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopsphere/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signOutReason = context.select<AuthBloc, String?>(
      (bloc) => bloc.state.message,
    );

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current.status == LoginStatus.success &&
          previous.status != LoginStatus.success,
      listener: (context, _) =>
          context.read<AuthBloc>().add(const AuthLoggedIn()),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AppLogo()),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Welcome back',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Sign in to continue shopping',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (signOutReason != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      MessageBanner(message: signOutReason),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    const LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
