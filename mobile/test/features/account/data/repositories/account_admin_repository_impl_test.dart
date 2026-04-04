import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/account/data/datasources/account_admin_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/account/data/repositories/account_admin_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/account/domain/models/account_admin_models.dart';

void main() {
  group('AccountAdminRepositoryImpl', () {
    test('returns users from api data source', () async {
      final apiDataSource = _FakeAccountAdminApiDataSource(
        usersResponse: const <AccountAdminUserEntity>[
          AccountAdminUserEntity(
            id: 'user-001',
            displayName: 'System Admin',
            username: 'admin',
            siteName: 'Kho HCM 01',
            roleCode: 'ADMIN',
            roleLabel: 'Administrator',
            active: true,
            lastSeenLabel: 'Vua truy cap',
          ),
        ],
      );

      final repository = AccountAdminRepositoryImpl(apiDataSource: apiDataSource);

      final users = await repository.getUsers();

      expect(apiDataSource.usersCallCount, 1);
      expect(users, hasLength(1));
      expect(users.single.username, 'admin');
      expect(users.single.roleCode, 'ADMIN');
    });

    test('returns roles from api data source', () async {
      final apiDataSource = _FakeAccountAdminApiDataSource(
        rolesResponse: const <AccountAdminRoleEntity>[
          AccountAdminRoleEntity(
            id: 'role-admin',
            roleCode: 'ADMIN',
            roleName: 'Administrator',
            description: 'Global admin role',
            isActive: true,
            permissionCodes: <String>['foundation.roles.view'],
          ),
        ],
      );

      final repository = AccountAdminRepositoryImpl(apiDataSource: apiDataSource);

      final roles = await repository.getRoles();

      expect(apiDataSource.rolesCallCount, 1);
      expect(roles, hasLength(1));
      expect(roles.single.roleName, 'Administrator');
      expect(roles.single.permissionCodes, contains('foundation.roles.view'));
    });

    test('forwards assign role command to api data source', () async {
      final apiDataSource = _FakeAccountAdminApiDataSource();
      final repository = AccountAdminRepositoryImpl(apiDataSource: apiDataSource);

      await repository.assignRoleToUser(
        userId: 'user-001',
        roleCode: 'WAREHOUSE_MANAGER',
        warehouseCode: 'WH5.1',
        isPrimary: false,
      );

      expect(apiDataSource.assignRoleCallCount, 1);
      expect(apiDataSource.assignedUserId, 'user-001');
      expect(apiDataSource.assignedRoleCode, 'WAREHOUSE_MANAGER');
      expect(apiDataSource.assignedWarehouseCode, 'WH5.1');
      expect(apiDataSource.assignedIsPrimary, isFalse);
    });
  });
}

class _FakeAccountAdminApiDataSource extends AccountAdminApiDataSource {
  _FakeAccountAdminApiDataSource({this.usersResponse, this.rolesResponse})
    : super(httpClient: _NoopAppHttpClient());

  final List<AccountAdminUserEntity>? usersResponse;
  final List<AccountAdminRoleEntity>? rolesResponse;

  int usersCallCount = 0;
  int rolesCallCount = 0;
  int assignRoleCallCount = 0;

  String? assignedUserId;
  String? assignedRoleCode;
  String? assignedWarehouseCode;
  bool? assignedIsPrimary;

  @override
  Future<List<AccountAdminUserEntity>> getUsers() async {
    usersCallCount += 1;
    return usersResponse ?? const <AccountAdminUserEntity>[];
  }

  @override
  Future<List<AccountAdminRoleEntity>> getRoles() async {
    rolesCallCount += 1;
    return rolesResponse ?? const <AccountAdminRoleEntity>[];
  }

  @override
  Future<void> assignRoleToUser({
    required String userId,
    required String roleCode,
    String? warehouseCode,
    bool isPrimary = true,
  }) async {
    assignRoleCallCount += 1;
    assignedUserId = userId;
    assignedRoleCode = roleCode;
    assignedWarehouseCode = warehouseCode;
    assignedIsPrimary = isPrimary;
  }
}

class _NoopAppHttpClient implements AppHttpClient {
  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
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
    throw UnimplementedError();
  }
}
