import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/account/data/datasources/account_admin_api_data_source.dart';

void main() {
  group('AccountAdminApiDataSource', () {
    late _FakeAppHttpClient httpClient;
    late AccountAdminApiDataSource dataSource;

    setUp(() {
      httpClient = _FakeAppHttpClient();
      dataSource = AccountAdminApiDataSource(httpClient: httpClient);
    });

    test('maps foundation role list', () async {
      httpClient.listByPath['/api/v1/foundation/roles'] = <dynamic>[
        <String, dynamic>{
          'id': 'role-admin',
          'roleCode': 'ADMIN',
          'roleName': 'Administrator',
          'description': 'Global admin role',
          'isActive': true,
          'permissions': <dynamic>[
            <String, dynamic>{
              'permission': <String, dynamic>{
                'permissionCode': 'foundation.roles.view',
              },
            },
            <String, dynamic>{'permissionCode': 'foundation.roles.create'},
          ],
        },
      ];

      final roles = await dataSource.getRoles();

      expect(roles, hasLength(1));
      expect(roles.single.id, 'role-admin');
      expect(roles.single.roleCode, 'ADMIN');
      expect(roles.single.roleName, 'Administrator');
      expect(roles.single.permissionCodes, contains('foundation.roles.view'));
      expect(roles.single.permissionCodes, contains('foundation.roles.create'));

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'GET_LIST');
      expect(httpClient.requests.single.path, '/api/v1/foundation/roles');
    });

    test('falls back to auth profile when foundation users endpoint is missing',
        () async {
      httpClient.listErrors['/api/v1/foundation/users'] =
          StateError('Not Found');
      httpClient.mapByPath['/api/v1/auth/me'] = <String, dynamic>{
        'id': 'user-admin-01',
        'username': 'admin',
        'fullName': 'System Admin',
        'roleCodes': <String>['ADMIN'],
        'selectedWarehouseId': 'wh-01',
        'warehouseOptions': <dynamic>[
          <String, dynamic>{
            'id': 'wh-01',
            'code': 'WH5.1',
            'name': 'Kho 5.1 - Phu My',
          },
        ],
      };

      final users = await dataSource.getUsers();

      expect(users, hasLength(1));
      expect(users.single.id, 'user-admin-01');
      expect(users.single.displayName, 'System Admin');
      expect(users.single.username, 'admin');
      expect(users.single.roleCode, 'ADMIN');
      expect(users.single.roleLabel, 'Administrator');
      expect(users.single.siteName, 'Kho 5.1 - Phu My');

      expect(httpClient.requests, hasLength(2));
      expect(httpClient.requests.first.path, '/api/v1/foundation/users');
      expect(httpClient.requests.last.path, '/api/v1/auth/me');
    });

    test('posts assign role payload to foundation endpoint', () async {
      await dataSource.assignRoleToUser(
        userId: 'user-001',
        roleCode: 'WAREHOUSE_MANAGER',
        warehouseCode: 'WH5.1',
      );

      expect(httpClient.requests, hasLength(1));
      final request = httpClient.requests.single;
      expect(request.method, 'POST_VOID');
      expect(request.path, '/api/v1/foundation/users/user-001/roles');
      expect(request.data, isA<Map<String, dynamic>>());

      final payload = request.data! as Map<String, dynamic>;
      expect(payload['roleCode'], 'WAREHOUSE_MANAGER');
      expect(payload['warehouseCode'], 'WH5.1');
      expect(payload['isPrimary'], isTrue);
    });
  });
}

class _FakeAppHttpClient implements AppHttpClient {
  final Map<String, List<dynamic>> listByPath = <String, List<dynamic>>{};
  final Map<String, Map<String, dynamic>> mapByPath =
      <String, Map<String, dynamic>>{};
  final Map<String, Object> listErrors = <String, Object>{};
  final List<_RecordedRequest> requests = <_RecordedRequest>[];

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
        queryParameters: queryParameters,
      ),
    );

    final error = listErrors[path];
    if (error != null) {
      throw error;
    }

    return listByPath[path] ?? const <dynamic>[];
  }

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
        queryParameters: queryParameters,
      ),
    );

    return mapByPath[path] ?? const <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
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
        queryParameters: queryParameters,
        data: data,
      ),
    );
  }
}

class _RecordedRequest {
  const _RecordedRequest({
    required this.method,
    required this.path,
    required this.queryParameters,
    this.data,
  });

  final String method;
  final String path;
  final Map<String, dynamic>? queryParameters;
  final Object? data;
}
