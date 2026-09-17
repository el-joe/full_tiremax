import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the auth token and cached customer profile JSON.
///
/// Mirrors the web app's storage strategy:
/// - auth token -> `tiremax_token` cookie (here: flutter_secure_storage)
/// - customer profile -> `localStorage.customerInfo` (here: shared_preferences)
class TokenStorage {
  TokenStorage({
    FlutterSecureStorage? secureStorage,
    SharedPreferencesAsync? preferences,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _preferences = preferences ?? SharedPreferencesAsync();

  static const String _tokenKey = 'tiremax_token';
  static const String _customerInfoKey = 'customerInfo';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferencesAsync _preferences;

  Future<String?> readToken() => _secureStorage.read(key: _tokenKey);

  Future<void> saveToken(String token) =>
      _secureStorage.write(key: _tokenKey, value: token);

  Future<void> deleteToken() => _secureStorage.delete(key: _tokenKey);

  /// Reads the cached customer profile JSON (decoded), or null if absent.
  Future<Map<String, dynamic>?> readCustomerInfo() async {
    final raw = await _preferences.getString(_customerInfoKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCustomerInfo(Map<String, dynamic> profile) =>
      _preferences.setString(_customerInfoKey, jsonEncode(profile));

  Future<void> deleteCustomerInfo() => _preferences.remove(_customerInfoKey);

  /// Clears both the token and the cached profile (used on logout / 401).
  Future<void> clearAll() async {
    await Future.wait([deleteToken(), deleteCustomerInfo()]);
  }
}
