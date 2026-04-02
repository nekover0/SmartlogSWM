import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/config/app_environment.dart';
import 'package:smartlog_swm_mobile/core/network/auth_session_invalidation_signal.dart';
import 'package:smartlog_swm_mobile/core/network/network_exception.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_provider.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';

final authSessionRefresherProvider = Provider<AuthSessionRefresher>((
  Ref<Object?> ref,
) {
  return DioAuthSessionRefresher(
    secureStorageService: ref.watch(secureStorageServiceProvider),
    invalidationSignal: ref.watch(authSessionInvalidationSignalProvider),
    dio: Dio(
      BaseOptions(
        baseUrl: ref.watch(apiBaseUrlProvider),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: <String, Object?>{
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        responseType: ResponseType.json,
      ),
    ),
    clock: () => DateTime.now().toUtc(),
  );
});

abstract interface class AuthSessionRefresher {
  Future<String?> refreshAccessToken();
}

class DioAuthSessionRefresher implements AuthSessionRefresher {
  DioAuthSessionRefresher({
    required SecureStorageService secureStorageService,
    required AuthSessionInvalidationSignal invalidationSignal,
    required Dio dio,
    required DateTime Function() clock,
  }) : _secureStorageService = secureStorageService,
       _invalidationSignal = invalidationSignal,
       _dio = dio,
       _clock = clock;

  final SecureStorageService _secureStorageService;
  final AuthSessionInvalidationSignal _invalidationSignal;
  final Dio _dio;
  final DateTime Function() _clock;

  Future<String?>? _refreshInFlight;

  @override
  Future<String?> refreshAccessToken() async {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final refreshFuture = _refreshAccessTokenInternal();
    _refreshInFlight = refreshFuture;

    try {
      return await refreshFuture;
    } finally {
      if (identical(_refreshInFlight, refreshFuture)) {
        _refreshInFlight = null;
      }
    }
  }

  Future<String?> _refreshAccessTokenInternal() async {
    final currentSession = await _secureStorageService.getSession();
    final refreshToken = currentSession?.refreshToken?.trim();

    if (currentSession == null ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      return null;
    }

    try {
      final response = await _dio.post<Object?>(
        '/api/v1/auth/refresh',
        data: <String, dynamic>{'refreshToken': refreshToken},
      );

      final payload = _asMap(response.data);
      final updatedAccessToken = (payload['accessToken'] as String? ?? '')
          .trim();
      if (updatedAccessToken.isEmpty) {
        return null;
      }

      final updatedSession = AuthSession(
        accessToken: updatedAccessToken,
        refreshToken:
            (payload['refreshToken'] as String?)?.trim() ??
            currentSession.refreshToken,
        expiresIn: payload['expiresIn'] as int? ?? currentSession.expiresIn,
        sessionId:
            (payload['sessionId'] as String?)?.trim() ??
            currentSession.sessionId,
        tokenType: currentSession.tokenType,
        currentUser: currentSession.currentUser,
        loggedInAt: currentSession.loggedInAt,
        persistedAt: _clock(),
      );

      await _secureStorageService.saveSession(updatedSession);
      return updatedSession.accessToken;
    } on DioException catch (error) {
      final code = _extractBusinessCode(error.response?.data);
      if (_isTerminalRefreshFailureCode(code)) {
        await _secureStorageService.deleteSession();
        _invalidationSignal.markInvalidated();
      }

      throw mapDioException(error);
    }
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return data.map(
        (Object? key, Object? value) => MapEntry(key?.toString() ?? '', value),
      );
    }

    return <String, dynamic>{};
  }

  String? _extractBusinessCode(Object? data) {
    final body = _asMap(data);

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

  bool _isTerminalRefreshFailureCode(String? code) {
    return code == 'AUTH_REFRESH_INVALID' ||
        code == 'AUTH_REFRESH_EXPIRED' ||
        code == 'AUTH_REFRESH_REPLAY_DETECTED' ||
        code == 'AUTH_SESSION_REVOKED';
  }
}
