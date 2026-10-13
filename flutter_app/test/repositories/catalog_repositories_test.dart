import 'package:dio/dio.dart';
import 'package:flutter_app/features/home/data/home_repository.dart';
import 'package:flutter_app/features/offers/data/offers_repository.dart';
import 'package:flutter_app/features/product/data/product_repository.dart';
import 'package:flutter_app/features/reservation/data/reservation_repository.dart';
import 'package:flutter_app/features/settings/data/public_settings_repository.dart';
import 'package:flutter_app/features/services/data/services_repository.dart';
import 'package:flutter_app/features/store/data/store_repository.dart';
import 'package:flutter_app/features/addresses/data/addresses_repository.dart';
import 'package:flutter_app/features/checkout/data/checkout_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

/// Fixtures under test/fixtures/*.json are captured from the live API
/// (public GETs), so they carry real nullability and field types.
void main() {
  late Harness h;
  setUp(() => h = Harness());
  tearDown(() => h.dispose());

  void expectCommonHeaders({String locale = 'en'}) {
    expect(h.last.headers['X-Guest-Token'], FakeTokenStorage.guest);
    expect(h.last.headers['x-locale'], locale);
    expect(h.last.headers['Accept'], 'application/json');
    expect(h.last.headers.containsKey('Authorization'), isFalse);
  }

  test('home: GET home parses sections and sends guest/locale headers', () async {
    h.reply('GET', 'home', fixture('home'));
    final res = await h.container.read(homeRepositoryProvider).fetchHome();
    expect(h.last.method, 'GET');
    expect(h.last.path, 'home');
    expectCommonHeaders();
    expect(res, isNotNull);
  });

  test('x-locale follows the locale provider; Authorization sent when token exists', () async {
    final authed = Harness(token: 'jwt-abc');
    addTearDown(authed.dispose);
    await authed.setLocale('ar');
    authed.reply('GET', 'home', fixture('home'));
    await authed.container.read(homeRepositoryProvider).fetchHome();
    expect(authed.last.headers['x-locale'], 'ar');
    expect(authed.last.headers['Authorization'], 'Bearer jwt-abc');
    expect(authed.last.headers['X-Guest-Token'], FakeTokenStorage.guest);
  });

  test('products: GET products with filters -> paginated Product list', () async {
    h.reply('GET', 'products', fixture('products'));
    final repo = h.container.read(storeRepositoryProvider);
    final page = await repo.fetchProducts(
      page: 2,
      filters: const ProductFilters(search: 'x', brandId: 3, minPrice: 10, width: 205),
    );
    expect(h.last.path, 'products');
    expect(h.last.queryParameters, containsPair('page', 2));
    expect(h.last.queryParameters, containsPair('brand_id', 3));
    expect(h.last.queryParameters, containsPair('search', 'x'));
    expect(h.last.queryParameters, containsPair('width', 205));
    expect(page.data, isNotEmpty);
  });

  test('brands / tyre sizes parse', () async {
    h.reply('GET', 'brands', fixture('brands'));
    h.reply('GET', 'fitments/sizes', fixture('sizes'));
    final repo = h.container.read(storeRepositoryProvider);
    expect(await repo.fetchBrands(), isNotEmpty);
    expect(await repo.fetchTyreSizes(), isNotEmpty);
    expect(h.last.path, 'fitments/sizes');
  });

  test('vehicle make/model/year chain', () async {
    final repo = h.container.read(storeRepositoryProvider);
    h.reply('GET', 'vehicles/makes', fixture('makes'));
    final makes = await repo.fetchVehicleMakes();
    expect(makes.first.id, 1);
    expect(makes.first.name, isNotEmpty);

    h.reply('GET', 'vehicles/makes/1/models', fixture('models'));
    final models = await repo.fetchVehicleModels(makes.first.id);
    expect(h.last.path, 'vehicles/makes/1/models');
    expect(models.first.id, 1);

    h.reply('GET', 'vehicles/models/1/years', {
      'success': true,
      'data': [
        {'id': 1, 'vehicle_model_id': 1, 'year_from': 2018, 'year_to': 2020},
        {'id': 2, 'vehicle_model_id': 1, 'year_from': 2020, 'year_to': 2021},
      ],
    });
    expect(await repo.fetchVehicleYears(1), [2021, 2020, 2019, 2018]);

    h.reply('GET', 'vehicles', {
      'success': true,
      'data': [
        {'id': 42},
      ],
    });
    final id = await repo.fetchVehicleId(makeId: 1, modelId: 1, year: 2019);
    expect(id, 42);
    expect(h.last.queryParameters, {'make_id': 1, 'model_id': 1, 'year': 2019});

    h.reply('GET', 'products', fixture('products'));
    await repo.fetchProducts(page: 1, filters: const ProductFilters(vehicleId: 42));
    expect(h.last.queryParameters, containsPair('vehicle_id', 42));
    expect(h.last.queryParameters.containsKey('make'), isFalse);
  });

  test('product detail / related / reviews', () async {
    h.reply('GET', 'products/1', fixture('product'));
    h.reply('GET', 'products/1/related', fixture('related'));
    h.reply('GET', 'reviews/1', fixture('reviews'));
    final repo = h.container.read(productRepositoryProvider);
    expect((await repo.fetchProduct(1)).id, 1);
    expect(await repo.fetchRelated(1), isNotEmpty);
    final (reviews, meta) = await repo.fetchReviews(1);
    expect(h.last.queryParameters, containsPair('page', 1));
    expect(reviews, isA<List>());
    expect(meta.ratingCount, isNonNegative);
  });

  test('product 404 surfaces as DioException with status 404', () async {
    h.reply('GET', 'products/99999', {'success': false, 'message': 'Not found'}, status: 404);
    expect(
      h.container.read(productRepositoryProvider).fetchProduct(99999),
      throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'status', 404)),
    );
  });

  test('add to cart / submit review request bodies', () async {
    h.reply('POST', 'cart/items', {'success': true, 'data': {}});
    h.reply('POST', 'reviews/1', {'success': true, 'data': {}}, status: 201);
    final repo = h.container.read(productRepositoryProvider);
    await repo.addToCart(productId: 1, quantity: 2);
    expect(h.last.data, {'product_id': 1, 'quantity': 2});
    await repo.submitReview(1, rating: 5, comment: 'great');
    expect(h.last.method, 'POST');
    expect(h.last.data, {'rating': 5, 'comment': 'great'});
  });

  test('flash sales list + products', () async {
    h.reply('GET', 'flash-sales', {
      'success': true,
      'data': [
        {'id': 1, 'title': 'Sale', 'discount_percent': 10.0, 'starts_at': '2026-01-01T00:00:00+00:00', 'ends_at': '2026-12-31T00:00:00+00:00', 'is_active': true}
      ]
    });
    h.reply('GET', 'flash-sales/1/products', fixture('related'));
    final repo = h.container.read(offersRepositoryProvider);
    expect(await repo.fetchFlashSales(), hasLength(1));
    expect(await repo.fetchFlashSaleProducts(1), isNotEmpty);
    expect(h.last.path, 'flash-sales/1/products');
  });

  test('services, branches, governorates, cities, payment gateways', () async {
    h.reply('GET', 'services', fixture('services'));
    h.reply('GET', 'branches', fixture('branches'));
    h.reply('GET', 'governorates', fixture('governorates'));
    h.reply('GET', 'governorates/1/cities', fixture('cities'));
    h.reply('GET', 'payment-gateways', fixture('gateways'));
    expect(await h.container.read(servicesRepositoryProvider).fetchServices(), isNotEmpty);
    final checkout = h.container.read(checkoutRepositoryProvider);
    expect(await checkout.fetchBranches(), isNotEmpty);
    expect(await checkout.fetchGovernorates(), isNotEmpty);
    expect(await h.container.read(addressesRepositoryProvider).fetchCities(1), isNotEmpty);
    // payment-gateways has no `is_active` key in the API payload
    expect(await checkout.fetchPaymentMethods(), isNotEmpty);
  });

  test('settings/public', () async {
    h.reply('GET', 'settings/public', fixture('settings'));
    // provider swallows errors, so assert on the request that went out
    await h.container.read(publicSettingsProvider.future);
    expect(h.last.path, 'settings/public');
  });

  test('reservation: services, branches, slots', () async {
    h.reply('GET', 'bookings/branch/1/slots', {
      'success': true,
      'data': [
        {'time': '09:00', 'available': true, 'capacity': 2, 'booked': 0},
        {'time': '09:30', 'available': false, 'capacity': 2, 'booked': 2},
      ]
    });
    final repo = h.container.read(reservationRepositoryProvider);
    final slots = await repo.fetchAvailableSlots(branchId: 1, date: '2026-12-01');
    expect(h.last.queryParameters, {'date': '2026-12-01'});
    expect(slots.map((s) => s.available), [true, false]);
  });
}
