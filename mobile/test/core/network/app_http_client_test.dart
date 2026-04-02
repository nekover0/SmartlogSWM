import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
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
        overrides: [secureStorageServiceProvider.overrideWithValue(fakeStorage)],
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
        overrides: [secureStorageServiceProvider.overrideWithValue(fakeStorage)],
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
  RequestOptions? lastRequest;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;

    return ResponseBody.fromString(
      '{}',
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
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
