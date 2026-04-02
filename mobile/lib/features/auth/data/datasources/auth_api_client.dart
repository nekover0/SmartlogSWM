import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_refresh_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_session_summary_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/select_warehouse_response_dto.dart';

final authApiClientProvider = Provider<AuthApi>((Ref<Object?> ref) {
  return AuthApiClient(httpClient: ref.watch(appHttpClientProvider));
});

abstract interface class AuthApi {
  Future<LoginResponseDto> login(LoginRequestDto request);

  Future<AuthRefreshResponseDto> refresh({required String refreshToken});

  Future<AuthProfileDto> getMe();

  Future<AuthPermissionsSnapshotDto> getMyPermissions();

  Future<List<AuthSessionSummaryDto>> getSessions();

  Future<void> changePassword(ChangePasswordRequestDto request);

  Future<SelectWarehouseResponseDto> selectWarehouse({
    required String warehouseId,
  });

  Future<void> revokeSession({required String sessionId});

  Future<void> logout();

  Future<void> logoutAll();
}

class AuthApiClient implements AuthApi {
  AuthApiClient({required AppHttpClient httpClient}) : _httpClient = httpClient;

  final AppHttpClient _httpClient;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final payload = await _httpClient.postMap(
      '/api/v1/auth/login',
      data: request.toJson(),
    );

    return LoginResponseDto.fromApiJson(payload);
  }

  @override
  Future<AuthRefreshResponseDto> refresh({required String refreshToken}) async {
    final payload = await _httpClient.postMap(
      '/api/v1/auth/refresh',
      data: <String, dynamic>{'refreshToken': refreshToken},
    );

    return AuthRefreshResponseDto.fromJson(payload);
  }

  @override
  Future<AuthProfileDto> getMe() async {
    final payload = await _httpClient.getMap('/api/v1/auth/me');
    return AuthProfileDto.fromJson(payload);
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() async {
    final payload = await _httpClient.getMap('/api/v1/auth/me/permissions');
    return AuthPermissionsSnapshotDto.fromJson(payload);
  }

  @override
  Future<List<AuthSessionSummaryDto>> getSessions() async {
    final payload = await _httpClient.getList('/api/v1/auth/sessions');

    return payload
        .whereType<Map>()
        .map(
          (Map<dynamic, dynamic> entry) => AuthSessionSummaryDto.fromJson(
            entry.map(
              (dynamic key, dynamic value) =>
                  MapEntry(key?.toString() ?? '', value),
            ),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> changePassword(ChangePasswordRequestDto request) {
    return _httpClient.postVoid(
      '/api/v1/auth/change-password',
      data: request.toJson(),
    );
  }

  @override
  Future<SelectWarehouseResponseDto> selectWarehouse({
    required String warehouseId,
  }) async {
    final payload = await _httpClient.postMap(
      '/api/v1/auth/select-warehouse',
      data: <String, dynamic>{'warehouseId': warehouseId},
    );

    return SelectWarehouseResponseDto.fromJson(payload);
  }

  @override
  Future<void> revokeSession({required String sessionId}) {
    return _httpClient.postVoid('/api/v1/auth/sessions/$sessionId/revoke');
  }

  @override
  Future<void> logout() {
    return _httpClient.postVoid('/api/v1/auth/logout');
  }

  @override
  Future<void> logoutAll() {
    return _httpClient.postVoid('/api/v1/auth/logout-all');
  }
}
