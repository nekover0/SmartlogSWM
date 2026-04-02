import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/network_exception.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_error_mapper.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/errors/auth_exceptions.dart';

void main() {
  group('AuthErrorMapper', () {
    const mapper = AuthErrorMapper();

    test('maps AUTH_INVALID_CREDENTIALS to InvalidCredentialsException', () {
      final mapped = mapper.map(
        const NetworkResponseException(
          statusCode: 401,
          errorCode: 'AUTH_INVALID_CREDENTIALS',
          message: 'Invalid credentials',
        ),
      );

      expect(mapped, isA<InvalidCredentialsException>());
    });

    test('maps AUTH_REFRESH_REPLAY_DETECTED to replay exception', () {
      final mapped = mapper.map(
        const NetworkResponseException(
          statusCode: 401,
          errorCode: 'AUTH_REFRESH_REPLAY_DETECTED',
          message: 'Replay detected',
        ),
      );

      expect(mapped, isA<AuthRefreshReplayDetectedException>());
    });

    test('maps 401 without business code to unauthorized exception', () {
      final mapped = mapper.map(
        const NetworkResponseException(
          statusCode: 401,
          message: 'Unauthorized',
        ),
      );

      expect(mapped, isA<AuthUnauthorizedException>());
    });

    test('maps connection problems to AuthNetworkException', () {
      final mapped = mapper.map(const NetworkConnectionException());

      expect(mapped, isA<AuthNetworkException>());
    });
  });
}
