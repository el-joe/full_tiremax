import '../../../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';

// Copy is verbatim from `frontend/locale/en.json` (`privacyPolicy` and
// `termsAndConditions`), laid out like the web pages.

const _privacyEmail = 'privacy@tiremax-iq.com';
const _privacyPhone = '+964 000 000 0000';


Widget _title(String t, String d) => Column(
      children: [
        Text(t,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
        const SizedBox(height: 12),
        Text(d, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gray2, fontSize: 14, height: 1.5)),
        const SizedBox(height: 32),
      ],
    );

Widget _iconTile(IconData icon) => Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: Colors.white, size: 26),
    );

Widget _scaffold(String title, List<Widget> children) => Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, title: Text(title)),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(16), children: children),
      ),
    );

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Widget _card(IconData icon, String heading, String body) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 12),
            Text(heading, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
          ],
        ),
      );

  Widget _contactButton(IconData icon, String label, Uri uri) => Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => launchUrl(uri),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Icon(icon, color: AppColors.primary, size: 28),
                const SizedBox(height: 6),
                Text(label,
                    textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return _scaffold(context.l10n.profilePrivacyPolicy, [
      _title(context.l10n.profilePrivacyPolicy, context.l10n.privacyPolicyDescription),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconTile(Icons.storage_outlined),
            const SizedBox(height: 14),
            Text(context.l10n.dataCollection,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24)),
            const SizedBox(height: 12),
            Text(context.l10n.dataCollectionDescription,
                style: TextStyle(color: AppColors.gray2, fontSize: 15, height: 1.5)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsetsDirectional.only(start: 16),
              decoration: const BoxDecoration(
                border: BorderDirectional(start: BorderSide(color: AppColors.primary, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final item in [context.l10n.privacyPersonalInformation,context.l10n.vehicleData,context.l10n.paymentInformation,context.l10n.locationData,])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text(item, style: const TextStyle(color: AppColors.gray2, fontSize: 15, height: 1.4)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/privacyPolicyBannerBg.png', fit: BoxFit.cover),
              const ColoredBox(color: Color(0x66000000)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      _card(Icons.insert_chart_outlined, context.l10n.howWeUseInformation, context.l10n.howWeUseInformationDescription),
      const SizedBox(height: 20),
      _card(Icons.shield_outlined, context.l10n.dataProtection, context.l10n.dataProtectionDescription),
      const SizedBox(height: 20),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.userRights, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24)),
            const SizedBox(height: 10),
            Text(context.l10n.userRightsDescription, style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.push('/contact'),
              child: Text(context.l10n.contactUs, style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.gray3, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(context.l10n.havePrivacyQuestions,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22)),
            const SizedBox(height: 8),
            Text(context.l10n.havePrivacyQuestionsDescription,
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.gray2)),
            const SizedBox(height: 16),
            Row(
              children: [
                _contactButton(Icons.mail_outline, _privacyEmail, Uri(scheme: 'mailto', path: _privacyEmail)),
                const SizedBox(width: 12),
                _contactButton(Icons.phone_outlined, _privacyPhone, Uri(scheme: 'tel', path: _privacyPhone)),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  Widget _section(String heading, List<Widget> body, {Color bg = AppColors.gray3, Color fg = Colors.white}) =>
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(heading, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 22)),
            const SizedBox(height: 12),
            ...body,
          ],
        ),
      );

  Widget _p(String t, {Color color = Colors.white}) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t, style: TextStyle(color: color, fontSize: 14, height: 1.5)),
      );

  Widget _bullet(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(t, style: const TextStyle(color: AppColors.gray2, fontSize: 14, height: 1.4))),
          ],
        ),
      );

  Widget _obligation(String title, String body) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.check, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(body, style: TextStyle(color: AppColors.gray2, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return _scaffold(context.l10n.profileTerms, [
      _title(context.l10n.profileTerms, context.l10n.termsAndConditionsDescription),
      _section('1. ${context.l10n.legalSectionIntroduction}', [
        _p(context.l10n.introductionParagraph1),
        _p(context.l10n.introductionParagraph2),
      ]),
      _section('2. ${context.l10n.legalSectionUserObligations}', [
        _obligation(context.l10n.informationAccuracy, context.l10n.informationAccuracyDescription),
        _obligation(context.l10n.accountSecurity, context.l10n.accountSecurityDescription),
      ]),
      _section('3. ${context.l10n.legalSectionPurchasesAndPayments}', [
        _p(context.l10n.purchasesAndPaymentsParagraph1),
        _bullet(context.l10n.purchasesAndPaymentsParagraph2),
        _bullet(context.l10n.purchasesAndPaymentsParagraph3),
      ]),
      _section('4. ${context.l10n.legalSectionWarranties}', [
        _p(context.l10n.warrantiesDescription),
        for (final item in [context.l10n.trafficAccidents, context.l10n.misuse, context.l10n.incorrectInstallation, context.l10n.improperStorage])
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Text(item, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
      ]),
      _section('5. ${context.l10n.legalSectionLimitationOfLiability}', [
        _p(context.l10n.limitationOfLiabilityParagraph1),
        _p(context.l10n.limitationOfLiabilityParagraph2),
      ], bg: Colors.black),
      Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(context.l10n.lastUpdated,
            textAlign: TextAlign.center, style: TextStyle(color: AppColors.gray2)),
      ),
    ]);
  }
}
