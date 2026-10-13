import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/branch.dart';
import 'package:flutter_app/core/models/governorate.dart';
import 'package:flutter_app/features/cart/models/cart_item.dart';
import 'package:flutter_app/features/cart/models/cart_product.dart';
import 'package:flutter_app/features/cart/models/customer_cart.dart';
import 'package:flutter_app/features/cart/presentation/cart_screen.dart';
import 'package:flutter_app/features/cart/providers/cart_provider.dart';
import 'package:flutter_app/features/checkout/data/checkout_repository.dart';
import 'package:flutter_app/features/checkout/models/payment_method.dart';
import 'package:flutter_app/features/checkout/presentation/checkout_screen.dart';
import 'package:flutter_app/features/orders/models/order.dart';
import 'package:flutter_app/features/orders/presentation/order_confirmation_screen.dart';
import 'package:flutter_app/features/orders/presentation/track_order_screen.dart';
import 'package:flutter_app/features/orders/providers/orders_provider.dart';
import 'package:flutter_app/features/reservation/data/reservation_repository.dart';
import 'package:flutter_app/features/reservation/presentation/booking_confirmation_screen.dart';
import 'package:flutter_app/features/reservation/presentation/reservation_screen.dart';
import 'package:flutter_app/features/reservation/providers/reservation_flow_provider.dart';
import 'package:flutter_app/features/services/models/service.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _json(String f) =>
    jsonDecode(File('test/fixtures/$f').readAsStringSync())
        as Map<String, dynamic>;

CustomerCart _cart() {
  final p = _json('product.json')['data'] as Map<String, dynamic>;
  final product = CartProduct.fromJson({
    ...p,
    'short_description': p['short_description'] ?? 'desc',
    'effective_price': p['effective_price'] ?? p['price'],
  });
  final items = [
    for (var i = 1; i <= 3; i++)
      CartItem(
        id: i,
        product_id: product.id,
        product: product,
        quantity: i,
        unit_price: 100000,
        total: 100000.0 * i,
      ),
  ];
  return CustomerCart(id: 1, items: items, subtotal: 600000, items_count: 6);
}

class _FakeCart extends CartNotifier {
  _FakeCart(this.cart);
  final CustomerCart cart;
  @override
  Future<CustomerCart> build() async => cart;
  @override
  Future<void> refresh() async {}
}

Order _order({bool guest = true, String type = 'delivery'}) => Order(
  id: 7,
  reference: 'ORD-12345',
  type: type,
  status: 'pending',
  payment_method: 'cash',
  payment_status: 'pending',
  subtotal: 600000,
  discount: 0,
  shipping_fee: 5000,
  installation_fee: 0,
  total: 605000,
  customer_name: 'Ali',
  customer_phone: '07700000000',
  shipping_address:
      'Basra, Street 1 with a rather long address line to test wrapping',
  placed_at: '2030-01-01T10:00:00Z',
  is_guest: guest,
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

void main() {
  final branches = (_json('branches.json')['data'] as List)
      .map((e) => Branch.fromJson(e as Map<String, dynamic>))
      .toList();
  final services = (_json('services.json')['data'] as List)
      .map((e) => Service.fromJson(e as Map<String, dynamic>))
      .toList();
  const gov = Governorate(
    id: 1,
    code: 'BAS',
    name: 'Basra',
    is_basra: true,
    shipping_fee: 5000,
  );
  const methods = [
    PaymentMethod(
      id: 1,
      name: 'cash',
      display_name: 'Cash on delivery',
      driver: 'cash',
      is_active: true,
    ),
    PaymentMethod(
      id: 2,
      name: 'paymob',
      display_name: 'Card (Paymob)',
      driver: 'paymob',
      is_active: true,
    ),
  ];

  for (final rtl in [false, true]) {
    final tag = rtl ? 'RTL' : 'LTR';

    testWidgets('Cart fits ($tag)', (tester) async {
      await _pump(
        tester,
        const CartScreen(),
        rtl: rtl,
        overrides: [cartProvider.overrideWith(() => _FakeCart(_cart()))],
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(Dismissible), findsNWidgets(3));
      await tester.drag(find.byType(ListView).first, const Offset(0, -800));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Cart empty state ($tag)', (tester) async {
      await _pump(
        tester,
        const CartScreen(),
        rtl: rtl,
        overrides: [
          cartProvider.overrideWith(
            () => _FakeCart(
              const CustomerCart(id: 1, subtotal: 0, items_count: 0),
            ),
          ),
        ],
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(Dismissible), findsNothing);
    });

    testWidgets('Checkout fits ($tag)', (tester) async {
      await _pump(
        tester,
        const CheckoutScreen(),
        rtl: rtl,
        overrides: [
          cartProvider.overrideWith(() => _FakeCart(_cart())),
          governoratesProvider.overrideWith((ref) async => const [gov]),
          checkoutBranchesProvider.overrideWith((ref) async => branches),
          paymentMethodsProvider.overrideWith((ref) async => methods),
        ],
      );
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView).first, const Offset(0, -1500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byType(ExpansionTile).last);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.drag(find.byType(ListView).first, const Offset(0, -1500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Order confirmation fits ($tag)', (tester) async {
      await _pump(
        tester,
        const OrderConfirmationScreen(orderId: 7),
        rtl: rtl,
        overrides: [
          orderDetailProvider(7).overrideWith((ref) async => _order()),
        ],
      );
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView).first, const Offset(0, -1500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Track order fits ($tag)', (tester) async {
      await _pump(tester, const TrackOrderScreen(), rtl: rtl);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Booking confirmation fits ($tag)', (tester) async {
      await _pump(
        tester,
        BookingConfirmationScreen(
          booking: BookingResult(
            id: 1,
            status: 'pending',
            scheduledAt: DateTime(2030, 1, 1, 10),
            branchName: 'Basra main branch with a long name',
            serviceName: 'Tire installation',
            reference: 'BK-1',
            customerNotes: 'Please call me before',
          ),
        ),
        rtl: rtl,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Reservation flow steps fit ($tag)', (tester) async {
      await _pump(
        tester,
        const ReservationScreen(),
        rtl: rtl,
        overrides: [
          reservationServicesProvider.overrideWith((ref) async => services),
          reservationBranchesProvider.overrideWith((ref) async => branches),
          reservationRepositoryProvider.overrideWithValue(_FakeRepo()),
        ],
      );
      expect(tester.takeException(), isNull);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ReservationScreen)),
      );
      final n = container.read(reservationFlowProvider.notifier);

      n.setService(services.first);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      n.setBranch(branches.first);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      final d = DateTime.now().add(const Duration(days: 2));
      await n.setDate(
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      n.setTime('10:00');
      await tester.pump();
      n.goNext();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView).first, const Offset(0, -1000));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });
  }
}

class _FakeRepo implements ReservationRepository {
  @override
  Future<List<TimeSlot>> fetchAvailableSlots({
    required int branchId,
    required String date,
  }) async => [
    for (final t in [
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '12:00',
      '12:30',
    ])
      TimeSlot(time: t, available: t != '09:30'),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
