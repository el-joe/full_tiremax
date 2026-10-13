// Basic smoke test for the TireMax app scaffolding.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/core/providers/locale_provider.dart';
import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App renders home placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TireMaxApp()));
    await tester.pumpAndSettle();

    // Arabic is the default language.
    expect(find.text('الرئيسية'), findsWidgets);
  });

  testWidgets('Defaults to RTL Arabic and switching to English flips to LTR', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TireMaxApp()));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(TireMaxApp)),
    );
    final context = tester.element(find.byType(Scaffold).first);
    expect(Directionality.of(context), TextDirection.rtl);
    await container.read(localeProvider.notifier).setLocale(const Locale('en'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('الرئيسية'), findsNothing);
  });
}
