import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/account/data/repositories/account_admin_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/account/domain/models/account_admin_models.dart';
import 'package:smartlog_swm_mobile/features/account/domain/repositories/account_admin_repository.dart';
import 'package:smartlog_swm_mobile/features/account/presentation/pages/role_admin_page.dart';

void main() {
  Widget buildSubject({required AccountAdminRepository repository}) {
    return ProviderScope(
      overrides: [
        accountAdminRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MaterialApp(home: RoleAdminPage()),
    );
  }

  testWidgets('renders roles and permissions from provider', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        repository: _FakeAccountAdminRepository(
          roles: const <AccountAdminRoleEntity>[
            AccountAdminRoleEntity(
              id: 'role-admin',
              roleCode: 'ADMIN',
              roleName: 'Administrator',
              description: 'Global admin role',
              isActive: true,
              permissionCodes: <String>[
                'foundation.roles.view',
                'foundation.roles.create',
              ],
            ),
            AccountAdminRoleEntity(
              id: 'role-keeper',
              roleCode: 'WAREHOUSE_KEEPER',
              roleName: 'Warehouse Keeper',
              description: 'Operational role',
              isActive: false,
              permissionCodes: <String>[],
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('role_admin_card_role-admin')), findsOneWidget);
    expect(find.byKey(const Key('role_admin_card_role-keeper')), findsOneWidget);
    expect(find.text('foundation.roles.view'), findsOneWidget);
    expect(find.text('Chua co permission'), findsOneWidget);
  });

  testWidgets('shows empty state when no roles available', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        repository: _FakeAccountAdminRepository(roles: const <AccountAdminRoleEntity>[]),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Chua co vai tro nao trong he thong.'), findsOneWidget);
  });
}

class _FakeAccountAdminRepository implements AccountAdminRepository {
  _FakeAccountAdminRepository({required this.roles, this.users = const <AccountAdminUserEntity>[]});

  final List<AccountAdminRoleEntity> roles;
  final List<AccountAdminUserEntity> users;

  @override
  Future<void> assignRoleToUser({
    required String userId,
    required String roleCode,
    String? warehouseCode,
    bool isPrimary = true,
  }) async {}

  @override
  Future<List<AccountAdminRoleEntity>> getRoles() async {
    return roles;
  }

  @override
  Future<List<AccountAdminUserEntity>> getUsers() async {
    return users;
  }
}
