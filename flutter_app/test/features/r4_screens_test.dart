import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/city.dart';
import 'package:flutter_app/core/models/governorate.dart';
import 'package:flutter_app/features/addresses/models/address.dart';
import 'package:flutter_app/features/addresses/presentation/addresses_screen.dart';
import 'package:flutter_app/features/addresses/providers/addresses_provider.dart';
import 'package:flutter_app/features/auth/presentation/auth_sheet.dart';
import 'package:flutter_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_app/features/contact/presentation/contact_screen.dart';
import 'package:flutter_app/features/favorites/models/customer_fav.dart';
import 'package:flutter_app/features/favorites/presentation/favorites_screen.dart';
import 'package:flutter_app/features/favorites/providers/favorites_list_provider.dart';
import 'package:flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:flutter_app/features/notifications/models/notification.dart';
import 'package:flutter_app/features/notifications/presentation/notifications_screen.dart';
import 'package:flutter_app/features/notifications/providers/notifications_provider.dart';
import 'package:flutter_app/features/orders/data/orders_repository.dart';
import 'package:flutter_app/features/orders/models/order.dart';
import 'package:flutter_app/features/orders/presentation/order_detail_screen.dart';
import 'package:flutter_app/features/orders/presentation/orders_screen.dart';
import 'package:flutter_app/features/orders/providers/orders_provider.dart';
import 'package:flutter_app/features/profile/models/customer_profile.dart';
import 'package:flutter_app/features/profile/presentation/legal_screens.dart';
import 'package:flutter_app/features/profile/presentation/profile_home_screen.dart';
import 'package:flutter_app/features/profile/presentation/profile_settings_screen.dart';
import 'package:flutter_app/features/reservation/data/reservation_repository.dart';
import 'package:flutter_app/features/reservation/models/reservation.dart';
import 'package:flutter_app/features/reservation/presentation/profile_reservation_detail_screen.dart';
import 'package:flutter_app/features/reservation/presentation/profile_reservations_screen.dart';
import 'package:flutter_app/features/settings/data/public_settings_repository.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

const _customer = CustomerProfile(
  id: 1,
  name: 'Ali Hassan',
  email: 'ali@example.com',
  phone: '07700000000',
  address: 'Basra',
  locale: 'ar',
);

Order _order({String status = 'pending', String type = 'delivery'}) => Order(
  id: 7,
  reference: 'ORD-12345',
  type: type,
  status: status,
  payment_method: 'cash',
  payment_status: 'pending',
  subtotal: 600000,
  discount: 10000,
  shipping_fee: 5000,
  installation_fee: 0,
  total: 595000,
  customer_name: 'Ali',
  customer_phone: '07700000000',
  shipping_address:
      'Basra, Street 1 with a rather long address line to test wrapping',
  placed_at: '2030-01-01T10:00:00Z',
  items: [
    for (var i = 0; i < 3; i++)
      OrderItem(
        id: i,
        product_id: 1,
        product_name: 'Michelin Pilot Sport 4 SUV 255/45 R20 105Y XL',
        product_sku: 'SKU$i',
        quantity: 2,
        unit_price: 100000,
        total: 200000,
      ),
  ],
);

Reservation _booking({String status = 'confirmed'}) => Reservation(
  id: 3,
  reference: 'BK-1',
  scheduled_at: DateTime(2030, 1, 1, 10),
  duration_minutes: 45,
  status: status,
  customer_notes: 'Please call me before arriving at the branch',
  branch: const ReservationBranch(
    id: 1,
    code: 'B1',
    name: 'Basra main branch with a long name',
    address: 'Basra, Industrial Street, near the big roundabout',
    phone: '07700000001',
  ),
  service: const ReservationService(
    id: 2,
    slug: 'install',
    name: 'Tire installation and balancing',
    duration_minutes: 45,
    price: 25000,
  ),
);

const _address = Address(
  id: 1,
  full_name: 'Ali Hassan',
  phone: '07700000000',
  governorate: Governorate(
    id: 1,
    code: 'BAS',
    name: 'Basra',
    is_basra: true,
    shipping_fee: 5000,
  ),
  city: City(id: 1, name_ar: 'البصرة القديمة', name_en: 'Old Basra'),
  address: 'Street 12, building 4, near the long named landmark',
  is_default: true,
);

class _FakeAddresses extends AddressesNotifier {
  _FakeAddresses(this.list);
  final List<Address> list;
  @override
  Future<List<Address>> build() async => list;
  @override
  Future<void> refresh() async {}
}

class _FakeFavs extends FavoritesListNotifier {
  _FakeFavs(this.list);
  final List<CustomerFav> list;
  @override
  Future<List<CustomerFav>> build() async {
    ref.read(favoritesProvider.notifier).syncIds(list.map((f) => f.id));
    return list;
  }
}

class _FakeNotifs extends NotificationsListNotifier {
  _FakeNotifs(this.list);
  final List<AppNotification> list;
  @override
  Future<List<AppNotification>> build() async => list;
  @override
  Future<void> refresh() async {}
}

List<AppNotification> _notifs() => [
  AppNotification(
    id: 'a',
    type: 'order',
    data: const NotificationData(
      title: 'Your order is on the way, please be ready',
      body: 'Order ORD-12345 left the warehouse and is arriving today',
    ),
    created_at: DateTime.now(),
  ),
  AppNotification(
    id: 'b',
    type: 'order',
    data: const NotificationData(
      title: 'Order delivered',
      body: 'Thanks for shopping with us',
    ),
    read_at: '2030-01-01T10:00:00Z',
    created_at: DateTime(2020, 1, 1),
  ),
];

