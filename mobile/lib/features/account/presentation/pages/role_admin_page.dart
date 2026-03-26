import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class RoleAdminPage extends StatelessWidget {
  const RoleAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final roleRows = _buildRoleRows();

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
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Text(
                'Role matrix',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...roleRows.map(
            (roleRow) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _RoleCard(roleRow: roleRow),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_moderator_outlined),
            label: const Text('Tạo role mới'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () {
              context.go(AppRoutePaths.permissions);
            },
            icon: const Icon(Icons.rule_outlined),
            label: const Text('Xem phân quyền hiện tại'),
          ),
        ],
      ),
    );
  }

  List<_RoleRow> _buildRoleRows() {
    return AppRole.values
        .map((role) {
          final moduleAccess = <_ModuleAccessInfo>[];
          for (final module in AppModule.values) {
            final access = RoleMatrix.accessFor(role: role, module: module);
            moduleAccess.add(
              _ModuleAccessInfo(
                moduleLabel: _moduleLabel(module),
                access: access,
              ),
            );
          }

          return _RoleRow(roleLabel: role.label, moduleAccess: moduleAccess);
        })
        .toList(growable: false);
  }

  String _moduleLabel(AppModule module) {
    return switch (module) {
      AppModule.home => 'Home',
      AppModule.tasks => 'Tasks',
      AppModule.scan => 'Scan',
      AppModule.inventory => 'Inventory',
      AppModule.inbound => 'Inbound',
      AppModule.outbound => 'Outbound',
      AppModule.ocr => 'OCR',
      AppModule.inventoryControl => 'Inventory Control',
      AppModule.reports => 'Reports',
      AppModule.account => 'Account',
      AppModule.admin => 'Admin',
    };
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.roleRow});

  final _RoleRow roleRow;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    roleRow.roleLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Sửa'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: roleRow.moduleAccess
                  .map((moduleInfo) {
                    return _ModuleAccessPill(
                      moduleLabel: moduleInfo.moduleLabel,
                      access: moduleInfo.access,
                    );
                  })
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleAccessPill extends StatelessWidget {
  const _ModuleAccessPill({required this.moduleLabel, required this.access});

  final String moduleLabel;
  final ModuleAccess access;

  @override
  Widget build(BuildContext context) {
    final color = switch (access) {
      ModuleAccess.full => AppColors.success,
      ModuleAccess.readOnly => AppColors.warning,
      ModuleAccess.hidden => AppColors.textSecondary,
    };

    final accessLabel = switch (access) {
      ModuleAccess.full => 'full',
      ModuleAccess.readOnly => 'read',
      ModuleAccess.hidden => 'hidden',
    };

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
        '$moduleLabel:$accessLabel',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RoleRow {
  const _RoleRow({required this.roleLabel, required this.moduleAccess});

  final String roleLabel;
  final List<_ModuleAccessInfo> moduleAccess;
}

class _ModuleAccessInfo {
  const _ModuleAccessInfo({required this.moduleLabel, required this.access});

  final String moduleLabel;
  final ModuleAccess access;
}
