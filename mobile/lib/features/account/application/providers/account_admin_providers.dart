import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/account/data/repositories/account_admin_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/account/domain/models/account_admin_models.dart';

final accountAdminUsersProvider = FutureProvider<List<AccountAdminUserEntity>>(
  (Ref<Object?> ref) {
    return ref.watch(accountAdminRepositoryProvider).getUsers();
  },
);

final accountAdminRolesProvider = FutureProvider<List<AccountAdminRoleEntity>>(
  (Ref<Object?> ref) {
    return ref.watch(accountAdminRepositoryProvider).getRoles();
  },
);
