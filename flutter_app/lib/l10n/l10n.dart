import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Indexed ARB entries exposed as lists (testimonials, service journey, ...).
extension L10nLists on AppLocalizations {
  List<String> get testimonials => [
    testimonials0,
    testimonials1,
    testimonials2,
  ];

  List<(String, String)> get journey => [
    (journey0Title, journey0Desc),
    (journey1Title, journey1Desc),
    (journey2Title, journey2Desc),
    (journey3Title, journey3Desc),
  ];

  List<(String, String)> get whyChoose => [
    (whyChoose0Title, whyChoose0Desc),
    (whyChoose1Title, whyChoose1Desc),
    (whyChoose2Title, whyChoose2Desc),
    (whyChoose3Title, whyChoose3Desc),
    (whyChoose4Title, whyChoose4Desc),
  ];

  List<(String, String)> get features => [
    (features0Title, features0Desc),
    (features1Title, features1Desc),
    (features2Title, features2Desc),
    (features3Title, features3Desc),
  ];
}
