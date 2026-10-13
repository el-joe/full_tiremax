import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:flutter_app/features/product/models/product.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/shared/widgets/product_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFavorites extends FavoritesNotifier {
  @override
  Set<int> build() => {1};
}

Product _product() {
  final json = jsonDecode(
    File('test/fixtures/products.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final p = Product.fromJson(
    (json['data'] as List).first as Map<String, dynamic>,
  );
  return p.copyWith(
    name: 'Bridgestone Turanza T005 Extra Long Product Name For Wrapping Test',
    price: 1250000,
    sale_price: 990000,
    effective_price: 990000,
    has_discount: true,
    badges: ['special_offer'],
    expert_rating: 4.5,
    images: [],
    primary_image: null,
  );
}

void main() {
  for (final rtl in [false, true]) {
    testWidgets(
      'ProductCard fits at 360 width, 1.3 text scale (${rtl ? 'RTL' : 'LTR'})',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [favoritesProvider.overrideWith(_FakeFavorites.new)],
            child: MaterialApp(
              locale: Locale(rtl ? 'ar' : 'en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.3)),
                child: child!,
              ),
              home: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverProductGrid(
                        products: [_product(), _product()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.byType(ProductGrid), findsNothing);
        expect(find.text('-21%'), findsNWidgets(2));
      },
    );
  }
}
