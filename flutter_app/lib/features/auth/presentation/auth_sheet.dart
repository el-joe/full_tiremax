import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

/// Opens the login/register modal bottom sheet, mirroring the web's
/// `AuthDialog` (opened via `protectedWithAuth` / `?authDialog=on`).
Future<void> showAuthSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AuthSheet(),
  );
}

class AuthSheet extends ConsumerStatefulWidget {
  const AuthSheet({super.key});

  @override
  ConsumerState<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<AuthSheet> {
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadii.xxl),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.gray2,
                      borderRadius: AppRadii.radiusFull,
                    ),
                  ),
                ),
                _TabToggle(
                  showLogin: _showLogin,
                  onChanged: (v) => setState(() => _showLogin = v),
                ),
                const SizedBox(height: 24),
                if (_showLogin)
                  const _LoginForm()
                else
                  const _RegisterForm(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TabToggle extends StatelessWidget {
  const _TabToggle({required this.showLogin, required this.onChanged});

  final bool showLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusFull,
      ),
      child: Row(
        children: [
          Expanded(child: _TabButton(label: AppLocalizations.of(context).authSignIn, active: showLogin, onTap: () => onChanged(true))),
          Expanded(child: _TabButton(label: AppLocalizations.of(context).authCreateAccount, active: !showLogin, onTap: () => onChanged(false))),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadii.radiusFull,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.onPrimary : AppColors.foregroundDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Mirrors `Schemas/authSchemas.ts`'s `loginSchema`.
class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;
  String? _apiError;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _apiError = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await ref.read(authProvider.notifier).login(
            login: _identifierController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      setState(() => _apiError = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _identifierController,
            decoration: InputDecoration(labelText: l10n.authEmailOrPhone),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.authEmailOrPhoneRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.authPassword),
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.authPasswordMinLength;
              }
              return null;
            },
          ),
          if (_apiError != null) ...[
            const SizedBox(height: 16),
            _ErrorBadge(message: _apiError!),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.authSignIn),
          ),
        ],
      ),
    );
  }
}

/// Mirrors `Schemas/authSchemas.ts`'s `registerSchema`.
class _RegisterForm extends ConsumerStatefulWidget {
  const _RegisterForm();

  @override
  ConsumerState<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _addressController = TextEditingController();
  bool _submitting = false;
  String? _apiError;

  static final _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _apiError = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await ref.read(authProvider.notifier).register(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim().isEmpty
                ? null
                : _emailController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmController.text,
            address: _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
            locale: ref.read(localeProvider).languageCode,
          );
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      setState(() => _apiError = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.authFullName),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.authFullNameRequired;
              }
              if (value.length > 120) return l10n.authNameTooLong;
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: l10n.authPhoneNumber),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.authPhoneNumberRequired;
              }
              if (value.length > 20) return l10n.authPhoneTooLong;
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.authEmailOptional),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              if (value.length > 120) return l10n.authEmailTooLong;
              if (!_emailRegExp.hasMatch(value.trim())) {
                return l10n.authInvalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.authPassword),
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.authPasswordMinLength;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmController,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.authConfirmPassword),
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.authConfirmPasswordRequired;
              }
              if (value != _passwordController.text) {
                return l10n.authPasswordsMustMatch;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: l10n.authAddressOptional),
            validator: (value) {
              if (value != null && value.length > 255) {
                return l10n.authAddressTooLong;
              }
              return null;
            },
          ),
          if (_apiError != null) ...[
            const SizedBox(height: 16),
            _ErrorBadge(message: _apiError!),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.authCreateAccount),
          ),
        ],
      ),
    );
  }
}

class _ErrorBadge extends StatelessWidget {
  const _ErrorBadge({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusLg,
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
      ),
    );
  }
}
