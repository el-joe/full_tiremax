import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/format.dart';
import '../../cart/providers/cart_provider.dart';
import '../../orders/models/order.dart';
import '../data/checkout_repository.dart';

/// "delivery" (shipped to an address) or "basra" (branch pickup), mirroring
/// `CreateOrderInput['type']`.
enum OrderType { delivery, basra }

extension OrderTypeApi on OrderType {
  String get apiValue => this == OrderType.delivery ? 'delivery' : 'basra';
}

class CheckoutFormState {
  const CheckoutFormState({
    this.type = OrderType.delivery,
    this.governorateId,
    this.shippingAddress = '',
    this.branchId,
    this.paymentMethod,
    this.customerName = '',
    this.customerPhone = '',
    this.customerEmail = '',
    this.notes = '',
    this.createAccount = false,
    this.password = '',
    this.isSubmitting = false,
    this.submitError,
    this.order,
  });

  final OrderType type;
  final int? governorateId;
  final String shippingAddress;
  final int? branchId;
  final String? paymentMethod;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String notes;
  final bool createAccount;
  final String password;
  final bool isSubmitting;
  final String? submitError;
  final Order? order;

  /// Field -> error message, mirroring `createOrderSchemas.ts`
  /// (`isLogged` skips the account-creation password rule).
  Map<String, String> validate() {
    final e = <String, String>{};
    if (customerName.trim().isEmpty) {
      e['name'] = 'Full name is required';
    } else if (customerName.trim().length > 120) {
      e['name'] = 'Name must be 120 characters or fewer';
    }
    if (customerPhone.trim().isEmpty) {
      e['phone'] = 'Phone number is required';
    } else if (customerPhone.trim().length > 20) {
      e['phone'] = 'Phone number must be 20 characters or fewer';
    } else if (!isValidIraqiPhone(customerPhone.trim())) {
      e['phone'] = 'Enter a valid Iraqi phone number (e.g. 07701234567)';
    }
    final email = customerEmail.trim();
    if (email.isNotEmpty) {
      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
        e['email'] = 'Invalid email address';
      } else if (email.length > 120) {
        e['email'] = 'Email must be 120 characters or fewer';
      }
    }
    if (notes.length > 500) e['notes'] = 'Notes must be 500 characters or fewer';
    if (paymentMethod == null || paymentMethod!.isEmpty) e['payment'] = 'Payment method selection is required';
    if (type == OrderType.basra) {
      if (branchId == null) e['branch'] = 'Please select a branch';
    } else {
      if (governorateId == null) e['governorate'] = 'Select governorate is required';
      final addr = shippingAddress.trim();
      if (addr.isEmpty) {
        e['address'] = 'The address is required';
      } else if (addr.length > 255) {
        e['address'] = 'The address must be less than 255 characters';
      } else if (addr.length <= 12) {
        e['address'] = 'The address must be more then 12 character';
      }
    }
    if (createAccount && password.length < 6) e['password'] = 'Password must be at least 6 characters';
    return e;
  }

  bool get isValid => validate().isEmpty;

  CheckoutFormState copyWith({
    OrderType? type,
    int? governorateId,
    bool clearGovernorateId = false,
    String? shippingAddress,
    int? branchId,
    bool clearBranchId = false,
    String? paymentMethod,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? notes,
    bool? createAccount,
    String? password,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Order? order,
  }) {
    return CheckoutFormState(
      type: type ?? this.type,
      governorateId: clearGovernorateId ? null : (governorateId ?? this.governorateId),
      shippingAddress: shippingAddress ?? this.shippingAddress,
      branchId: clearBranchId ? null : (branchId ?? this.branchId),
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      notes: notes ?? this.notes,
      createAccount: createAccount ?? this.createAccount,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      order: order ?? this.order,
    );
  }
}

/// Drives the checkout form + order submission. Mirrors
/// `CheckoutForm.tsx`'s react-hook-form state and `createOrder` mutation.
class CheckoutFlowNotifier extends Notifier<CheckoutFormState> {
  @override
  CheckoutFormState build() => const CheckoutFormState();

  void setType(OrderType type) => state = state.copyWith(type: type);
  void setGovernorate(int id) => state = state.copyWith(governorateId: id);
  void setShippingAddress(String value) => state = state.copyWith(shippingAddress: value);
  void setBranch(int id) => state = state.copyWith(branchId: id);
  void setPaymentMethod(String driver) => state = state.copyWith(paymentMethod: driver);
  void setCustomerName(String value) => state = state.copyWith(customerName: value);
  void setCustomerPhone(String value) => state = state.copyWith(customerPhone: value);
  void setCustomerEmail(String value) => state = state.copyWith(customerEmail: value);
  void setNotes(String value) => state = state.copyWith(notes: value);
  void setCreateAccount(bool value) => state = state.copyWith(createAccount: value);
  void setPassword(String value) => state = state.copyWith(password: value);

  /// Submits the order. Returns the created [Order] id on success, or null
  /// on failure (with [CheckoutFormState.submitError] set).
  Future<int?> submit() async {
    if (!state.isValid) {
      state = state.copyWith(submitError: currentL10n.pleaseFillRequiredFields);
      return null;
    }
    state = state.copyWith(isSubmitting: true, clearSubmitError: true);
    try {
      final repository = ref.read(checkoutRepositoryProvider);
      final order = await repository.createOrder(
        type: state.type.apiValue,
        paymentMethod: state.paymentMethod!,
        customerName: state.customerName,
        customerPhone: state.customerPhone,
        customerEmail: state.customerEmail,
        locale: ref.read(localeProvider).languageCode,
        offerCode: ref.read(cartProvider.notifier).appliedOffer?.offer.code,
        notes: state.notes,
        governorateId: state.governorateId,
        shippingAddress: state.shippingAddress,
        branchId: state.branchId,
      );
      state = state.copyWith(isSubmitting: false, order: order);
      return order.id;
    } on DioException catch (e) {
      final error = e.error;
      final message = error is ApiException ? error.message : e.message ?? currentL10n.couldNotPlaceOrder;
      state = state.copyWith(isSubmitting: false, submitError: message);
      return null;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.toString());
      return null;
    }
  }
}

final checkoutFlowProvider = NotifierProvider<CheckoutFlowNotifier, CheckoutFormState>(
  CheckoutFlowNotifier.new,
);
