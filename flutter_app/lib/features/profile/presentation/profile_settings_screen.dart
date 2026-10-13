import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../auth/providers/auth_provider.dart';

/// Update name/email/password -> PUT /auth/me via `authProvider.updateProfile`.
/// Validation mirrors the web's update-profile form (name required, valid
/// email, and if a new password is entered it must be confirmed).
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
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
      final password = _passwordController.text.isEmpty ? null : _passwordController.text;
      await ref.read(authProvider.notifier).updateProfile(
            name: orNull(_nameController.text),
            email: orNull(_emailController.text),
            password: password,
            passwordConfirmation: password == null ? null : orNull(_confirmController.text),
          );
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _passwordController.clear();
        _confirmController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.profileUpdated)));
    } catch (e) {
      setState(() {
        _submitting = false;
        _error = e is ApiException ? e.message : context.l10n.somethingWentWrong;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.webProfileSettings)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(context.l10n.accountSettings,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24)),
              const SizedBox(height: 4),
              Text(context.l10n.accountSettingsDescription,
                  style: TextStyle(color: AppColors.gray2, fontSize: 13)),
              const SizedBox(height: 20),
              _Group(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                iconBg: Color(0x1AFDB604),
                title: context.l10n.profilePersonalInformation,
                children: [
                  _Field(
                    label: context.l10n.profileFullName,
                    hint: context.l10n.enterFullName,
                    controller: _nameController,
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return null;
                      if (value.length < 6) return context.l10n.nameMinLength;
                      if (value.length > 120) return context.l10n.nameMaxLength;
                      return null;
                    },
                  ),
                  _Field(
                    label: context.l10n.profileEmail,
                    hint: context.l10n.emailPlaceholderProfile,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return null;
                      if (value.length > 120) return context.l10n.emailMaxLength;
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return context.l10n.invalidEmail;
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _Group(
                icon: Icons.lock_outline,
                iconColor: Color(0xFF155DFC),
                iconBg: Color(0xFFEFF6FF),
                title: context.l10n.securityAndPassword,
                children: [
                  _Field(
                    label: context.l10n.newPassword,
                    controller: _passwordController,
                    obscure: true,
                    validator: (v) {
                      if (v != null && v.isNotEmpty && v.length < 6) return context.l10n.passwordMinLength;
                      return null;
                    },
                  ),
                  _Field(
                    label: context.l10n.profileConfirmPassword,
                    controller: _confirmController,
                    obscure: true,
                    validator: (v) {
                      if (_passwordController.text.isEmpty) return null;
                      if (v == null || v.isEmpty) return context.l10n.passwordConfirmationRequired;
                      if (v != _passwordController.text) return context.l10n.passwordsMustMatch;
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _Group(
                icon: Icons.notifications_none,
                iconColor: Color(0xFF00A63E),
                iconBg: Color(0xFFF0FDF4),
                title: context.l10n.notificationSettings,
                children: [
                  for (final (name, description) in [
                    (context.l10n.orderUpdates, context.l10n.orderUpdatesDescription),
                    (context.l10n.offersAndDiscounts, context.l10n.offersAndDiscountsDescription),
                    (context.l10n.newsletter, context.l10n.newsletterDescription),
                    (context.l10n.smsMessages, context.l10n.smsMessagesDescription),
                  ])
                    // Disabled on the web too (no backing preference API yet).
                    SwitchListTile(
                      value: false,
                      onChanged: null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      tileColor: AppColors.background,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      subtitle: Text(description, style: const TextStyle(color: AppColors.gray2, fontSize: 12)),
                    ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: AppRadii.radiusLg,
                  ),
                  child: Text(_error!,
                      style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                  ),
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(context.l10n.saveChanges, style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Web `GroupContainer` section: icon chip + heading and its fields.
class _Group extends StatelessWidget {
  const _Group({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray3,
        borderRadius: AppRadii.radiusXl,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.keyboardType,
    this.obscure = false,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.gray2),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: AppRadii.radiusLg, borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
