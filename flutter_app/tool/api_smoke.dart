// Read-only smoke test against the live TireMax API.
//
//   dart run tool/api_smoke.dart [baseUrl]
//
// Only issues GET requests. Exits non-zero if any check fails.
import 'dart:convert';
import 'dart:io';

const defaultBase = 'https://api.tiremaxiq.com/api/v1';

int failures = 0;

late String base;
final client = HttpClient()..connectionTimeout = const Duration(seconds: 20);

Future<(int, dynamic)> get(String path, {Map<String, String> headers = const {}}) async {
  final req = await client.getUrl(Uri.parse('$base/$path'));
  req.headers.set('Accept', 'application/json');
  req.headers.set('x-locale', 'en');
  req.headers.set('X-Guest-Token', 'smoke-test-guest-token-000000');
  headers.forEach(req.headers.set);
  final res = await req.close();
  final body = await res.transform(utf8.decoder).join();
  dynamic json;
  try {
    json = jsonDecode(body);
  } catch (_) {}
  return (res.statusCode, json);
}

/// [keys] must exist on the first element (or on the object itself).
Future<void> check(
  String name,
  String path, {
  int status = 200,
  List<String> keys = const [],
  bool list = true,
  bool nonEmpty = false,
  Map<String, String> headers = const {},
}) async {
  final problems = <String>[];
  try {
    final (code, json) = await get(path, headers: headers);
    if (code != status) problems.add('status $code != $status');
    if (code == 200 && json is! Map) {
      problems.add('body is not a JSON object');
    } else if (code == 200 && keys.isNotEmpty || (code == 200 && nonEmpty)) {
      final data = (json as Map)['data'];
      if (list) {
        if (data is! List) {
          problems.add('data is not a list');
        } else if (data.isEmpty) {
          if (nonEmpty) problems.add('data is empty');
        } else {
          final first = data.first as Map;
          for (final k in keys) {
            if (!first.containsKey(k)) problems.add('missing key "$k"');
          }
        }
      } else {
        if (data is! Map) {
          problems.add('data is not an object');
        } else {
          for (final k in keys) {
            if (!data.containsKey(k)) problems.add('missing key "$k"');
          }
        }
      }
    }
  } catch (e) {
    problems.add('request failed: $e');
  }
  if (problems.isEmpty) {
    stdout.writeln('PASS  $name  GET /$path');
  } else {
    failures++;
    stdout.writeln('FAIL  $name  GET /$path  -> ${problems.join('; ')}');
  }
}

Future<void> main(List<String> args) async {
  base = (args.isNotEmpty ? args.first : defaultBase).replaceAll(RegExp(r'/+$'), '');
  stdout.writeln('Smoke testing $base');

  const productKeys = ['id', 'sku', 'name', 'price', 'effective_price', 'in_stock', 'brand'];
  final tomorrow = DateTime.now().add(const Duration(days: 3)).toIso8601String().substring(0, 10);

  await check('home', 'home', list: false, keys: ['featured', 'best_sellers', 'new_arrivals', 'offers', 'brands', 'governorates']);
  await check('settings/public', 'settings/public', list: false, keys: ['whatsapp_url']);
  await check('payment-gateways', 'payment-gateways', keys: ['id', 'name', 'display_name', 'driver', 'is_active'], nonEmpty: true);
  await check('brands', 'brands', keys: ['id', 'slug', 'name'], nonEmpty: true);
  await check('branches', 'branches', keys: ['id', 'code', 'name', 'address', 'phone'], nonEmpty: true);
  await check('governorates', 'governorates', keys: ['id', 'code', 'name', 'is_basra', 'shipping_fee'], nonEmpty: true);
  await check('cities', 'governorates/1/cities', keys: ['id', 'name_ar', 'name_en']);
  await check('services', 'services', keys: ['id', 'slug', 'name', 'duration_minutes', 'price'], nonEmpty: true);
  await check('flash-sales', 'flash-sales');
  await check('vehicles/makes', 'vehicles/makes', keys: ['id', 'slug', 'name']);
  await check('vehicles/models', 'vehicles/makes/1/models', keys: ['id', 'slug', 'name']);
  await check('vehicles/years', 'vehicles/models/1/years');
  await check('vehicles', 'vehicles');
  await check('products', 'products?per_page=3', keys: productKeys, nonEmpty: true);
  await check('products/{id}', 'products/1', list: false, keys: productKeys);
  await check('products/{id}/related', 'products/1/related', keys: productKeys);
  await check('products/{id} 404', 'products/99999999', status: 404);
  await check('fitments/sizes', 'fitments/sizes', keys: ['width', 'aspect_ratio', 'rim_diameter']);
  await check('fitments/by-size', 'fitments/by-size?width=205&aspect_ratio=55&rim_diameter=16');
  await check('fitments/by-size validation', 'fitments/by-size', status: 422);
  await check('reviews/{product}', 'reviews/1');
  await check('booking slots', 'bookings/branch/1/slots?date=$tomorrow');
  await check('booking slots validation', 'bookings/branch/1/slots', status: 422);
  await check('guest cart', 'cart', list: false, keys: ['id', 'items', 'subtotal', 'items_count']);
  await check('auth-only 401: auth/me', 'auth/me', status: 401);
  await check('auth-only 401: orders', 'orders', status: 401);
  await check('auth-only 401: addresses', 'addresses', status: 401);
  await check('auth-only 401: favorites', 'favorites', status: 401);
  await check('auth-only 401: notifications', 'notifications', status: 401);
  await check('auth-only 401: bookings', 'bookings', status: 401);

  client.close();
  stdout.writeln(failures == 0 ? '\nAll checks passed.' : '\n$failures check(s) failed.');
  exit(failures == 0 ? 0 : 1);
}
