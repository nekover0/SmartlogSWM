import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_snapshot_mapper.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';

void main() {
  group('PermissionSnapshotMapper', () {
    test('falls back to role matrix when permissions are empty', () {
      final accessByModule = PermissionSnapshotMapper.toModuleAccess(
        roleCodes: const <String>['WAREHOUSE_KEEPER'],
        permissions: const <String>[],
      );

      expect(accessByModule[AppModule.tasks], ModuleAccess.full);
      expect(accessByModule[AppModule.admin], ModuleAccess.hidden);
    });

    test('elevates module to full when snapshot contains mutation actions', () {
      final accessByModule = PermissionSnapshotMapper.toModuleAccess(
        roleCodes: const <String>['CUSTOMER_VIEWER'],
        permissions: const <String>[
          'inventory.stock.view',
          'inventory.adjust.create',
        ],
      );

      expect(accessByModule[AppModule.inventory], ModuleAccess.full);
    });

    test('maps read-only permission sets to read-only access', () {
      final accessByModule = PermissionSnapshotMapper.toModuleAccess(
        roleCodes: const <String>['CUSTOMER_VIEWER'],
        permissions: const <String>['reports.kpi.view'],
      );

      expect(accessByModule[AppModule.reports], ModuleAccess.readOnly);
    });

    test('supports admin/foundation permission namespaces', () {
      final accessByModule = PermissionSnapshotMapper.toModuleAccess(
        roleCodes: const <String>[],
        permissions: const <String>[
          'foundation.roles.view',
          'foundation.roles.create',
        ],
      );

      expect(accessByModule[AppModule.admin], ModuleAccess.full);
    });
  });
}
