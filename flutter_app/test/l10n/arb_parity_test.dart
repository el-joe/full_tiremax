import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _load(String name) =>
    jsonDecode(File('lib/l10n/$name').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

void main() {
  final en = _load('app_en.arb');
  final ar = _load('app_ar.arb');

  test('en and ar ARB files define identical message keys', () {
    final enKeys = _messageKeys(en);
    final arKeys = _messageKeys(ar);
    expect(enKeys.difference(arKeys), isEmpty, reason: 'missing in app_ar.arb');
    expect(arKeys.difference(enKeys), isEmpty, reason: 'missing in app_en.arb');
  });

  test('no ARB message is empty and placeholders match across locales', () {
    final placeholder = RegExp(r'\{(\w+)\}');
    for (final key in _messageKeys(en)) {
      final e = en[key] as String;
      final a = ar[key] as String;
      expect(e.trim(), isNotEmpty, reason: 'en.$key');
      expect(a.trim(), isNotEmpty, reason: 'ar.$key');
      expect(
        placeholder.allMatches(a).map((m) => m.group(1)).toSet(),
        placeholder.allMatches(e).map((m) => m.group(1)).toSet(),
        reason: 'placeholders differ for $key',
      );
    }
  });
}
