import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/config/app_environment.dart';
import 'package:smartlog_swm_mobile/core/network/network_exception.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_provider.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';

const String skipAuthorizationHeaderExtraKey = 'skipAuthorizationHeader';

final dioProvider = Provider<Dio>((Ref<Object?> ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final secureStorageService = ref.watch(secureStorageServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: <String, Object?>{
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(_RequestIdInterceptor());
  dio.interceptors.add(
    _AuthTokenInterceptor(secureStorageService: secureStorageService),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  return dio;
});

final appHttpClientProvider = Provider<AppHttpClient>((Ref<Object?> ref) {
  return DioAppHttpClient(dio: ref.watch(dioProvider));
});

abstract interface class AppHttpClient {
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });

  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });

  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });

  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  });
}

class DioAppHttpClient implements AppHttpClient {
  DioAppHttpClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: _resolveOptions(options, requiresAuth: requiresAuth),
      );

      return _asMap(response.data, path: path);
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: _resolveOptions(options, requiresAuth: requiresAuth),
      );

      final data = response.data;
      if (data is List<dynamic>) {
        return data;
      }

      if (data is List) {
        return List<dynamic>.from(data);
      }

      throw NetworkUnexpectedException(
        message: 'Expected a list response from $path.',
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  @override
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _resolveOptions(options, requiresAuth: requiresAuth),
      );

      return _asMap(response.data, path: path);
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      await _dio.post<void>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _resolveOptions(options, requiresAuth: requiresAuth),
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Map<String, dynamic> _asMap(Object? data, {required String path}) {
    if (data == null) {
      return <String, dynamic>{};
    }

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return data.map(
        (Object? key, Object? value) => MapEntry(key?.toString() ?? '', value),
      );
    }

    throw NetworkUnexpectedException(
      message: 'Expected an object response from $path.',
    );
  }

  Options _resolveOptions(Options? options, {required bool requiresAuth}) {
    final baseOptions = options ?? Options();
    if (requiresAuth) {
      return baseOptions;
    }

    return baseOptions.copyWith(
      extra: <String, Object?>{
        ...?baseOptions.extra,
        skipAuthorizationHeaderExtraKey: true,
      },
    );
  }
}

class _RequestIdInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('X-Request-Id', _createRequestId);
    super.onRequest(options, handler);
  }

  String _createRequestId() {
    final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;
    final randomHex = Random().nextInt(0x7fffffff).toRadixString(16);
    return 'swm-$timestamp-$randomHex';
  }
}

class _AuthTokenInterceptor extends QueuedInterceptor {
  _AuthTokenInterceptor({required SecureStorageService secureStorageService})
    : _secureStorageService = secureStorageService;

  final SecureStorageService _secureStorageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skipAuth = options.extra[skipAuthorizationHeaderExtraKey] == true;
    if (!skipAuth) {
      final session = await _secureStorageService.getSession();
      final accessToken = session?.accessToken.trim();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers[HttpHeaders.authorizationHeader] =
            'Bearer $accessToken';
      }
    }

    handler.next(options);
  }
}
