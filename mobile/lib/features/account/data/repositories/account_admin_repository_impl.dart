import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/account/data/datasources/account_admin_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/account/domain/models/account_admin_models.dart';
import 'package:smartlog_swm_mobile/features/account/domain/repositories/account_admin_repository.dart';

final accountAdminRepositoryProvider = Provider<AccountAdminRepository>((
  Ref<Object?> ref,
) {
  return AccountAdminRepositoryImpl(
    apiDataSource: ref.watch(accountAdminApiDataSourceProvider),
  );
});

class AccountAdminRepositoryImpl implements AccountAdminRepository {
  AccountAdminRepositoryImpl({required AccountAdminApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  final AccountAdminApiDataSource _apiDataSource;

  @override
  Future<List<AccountAdminUserEntity>> getUsers() {
    return _apiDataSource.getUsers();
  }

  @override
  Future<List<AccountAdminRoleEntity>> getRoles() {
    return _apiDataSource.getRoles();
  }

  @override
  Future<void> assignRoleToUser({
    required String userId,
    required String roleCode,
    String? warehouseCode,
    bool isPrimary = true,
  }) {
    return _apiDataSource.assignRoleToUser(
      userId: userId,
      roleCode: roleCode,
      warehouseCode: warehouseCode,
      isPrimary: isPrimary,
    );
  }
}
