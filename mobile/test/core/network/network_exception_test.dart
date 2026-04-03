import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/network_exception.dart';

void main() {
  group('mapDioException', () {
    test('extracts nested error code and message from API envelope', () {
      final requestOptions = RequestOptions(
        path: '/api/v1/auth/change-password',
      );
      final response = Response<Object?>(
        requestOptions: requestOptions,
        statusCode: 400,
        data: <String, dynamic>{
          'success': false,
          'error': <String, dynamic>{
            'statusCode': 400,
            'code': 'AUTH_PASSWORD_MISMATCH',
            'message': 'Mật khẩu xác nhận không khớp',
          },
          'meta': <String, dynamic>{'requestId': 'req-001'},
        },
      );

      final dioException = DioException(
        requestOptions: requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

      final mapped = mapDioException(dioException);
      expect(mapped, isA<NetworkResponseException>());

      final networkError = mapped as NetworkResponseException;
      expect(networkError.errorCode, 'AUTH_PASSWORD_MISMATCH');
      expect(networkError.message, 'Mật khẩu xác nhận không khớp');
      expect(networkError.statusCode, 400);
      expect(networkError.responseBody, isNotNull);
    });
  });
}
