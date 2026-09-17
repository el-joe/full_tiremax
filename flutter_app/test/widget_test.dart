// Basic smoke test for the TireMax app scaffolding.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App renders home placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TireMaxApp()));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
  });
}
