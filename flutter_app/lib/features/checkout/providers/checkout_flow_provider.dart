import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
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
  final bool isSubmitting;
  final String? submitError;
  final Order? order;

  bool get isValid {
    if (paymentMethod == null || paymentMethod!.isEmpty) return false;
    if (type == OrderType.basra) return branchId != null;
    return governorateId != null && shippingAddress.trim().length >= 12;
  }

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

  /// Submits the order. Returns the created [Order] id on success, or null
  /// on failure (with [CheckoutFormState.submitError] set).
  Future<int?> submit() async {
    if (!state.isValid) {
      state = state.copyWith(submitError: 'Please fill in all required fields.');
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
        notes: state.notes,
        governorateId: state.governorateId,
        shippingAddress: state.shippingAddress,
        branchId: state.branchId,
      );
      state = state.copyWith(isSubmitting: false, order: order);
      return order.id;
    } on DioException catch (e) {
      final error = e.error;
      final message = error is ApiException ? error.message : e.message ?? 'Could not place order.';
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
