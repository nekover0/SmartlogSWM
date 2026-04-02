import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/auth_session_invalidation_signal.dart';
import 'package:smartlog_swm_mobile/core/network/auth_session_refresher.dart';
import 'package:smartlog_swm_mobile/core/network/network_exception.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

void main() {
  group('DioAuthSessionRefresher', () {
    test('executes refresh in single-flight mode', () async {
      final storage = _FakeSecureStorageService(session: _TestData.session);
      final invalidationSignal = AuthSessionInvalidationSignal();
      final adapter =
          _QueuedHttpClientAdapter(
            delay: const Duration(milliseconds: 30),
          )..enqueueResponse(
            statusCode: 200,
            body:
                '{"accessToken":"new-access-token","refreshToken":"new-refresh-token","expiresIn":900,"sessionId":"session-002"}',
          );
      final dio = Dio();
      dio.httpClientAdapter = adapter;

      final refresher = DioAuthSessionRefresher(
        secureStorageService: storage,
        invalidationSignal: invalidationSignal,
        dio: dio,
        clock: () => DateTime.utc(2026, 4, 3, 12, 0),
      );

      final results = await Future.wait<String?>(<Future<String?>>[
        refresher.refreshAccessToken(),
        refresher.refreshAccessToken(),
      ]);

      expect(results, <String?>['new-access-token', 'new-access-token']);
      expect(adapter.requestCount, 1);
      expect(storage.session?.accessToken, 'new-access-token');
      expect(storage.session?.refreshToken, 'new-refresh-token');
      expect(storage.session?.sessionId, 'session-002');
      expect(invalidationSignal.version, 0);
    });

    for (final terminalCode in const <String>[
      'AUTH_REFRESH_INVALID',
      'AUTH_REFRESH_EXPIRED',
      'AUTH_REFRESH_REPLAY_DETECTED',
      'AUTH_SESSION_REVOKED',
    ]) {
      test(
        'clears persisted session for terminal refresh failure: $terminalCode',
        () async {
          final storage = _FakeSecureStorageService(session: _TestData.session);
          final invalidationSignal = AuthSessionInvalidationSignal();
          final adapter = _QueuedHttpClientAdapter()
            ..enqueueResponse(
              statusCode: 401,
              body:
                  '{"code":"$terminalCode","message":"terminal refresh failure"}',
            );
          final dio = Dio();
          dio.httpClientAdapter = adapter;

          final refresher = DioAuthSessionRefresher(
            secureStorageService: storage,
            invalidationSignal: invalidationSignal,
            dio: dio,
            clock: () => DateTime.utc(2026, 4, 3, 12, 0),
          );

          await expectLater(
            refresher.refreshAccessToken(),
            throwsA(isA<NetworkResponseException>()),
          );
          expect(storage.session, isNull);
          expect(invalidationSignal.version, 1);
        },
      );
    }
  });
}

class _FakeSecureStorageService implements SecureStorageService {
  _FakeSecureStorageService({this.session});

  AuthSession? session;

  @override
  Future<void> deleteSession() async {
    session = null;
  }

  @override
  Future<AuthSession?> getSession() async {
    return session;
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    this.session = session;
  }
}

class _QueuedHttpClientAdapter implements HttpClientAdapter {
  _QueuedHttpClientAdapter({this.delay = Duration.zero});

  final Duration delay;
  final List<_ResponseStub> _responses = <_ResponseStub>[];
  int requestCount = 0;

  void enqueueResponse({required int statusCode, required String body}) {
    _responses.add(_ResponseStub(statusCode: statusCode, body: body));
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount += 1;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final stub = _responses.isNotEmpty
        ? _responses.removeAt(0)
        : const _ResponseStub(statusCode: 200, body: '{}');

    return ResponseBody.fromString(
      stub.body,
      stub.statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }
}

class _ResponseStub {
  const _ResponseStub({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

class _TestData {
  static final session = AuthSession(
    accessToken: 'access-token-001',
    refreshToken: 'refresh-token-001',
    expiresIn: 900,
    sessionId: 'session-001',
    tokenType: 'Bearer',
    currentUser: const AuthUser(
      id: 'user-001',
      username: 'warehouse.keeper',
      displayName: 'Warehouse Keeper',
      role: 'Warehouse Keeper',
      siteId: 'bdg-wh-02',
      siteName: 'Binh Duong Overflow Warehouse',
    ),
    loggedInAt: DateTime.utc(2026, 4, 3, 10, 0),
    persistedAt: DateTime.utc(2026, 4, 3, 10, 0),
  );
}
