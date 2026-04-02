import 'package:dio/dio.dart';

sealed class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkTimeoutException extends NetworkException {
  const NetworkTimeoutException({
    this.statusCode,
    this.errorCode,
    this.responseBody,
    String message = 'Request timed out. Please try again.',
  }) : super(message);

  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? responseBody;
}

class NetworkConnectionException extends NetworkException {
  const NetworkConnectionException({
    this.statusCode,
    this.errorCode,
    this.responseBody,
    String message = 'Unable to connect to server. Please check network.',
  }) : super(message);

  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? responseBody;
}

class NetworkCancelledException extends NetworkException {
  const NetworkCancelledException({
    this.statusCode,
    this.errorCode,
    this.responseBody,
    String message = 'Request was cancelled.',
  }) : super(message);

  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? responseBody;
}

class NetworkResponseException extends NetworkException {
  const NetworkResponseException({
    this.statusCode,
    this.errorCode,
    this.responseBody,
    required String message,
  }) : super(message);

  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? responseBody;
}

class NetworkUnexpectedException extends NetworkException {
  const NetworkUnexpectedException({
    this.statusCode,
    this.errorCode,
    this.responseBody,
    String message = 'Unexpected network error.',
  }) : super(message);

  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? responseBody;
}

NetworkException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return NetworkTimeoutException(
        statusCode: error.response?.statusCode,
        errorCode: _extractErrorCode(error.response?.data),
        responseBody: _extractResponseBody(error.response?.data),
      );
    case DioExceptionType.connectionError:
      return NetworkConnectionException(
        statusCode: error.response?.statusCode,
        errorCode: _extractErrorCode(error.response?.data),
        responseBody: _extractResponseBody(error.response?.data),
      );
    case DioExceptionType.cancel:
      return NetworkCancelledException(
        statusCode: error.response?.statusCode,
        errorCode: _extractErrorCode(error.response?.data),
        responseBody: _extractResponseBody(error.response?.data),
      );
    case DioExceptionType.badResponse:
      return NetworkResponseException(
        statusCode: error.response?.statusCode,
        errorCode: _extractErrorCode(error.response?.data),
        responseBody: _extractResponseBody(error.response?.data),
        message: _extractErrorMessage(
          data: error.response?.data,
          statusCode: error.response?.statusCode,
          fallback: error.message ?? 'Request failed with server response.',
        ),
      );
    case DioExceptionType.badCertificate:
      return const NetworkConnectionException(
        message: 'Unable to establish a secure connection.',
      );
    case DioExceptionType.unknown:
      return NetworkUnexpectedException(
        statusCode: error.response?.statusCode,
        errorCode: _extractErrorCode(error.response?.data),
        responseBody: _extractResponseBody(error.response?.data),
        message: error.message ?? 'Unexpected network error.',
      );
  }
}

String? _extractErrorCode(Object? data) {
  final body = _extractResponseBody(data);
  if (body == null) {
    return null;
  }

  for (final key in const <String>[
    'code',
    'errorCode',
    'error_code',
    'error',
  ]) {
    final value = body[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }

  return null;
}

String _extractErrorMessage({
  required Object? data,
  required int? statusCode,
  required String fallback,
}) {
  final body = _extractResponseBody(data);
  if (body != null) {
    for (final key in const <String>['message', 'detail', 'errorMessage']) {
      final value = body[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
  }

  if (statusCode == null) {
    return fallback;
  }

  if (statusCode >= 500) {
    return 'Server error. Please try again later.';
  }

  return fallback;
}

Map<String, dynamic>? _extractResponseBody(Object? data) {
  if (data is Map<String, dynamic>) {
    return data;
  }

  if (data is Map) {
    return data.map(
      (Object? key, Object? value) => MapEntry(key?.toString() ?? '', value),
    );
  }

  return null;
}
