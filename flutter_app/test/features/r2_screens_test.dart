import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:flutter_app/features/home/models/home_res.dart';
import 'package:flutter_app/features/home/presentation/home_screen.dart';
import 'package:flutter_app/features/home/providers/home_provider.dart';
import 'package:flutter_app/features/notifications/providers/notifications_provider.dart';
import 'package:flutter_app/features/product/data/product_repository.dart';
import 'package:flutter_app/features/product/models/product.dart';
import 'package:flutter_app/features/product/presentation/product_detail_screen.dart';
import 'package:flutter_app/features/services/data/services_repository.dart';
import 'package:flutter_app/features/services/models/service.dart';
import 'package:flutter_app/features/services/presentation/services_screen.dart';
import 'package:flutter_app/features/store/data/store_repository.dart';
import 'package:flutter_app/features/store/presentation/store_screen.dart';
import 'package:flutter_app/features/store/providers/store_provider.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _json(String f) =>
    jsonDecode(File('test/fixtures/$f').readAsStringSync())
        as Map<String, dynamic>;

class _FakeFavorites extends FavoritesNotifier {
  @override
  Set<int> build() => {1};
}

class _FakeStore extends StoreListNotifier {
  _FakeStore(this.products);
  final List<Product> products;

  StoreListState get _s =>
      StoreListState(products: products, total: products.length);

  @override
  Future<StoreListState> build() async => _s;

  @override
  Future<void> applyFilters(ProductFilters filters) async {}

  @override
  Future<void> loadMore() async {}
}

Future<void> _pump(
  WidgetTester tester,
  Widget home, {
  required bool rtl,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final products = (_json('products.json')['data'] as List)
      .map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList();
  final homeRes = HomeRes.fromJson(
    _json('home.json')['data'] as Map<String, dynamic>,
  );
  final product = Product.fromJson(
    _json('product.json')['data'] as Map<String, dynamic>,
  );
  final services = (_json('services.json')['data'] as List)
      .map((e) => Service.fromJson(e as Map<String, dynamic>))
      .toList();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        favoritesProvider.overrideWith(_FakeFavorites.new),
        unreadCountProvider.overrideWith((ref) async => 3),
        homeProvider.overrideWith((ref) async => homeRes),
        storeListProvider.overrideWith(
          () => _FakeStore([
            ...products,
            ...products.map((p) => p.copyWith(id: p.id + 100)),
          ]),
        ),
        vehicleMakesProvider.overrideWith(
          (ref) async => const <VehicleOption>[],
        ),
        productDetailProvider.overrideWith((ref, id) async => product),
        productReviewsProvider.overrideWith(
          (ref, id) async =>
              const ReviewsState(reviews: [], ratingAvg: 0, ratingCount: 0),
        ),
        servicesProvider.overrideWith((ref) async => services),
        ...overrides,
      ],
      child: MaterialApp(
        locale: Locale(rtl ? 'ar' : 'en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.3)),
          child: child!,
        ),
        home: home,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  for (final rtl in [false, true]) {
    final tag = rtl ? 'RTL' : 'LTR';
    testWidgets('Home fits 360x640 @1.3 ($tag)', (tester) async {
      await _pump(tester, const HomeScreen(), rtl: rtl);
      expect(tester.takeException(), isNull);
      expect(find.byType(CustomScrollView), findsOneWidget);
      // Scroll through the whole page to build every section.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Store fits 360x640 @1.3 ($tag)', (tester) async {
      await _pump(tester, const StoreScreen(), rtl: rtl);
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Offers preset fits ($tag)', (tester) async {
      await _pump(
        tester,
        const StoreScreen(
          isOffers: true,
          initialFilters: ProductFilters(badge: 'special_offer'),
        ),
        rtl: rtl,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Product detail fits 360x640 @1.3 ($tag)', (tester) async {
      await _pump(tester, const ProductDetailScreen(productId: 1), rtl: rtl);
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1500));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Services fits 360x640 @1.3 ($tag)', (tester) async {
      await _pump(tester, const ServicesScreen(), rtl: rtl);
      expect(tester.takeException(), isNull);
    });
  }
}
