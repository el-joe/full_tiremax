import 'package:dio/dio.dart';
import '../utils/format.dart';

/// A typed exception wrapping a [DioException] with a human-readable
/// message, mirroring Laravel's standard validation error shape:
/// `{ "message": "...", "errors": { "field": ["..."] } }`.
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
    this.cause,
  });

  /// Builds an [ApiException] from a raw [DioException], parsing the
  /// Laravel-style error payload when present.
  factory ApiException.fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String? message;
    Map<String, List<String>>? errors;

    if (data is Map<String, dynamic>) {
      final rawMessage = data['message'];
      if (rawMessage is String && rawMessage.isNotEmpty) {
        message = rawMessage;
      }

      final rawErrors = data['errors'];
      if (rawErrors is Map) {
        errors = rawErrors.map((key, value) {
          final messages = value is List
              ? value.map((e) => e.toString()).toList()
              : <String>[value.toString()];
          return MapEntry(key.toString(), messages);
        });
        // Prefer the first field error as the headline message when the
        // top-level message is generic/missing.
        if (message == null && errors.isNotEmpty) {
          message = errors.values.first.first;
        }
      }
    }

    message ??= _fallbackMessage(error);

    return ApiException(
      message: message,
      statusCode: statusCode,
      errors: errors,
      cause: error,
    );
  }

  final String message;
  final int? statusCode;
  final Map<String, List<String>>? errors;
  final Object? cause;

  bool get isUnauthorized => statusCode == 401;
  bool get isValidationError => statusCode == 422;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => (statusCode ?? 0) >= 500;

  static String _fallbackMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return currentL10n.errTimeout;
      case DioExceptionType.connectionError:
        return currentL10n.errConnection;
      case DioExceptionType.cancel:
        return currentL10n.errCancelled;
      case DioExceptionType.badCertificate:
        return currentL10n.errBadCertificate;
      case DioExceptionType.badResponse:
        return currentL10n.errSomethingWrongTryAgain;
      case DioExceptionType.unknown:
        return error.message ?? currentL10n.errUnexpected;
      default:
        return error.message ?? currentL10n.errUnexpected;
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
