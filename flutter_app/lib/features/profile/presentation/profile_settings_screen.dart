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
  String? _success;

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
      _success = null;
    });

    try {
      await ref.read(authProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.isEmpty ? null : _passwordController.text,
            passwordConfirmation: _passwordController.text.isEmpty ? null : _confirmController.text,
          );
      setState(() {
        _submitting = false;
        _success = 'Profile updated successfully.';
        _passwordController.clear();
        _confirmController.clear();
      });
    } catch (e) {
      setState(() {
        _submitting = false;
        _error = e is ApiException ? e.message : 'Could not update your profile.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: const Text('Settings')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Account Settings',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 4),
              const Text('Manage your personal information and security settings',
                  style: TextStyle(color: AppColors.gray2, fontSize: 12)),
              const SizedBox(height: 20),
              _Field(
                label: 'Full Name',
                controller: _nameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 14),
              _Field(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Security & Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _Field(
                label: 'New Password',
                controller: _passwordController,
                obscure: true,
                validator: (v) {
                  if (v != null && v.isNotEmpty && v.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _Field(
                label: 'Confirm Password',
                controller: _confirmController,
                obscure: true,
                validator: (v) {
                  if (_passwordController.text.isNotEmpty && v != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: AppColors.error)),
              ],
              if (_success != null) ...[
                const SizedBox(height: 16),
                Text(_success!, style: const TextStyle(color: AppColors.green)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
                  ),
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                        )
                      : const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscure = false,
  });

  final String label;
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
            filled: true,
            fillColor: AppColors.gray3,
            border: OutlineInputBorder(borderRadius: AppRadii.radiusLg, borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
