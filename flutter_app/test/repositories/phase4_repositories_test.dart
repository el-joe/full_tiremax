import 'package:flutter_app/core/utils/format.dart';
import 'package:flutter_app/features/checkout/data/checkout_repository.dart';
import 'package:flutter_app/features/checkout/providers/checkout_flow_provider.dart';
import 'package:flutter_app/features/orders/data/orders_repository.dart';
import 'package:flutter_app/features/reservation/data/reservation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'account_repositories_test.dart' show order, booking;
import 'harness.dart';

void main() {
  late Harness h;
  setUp(() => h = Harness(token: 'jwt-abc'));
  tearDown(() => h.dispose());

  Map<String, dynamic> meta(int page, int last) =>
      {'pagination': {'total': 31, 'per_page': 15, 'current_page': page, 'last_page': last}};

  test('orders page sends status + page and parses meta.pagination', () async {
    h.reply('GET', 'orders', {'success': true, 'data': [order()], 'meta': meta(2, 3)});
    final r = await h.container.read(ordersRepositoryProvider).fetchOrdersPage(page: 2, status: 'on_the_way');
    expect(h.last.queryParameters, {'page': 2, 'status': 'on_the_way'});
    expect(r.items, hasLength(1));
    expect((r.total, r.currentPage, r.lastPage), (31, 2, 3));
  });

  test('bookings page sends page', () async {
    h.reply('GET', 'bookings', {'success': true, 'data': [booking()], 'meta': meta(3, 3)});
    final r = await h.container.read(reservationRepositoryProvider).fetchBookingsPage(page: 3);
    expect(h.last.queryParameters, {'page': 3});
    expect(r.lastPage, 3);
  });

  test('createOrder payload matches CheckoutForm.tsx (delivery, locale, offer_code)', () async {
    h.reply('POST', 'orders', {'success': true, 'message': 'ok', 'data': order()}, status: 201);
    await h.container.read(checkoutRepositoryProvider).createOrder(
          type: 'delivery',
          paymentMethod: 'paymob',
          customerName: 'Ali',
          customerPhone: '07701234567',
          customerEmail: 'a@b.co',
          locale: 'ar',
          offerCode: 'TEN',
          notes: 'n',
          governorateId: 2,
          shippingAddress: 'Street 1, house 2',
        );
    expect(h.last.data, {
      'type': 'delivery', 'payment_method': 'paymob', 'customer_name': 'Ali', 'customer_phone': '07701234567',
      'customer_email': 'a@b.co', 'locale': 'ar', 'offer_code': 'TEN', 'notes': 'n',
      'governorate_id': 2, 'shipping_address': 'Street 1, house 2',
    });
  });

  test('guest booking payload matches ReservationProvider.tsx; logged-in omits contact', () async {
    h.reply('POST', 'bookings', {'success': true, 'data': booking()}, status: 201);
    final repo = h.container.read(reservationRepositoryProvider);
    await repo.createBooking(
        serviceId: 1, branchId: 2, scheduledAt: '2030-01-01T10:00', locale: 'en',
        customerName: ' Ali ', customerPhone: '0770', customerEmail: '');
    expect(h.last.data, {
      'customer_name': 'Ali', 'customer_phone': '0770', 'locale': 'en',
      'service_id': 1, 'branch_id': 2, 'scheduled_at': '2030-01-01T10:00',
    });
    await repo.createBooking(serviceId: 1, branchId: 2, scheduledAt: '2030-01-01T10:00', locale: 'en');
    expect(h.last.data, {'locale': 'en', 'service_id': 1, 'branch_id': 2, 'scheduled_at': '2030-01-01T10:00'});
  });

  test('iraqi phone + IQD formatting match web helpers', () {
    expect(isValidIraqiPhone('07701234567'), isTrue);
    expect(isValidIraqiPhone('+964 770 123 4567'), isTrue);
    expect(isValidIraqiPhone('12345'), isFalse);
    expect(formatIqd(1234567), '1,234,567 IQD');
  });

  test('checkout validation mirrors createOrderSchemas', () {
    const base = CheckoutFormState(customerName: 'Ali', customerPhone: '07701234567', paymentMethod: 'cod');
    expect(base.validate().keys, containsAll(['governorate', 'address']));
    expect(base.copyWith(governorateId: 1, shippingAddress: '123456789012').validate().keys, ['address']);
    expect(base.copyWith(governorateId: 1, shippingAddress: '1234567890123').validate(), isEmpty);
    expect(base.copyWith(type: OrderType.basra).validate().keys, ['branch']);
    expect(base.copyWith(type: OrderType.basra, branchId: 1, createAccount: true, password: '123').validate().keys, ['password']);
  });
}
