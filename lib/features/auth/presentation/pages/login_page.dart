import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
import 'package:shopsphere/core/widgets/app_logo.dart';
import 'package:shopsphere/core/widgets/message_banner.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopsphere/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current.status == LoginStatus.success &&
          previous.status != LoginStatus.success,
      listener: (context, _) =>
          context.read<AuthBloc>().add(const AuthLoggedIn()),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final sideBySide =
                constraints.maxWidth >= WindowSize.mediumMin &&
                constraints.maxWidth > constraints.maxHeight;
            if (sideBySide) {
              return const Row(
                children: [
                  Expanded(child: BrandPanel(expanded: true)),
                  Expanded(
                    child: SafeArea(
                      left: false,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: _FormSection(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SingleChildScrollView(
              child: Column(
                children: [
                  BrandPanel(),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(child: _FormSection()),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signOutReason = context.select<AuthBloc, String?>(
      (bloc) => bloc.state.message,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.loginWelcome, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.loginSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (signOutReason != null) ...[
            const SizedBox(height: AppSpacing.lg),
            MessageBanner(message: context.l10n.errorText(signOutReason)),
          ],
          const SizedBox(height: AppSpacing.xl),
          const LoginForm(),
        ],
      ),
    );
  }
}
