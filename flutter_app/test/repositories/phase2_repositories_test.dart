import 'package:dio/dio.dart';
import 'package:flutter_app/features/contact/data/contact_repository.dart';
import 'package:flutter_app/features/orders/data/orders_repository.dart';
import 'package:flutter_app/features/reservation/data/reservation_repository.dart';
import 'package:flutter_app/features/settings/data/public_settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'account_repositories_test.dart' show order, booking;
import 'harness.dart';

void main() {
  late Harness h;
  setUp(() => h = Harness());
  tearDown(() => h.dispose());

  test('contact message POST body is trimmed and guest token sent', () async {
    h.reply('POST', 'contact-messages', {'success': true, 'message': 'ok'}, status: 201);
    await h.container.read(contactRepositoryProvider).sendMessage(
        name: ' Ali ', phone: '0770', subject: 'Prices', message: 'Hello ');
    expect(h.last.method, 'POST');
    expect(h.last.path, 'contact-messages');
    expect(h.last.data, {'name': 'Ali', 'phone': '0770', 'subject': 'Prices', 'message': 'Hello'});
    expect(h.last.headers['X-Guest-Token'], FakeTokenStorage.guest);
  });

  test('contact 422 surfaces field errors', () async {
    h.reply('POST', 'contact-messages', {
      'message': 'invalid',
      'errors': {'phone': ['bad phone']},
    }, status: 422);
    expect(
      h.container.read(contactRepositoryProvider).sendMessage(
          name: 'a', phone: 'b', subject: 'c', message: 'd'),
      throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'status', 422)),
    );
  });

  test('contact validator mirrors contactSchema limits', () {
    expect(ContactValidator.name(' '), isNotNull);
    expect(ContactValidator.name('a' * 121), isNotNull);
    expect(ContactValidator.phone('1' * 31), isNotNull);
    expect(ContactValidator.subject('a' * 191), isNotNull);
    expect(ContactValidator.message('a' * 5001), isNotNull);
    expect(ContactValidator.message('hi'), isNull);
  });

  test('track order / booking use reference path + phone query', () async {
    h.reply('GET', 'orders/ORD-ABC123', {'success': true, 'data': order()});
    final o = await h.container.read(ordersRepositoryProvider).trackOrder(' ORD-ABC123 ', ' 0770 ');
    expect(o.reference, 'ORD-ABC123');
    expect(h.last.queryParameters, {'phone': '0770'});
    expect(h.last.headers['X-Guest-Token'], FakeTokenStorage.guest);

    h.reply('GET', 'bookings/BK-AB12', {'success': true, 'data': booking()});
    final b = await h.container.read(reservationRepositoryProvider).trackBooking('BK-AB12', '0770');
    expect(b.reference, 'BK-AB12');
    expect(h.last.queryParameters, {'phone': '0770'});
  });

  test('track 404 is a DioException with status 404', () async {
    h.reply('GET', 'orders/NOPE', {'success': false, 'message': 'nf'}, status: 404);
    expect(
      h.container.read(ordersRepositoryProvider).trackOrder('NOPE', '1'),
      throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'status', 404)),
    );
  });

  test('public settings parse contact fields', () {
    final s = PublicSettings.fromJson({
      'site_phone': ' +964 ', 'site_email': 'a@b.iq', 'address': 'Basra',
      'whatsapp_url': 'https://wa.me/1', 'whatsapp_button_enabled': '1',
    });
    expect([s.sitePhone, s.siteEmail, s.address, s.showWhatsapp], ['+964', 'a@b.iq', 'Basra', true]);
  });
}
