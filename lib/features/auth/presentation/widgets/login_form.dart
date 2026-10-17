import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/validators.dart';
import 'package:shopsphere/core/widgets/app_button.dart';
import 'package:shopsphere/core/widgets/message_banner.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    unawaited(
      context.read<LoginCubit>().submit(
        username: _username.text,
        password: _password.text,
      ),
    );
  }

  void _fillDemoAccount() {
    _username.text = 'emilys';
    _password.text = 'emilyspass';
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _username,
                  enabled: !state.isSubmitting,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: Validators.username,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _password,
                  enabled: !state.isSubmitting,
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: context
                          .read<LoginCubit>()
                          .togglePasswordVisibility,
                      tooltip: state.obscurePassword
                          ? 'Show password'
                          : 'Hide password',
                      icon: Icon(
                        state.obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: Validators.password,
                ),
                if (state.status == LoginStatus.failure &&
                    state.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  MessageBanner(
                    message: state.errorMessage!,
                    tone: BannerTone.error,
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Sign in',
                  isLoading: state.isSubmitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: state.isSubmitting ? null : _fillDemoAccount,
                  child: Text(
                    'Use demo account',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
