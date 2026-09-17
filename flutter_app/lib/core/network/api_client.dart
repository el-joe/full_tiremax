import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

/// Base URL for the API. Overridable at build time with
/// `--dart-define=API_BASE_URL=https://api.tiremaxiq.com/api/v1`.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.tiremaxiq.com/api/v1',
);

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

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

        final locale = ref.read(localeProvider);
        options.headers['x-locale'] = locale.languageCode;

        handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          await tokenStorage.clearAll();
          ref.read(unauthorizedNotifierProvider.notifier).notify();
        }
        handler.next(
          error.copyWith(error: ApiException.fromDioException(error)),
        );
      },
    ),
  );

  return dio;
});
