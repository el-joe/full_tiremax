import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'dart:ui' show Locale;

import 'package:flutter_app/core/network/api_client.dart';
import 'package:flutter_app/core/providers/locale_provider.dart';
import 'package:flutter_app/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// In-memory [TokenStorage] so tests never touch secure storage / prefs.
class FakeTokenStorage extends TokenStorage {
  FakeTokenStorage({this.token});
  String? token;
  Map<String, dynamic>? customer;
  static const guest = 'guest-token-0123456789abcdef';

  @override
  Future<String?> readToken() async => token;
  @override
  Future<void> saveToken(String t) async => token = t;
  @override
  Future<void> deleteToken() async => token = null;
  @override
  Future<String> getOrCreateGuestToken() async => guest;
  @override
  Future<void> clearGuestToken() async {}
  @override
  Future<void> saveCustomerInfo(Map<String, dynamic> p) async => customer = p;
  @override
  Future<Map<String, dynamic>?> readCustomerInfo() async => customer;
  @override
  Future<void> deleteCustomerInfo() async => customer = null;
  @override
  Future<void> clearAll() async {
    token = null;
    customer = null;
  }
}

/// Loads a JSON fixture from test/fixtures (real API captures or Postman-shaped).
dynamic fixture(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync());

class Harness {
  Harness({String? token}) {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    storage = FakeTokenStorage(token: token);
    container = ProviderContainer(
      overrides: [tokenStorageProvider.overrideWithValue(storage)],
    );
    // The app defaults to Arabic; contract tests assert English headers.
    container.read(localeProvider.notifier).setLocale(const Locale('en'));
    dio = container.read(apiClientProvider);
    adapter = DioAdapter(
      dio: dio,
      matcher: const UrlRequestMatcher(matchMethod: true),
    );
    // Added after the app interceptor, so it observes the final headers.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          requests.add(o);
          h.next(o);
        },
      ),
    );
  }

  late final FakeTokenStorage storage;
  late final ProviderContainer container;
  late final Dio dio;
  late final DioAdapter adapter;
  final List<RequestOptions> requests = [];

  RequestOptions get last => requests.last;

  Future<void> setLocale(String code) =>
      container.read(localeProvider.notifier).setLocale(Locale(code));

  /// Registers a canned reply for [method] [path] (relative to the API base URL).
  void reply(String method, String path, dynamic body, {int status = 200}) {
    void handler(dynamic server) => server.reply(status, body);
    switch (method) {
      case 'GET':
        adapter.onGet(path, handler);
      case 'POST':
        adapter.onPost(path, handler);
      case 'PUT':
        adapter.onPut(path, handler);
      case 'DELETE':
        adapter.onDelete(path, handler);
      default:
        throw ArgumentError(method);
    }
  }

  void dispose() => container.dispose();
}
