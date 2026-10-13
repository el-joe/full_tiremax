import '../../../l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';

/// Update name/email/password -> PUT /auth/me via `authProvider.updateProfile`.
/// Validation mirrors the web's update-profile form (name required, valid
/// email, and if a new password is entered it must be confirmed).
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final customer = ref.read(customerProvider);
    _nameController = TextEditingController(text: customer?.name);
    _emailController = TextEditingController(text: customer?.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    String? orNull(String v) => v.trim().isEmpty ? null : v.trim();
    try {
      // Web `settingsSchema` preprocesses "" -> undefined, so empty fields are
      // simply not sent.
      final password = _passwordController.text.isEmpty
          ? null
          : _passwordController.text;
      await ref
          .read(authProvider.notifier)
          .updateProfile(
            name: orNull(_nameController.text),
            email: orNull(_emailController.text),
            password: password,
            passwordConfirmation: password == null
                ? null
                : orNull(_confirmController.text),
          );
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _passwordController.clear();
        _confirmController.clear();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.profileUpdated)));
    } catch (e) {
      setState(() {
        _submitting = false;
        _error = e is ApiException
            ? e.message
            : context.l10n.somethingWentWrong;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppScaffold(
      title: l.webProfileSettings,
      bottomBar: StickyBottomBar(
        action: PrimaryButton(
          label: l.saveChanges,
          icon: Icons.save_outlined,
          loading: _submitting,
          onPressed: _submit,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            _Heading(l.profilePersonalInformation),
            AppCard(
              child: Column(
                children: [
                  AppTextField(
                    label: l.profileFullName,
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return null;
                      if (value.length < 6) return l.nameMinLength;
                      if (value.length > 120) return l.nameMaxLength;
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l.profileEmail,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.mail_outline),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return null;
                      if (value.length > 120) return l.emailMaxLength;
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(value))
                        return l.invalidEmail;
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _Heading(l.securityAndPassword),
            AppCard(
              child: Column(
                children: [
                  AppTextField(
                    label: l.newPassword,
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (v) {
                      if (v != null && v.isNotEmpty && v.length < 6) {
                        return l.passwordMinLength;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l.profileConfirmPassword,
                    controller: _confirmController,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (v) {
                      if (_passwordController.text.isEmpty) return null;
                      if (v == null || v.isEmpty) {
                        return l.passwordConfirmationRequired;
                      }
                      if (v != _passwordController.text) {
                        return l.passwordsMustMatch;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _Heading(l.notificationSettings),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (name, description) in [
                    (l.orderUpdates, l.orderUpdatesDescription),
                    (l.offersAndDiscounts, l.offersAndDiscountsDescription),
                    (l.newsletter, l.newsletterDescription),
                    (l.smsMessages, l.smsMessagesDescription),
                  ])
                    // Disabled on the web too (no backing preference API yet).
                    SwitchListTile(
                      value: false,
                      onChanged: null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foregroundLight,
                        ),
                      ),
                      subtitle: Text(
                        description,
                        style: const TextStyle(
                          color: AppColors.gray2,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 18,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.foregroundLight,
      ),
    ),
  );
}
