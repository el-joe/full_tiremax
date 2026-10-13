import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/network/api_client.dart';
import 'package:flutter_app/core/router/app_router.dart';
import 'package:flutter_app/core/utils/format.dart';
import 'package:flutter_app/features/addresses/data/addresses_repository.dart';
import 'package:flutter_app/features/profile/presentation/legal_screens.dart';
import 'package:flutter_app/features/reservation/data/reservation_repository.dart';
import 'package:flutter_app/shared/widgets/status_badge.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  group('401 handling (axiosInstance.isProtectedEndpoint)', () {
    test('protected endpoints', () {
      expect(isProtectedEndpoint('addresses'), isTrue);
      expect(isProtectedEndpoint('addresses/3/set-default', 'POST'), isTrue);
      expect(isProtectedEndpoint('favorites/4/toggle', 'POST'), isTrue);
      expect(isProtectedEndpoint('notifications/unread-count'), isTrue);
      expect(isProtectedEndpoint('auth/me', 'PUT'), isTrue);
      expect(isProtectedEndpoint('orders?page=1', 'GET'), isTrue);
      expect(isProtectedEndpoint('bookings', 'GET'), isTrue);
    });
    test('guest-capable endpoints', () {
      expect(isProtectedEndpoint('orders', 'POST'), isFalse);
      expect(isProtectedEndpoint('bookings', 'POST'), isFalse);
      expect(isProtectedEndpoint('cart'), isFalse);
      expect(isProtectedEndpoint('auth/login', 'POST'), isFalse);
      expect(isProtectedEndpoint('products'), isFalse);
    });

    test('401 on a guest-capable call without a token keeps state', () async {
      final h = Harness();
      addTearDown(h.dispose);
      h.reply('POST', 'auth/login', {'message': 'Invalid credentials'}, status: 401);
      await expectLater(h.dio.post('auth/login', data: {}), throwsA(anything));
      expect(h.container.read(unauthorizedNotifierProvider), 0);
    });

    test('401 with a stored token clears it and notifies', () async {
      final h = Harness(token: 'abc');
      addTearDown(h.dispose);
      h.storage.customer = {'id': 1};
      h.reply('GET', 'cart', {'message': 'Unauthenticated.'}, status: 401);
      await expectLater(h.dio.get('cart'), throwsA(anything));
      expect(h.storage.token, isNull);
      expect(h.storage.customer, isNull);
      expect(h.container.read(unauthorizedNotifierProvider), 1);
    });

    test('requests carry Accept-Language like the web', () async {
      final h = Harness();
      addTearDown(h.dispose);
      h.reply('GET', 'cart', {'data': {}});
      await h.dio.get('cart');
      expect(h.last.headers['Accept-Language'], 'en');
      expect(h.last.headers['x-locale'], 'en');
    });
  });

  group('middleware parity', () {
    test('protected paths include checkout', () {
      for (final p in ['/profile', '/profile/orders/3', '/favorites', '/notifications', '/checkout']) {
        expect(isProtectedPath(p), isTrue, reason: p);
      }
      expect(isProtectedPath('/store'), isFalse);
      expect(isProtectedPath('/cart'), isFalse);
    });
    test('guest email links go to track-order', () {
      expect(guestTrackingRedirect(Uri.parse('/profile/orders/ORD-1?phone=0770')),
          '/track-order?type=order&reference=ORD-1&phone=0770');
      expect(guestTrackingRedirect(Uri.parse('/profile/bookings')), '/track-order?type=booking');
      expect(guestTrackingRedirect(Uri.parse('/profile/reservations/BKG-9')),
          '/track-order?type=booking&reference=BKG-9');
      expect(guestTrackingRedirect(Uri.parse('/profile/orders')), isNull);
      expect(guestTrackingRedirect(Uri.parse('/profile/settings')), isNull);
    });
  });

  group('status badges use the web colours', () {
    test('order list / detail', () {
      expect(statusBadgeColors(StatusBadgeKind.orderList, 'delivered'), (const Color(0xFF1447E6), const Color(0xFFDBEAFE)));
      expect(statusBadgeColors(StatusBadgeKind.orderDetail, 'processing').$2, const Color(0x33FFB800));
    });
    test('booking list / detail', () {
      expect(statusBadgeColors(StatusBadgeKind.bookingList, 'complete').$1, const Color(0xFF71717A));
      expect(statusBadgeColors(StatusBadgeKind.bookingList, 'confirmed').$2, const Color(0xFFDBEAFE));
      expect(statusBadgeColors(StatusBadgeKind.bookingDetail, 'cancelled'), (const Color(0xFFE7000B), const Color(0xFFFFE2E2)));
      expect(statusBadgeColors(StatusBadgeKind.bookingDetail, 'confirmed').$2, const Color(0x33FFB800));
    });
  });

  test('formatTimeRange matches helpers/formatTimeRange.ts', () {
    expect(formatTimeRange('09:00:00', '22:30:00'), '9:00 AM - 10:30 PM');
    expect(formatTimeRange('00:00:00', '12:00:00'), '12:00 AM - 12:00 PM');
    expect(formatTimeRange(null, '10:00'), isNull);
  });

  test('address create omits empty optional fields, sends ids', () async {
    final h = Harness(token: 't');
    addTearDown(h.dispose);
    h.reply('POST', 'addresses', {
      'data': {
        'id': 1, 'full_name': 'A', 'phone': '1', 'is_default': false, 'address': 'Street number 12',
        'governorate': {'id': 1, 'code': 'B', 'name': 'Basra', 'is_basra': true, 'shipping_fee': 0},
        'city': {'id': 2, 'name_ar': 'x', 'name_en': 'y'},
      }
    }, status: 201);
    await h.container.read(addressesRepositoryProvider).createAddress(
        governorateId: 1, cityId: 2, address: 'Street number 12', fullName: 'A');
    expect(h.last.data, {'full_name': 'A', 'governorate_id': 1, 'city_id': 2, 'address': 'Street number 12'});
  });

  test('legal copy equals frontend/locale/en.json', () {
    final file = File('../frontend/locale/en.json');
    if (!file.existsSync()) return;
    final en = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final arb = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync()) as Map<String, dynamic>;
    final values = arb.values.whereType<String>().toSet();
    final privacy = en['privacyPolicy'] as Map<String, dynamic>;
    final terms = en['termsAndConditions'] as Map<String, dynamic>;
    bool has(String s) => values.contains(s.trim());
    for (final k in [
      'privacyPolicyDescription', 'dataCollection', 'dataCollectionDescription', 'personalInformation',
      'vehicleData', 'paymentInformation', 'locationData', 'howWeUseInformation',
      'howWeUseInformationDescription', 'dataProtection', 'dataProtectionDescription', 'userRights',
      'userRightsDescription', 'havePrivacyQuestions', 'havePrivacyQuestionsDescription', 'contactUs',
    ]) {
      expect(has(privacy[k] as String), isTrue, reason: 'privacy.$k');
    }
    for (final k in [
      'termsAndConditionsDescription', 'introductionParagraph1', 'introductionParagraph2', 'informationAccuracy',
      'informationAccuracyDescription', 'accountSecurity', 'accountSecurityDescription',
      'purchasesAndPaymentsParagraph1', 'purchasesAndPaymentsParagraph2', 'purchasesAndPaymentsParagraph3',
      'warrantiesDescription', 'trafficAccidents', 'misuse', 'incorrectInstallation', 'improperStorage',
      'limitationOfLiabilityParagraph1', 'limitationOfLiabilityParagraph2', 'lastUpdated',
    ]) {
      expect(has(terms[k] as String), isTrue, reason: 'terms.$k');
    }
    // Screens still exported.
    expect(const PrivacyPolicyScreen(), isA<Widget>());
    expect(const TermsAndConditionsScreen(), isA<Widget>());
  });

  test('reservation provider import sanity', () {
    expect(bookingsListProvider, isNotNull);
  });
}
