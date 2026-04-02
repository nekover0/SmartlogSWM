import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/config/app_environment.dart';
import 'package:smartlog_swm_mobile/core/network/network_exception.dart';

final dioProvider = Provider<Dio>((Ref<Object?> ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);

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
  });

  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
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
  }) async {
    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: options,
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
  }) async {
    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: options,
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
  }) async {
    try {
      final response = await _dio.post<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
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
  }) async {
    try {
      await _dio.post<void>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
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
