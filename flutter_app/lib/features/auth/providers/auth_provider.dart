import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../profile/models/customer_profile.dart';
import '../data/auth_repository.dart';

/// Auth state, mirroring `useAuth`'s `{ customer, isLogged }`.
class AuthState {
  const AuthState({this.customer});

  final CustomerProfile? customer;

  bool get isLoggedIn => customer != null;

  AuthState copyWith({CustomerProfile? customer, bool clearCustomer = false}) {
    return AuthState(
      customer: clearCustomer ? null : (customer ?? this.customer),
    );
  }
}

/// Async notifier hydrated from storage on app start (mirrors `useAuth`'s
/// initial state derived from `localStorage.customerInfo` + the
/// `tiremax_token` cookie).
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // React to 401s from the API client by clearing local auth state.
    ref.listen<int>(unauthorizedNotifierProvider, (previous, next) {
      if (previous != null && next != previous) {
        state = const AsyncData(AuthState());
      }
    });

    final tokenStorage = ref.watch(tokenStorageProvider);
    final token = await tokenStorage.readToken();
    final profileJson = await tokenStorage.readCustomerInfo();

    if (token == null || token.isEmpty || profileJson == null) {
      // Mirrors useAuth's cleanup effect: if either half is missing, clear
      // both so state is consistent.
      await tokenStorage.clearAll();
      return const AuthState();
    }

    try {
      return AuthState(customer: CustomerProfile.fromJson(profileJson));
    } catch (_) {
      await tokenStorage.clearAll();
      return const AuthState();
    }
  }

  Future<AuthResult> login({required String login, required String password}) async {
    final previous = state.value ?? const AuthState();
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    try {
      final result = await repository.login(login: login, password: password);
      state = AsyncData(AuthState(customer: result.customer));
      return result;
    } on ApiException {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<AuthResult> register({
    required String name,
    required String phone,
    String? email,
    required String password,
    required String passwordConfirmation,
    String? address,
    String? locale,
  }) async {
    final previous = state.value ?? const AuthState();
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    try {
      final result = await repository.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        address: address,
        locale: locale,
      );
      state = AsyncData(AuthState(customer: result.customer));
      return result;
    } on ApiException {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? locale,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    final customer = await repository.updateMe(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      locale: locale,
    );
    state = AsyncData(AuthState(customer: customer));
  }

  Future<void> logout() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    await tokenStorage.clearAll();
    state = const AsyncData(AuthState());
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Convenience provider mirroring `useAuth().isLogged` — false while the
/// initial hydration is still loading.
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).value?.isLoggedIn ?? false;
});

/// Convenience provider mirroring `useAuth().customer`.
final customerProvider = Provider<CustomerProfile?>((ref) {
  return ref.watch(authProvider).value?.customer;
});
