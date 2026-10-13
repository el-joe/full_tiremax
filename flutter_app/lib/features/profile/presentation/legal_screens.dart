import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/widgets.dart';

// Copy is verbatim from `frontend/locale/en.json` (`privacyPolicy` and
// `termsAndConditions`), laid out as light mobile cards.

const _privacyEmail = 'privacy@tiremax-iq.com';
const _privacyPhone = '+964 000 000 0000';

Widget _legalScaffold(
  String title,
  String description,
  List<Widget> children,
) => AppScaffold(
  title: title,
  body: ListView(
    padding: const EdgeInsets.all(AppSpacing.gutter),
    children: [
      Text(
        description,
        style: const TextStyle(
          color: AppColors.gray2,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      for (final c in children) ...[c, const SizedBox(height: AppSpacing.md)],
    ],
  ),
);

Widget _section(String heading, List<Widget> body, {IconData? icon}) => AppCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              heading,
              style: const TextStyle(
                color: AppColors.foregroundLight,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.sm),
      ...body,
    ],
  ),
);

Widget _p(String t) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
  child: Text(
    t,
    style: const TextStyle(color: AppColors.gray2, fontSize: 14, height: 1.5),
  ),
);

Widget _bullet(String t) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(
        Icons.check_circle_outline,
        color: AppColors.primary,
        size: 18,
      ),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Text(
          t,
          style: const TextStyle(
            color: AppColors.gray2,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    ],
  ),
);

Widget _item(String title, String body) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.md),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: AppColors.foregroundLight,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        body,
        style: const TextStyle(
          color: AppColors.gray2,
          fontSize: 13,
          height: 1.4,
        ),
      ),
    ],
  ),
);

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _legalScaffold(l.profilePrivacyPolicy, l.privacyPolicyDescription, [
      _section(l.dataCollection, [
        _p(l.dataCollectionDescription),
        for (final item in [
          l.privacyPersonalInformation,
          l.vehicleData,
          l.paymentInformation,
          l.locationData,
        ])
          _bullet(item),
      ], icon: Icons.storage_outlined),
      _section(l.howWeUseInformation, [
        _p(l.howWeUseInformationDescription),
      ], icon: Icons.insert_chart_outlined),
      _section(l.dataProtection, [
        _p(l.dataProtectionDescription),
      ], icon: Icons.shield_outlined),
      _section(l.userRights, [
        _p(l.userRightsDescription),
        SecondaryButton(
          label: l.contactUs,
          icon: Icons.support_agent_outlined,
          onPressed: () => context.push('/contact'),
        ),
      ], icon: Icons.verified_user_outlined),
      _section(l.havePrivacyQuestions, [
        _p(l.havePrivacyQuestionsDescription),
        TileGroup(
          children: [
            GroupTile(
              icon: Icons.mail_outline,
              label: _privacyEmail,
              onTap: () =>
                  launchUrl(Uri(scheme: 'mailto', path: _privacyEmail)),
            ),
            GroupTile(
              icon: Icons.phone_outlined,
              label: _privacyPhone,
              onTap: () => launchUrl(Uri(scheme: 'tel', path: _privacyPhone)),
            ),
          ],
        ),
      ], icon: Icons.help_outline),
    ]);
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _legalScaffold(l.profileTerms, l.termsAndConditionsDescription, [
      _section('1. ${l.legalSectionIntroduction}', [
        _p(l.introductionParagraph1),
        _p(l.introductionParagraph2),
      ]),
      _section('2. ${l.legalSectionUserObligations}', [
        _item(l.informationAccuracy, l.informationAccuracyDescription),
        _item(l.accountSecurity, l.accountSecurityDescription),
      ]),
      _section('3. ${l.legalSectionPurchasesAndPayments}', [
        _p(l.purchasesAndPaymentsParagraph1),
        _bullet(l.purchasesAndPaymentsParagraph2),
        _bullet(l.purchasesAndPaymentsParagraph3),
      ]),
      _section('4. ${l.legalSectionWarranties}', [
        _p(l.warrantiesDescription),
        for (final item in [
          l.trafficAccidents,
          l.misuse,
          l.incorrectInstallation,
          l.improperStorage,
        ])
          _bullet(item),
      ]),
      _section('5. ${l.legalSectionLimitationOfLiability}', [
        _p(l.limitationOfLiabilityParagraph1),
        _p(l.limitationOfLiabilityParagraph2),
      ]),
      Text(
        l.lastUpdated,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.gray2, fontSize: 12),
      ),
    ]);
  }
}
