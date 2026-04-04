import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/account/application/providers/account_admin_providers.dart';
import 'package:smartlog_swm_mobile/features/account/domain/models/account_admin_models.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class RoleAdminPage extends ConsumerWidget {
  const RoleAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesState = ref.watch(accountAdminRolesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quản lý vai trò'),
        leading: IconButton(
          tooltip: 'Quay lại',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutePaths.account);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            tooltip: 'Quản lý người dùng',
            onPressed: () {
              context.go(AppRoutePaths.userAdmin);
            },
            icon: const Icon(Icons.people_alt_outlined),
          ),
        ],
      ),
      body: rolesState.when(
        loading: () => const AppLoadingView(message: 'Dang tai vai tro...'),
        error: (Object error, StackTrace stackTrace) {
          return AppErrorState(
            title: 'Khong tai duoc danh sach vai tro',
            message: error.toString(),
            onRetry: () => ref.invalidate(accountAdminRolesProvider),
          );
        },
        data: (List<AccountAdminRoleEntity> roles) {
          return ListView(
            padding: AppSpacing.pagePadding,
            children: [
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Text(
                    'Danh sach vai tro (${roles.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (roles.isEmpty)
                const Card(
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Text('Chua co vai tro nao trong he thong.'),
                  ),
                )
              else
                ...roles.map(
                  (role) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _RoleCard(role: role),
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_moderator_outlined),
                label: const Text('Tao role moi'),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () {
                  context.go(AppRoutePaths.permissions);
                },
                icon: const Icon(Icons.rule_outlined),
                label: const Text('Xem phan quyen hien tai'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.role});

  final AccountAdminRoleEntity role;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('role_admin_card_${role.id}'),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.roleName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role.roleCode,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _RoleStatusBadge(isActive: role.isActive),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              role.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (role.permissionCodes.isEmpty)
              const _PermissionPill(permissionCode: 'Chua co permission')
            else
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: role.permissionCodes
                    .take(8)
                    .map(
                      (permissionCode) =>
                          _PermissionPill(permissionCode: permissionCode),
                    )
                    .toList(growable: false),
              ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Sua'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionPill extends StatelessWidget {
  const _PermissionPill({required this.permissionCode});

  final String permissionCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.brand.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        permissionCode,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.brand,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RoleStatusBadge extends StatelessWidget {
  const _RoleStatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.danger;
    final label = isActive ? 'Active' : 'Inactive';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
