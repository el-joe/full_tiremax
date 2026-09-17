import 'package:dio/dio.dart';

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
        return 'The connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Could not connect to the server. Check your internet connection.';
      case DioExceptionType.cancel:
        return 'The request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'A secure connection could not be established.';
      case DioExceptionType.badResponse:
        return 'Something went wrong. Please try again.';
      case DioExceptionType.unknown:
        return error.message ?? 'An unexpected error occurred.';
      default:
        return error.message ?? 'An unexpected error occurred.';
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
