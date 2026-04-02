import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/network_exception.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_api_client.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_error_mapper.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_refresh_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_session_summary_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/select_warehouse_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/errors/auth_exceptions.dart';

void main() {
  group('AuthRemoteDataSource', () {
    test('maps API business code into auth exception', () async {
      final api = _ThrowingAuthApi(
        const NetworkResponseException(
          statusCode: 401,
          errorCode: 'AUTH_INVALID_CREDENTIALS',
          message: 'Invalid credentials',
        ),
      );
      final dataSource = AuthRemoteDataSourceImpl(
        api: api,
        errorMapper: const AuthErrorMapper(),
      );

      expect(
        () => dataSource.login(
          const LoginRequestDto(username: 'ops.supervisor', password: 'wrong'),
        ),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });
  });
}

class _ThrowingAuthApi implements AuthApi {
  const _ThrowingAuthApi(this.error);

  final Object error;

  @override
  Future<void> changePassword(ChangePasswordRequestDto request) {
    throw error;
  }

  @override
  Future<AuthProfileDto> getMe() {
    throw error;
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() {
    throw error;
  }

  @override
  Future<List<AuthSessionSummaryDto>> getSessions() {
    throw error;
  }

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) {
    throw error;
  }

  @override
  Future<void> logout() {
    throw error;
  }

  @override
  Future<void> logoutAll() {
    throw error;
  }

  @override
  Future<AuthRefreshResponseDto> refresh({required String refreshToken}) {
    throw error;
  }

  @override
  Future<void> revokeSession({required String sessionId}) {
    throw error;
  }

  @override
  Future<SelectWarehouseResponseDto> selectWarehouse({
    required String warehouseId,
  }) {
    throw error;
  }
}
