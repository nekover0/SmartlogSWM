import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_api_client.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_error_mapper.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_refresh_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_session_summary_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/select_warehouse_response_dto.dart';

final authErrorMapperProvider = Provider<AuthErrorMapper>((Ref<Object?> ref) {
  return const AuthErrorMapper();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((
  Ref<Object?> ref,
) {
  return AuthRemoteDataSource(
    api: ref.watch(authApiClientProvider),
    errorMapper: ref.watch(authErrorMapperProvider),
  );
});

class AuthRemoteDataSource {
  AuthRemoteDataSource({
    required AuthApi api,
    required AuthErrorMapper errorMapper,
  }) : _api = api,
       _errorMapper = errorMapper;

  final AuthApi _api;
  final AuthErrorMapper _errorMapper;

  Future<LoginResponseDto> login(LoginRequestDto request) async {
    try {
      return await _api.login(request);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<AuthRefreshResponseDto> refresh({required String refreshToken}) async {
    try {
      return await _api.refresh(refreshToken: refreshToken);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<AuthProfileDto> getMe() async {
    try {
      return await _api.getMe();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<AuthPermissionsSnapshotDto> getMyPermissions() async {
    try {
      return await _api.getMyPermissions();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<List<AuthSessionSummaryDto>> getSessions() async {
    try {
      return await _api.getSessions();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<void> changePassword(ChangePasswordRequestDto request) async {
    try {
      await _api.changePassword(request);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<SelectWarehouseResponseDto> selectWarehouse({
    required String warehouseId,
  }) async {
    try {
      return await _api.selectWarehouse(warehouseId: warehouseId);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<void> revokeSession({required String sessionId}) async {
    try {
      await _api.revokeSession(sessionId: sessionId);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<void> logout() async {
    try {
      await _api.logout();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  Future<void> logoutAll() async {
    try {
      await _api.logoutAll();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }
}
