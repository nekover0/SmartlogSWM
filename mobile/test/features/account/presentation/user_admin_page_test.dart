import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/account/data/repositories/account_admin_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/account/domain/models/account_admin_models.dart';
import 'package:smartlog_swm_mobile/features/account/domain/repositories/account_admin_repository.dart';
import 'package:smartlog_swm_mobile/features/account/presentation/pages/user_admin_page.dart';

void main() {
  Widget buildSubject({required AccountAdminRepository repository}) {
    return ProviderScope(
      overrides: [
        accountAdminRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MaterialApp(home: UserAdminPage()),
    );
  }

  testWidgets('renders users from account admin provider', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        repository: _FakeAccountAdminRepository(
          users: const <AccountAdminUserEntity>[
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
            AccountAdminUserEntity(
              id: 'user-002',
              displayName: 'Warehouse Keeper',
              username: 'keeper',
              siteName: 'Kho Binh Duong',
              roleCode: 'WAREHOUSE_KEEPER',
              roleLabel: 'Warehouse Keeper',
              active: false,
              lastSeenLabel: '2 gio truoc',
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('System Admin'), findsOneWidget);
    expect(find.text('Warehouse Keeper'), findsAtLeastNWidgets(1));
    expect(find.byKey(const Key('user_admin_card_user-001')), findsOneWidget);
    expect(find.byKey(const Key('user_admin_card_user-002')), findsOneWidget);
  });

  testWidgets('shows empty state when no users available', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        repository: _FakeAccountAdminRepository(users: const <AccountAdminUserEntity>[]),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Chua co nguoi dung nao trong he thong.'), findsOneWidget);
  });
}

class _FakeAccountAdminRepository implements AccountAdminRepository {
  _FakeAccountAdminRepository({required this.users, this.roles = const <AccountAdminRoleEntity>[]});

  final List<AccountAdminUserEntity> users;
  final List<AccountAdminRoleEntity> roles;

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
