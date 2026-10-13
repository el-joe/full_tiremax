import '../../../l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/format.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../core/providers/locale_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../orders/providers/orders_provider.dart';
import '../../reservation/data/reservation_repository.dart';
import '../data/auth_repository.dart';
import '../providers/auth_provider.dart';

/// Opens the login/register modal bottom sheet, mirroring the web's
/// `AuthDialog` (opened via `protectedWithAuth` / `?authDialog=on`).
Future<void> showAuthSheet(BuildContext context) {
  return showAppBottomSheet<void>(context, (context) => const AuthSheet());
}

/// After login/register: refresh guest-linked data and tell the user how many
/// guest orders/bookings were attached to their account.
void _afterAuth(
  WidgetRef ref,
  AuthResult result,
  ScaffoldMessengerState messenger,
  AppLocalizations l10n,
) {
  messenger.showSnackBar(
    SnackBar(content: Text('${l10n.authWelcome} ${result.customer.name}')),
  );
  ref.invalidate(cartProvider);
  ref.invalidate(ordersListProvider);
  ref.invalidate(bookingsListProvider);
  if (result.hasLinked) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l10n.guestLinkedMessage(result.linkedOrders, result.linkedBookings),
        ),
      ),
    );
  }
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
    return BottomSheetScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _Segment(
                  label: context.l10n.authLogin,
                  active: _showLogin,
                  onTap: () => setState(() => _showLogin = true),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _Segment(
                  label: context.l10n.authRegister,
                  active: !_showLogin,
                  onTap: () => setState(() => _showLogin = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _showLogin
                ? const _LoginForm(key: ValueKey('login'))
                : const _RegisterForm(key: ValueKey('register')),
          ),
        ],
      ),
    );
  }
}

/// Segmented Login/Register control (44px+ tap target).
class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(minHeight: AppSpacing.minTap),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.gray4,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: active ? AppColors.chrome : AppColors.gray2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mirrors `Schemas/authSchemas.ts`'s `loginSchema`.
class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm({super.key});

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;
  String? _apiError;
  Map<String, String> _serverErrors = {};

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearServerError(String key) {
    if (_serverErrors.containsKey(key)) {
      setState(() => _serverErrors = {..._serverErrors}..remove(key));
    }
  }

  Future<void> _submit() async {
    setState(() {
      _apiError = null;
      _serverErrors = {};
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final messenger = ScaffoldMessenger.of(context);
      final l10n = AppLocalizations.of(context);
      final result = await ref
          .read(authProvider.notifier)
          .login(
            login: _identifierController.text.trim(),
            password: _passwordController.text,
          );
      _afterAuth(ref, result, messenger, l10n);
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      final fields = _fieldErrors(e, const {'login', 'password'});
      setState(() {
        _serverErrors = fields;
        _apiError = fields.isEmpty ? e.message : null;
      });
    } catch (_) {
      if (mounted) setState(() => _apiError = currentL10n.errUnexpected);
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
          AppTextField(
            controller: _identifierController,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.person_outline),
            onChanged: (_) => _clearServerError('login'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.authEmailOrPhoneRequired;
              }
              return null;
            },
            label: l10n.authEmailOrPhone,
            errorText: _serverErrors['login'],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _passwordController,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outline),
            onChanged: (_) => _clearServerError('password'),
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.authPasswordMinLength;
              }
              return null;
            },
            label: l10n.authPassword,
            errorText: _serverErrors['password'],
          ),
          if (_apiError != null) ...[
            const SizedBox(height: AppSpacing.md),
            _ErrorBadge(message: _apiError!),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l10n.authSignIn,
            loading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

/// Mirrors `Schemas/authSchemas.ts`'s `registerSchema`.
class _RegisterForm extends ConsumerStatefulWidget {
  const _RegisterForm({super.key});

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
  Map<String, String> _serverErrors = {};

  void _clearServerError(String key) {
    if (_serverErrors.containsKey(key)) {
      setState(() => _serverErrors = {..._serverErrors}..remove(key));
    }
  }

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
    setState(() {
      _apiError = null;
      _serverErrors = {};
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final messenger = ScaffoldMessenger.of(context);
      final l10n = AppLocalizations.of(context);
      final result = await ref
          .read(authProvider.notifier)
          .register(
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
      _afterAuth(ref, result, messenger, l10n);
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      // Per-field API errors land on the matching input (the banner is only
      // shown when there are none), like the web's `setError(..., "server")`.
      if (!mounted) return;
      final fields = _fieldErrors(e, const {
        'name',
        'phone',
        'email',
        'password',
        'password_confirmation',
        'address',
      });
      setState(() {
        _serverErrors = fields;
        _apiError = fields.isEmpty ? e.message : null;
      });
    } catch (_) {
      if (mounted) setState(() => _apiError = currentL10n.errUnexpected);
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
          AppTextField(
            controller: _phoneController,
            onChanged: (_) => _clearServerError('phone'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.authPhoneNumberRequired;
              }
              if (value.length > 20) return l10n.authPhoneTooLong;
              return null;
            },
            label: l10n.authPhoneNumber,
            errorText: _serverErrors['phone'],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _nameController,
            onChanged: (_) => _clearServerError('name'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.authFullNameRequired;
              }
              if (value.length > 120) return l10n.authNameTooLong;
              return null;
            },
            label: l10n.authFullName,
            errorText: _serverErrors['name'],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _emailController,
            onChanged: (_) => _clearServerError('email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              if (value.length > 120) return l10n.authEmailTooLong;
              if (!_emailRegExp.hasMatch(value.trim())) {
                return l10n.authInvalidEmail;
              }
              return null;
            },
            label: l10n.authEmailOptional,
            errorText: _serverErrors['email'],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _passwordController,
            onChanged: (_) => _clearServerError('password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.authPasswordMinLength;
              }
              return null;
            },
            label: l10n.authPassword,
            errorText: _serverErrors['password'],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _confirmController,
            onChanged: (_) => _clearServerError('password_confirmation'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return l10n.authConfirmPasswordRequired;
              }
              if (value != _passwordController.text) {
                return l10n.authPasswordsMustMatch;
              }
              return null;
            },
            label: l10n.authConfirmPassword,
            errorText: _serverErrors['password_confirmation'],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _addressController,
            onChanged: (_) => _clearServerError('address'),
            validator: (value) {
              if (value != null && value.length > 255) {
                return l10n.authAddressTooLong;
              }
              return null;
            },
            label: l10n.authAddressOptional,
            errorText: _serverErrors['address'],
          ),
          if (_apiError != null) ...[
            const SizedBox(height: AppSpacing.md),
            _ErrorBadge(message: _apiError!),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l10n.authCreateAccount,
            loading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

Map<String, String> _fieldErrors(ApiException e, Set<String> allowed) => {
  for (final entry in (e.errors ?? const <String, List<String>>{}).entries)
    if (allowed.contains(entry.key) && entry.value.isNotEmpty)
      entry.key: entry.value.first,
};

class _ErrorBadge extends StatelessWidget {
  const _ErrorBadge({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, size: 18, color: AppColors.error),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