CustomerFav _fav(int id) => CustomerFav(
  id: id,
  sku: 'S$id',
  name: 'Michelin Pilot Sport 4 SUV 255/45 R20 105Y XL',
  price: 100000,
  has_discount: false,
  in_stock: true,
  is_featured: false,
  brand: const CustomerFavBrand(id: 1, slug: 'michelin', name: 'Michelin'),
);

Future<void> _pump(
  WidgetTester tester,
  Widget home, {
  required bool rtl,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
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
  await tester.pump(const Duration(milliseconds: 600));
}

Future<void> _scroll(WidgetTester tester) async {
  final list = find.byType(Scrollable);
  if (list.evaluate().isEmpty) return;
  await tester.drag(list.first, const Offset(0, -1500));
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  for (final rtl in [false, true]) {
    final tag = rtl ? 'RTL' : 'LTR';

    testWidgets('Profile home fits ($tag)', (tester) async {
      await _pump(
        tester,
        const ProfileHomeScreen(),
        rtl: rtl,
        overrides: [customerProvider.overrideWithValue(_customer)],
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Ali Hassan'), findsOneWidget);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Profile settings fits ($tag)', (tester) async {
      await _pump(
        tester,
        const ProfileSettingsScreen(),
        rtl: rtl,
        overrides: [customerProvider.overrideWithValue(_customer)],
      );
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Addresses list + form sheet ($tag)', (tester) async {
      await _pump(
        tester,
        const AddressesScreen(),
        rtl: rtl,
        overrides: [
          addressesProvider.overrideWith(
            () => _FakeAddresses([
              _address,
              _address.copyWith(id: 2, is_default: false),
            ]),
          ),
        ],
      );
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Addresses empty ($tag)', (tester) async {
      await _pump(
        tester,
        const AddressesScreen(),
        rtl: rtl,
        overrides: [
          addressesProvider.overrideWith(() => _FakeAddresses(const [])),
        ],
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Orders list fits ($tag)', (tester) async {
      await _pump(
        tester,
        const OrdersScreen(),
        rtl: rtl,
        overrides: [
          ordersListProvider.overrideWith(
            (ref, key) async =>
                PagedResult([_order(), _order(status: 'delivered')], null),
          ),
        ],
      );
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Orders empty ($tag)', (tester) async {
      await _pump(
        tester,
        const OrdersScreen(),
        rtl: rtl,
        overrides: [
          ordersListProvider.overrideWith(
            (ref, key) async => PagedResult(<Order>[], null),
          ),
        ],
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Order detail fits ($tag)', (tester) async {
      for (final o in [
        _order(),
        _order(status: 'cancelled'),
        _order(type: 'basra', status: 'processing'),
      ]) {
        await _pump(
          tester,
          OrderDetailScreen(orderId: 7),
          rtl: rtl,
          overrides: [orderDetailProvider(7).overrideWith((ref) async => o)],
        );
        expect(tester.takeException(), isNull);
        await _scroll(tester);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Reservations list fits ($tag)', (tester) async {
      await _pump(
        tester,
        const ProfileReservationsScreen(),
        rtl: rtl,
        overrides: [
          bookingsListProvider.overrideWith(
            (ref, page) async =>
                PagedResult([_booking(), _booking(status: 'cancelled')], null),
          ),
        ],
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(rtl ? 'القادمة' : 'Upcoming').first);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Reservation detail fits ($tag)', (tester) async {
      await _pump(
        tester,
        const ProfileReservationDetailScreen(reservationId: 3),
        rtl: rtl,
        overrides: [
          bookingDetailProvider(3).overrideWith((ref) async => _booking()),
        ],
      );
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Favorites grid + empty ($tag)', (tester) async {
      await _pump(
        tester,
        const FavoritesScreen(),
        rtl: rtl,
        overrides: [
          favoritesListProvider.overrideWith(
            () => _FakeFavs([_fav(1), _fav(2)]),
          ),
        ],
      );
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
      await _pump(
        tester,
        const FavoritesScreen(),
        rtl: rtl,
        overrides: [
          favoritesListProvider.overrideWith(() => _FakeFavs(const [])),
        ],
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Notifications grouped, swipe + tap ($tag)', (tester) async {
      await _pump(
        tester,
        const NotificationsScreen(),
        rtl: rtl,
        overrides: [
          notificationsListProvider.overrideWith(() => _FakeNotifs(_notifs())),
        ],
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('unread-dot')), findsOneWidget);
      expect(find.byType(Dismissible), findsOneWidget);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Contact fits ($tag)', (tester) async {
      await _pump(
        tester,
        const ContactScreen(),
        rtl: rtl,
        overrides: [
          publicSettingsProvider.overrideWith(
            (ref) async => const PublicSettings(
              sitePhone: '+9647700000000',
              siteEmail: 'info@example.com',
              address: 'Basra, a long head office address line',
            ),
          ),
        ],
      );
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Legal screens fit ($tag)', (tester) async {
      await _pump(tester, const PrivacyPolicyScreen(), rtl: rtl);
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
      await _pump(tester, const TermsAndConditionsScreen(), rtl: rtl);
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Auth sheet login/register + inline errors ($tag)', (
      tester,
    ) async {
      await _pump(tester, const Scaffold(body: AuthSheet()), rtl: rtl);
      expect(tester.takeException(), isNull);
      final submit = find.byType(ElevatedButton);
      await tester.ensureVisible(submit.first);
      await tester.tap(submit.first);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.error_outline), findsNothing);
      await tester.tap(find.text(rtl ? 'إنشاء حساب' : 'Register').first);
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);
      await _scroll(tester);
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });
  }
}
