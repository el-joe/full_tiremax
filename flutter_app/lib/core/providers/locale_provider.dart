import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeStorageKey = 'tiremax_locale';

/// Holds the app's current locale (mirrors the web's `useToggleLang`).
///
/// Defaults to English, then hydrates from `shared_preferences` on startup
/// (mirroring the hydration pattern in `TokenStorage`) so the user's choice
/// survives app restarts. Feature code (settings screen, locale toggle)
/// should call [setLocale]; `apiClientProvider` reads this provider to set
/// the `x-locale` header on every request.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _hydrate();
    return const Locale('en');
  }

  Future<void> _hydrate() async {
    try {
      final prefs = SharedPreferencesAsync();
      final saved = await prefs.getString(_localeStorageKey);
      if (saved != null && saved.isNotEmpty) {
        state = Locale(saved);
      }
    } catch (_) {
      // Ignore hydration failures; default locale stays in effect.
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    try {
      await SharedPreferencesAsync().setString(_localeStorageKey, locale.languageCode);
    } catch (_) {
      // Best-effort persistence; in-memory state already updated.
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
