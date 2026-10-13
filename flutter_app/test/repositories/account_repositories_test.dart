import 'package:dio/dio.dart';
import 'package:flutter_app/core/network/api_exception.dart';
import 'package:flutter_app/features/addresses/data/addresses_repository.dart';
import 'package:flutter_app/features/auth/data/auth_repository.dart';
import 'package:flutter_app/features/cart/data/cart_repository.dart';
import 'package:flutter_app/features/checkout/data/checkout_repository.dart';
import 'package:flutter_app/features/favorites/data/favorites_repository.dart';
import 'package:flutter_app/features/notifications/data/notifications_repository.dart';
import 'package:flutter_app/features/orders/data/orders_repository.dart';
import 'package:flutter_app/features/reservation/data/reservation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

// Response shapes follow the Laravel resources / TireMax_API.postman_collection.json.
Map<String, dynamic> customer({String? email}) => {
      'id': 7, 'name': 'Ali', 'email': email, 'phone': '07701234567', 'address': null, 'locale': 'en',
    };

Map<String, dynamic> gov() => {'id': 1, 'code': 'BSR', 'name': 'Basra', 'is_basra': true, 'shipping_fee': 5000.0};

Map<String, dynamic> product() => (fixture('product') as Map)['data'] as Map<String, dynamic>;

Map<String, dynamic> cart({int count = 2}) => {
      'success': true,
      'message': 'ok',
      'data': {
        'id': 3,
        'governorate_id': null,
        'items': [
          {'id': 11, 'product_id': 1, 'product': product(), 'quantity': count, 'unit_price': 1000.0, 'total': 1000.0 * count}
        ],
        'subtotal': 1000.0 * count,
        'items_count': count,
      },
    };

Map<String, dynamic> order({String status = 'pending'}) => {
      'id': 5, 'reference': 'ORD-ABC123', 'type': 'basra', 'status': status, 'payment_method': 'cod',
      'payment_status': 'pending', 'subtotal': 2000.0, 'discount': 0.0, 'shipping_fee': 0.0,
      'installation_fee': 0.0, 'total': 2000.0, 'is_guest': true, 'customer_id': null,
      'customer_name': 'Guest', 'customer_phone': '07701234567', 'customer_email': null,
      'shipping_address': null, 'tracking_number': null, 'placed_at': '2026-10-01T10:00:00+03:00',
      'items': [
        {'id': 1, 'product_id': 1, 'product_name': 'Tire', 'product_sku': 'SKU1', 'quantity': 2, 'unit_price': 1000.0, 'total': 2000.0, 'reviewed': false}
      ],
    };

Map<String, dynamic> address() => {
      'id': 9, 'full_name': 'Ali', 'phone': '07701234567', 'governorate': gov(),
      'city': {'id': 2, 'name_ar': 'الزبير', 'name_en': 'Zubair'}, 'address': 'Street 1', 'is_default': false,
    };

Map<String, dynamic> booking() => {
      'id': 4, 'reference': 'BK-AB12', 'scheduled_at': '2026-12-01T10:00:00+03:00', 'duration_minutes': 30,
      'status': 'pending', 'is_guest': true, 'customer_name': 'G', 'customer_phone': '07701234567',
      'customer_email': null, 'customer_notes': null,
      'branch': (fixture('branches') as Map)['data'][0], 'service': (fixture('services') as Map)['data'][0],
    };

