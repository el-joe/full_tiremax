import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';

/// Static copy pulled from `frontend/locale/en.json`'s `privacyPolicy` key.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _LegalScreen(
      title: 'Privacy Policy',
      description:
          'At Tire Max Iraq, we are committed to protecting your privacy and ensuring the security of your personal data. This policy explains how we handle your information with transparency and care.',
      sections: const [
        _LegalSection(
          title: 'Data Collection',
          paragraphs: [
            'We collect information that you provide directly to us when using our services, including:',
            '• Personal Information: Name, email address, and phone number.',
            '• Vehicle Data: Vehicle type, tire size, and maintenance history.',
            '• Payment Information: Financial transaction details (processed through encrypted channels).',
            '• Location Data: To provide roadside assistance services and locate the nearest branch.',
          ],
        ),
        _LegalSection(
          title: 'How We Use Information',
          paragraphs: [
            'We use your data to improve your driving experience, personalize technical offers, and ensure tire safety through regular maintenance reminders. We do not sell your data to third parties for marketing purposes.',
          ],
        ),
        _LegalSection(
          title: 'Data Protection',
          paragraphs: [
            'We implement military-grade encryption protocols (AES-256) to protect our databases. Access to personal information is restricted to employees who need it to serve you.',
          ],
        ),
        _LegalSection(
          title: 'User Rights',
          paragraphs: [
            'You have the full right to access your data, correct it, or request its permanent deletion from our systems. You may also object to the processing of your data at any time.',
          ],
        ),
        _LegalSection(
          title: 'Have Questions About Privacy?',
          paragraphs: [
            'Our legal and technical teams are ready to answer all your questions.',
          ],
        ),
      ],
    );
  }
}

/// Static copy pulled from `frontend/locale/en.json`'s `termsAndConditions` key.
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _LegalScreen(
      title: 'Terms & Conditions',
      description:
          'Welcome to Tire Max Iraq. These Terms and Conditions govern your use of our website and services. By accessing our services, you agree to be bound by these terms in full.',
      sections: const [
        _LegalSection(
          title: 'Introduction',
          paragraphs: [
            'This agreement is entered into between you and Tire Max Iraq. These terms apply to all visitors, users, and others who access or use the service.',
            'Please read these terms carefully before using the website. If you do not agree to any part of these terms, you may not access the service.',
          ],
        ),
        _LegalSection(
          title: 'User Obligations',
          paragraphs: [
            'Information Accuracy: All information provided during registration must be accurate, current, and complete.',
            'Account Security: You are responsible for maintaining the confidentiality of your password and for all activities that occur under your account.',
          ],
        ),
        _LegalSection(
          title: 'Purchases & Payments',
          paragraphs: [
            'We reserve the right to refuse or cancel your order at any time for certain reasons, including but not limited to product availability, errors in product descriptions or pricing, or errors in your order.',
            'Payments are made in Iraqi Dinar according to the exchange rate announced by the store.',
            'We use secure and encrypted payment gateways to protect your financial information.',
          ],
        ),
        _LegalSection(
          title: 'Warranties',
          paragraphs: [
            "All tires sold through Tire Max Iraq come with a manufacturer's warranty against manufacturing defects. Warranty periods and conditions vary by brand and model. The warranty does not cover damage resulting from:",
            '• Traffic Accidents',
            '• Misuse',
            '• Incorrect Installation Outside Our Centers',
            '• Improper Storage',
          ],
        ),
        _LegalSection(
          title: 'Limitation of Liability',
          paragraphs: [
            'Under no circumstances shall Tire Max Iraq, its directors, employees, or partners be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, use, or goodwill.',
            'We strive to provide the most accurate information, but we do not guarantee that the website will be free from technical or typographical errors.',
          ],
        ),
      ],
      footer: 'Last Updated: May 20, 2024',
    );
  }
}

class _LegalSection {
  const _LegalSection({required this.title, required this.paragraphs});

  final String title;
  final List<String> paragraphs;
}

class _LegalScreen extends StatelessWidget {
  const _LegalScreen({
    required this.title,
    required this.description,
    required this.sections,
    this.footer,
  });

  final String title;
  final String description;
  final List<_LegalSection> sections;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(color: AppColors.gray2, fontSize: 13, height: 1.5)),
            const SizedBox(height: 20),
            for (final section in sections)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.gray3, borderRadius: AppRadii.radiusXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(section.title,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 8),
                    for (final paragraph in section.paragraphs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(paragraph, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
                      ),
                  ],
                ),
              ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(footer!, style: const TextStyle(color: AppColors.gray2, fontSize: 11)),
              ),
          ],
        ),
      ),
    );
  }
}
