import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_api_client.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';

void main() {
  group('AuthApiClient', () {
    late _FakeAppHttpClient httpClient;
    late AuthApiClient apiClient;

    setUp(() {
      httpClient = _FakeAppHttpClient();
      apiClient = AuthApiClient(httpClient: httpClient);
    });

    test('login posts expected payload and maps response fields', () async {
      httpClient.mapResponse = <String, dynamic>{
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
        'tokenType': 'Bearer',
        'expiresIn': 900,
        'sessionId': 'session-001',
        'selectedWarehouseId': 'wh-01',
        'warehouseOptions': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'wh-01',
            'code': 'WH5.1',
            'name': 'Kho 5.1 - Phu My',
          },
        ],
        'user': <String, dynamic>{
          'id': 'user-001',
          'username': 'warehouse.keeper',
          'fullName': 'Warehouse Keeper',
          'roleCodes': <String>['WAREHOUSE_KEEPER'],
          'mustChangePassword': false,
        },
      };

      final response = await apiClient.login(
        const LoginRequestDto(
          username: 'warehouse.keeper',
          password: 'secret',
          deviceId: 'android-device-001',
          deviceName: 'Pixel 8',
        ),
      );

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'POST_MAP');
      expect(httpClient.requests.single.path, '/api/v1/auth/login');
      expect(httpClient.requests.single.requiresAuth, isFalse);
      expect(httpClient.requests.single.data, <String, dynamic>{
        'username': 'warehouse.keeper',
        'password': 'secret',
        'channel': 'MOBILE',
        'deviceId': 'android-device-001',
        'deviceName': 'Pixel 8',
      });

      expect(response.accessToken, 'access-token');
      expect(response.refreshToken, 'refresh-token');
      expect(response.sessionId, 'session-001');
      expect(response.user.displayName, 'Warehouse Keeper');
      expect(response.user.role, 'WAREHOUSE_KEEPER');
      expect(response.user.siteId, 'wh-01');
      expect(response.user.siteName, 'Kho 5.1 - Phu My');
    });

    test('refresh calls expected endpoint', () async {
      httpClient.mapResponse = <String, dynamic>{
        'accessToken': 'new-access-token',
        'refreshToken': 'new-refresh-token',
        'expiresIn': 900,
        'sessionId': 'session-001',
      };

      final response = await apiClient.refresh(refreshToken: 'refresh-123');

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'POST_MAP');
      expect(httpClient.requests.single.path, '/api/v1/auth/refresh');
      expect(httpClient.requests.single.requiresAuth, isFalse);
      expect(httpClient.requests.single.data, <String, dynamic>{
        'refreshToken': 'refresh-123',
      });
      expect(response.accessToken, 'new-access-token');
    });

    test('permissions and session endpoints use typed methods', () async {
      httpClient.mapResponse = <String, dynamic>{
        'roleCodes': <String>['ADMIN'],
        'permissions': <String>['foundation.roles.view'],
        'warehouseScope': <String>['WH5.1'],
        'ownerScope': <String>[],
      };
      httpClient.listResponse = <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'ses-1',
          'sessionCode': 'SES-ABC123',
          'channel': 'MOBILE',
          'isCurrent': true,
        },
      ];

      final permissions = await apiClient.getMyPermissions();
      final sessions = await apiClient.getSessions();

      expect(permissions.roleCodes, <String>['ADMIN']);
      expect(sessions, hasLength(1));
      expect(sessions.single.id, 'ses-1');

      expect(httpClient.requests, hasLength(2));
      expect(httpClient.requests[0].method, 'GET_MAP');
      expect(httpClient.requests[0].path, '/api/v1/auth/me/permissions');
      expect(httpClient.requests[0].requiresAuth, isTrue);
      expect(httpClient.requests[1].method, 'GET_LIST');
      expect(httpClient.requests[1].path, '/api/v1/auth/sessions');
      expect(httpClient.requests[1].requiresAuth, isTrue);
    });

    test(
      'change password and select warehouse hit expected endpoints',
      () async {
        httpClient.mapResponse = <String, dynamic>{
          'selectedWarehouseId': 'wh-02',
          'accessToken': 'switched-token',
        };

        await apiClient.changePassword(
          const ChangePasswordRequestDto(
            oldPassword: 'old-123',
            newPassword: 'NewPass@123',
            confirmPassword: 'NewPass@123',
          ),
        );

        final selected = await apiClient.selectWarehouse(warehouseId: 'wh-02');

        expect(selected.selectedWarehouseId, 'wh-02');
        expect(selected.accessToken, 'switched-token');

        expect(httpClient.requests, hasLength(2));
        expect(httpClient.requests[0].method, 'POST_VOID');
        expect(httpClient.requests[0].path, '/api/v1/auth/change-password');
        expect(httpClient.requests[0].requiresAuth, isTrue);
        expect(httpClient.requests[1].method, 'POST_MAP');
        expect(httpClient.requests[1].path, '/api/v1/auth/select-warehouse');
        expect(httpClient.requests[1].requiresAuth, isTrue);
        expect(httpClient.requests[1].data, <String, dynamic>{
          'warehouseId': 'wh-02',
        });
      },
    );
  });
}

class _FakeAppHttpClient implements AppHttpClient {
  final List<_RecordedRequest> requests = <_RecordedRequest>[];
  Map<String, dynamic> mapResponse = <String, dynamic>{};
  List<dynamic> listResponse = const <dynamic>[];

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    requests.add(
      _RecordedRequest(
        method: 'GET_MAP',
        path: path,
        data: null,
        queryParameters: queryParameters,
        requiresAuth: requiresAuth,
      ),
    );

    return mapResponse;
  }

  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    requests.add(
      _RecordedRequest(
        method: 'GET_LIST',
        path: path,
        data: null,
        queryParameters: queryParameters,
        requiresAuth: requiresAuth,
      ),
    );

    return listResponse;
  }

  @override
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    requests.add(
      _RecordedRequest(
        method: 'POST_MAP',
        path: path,
        data: data,
        queryParameters: queryParameters,
        requiresAuth: requiresAuth,
      ),
    );

    return mapResponse;
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    requests.add(
      _RecordedRequest(
        method: 'POST_VOID',
        path: path,
        data: data,
        queryParameters: queryParameters,
        requiresAuth: requiresAuth,
      ),
    );
  }
}

class _RecordedRequest {
  const _RecordedRequest({
    required this.method,
    required this.path,
    required this.data,
    required this.queryParameters,
    required this.requiresAuth,
  });

  final String method;
  final String path;
  final Object? data;
  final Map<String, dynamic>? queryParameters;
  final bool requiresAuth;
}