void main() {
  late Harness h;
  setUp(() => h = Harness(token: 'jwt-abc'));
  tearDown(() => h.dispose());

  void expectAuthed() {
    expect(h.last.headers['Authorization'], 'Bearer jwt-abc');
    expect(h.last.headers['X-Guest-Token'], FakeTokenStorage.guest);
    expect(h.last.headers['x-locale'], 'en');
  }

  group('auth', () {
    test('login POST auth/login stores token + customer', () async {
      h.reply('POST', 'auth/login', {
        'success': true, 'message': 'ok',
        'data': {'customer': customer(), 'access_token': 'new-jwt', 'token_type': 'bearer', 'expires_in': 3600},
        'meta': {'linked_orders': 2, 'linked_bookings': 1},
      });
      final res = await h.container.read(authRepositoryProvider).login(login: '07701234567', password: 'secret12');
      expect(h.last.method, 'POST');
      expect(h.last.path, 'auth/login');
      expect(h.last.data, {'login': '07701234567', 'password': 'secret12'});
      expect(res.accessToken, 'new-jwt');
      expect(res.hasLinked, isTrue);
      expect(h.storage.token, 'new-jwt');
    });

    test('register POST auth/register body', () async {
      h.reply('POST', 'auth/register', {
        'success': true, 'message': 'ok',
        'data': {'customer': customer(), 'access_token': 't', 'token_type': 'bearer', 'expires_in': 3600},
      }, status: 201);
      await h.container.read(authRepositoryProvider).register(
          name: 'Ali', phone: '07701234567', password: 'secret12', passwordConfirmation: 'secret12', locale: 'en');
      expect(h.last.path, 'auth/register');
      expect(h.last.data, containsPair('password_confirmation', 'secret12'));
      expect(h.last.data, isNot(contains('email')));
    });

    test('422 validation error is mapped to ApiException', () async {
      h.reply('POST', 'auth/login', {'success': false, 'message': 'The given data was invalid.', 'errors': {'login': ['required']}}, status: 422);
      expect(
        h.container.read(authRepositoryProvider).login(login: '', password: ''),
        throwsA(isA<ApiException>()),
      );
    });

    test('401 clears stored token', () async {
      h.reply('PUT', 'auth/me', {'success': false, 'message': 'Unauthenticated.'}, status: 401);
      await expectLater(
        h.container.read(authRepositoryProvider).updateMe(name: 'x'),
        throwsA(isA<ApiException>()),
      );
      expect(h.storage.token, isNull);
    });

    test('updateMe PUT auth/me', () async {
      h.reply('PUT', 'auth/me', {'success': true, 'message': 'ok', 'data': customer()});
      final me = await h.container.read(authRepositoryProvider).updateMe(name: 'Ali', locale: 'en');
      expect(h.last.method, 'PUT');
      expect(h.last.data, {'name': 'Ali', 'locale': 'en'});
      expectAuthed();
      expect(me.id, 7);
    });
  });

  group('cart', () {
    test('fetch/add/update/remove', () async {
      final repo = h.container.read(cartRepositoryProvider);
      h.reply('GET', 'cart', cart());
      h.reply('POST', 'cart/items', cart());
      h.reply('PUT', 'cart/items/11', cart(count: 5));
      h.reply('DELETE', 'cart/items/11', cart(count: 0));
      expect((await repo.fetchCart()).items_count, 2);
      expectAuthed();
      await repo.addItem(productId: 1, quantity: 2);
      expect(h.last.data, {'product_id': 1, 'quantity': 2});
      expect((await repo.updateItem(itemId: 11, quantity: 5)).items_count, 5);
      expect(h.last.method, 'PUT');
      expect(h.last.data, {'quantity': 5});
      await repo.removeItem(11);
      expect(h.last.method, 'DELETE');
    });

    test('clearCart DELETE cart (backend replies with data: null)', () async {
      h.reply('DELETE', 'cart', {'success': true, 'message': 'Deleted'});
      await h.container.read(cartRepositoryProvider).clearCart();
      expect(h.last.method, 'DELETE');
      expect(h.last.path, 'cart');
    });

    test('applyOffer POST cart/apply-offer', () async {
      h.reply('POST', 'cart/apply-offer', {
        'success': true, 'message': 'ok',
        'data': {
          'discount': 200.0, 'subtotal': 2000.0, 'total': 1800.0, 'discount_percent': 10.0,
          'offer': {'code': 'TEN', 'title': 'Ten', 'discount_type': 'percent', 'discount_value': 10.0},
        },
      });
      final r = await h.container.read(cartRepositoryProvider).applyOffer('TEN');
      expect(h.last.data, {'code': 'TEN'});
      expect(r.discount, 200);
    });
  });

  group('orders & checkout', () {
    test('createOrder (basra) POST orders and parses nullable order fields', () async {
      h.reply('POST', 'orders', {'success': true, 'message': 'ok', 'data': order()}, status: 201);
      final o = await h.container.read(checkoutRepositoryProvider).createOrder(
            type: 'basra', paymentMethod: 'cod', branchId: 1, customerName: 'Guest', customerPhone: '07701234567');
      expect(h.last.path, 'orders');
      expect(h.last.data, {
        'type': 'basra', 'payment_method': 'cod', 'customer_name': 'Guest',
        'customer_phone': '07701234567', 'branch_id': 1,
      });
      expect(o.reference, 'ORD-ABC123');
    });

    test('createOrder (delivery) sends governorate + address, not branch', () async {
      h.reply('POST', 'orders', {'success': true, 'message': 'ok', 'data': order()}, status: 201);
      await h.container.read(checkoutRepositoryProvider).createOrder(
          type: 'delivery', paymentMethod: 'cod', governorateId: 1, shippingAddress: 'x', branchId: 4);
      expect(h.last.data, containsPair('governorate_id', 1));
      expect(h.last.data, containsPair('shipping_address', 'x'));
      expect(h.last.data, isNot(contains('branch_id')));
    });

    test('list / show / cancel', () async {
      final repo = h.container.read(ordersRepositoryProvider);
      h.reply('GET', 'orders', {'success': true, 'data': [order()], 'meta': {'pagination': {'total': 1, 'per_page': 15, 'current_page': 1, 'last_page': 1}}});
      h.reply('GET', 'orders/5', {'success': true, 'data': order()});
      h.reply('POST', 'orders/5/cancel', {'success': true, 'message': 'ok', 'data': order(status: 'cancelled')});
      expect(await repo.fetchOrders(), hasLength(1));
      expect((await repo.fetchOrder(5)).id, 5);
      expect((await repo.cancelOrder(5)).status, 'cancelled');
      expect(h.last.method, 'POST');
    });

    test('order 404', () async {
      h.reply('GET', 'orders/99', {'success': false, 'message': 'Not found'}, status: 404);
      expect(h.container.read(ordersRepositoryProvider).fetchOrder(99), throwsA(isA<DioException>()));
    });

    test('fetchPayment returns null on 404', () async {
      h.reply('GET', 'orders/5/payment', {'message': 'No payment found for this order.'}, status: 404);
      expect(await h.container.read(checkoutRepositoryProvider).fetchPayment(5), isNull);
    });
  });

  group('addresses', () {
    test('list/create/update/default/delete', () async {
      final repo = h.container.read(addressesRepositoryProvider);
      h.reply('GET', 'addresses', {'success': true, 'data': [address()]});
      h.reply('POST', 'addresses', {'success': true, 'data': address()}, status: 201);
      h.reply('PUT', 'addresses/9', {'success': true, 'data': address()});
      h.reply('POST', 'addresses/9/set-default', {'success': true, 'data': address()});
      h.reply('DELETE', 'addresses/9', {'success': true, 'message': 'Deleted'});
      expect(await repo.fetchAddresses(), hasLength(1));
      await repo.createAddress(fullName: 'Ali', phone: '0770', governorateId: 1, cityId: 2, address: 'S');
      expect(h.last.data, {'full_name': 'Ali', 'phone': '0770', 'governorate_id': 1, 'city_id': 2, 'address': 'S'});
      await repo.updateAddress(id: 9, fullName: 'Ali', phone: '0770', governorateId: 1, cityId: 2, address: 'S');
      expect(h.last.method, 'PUT');
      await repo.setDefault(9);
      expect(h.last.path, 'addresses/9/set-default');
      await repo.deleteAddress(9);
      expect(h.last.method, 'DELETE');
    });
  });

  group('favorites', () {
    test('list parses product cards; toggle POST', () async {
      final p = product();
      h.reply('GET', 'favorites', {'success': true, 'data': [p]});
      h.reply('POST', 'favorites/1/toggle', {'success': true, 'data': {'favorited': true}}, status: 201);
      final repo = h.container.read(favoritesRepositoryProvider);
      expect(await repo.fetchFavorites(), hasLength(1));
      await repo.toggle(1);
      expect(h.last.method, 'POST');
      expect(h.last.path, 'favorites/1/toggle');
    });
  });

  group('notifications', () {
    final n = {
      'id': 'u-1', 'type': 'order_status_changed', 'title': 'Order updated', 'body': 'x',
      'data': {'type': 'order_status_changed', 'title': 'Order Updated', 'body': 'x', 'reference': 'ORD-1', 'status': 'shipped'},
      'read_at': null, 'created_at': '2026-10-01T10:00:00.000000Z',
    };

    test('list', () async {
      h.reply('GET', 'notifications', {'data': [n], 'meta': {'current_page': 1, 'last_page': 1, 'per_page': 15, 'total': 1, 'unread_count': 1}});
      final list = await h.container.read(notificationsRepositoryProvider).fetchNotifications();
      expect(list.single.is_read, isFalse);
    });

    test('unread-count: backend replies {"unread_count": N} at top level', () async {
      h.reply('GET', 'notifications/unread-count', {'unread_count': 3});
      expect(await h.container.read(notificationsRepositoryProvider).fetchUnreadCount(), 3);
    });

    test('mark read / read-all', () async {
      h.reply('POST', 'notifications/u-1/read', {'message': 'ok'});
      h.reply('POST', 'notifications/read-all', {'message': 'ok'});
      final repo = h.container.read(notificationsRepositoryProvider);
      await repo.markRead('u-1');
      expect(h.last.path, 'notifications/u-1/read');
      await repo.markAllRead();
      expect(h.last.path, 'notifications/read-all');
    });
  });

  group('bookings', () {
    test('create / list / show / cancel', () async {
      final repo = h.container.read(reservationRepositoryProvider);
      h.reply('POST', 'bookings', {'success': true, 'data': booking()}, status: 201);
      h.reply('GET', 'bookings', {'success': true, 'data': [booking()], 'meta': {'pagination': {}}});
      h.reply('GET', 'bookings/4', {'success': true, 'data': booking()});
      h.reply('POST', 'bookings/4/cancel', {'success': true, 'data': {...booking(), 'status': 'cancelled'}});
      final b = await repo.createBooking(serviceId: 1, branchId: 1, scheduledAt: '2026-12-01T10:00:00+03:00', customerNotes: ' hi ');
      expect(h.last.data, {'service_id': 1, 'branch_id': 1, 'scheduled_at': '2026-12-01T10:00:00+03:00', 'customer_notes': 'hi'});
      expect(b.reference, 'BK-AB12');
      expect(await repo.fetchBookings(), hasLength(1));
      expect((await repo.fetchBooking(4)).id, 4);
      expect((await repo.cancelBooking(4)).status, 'cancelled');
    });
  });
}
