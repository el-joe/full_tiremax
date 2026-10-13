import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

/// Base URL for the API. Overridable at build time with
/// `--dart-define=API_BASE_URL=https://api.tiremaxiq.com/api/v1`.
///
/// Must end with a trailing slash: Dio resolves relative request paths
/// (e.g. `'home'`, `'products'`) against [apiBaseUrl] using standard URI
/// resolution, which replaces the last path segment when there's no
/// trailing slash (`.../api/v1` + `home` -> `.../api/home`, silently
/// dropping `v1` and 404ing on every endpoint). Normalizing here makes this
/// safe regardless of how `API_BASE_URL` is passed at build time.
const String _rawApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.tiremaxiq.com/api/v1',
);

final String apiBaseUrl = _rawApiBaseUrl.endsWith('/')
    ? _rawApiBaseUrl
    : '$_rawApiBaseUrl/';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

/// Mirror of `frontend/utils/axiosInstance.ts`'s `isProtectedEndpoint`: only
/// these calls need a signed-in customer; everything else is guest-capable and
/// must never bounce a guest to the login sheet on a 401.
const List<String> _protectedSegments = ['addresses', 'favorites', 'notifications', 'reviews', 'auth/me'];

bool isProtectedEndpoint(String? url, [String? method]) {
  final path = (url ?? '').split('?').first.replaceAll(RegExp(r'^/+|/+$'), '');
  if ((method ?? 'get').toLowerCase() == 'get' && (path == 'orders' || path == 'bookings')) {
    return true;
  }
  return _protectedSegments.any((s) => path == s || path.startsWith('$s/'));
}

/// Broadcasts whenever the API client receives a 401 response, so the
/// app-level router (or any listener) can react by redirecting to Home and
/// opening the auth sheet.
class UnauthorizedNotifier extends Notifier<int> {
  @override
  int build() => 0;

  /// Bumps the counter, notifying listeners a 401 occurred.
  void notify() => state++;
}

final unauthorizedNotifierProvider =
    NotifierProvider<UnauthorizedNotifier, int>(UnauthorizedNotifier.new);

/// Provides a configured [Dio] instance for talking to the TireMax API.
final apiClientProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStorage.readToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        options.headers['X-Guest-Token'] =
            await tokenStorage.getOrCreateGuestToken();

        final locale = ref.read(localeProvider);
        options.headers['x-locale'] = locale.languageCode;
        options.headers['Accept-Language'] = locale.languageCode;

        handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Web: guests hitting guest-capable endpoints are never bounced.
          // We only drop the session when the call needs auth, or when a
          // stored token was rejected (expired/revoked) - otherwise a stale
          // token would leave the app "logged in" with every call failing.
          final hadToken = (error.requestOptions.headers['Authorization'] as String?)?.isNotEmpty ?? false;
          final path = error.requestOptions.path.replaceFirst(apiBaseUrl, '');
          if (hadToken || isProtectedEndpoint(path, error.requestOptions.method)) {
            await tokenStorage.clearAll();
            ref.read(unauthorizedNotifierProvider.notifier).notify();
          }
        }
        handler.next(
          error.copyWith(error: ApiException.fromDioException(error)),
        );
      },
    ),
  );

  return dio;
});
