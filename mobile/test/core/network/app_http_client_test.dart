import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/core/network/auth_session_refresher.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_provider.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

void main() {
  group('DioAppHttpClient authorization', () {
    late _RecordingHttpClientAdapter adapter;

    setUp(() {
      adapter = _RecordingHttpClientAdapter();
    });

    test('injects Authorization header when auth is required', () async {
      final fakeStorage = _FakeSecureStorageService(session: _TestData.session);
      final container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(fakeStorage),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      dio.httpClientAdapter = adapter;
      final client = DioAppHttpClient(dio: dio);

      await client.getMap('/api/v1/auth/me');

      expect(
        _authorizationHeader(adapter.lastRequest?.headers),
        'Bearer access-token-001',
      );
    });

    test('skips Authorization header when requiresAuth is false', () async {
      final fakeStorage = _FakeSecureStorageService(session: _TestData.session);
      final container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(fakeStorage),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      dio.httpClientAdapter = adapter;
      final client = DioAppHttpClient(dio: dio);

      await client.postMap(
        '/api/v1/auth/login',
        data: const <String, dynamic>{'username': 'u', 'password': 'p'},
        requiresAuth: false,
      );

      expect(_authorizationHeader(adapter.lastRequest?.headers), isNull);
      expect(
        adapter.lastRequest?.extra[skipAuthorizationHeaderExtraKey],
        isTrue,
      );
    });

    test('unwraps map payload from success envelope', () async {
      adapter.enqueueResponse(
        statusCode: HttpStatus.ok,
        body: '{"success":true,"data":{"id":"user-001","name":"Admin"}}',
      );

      final fakeStorage = _FakeSecureStorageService(session: _TestData.session);
      final container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(fakeStorage),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      dio.httpClientAdapter = adapter;
      final client = DioAppHttpClient(dio: dio);

      final result = await client.getMap('/api/v1/auth/me');
      expect(result['id'], 'user-001');
      expect(result['name'], 'Admin');
    });

    test('unwraps list payload from success envelope', () async {
      adapter.enqueueResponse(
        statusCode: HttpStatus.ok,
        body:
            '{"success":true,"data":[{"id":"session-001","channel":"MOBILE"}]}',
      );

      final fakeStorage = _FakeSecureStorageService(session: _TestData.session);
      final container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(fakeStorage),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      dio.httpClientAdapter = adapter;
      final client = DioAppHttpClient(dio: dio);

      final result = await client.getList('/api/v1/auth/sessions');
      expect(result, hasLength(1));
      expect((result.first as Map)['id'], 'session-001');
    });

    test('retries once with refreshed token on 401 responses', () async {
      adapter.enqueueResponse(
        statusCode: HttpStatus.unauthorized,
        body: '{"code":"AUTH_REFRESH_EXPIRED","message":"refresh expired"}',
      );
      adapter.enqueueResponse(statusCode: HttpStatus.ok, body: '{}');

      final fakeStorage = _FakeSecureStorageService(session: _TestData.session);
      final fakeRefresher = _FakeAuthSessionRefresher(
        refreshedToken: 'refreshed-access-token',
        onRefresh: () {
          final current = fakeStorage.session;
          if (current == null) {
            return;
          }

          fakeStorage.session = AuthSession(
            accessToken: 'refreshed-access-token',
            refreshToken: current.refreshToken,
            expiresIn: current.expiresIn,
            sessionId: current.sessionId,
            tokenType: current.tokenType,
            currentUser: current.currentUser,
            loggedInAt: current.loggedInAt,
            persistedAt: current.persistedAt,
          );
        },
      );
      final container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(fakeStorage),
          authSessionRefresherProvider.overrideWithValue(fakeRefresher),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      dio.httpClientAdapter = adapter;
      final client = DioAppHttpClient(dio: dio);

      await client.getMap('/api/v1/auth/me');

      expect(fakeRefresher.callCount, 1);
      expect(adapter.requests, hasLength(2));
      expect(
        _authorizationHeader(adapter.requests.first.headers),
        'Bearer access-token-001',
      );
      expect(
        _authorizationHeader(adapter.requests.last.headers),
        'Bearer refreshed-access-token',
      );
      expect(
        adapter.requests.last.extra[retriedWithRefreshedTokenExtraKey],
        isTrue,
      );
    });
  });
}

String? _authorizationHeader(Map<String, dynamic>? headers) {
  if (headers == null) {
    return null;
  }

  for (final MapEntry<String, dynamic> entry in headers.entries) {
    if (entry.key.toLowerCase() == HttpHeaders.authorizationHeader) {
      return entry.value?.toString();
    }
  }

  return null;
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

class _RecordingHttpClientAdapter implements HttpClientAdapter {
  final List<_QueuedAdapterResponse> _queuedResponses =
      <_QueuedAdapterResponse>[];
  final List<RequestOptions> requests = <RequestOptions>[];
  RequestOptions? lastRequest;

  void enqueueResponse({required int statusCode, required String body}) {
    _queuedResponses.add(
      _QueuedAdapterResponse(statusCode: statusCode, body: body),
    );
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    requests.add(options);

    final queued = _queuedResponses.isNotEmpty
        ? _queuedResponses.removeAt(0)
        : const _QueuedAdapterResponse(statusCode: 200, body: '{}');

    return ResponseBody.fromString(
      queued.body,
      queued.statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }
}

class _QueuedAdapterResponse {
  const _QueuedAdapterResponse({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

class _FakeAuthSessionRefresher implements AuthSessionRefresher {
  _FakeAuthSessionRefresher({required this.refreshedToken, this.onRefresh});

  final String refreshedToken;
  final void Function()? onRefresh;
  int callCount = 0;

  @override
  Future<String?> refreshAccessToken() async {
    callCount += 1;
    onRefresh?.call();
    return refreshedToken;
  }
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
