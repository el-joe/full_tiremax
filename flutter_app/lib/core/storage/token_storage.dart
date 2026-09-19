import 'dart:convert';
import 'dart:math';

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

  static const String _guestTokenKey = 'tiremax_guest_token';
  static final RegExp _guestTokenPattern = RegExp(r'^[A-Za-z0-9_-]{16,64}$');
  String? _guestTokenCache;

  /// Returns the persisted guest token (UUID v4), generating and saving one
  /// on first use. Mirrors `frontend/helpers/guestToken.ts`.
  Future<String> getOrCreateGuestToken() async {
    final cached = _guestTokenCache;
    if (cached != null) return cached;
    try {
      final existing = await _preferences.getString(_guestTokenKey);
      if (existing != null && _guestTokenPattern.hasMatch(existing)) {
        return _guestTokenCache = existing;
      }
    } catch (_) {}
    final token = _generateUuid();
    _guestTokenCache = token;
    try {
      await _preferences.setString(_guestTokenKey, token);
    } catch (_) {}
    return token;
  }

  /// Forgets the guest token (after its data was linked to an account).
  Future<void> clearGuestToken() async {
    _guestTokenCache = null;
    try {
      await _preferences.remove(_guestTokenKey);
    } catch (_) {}
  }

  static String _generateUuid() {
    final rnd = Random.secure();
    final b = List<int>.generate(16, (_) => rnd.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    final h = b.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-'
        '${h.substring(16, 20)}-${h.substring(20)}';
  }

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
