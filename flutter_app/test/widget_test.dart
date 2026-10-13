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

    expect(find.text('Home'), findsWidgets);
  });

  testWidgets('Switching to Arabic localizes the UI and flips to RTL', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TireMaxApp()));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(tester.element(find.byType(TireMaxApp)));
    await container.read(localeProvider.notifier).setLocale(const Locale('ar'));
    await tester.pumpAndSettle();

    expect(find.text('الرئيسية'), findsWidgets);
    expect(find.text('Home'), findsNothing);
    final context = tester.element(find.byType(Scaffold).first);
    expect(Directionality.of(context), TextDirection.rtl);
  });
}
