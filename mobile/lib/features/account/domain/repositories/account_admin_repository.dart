import 'package:smartlog_swm_mobile/features/account/domain/models/account_admin_models.dart';

abstract interface class AccountAdminRepository {
  Future<List<AccountAdminUserEntity>> getUsers();

  Future<List<AccountAdminRoleEntity>> getRoles();

  Future<void> assignRoleToUser({
    required String userId,
    required String roleCode,
    String? warehouseCode,
    bool isPrimary = true,
  });
}
