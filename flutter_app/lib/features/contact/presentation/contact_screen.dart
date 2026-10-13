import '../../../l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
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
      await ref.read(contactRepositoryProvider).sendMessage(
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
      messenger.showSnackBar(SnackBar(
        content: Text(context.l10n.contactMessageSent),
      ));
    } on DioException catch (e) {
      final err = ApiException.fromDioException(e);
      if (mounted) {
        setState(() => _serverErrors = err.statusCode == 422 ? (err.errors ?? {}) : {});
        _formKey.currentState!.validate();
      }
      messenger.showSnackBar(SnackBar(content: Text(err.message)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  InputDecoration _decoration(String label, String hint, IconData icon) => InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.gray2, size: 20),
      );

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(publicSettingsProvider).value ?? const PublicSettings();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(context.l10n.contactUs)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Text(context.l10n.contactUs,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.contactUsDescription,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray2, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 96,
                height: 8,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadii.radiusXl),
              ),
            ),
            const SizedBox(height: 20),
            _InfoCard(
              icon: Icons.phone_in_talk_outlined,
              heading: context.l10n.customerServiceNumber,
              value: settings.sitePhone.isEmpty ? '+964 770 000 0000' : settings.sitePhone,
              ltr: true,
              onTap: settings.sitePhone.isEmpty
                  ? null
                  : () => launchUrl(Uri(scheme: 'tel', path: settings.sitePhone)),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.mark_email_unread_outlined,
              heading: context.l10n.email,
              value: settings.siteEmail.isEmpty ? 'info@iraqmaxtire.iq' : settings.siteEmail,
              ltr: true,
              onTap: settings.siteEmail.isEmpty
                  ? null
                  : () => launchUrl(Uri(scheme: 'mailto', path: settings.siteEmail)),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.location_on_outlined,
              heading: context.l10n.headOffice,
              value: settings.address.isEmpty ? '-' : settings.address,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXxl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration(context.l10n.authFullName, context.l10n.enterYourFullName, Icons.person_outline),
                      validator: (v) => _check('name', v ?? '', ContactValidator.name),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration(context.l10n.authPhoneNumber, '+98560054', Icons.phone_outlined),
                      validator: (v) => _check('phone', v ?? '', ContactValidator.phone),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _subject,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration(context.l10n.inquirySubject, context.l10n.inquiryAboutPrices, Icons.subject),
                      validator: (v) => _check('subject', v ?? '', ContactValidator.subject),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _message,
                      minLines: 5,
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: context.l10n.message,
                        hintText: context.l10n.howCanWeHelpYouToday,
                        alignLabelWithHint: true,
                      ),
                      validator: (v) => _check('message', v ?? '', ContactValidator.message),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusFull),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _sending ? null : _submit,
                      icon: _sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                            )
                          : const Icon(Icons.send, size: 18),
                      label: Text(context.l10n.sendMessage, style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    if (settings.showWhatsapp) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(context.l10n.orContactImmediatelyVia,
                                style: TextStyle(color: AppColors.gray2, fontSize: 13)),
                          ),
                          Material(
                            color: const Color(0xFF25D366),
                            borderRadius: AppRadii.radiusLg,
                            child: InkWell(
                              borderRadius: AppRadii.radiusLg,
                              onTap: () => launchUrl(Uri.parse(settings.whatsappUrl),
                                  mode: LaunchMode.externalApplication),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.chat, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
    return Material(
      color: AppColors.gray3,
      borderRadius: AppRadii.radiusXxl,
      child: InkWell(
        borderRadius: AppRadii.radiusXxl,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadii.radiusXxl),
                child: Icon(icon, color: AppColors.onPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(heading,
                        style: const TextStyle(
                            color: AppColors.gray2, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      textDirection: ltr ? TextDirection.ltr : null,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
