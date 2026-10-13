import '../../../l10n/l10n.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/widgets.dart';
import '../../settings/data/public_settings_repository.dart';
import '../data/contact_repository.dart';

/// Mirrors `frontend/components/shared/ContactUsSection.tsx` +
/// `ContactUsForm.tsx` (route `/contact`).
class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  Map<String, List<String>> _serverErrors = {};
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  String? _check(String field, String value, String? Function(String) v) =>
      v(value) ?? _serverErrors[field]?.first;

  Future<void> _submit() async {
    setState(() => _serverErrors = {});
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(contactRepositoryProvider)
          .sendMessage(
            name: _name.text,
            phone: _phone.text,
            subject: _subject.text,
            message: _message.text,
          );
      if (!mounted) return;
      _formKey.currentState!.reset();
      _name.clear();
      _phone.clear();
      _subject.clear();
      _message.clear();
      messenger.showSnackBar(
        SnackBar(content: Text(context.l10n.contactMessageSent)),
      );
    } on DioException catch (e) {
      final err = ApiException.fromDioException(e);
      if (mounted) {
        setState(
          () => _serverErrors = err.statusCode == 422 ? (err.errors ?? {}) : {},
        );
        _formKey.currentState!.validate();
      }
      messenger.showSnackBar(SnackBar(content: Text(err.message)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final settings =
        ref.watch(publicSettingsProvider).value ?? const PublicSettings();
    return AppScaffold(
      title: l.contactUs,
      bottomBar: StickyBottomBar(
        action: PrimaryButton(
          label: l.sendMessage,
          icon: Icons.send,
          loading: _sending,
          onPressed: _submit,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            l.contactUsDescription,
            style: const TextStyle(color: AppColors.gray2, fontSize: 14),
          ),
          const SizedBox(height: AppSpacing.lg),
          TileGroup(
            children: [
              _ContactRow(
                icon: Icons.phone_in_talk_outlined,
                heading: l.customerServiceNumber,
                value: settings.sitePhone.isEmpty
                    ? '+964 770 000 0000'
                    : settings.sitePhone,
                ltr: true,
                onTap: settings.sitePhone.isEmpty
                    ? null
                    : () => launchUrl(
                        Uri(scheme: 'tel', path: settings.sitePhone),
                      ),
              ),
              _ContactRow(
                icon: Icons.mark_email_unread_outlined,
                heading: l.email,
                value: settings.siteEmail.isEmpty
                    ? 'info@iraqmaxtire.iq'
                    : settings.siteEmail,
                ltr: true,
                onTap: settings.siteEmail.isEmpty
                    ? null
                    : () => launchUrl(
                        Uri(scheme: 'mailto', path: settings.siteEmail),
                      ),
              ),
              _ContactRow(
                icon: Icons.location_on_outlined,
                heading: l.headOffice,
                value: settings.address.isEmpty ? '-' : settings.address,
              ),
              if (settings.showWhatsapp)
                _ContactRow(
                  icon: Icons.chat_outlined,
                  heading: l.orContactImmediatelyVia,
                  value: 'WhatsApp',
                  onTap: () => launchUrl(
                    Uri.parse(settings.whatsappUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: l.authFullName,
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (v) =>
                        _check('name', v ?? '', ContactValidator.name),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l.authPhoneNumber,
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    validator: (v) =>
                        _check('phone', v ?? '', ContactValidator.phone),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l.inquirySubject,
                    controller: _subject,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.subject),
                    validator: (v) =>
                        _check('subject', v ?? '', ContactValidator.subject),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l.message,
                    controller: _message,
                    maxLines: 5,
                    validator: (v) =>
                        _check('message', v ?? '', ContactValidator.message),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.heading,
    required this.value,
    this.ltr = false,
    this.onTap,
  });

  final IconData icon;
  final String heading;
  final String value;
  final bool ltr;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: const TextStyle(
                      color: AppColors.gray2,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    value,
                    textDirection: ltr ? TextDirection.ltr : null,
                    style: const TextStyle(
                      color: AppColors.foregroundLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
