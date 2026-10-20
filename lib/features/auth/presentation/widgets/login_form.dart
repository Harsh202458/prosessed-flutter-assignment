import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
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

  static String? _usernameError(AppLocalizations l10n, String? value) =>
      switch (Validators.username(value)) {
        FieldError.required => l10n.usernameRequired,
        FieldError.tooShort => l10n.usernameTooShort(
          Validators.usernameMinLength,
        ),
        null => null,
      };

  static String? _passwordError(AppLocalizations l10n, String? value) =>
      switch (Validators.password(value)) {
        FieldError.required => l10n.passwordRequired,
        FieldError.tooShort => l10n.passwordTooShort(
          Validators.passwordMinLength,
        ),
        null => null,
      };

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
        final l10n = context.l10n;
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FieldLabel(l10n.usernameLabel),
                TextFormField(
                  controller: _username,
                  enabled: !state.isSubmitting,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: l10n.usernameHint,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  validator: (value) => _usernameError(l10n, value),
                ),
                const SizedBox(height: AppSpacing.lg),
                _FieldLabel(l10n.passwordLabel),
                TextFormField(
                  controller: _password,
                  enabled: !state.isSubmitting,
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: l10n.passwordHint,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: context
                          .read<LoginCubit>()
                          .togglePasswordVisibility,
                      tooltip: state.obscurePassword
                          ? l10n.showPassword
                          : l10n.hidePassword,
                      icon: Icon(
                        state.obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) => _passwordError(l10n, value),
                ),
                if (state.status == LoginStatus.failure &&
                    state.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  MessageBanner(
                    message: l10n.errorText(state.errorMessage),
                    tone: BannerTone.error,
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: l10n.signIn,
                  isLoading: state.isSubmitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: state.isSubmitting ? null : _fillDemoAccount,
                  child: Text(
                    l10n.useDemoAccount,
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

/// Static label above a field. A floating label sits on the top edge of a
/// borderless filled field and looks misaligned, so the label lives outside.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
