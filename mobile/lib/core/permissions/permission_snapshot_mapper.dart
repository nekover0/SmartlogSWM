import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';

abstract final class PermissionSnapshotMapper {
  static Map<AppModule, ModuleAccess> toModuleAccess({
    required List<String> roleCodes,
    required List<String> permissions,
  }) {
    final baselineRole = _resolveBaselineRole(roleCodes);
    final normalizedPermissions = permissions
        .map((String permission) => permission.trim().toLowerCase())
        .where((String permission) => permission.isNotEmpty)
        .toList(growable: false);

    final accessByModule = <AppModule, ModuleAccess>{};
    for (final module in AppModule.values) {
      final baselineAccess = baselineRole == null
          ? ModuleAccess.hidden
          : RoleMatrix.accessFor(role: baselineRole, module: module);
      final modulePermissions = normalizedPermissions
          .where(
            (String permission) => _isPermissionOfModule(module, permission),
          )
          .toList(growable: false);

      if (modulePermissions.isEmpty) {
        accessByModule[module] = baselineAccess;
        continue;
      }

      final hasMutation = modulePermissions.any(_isMutationPermission);
      accessByModule[module] = hasMutation
          ? ModuleAccess.full
          : ModuleAccess.readOnly;
    }

    return accessByModule;
  }

  static AppRole? _resolveBaselineRole(List<String> roleCodes) {
    for (final roleCode in roleCodes) {
      if (roleCode.trim().isEmpty) {
        continue;
      }

      try {
        return AppRole.fromName(roleCode);
      } catch (_) {
        continue;
      }
    }

    return null;
  }

  static bool _isPermissionOfModule(AppModule module, String permission) {
    final prefixes = switch (module) {
      AppModule.home => const <String>['home.', 'dashboard.', 'overview.'],
      AppModule.tasks => const <String>[
        'task.',
        'tasks.',
        'work_execution.',
        'work.',
      ],
      AppModule.scan => const <String>['scan.', 'barcode.'],
      AppModule.inventory => const <String>[
        'inventory.',
        'stock.',
        'master_data.',
      ],
      AppModule.inbound => const <String>['inbound.', 'receipt.', 'receiving.'],
      AppModule.outbound => const <String>[
        'outbound.',
        'shipment.',
        'delivery.',
      ],
      AppModule.ocr => const <String>['ocr.', 'document_ocr.'],
      AppModule.inventoryControl => const <String>[
        'inventory_control.',
        'stocktake.',
        'cycle_count.',
        'relocation.',
      ],
      AppModule.reports => const <String>[
        'report.',
        'reports.',
        'analytics.',
        'billing.',
      ],
      AppModule.account => const <String>[
        'profile.',
        'account.',
        'session.',
        'password.',
      ],
      AppModule.admin => const <String>[
        'foundation.',
        'admin.',
        'rbac.',
        'users.',
        'roles.',
      ],
    };

    return prefixes.any(permission.startsWith);
  }

  static bool _isMutationPermission(String permission) {
    final segments = permission.split('.');
    final action = segments.isEmpty ? permission : segments.last;

    const readOnlyActions = <String>{
      'view',
      'read',
      'list',
      'search',
      'get',
      'export',
      'download',
    };

    return !readOnlyActions.contains(action);
  }
}
