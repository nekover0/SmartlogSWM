import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_names.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';

void main() {
  group('AppRoutePaths', () {
    test('defines stable shell and feature paths', () {
      expect(AppRoutePaths.login, '/login');
      expect(AppRoutePaths.home, '/home');
      expect(AppRoutePaths.tasks, '/tasks');
      expect(AppRoutePaths.receiptList, '/inbound/receipts');
      expect(AppRoutePaths.receiptDetail, '/inbound/receipts/:receiptId');
      expect(AppRoutePaths.scanBarcode, '/scan/barcode');
    });

    test('builds concrete paths for deep links', () {
      expect(AppRoutePaths.tasksPath(type: 'weighing'), '/tasks?type=weighing');
      expect(
        AppRoutePaths.receiptDetailPath('rcp-001'),
        '/inbound/receipts/rcp-001',
      );
      expect(AppRoutePaths.ocrReviewPath('ocr-01'), '/ocr/ocr-01/review');
    });
  });

  group('AppRouteNames', () {
    test('matches route ids from the mobile navigation spec', () {
      expect(AppRouteNames.home, 'home');
      expect(AppRouteNames.tasks, 'tasks');
      expect(AppRouteNames.inventoryList, 'inventory_list');
      expect(AppRouteNames.receiptDetail, 'receipt_detail');
      expect(AppRouteNames.scanBarcode, 'scan_barcode');
      expect(AppRouteNames.rbacProfile, 'rbac_profile');
    });
  });

  group('RoleMatrix', () {
    test('returns full, read-only, and hidden access by role', () {
      expect(
        RoleMatrix.accessFor(
          role: AppRole.warehouseKeeper,
          module: AppModule.tasks,
        ),
        ModuleAccess.full,
      );
      expect(
        RoleMatrix.accessFor(
          role: AppRole.warehouseKeeper,
          module: AppModule.ocr,
        ),
        ModuleAccess.readOnly,
      );
      expect(
        RoleMatrix.accessFor(
          role: AppRole.customerViewer,
          module: AppModule.tasks,
        ),
        ModuleAccess.hidden,
      );
      expect(
        RoleMatrix.accessFor(
          role: AppRole.administrator,
          module: AppModule.admin,
        ),
        ModuleAccess.full,
      );
    });
  });

  group('RoleGuard', () {
    test('maps role labels to the expected default landing locations', () {
      expect(
        RoleGuard.defaultLandingPathForRoleName('Warehouse Keeper'),
        AppRoutePaths.tasks,
      );
      expect(
        RoleGuard.defaultLandingPathForRoleName('Weighbridge Operator'),
        '/tasks?type=weighing',
      );
      expect(
        RoleGuard.defaultLandingPathForRoleName('Customer Viewer'),
        AppRoutePaths.inventory,
      );
    });

    test('checks module and route access from the centralized matrix', () {
      expect(
        RoleGuard.canAccessModule(
          roleName: 'Billing Officer',
          module: AppModule.scan,
        ),
        isFalse,
      );
      expect(
        RoleGuard.canAccessLocation(
          roleName: 'Billing Officer',
          location: AppRoutePaths.scanBarcode,
        ),
        isFalse,
      );
      expect(
        RoleGuard.canAccessLocation(
          roleName: 'Billing Officer',
          location: AppRoutePaths.permissions,
        ),
        isTrue,
      );
      expect(
        RoleGuard.canAccessLocation(
          roleName: 'Warehouse Keeper',
          location: AppRoutePaths.receiptDetailPath('rcp-001'),
        ),
        isTrue,
      );
    });

    test('derives shell fallback and visibility helpers', () {
      expect(
        RoleGuard.firstAllowedShellPathForRoleName('Customer Viewer'),
        AppRoutePaths.home,
      );
      expect(RoleGuard.showsTasksTab('Customer Viewer'), isFalse);
      expect(RoleGuard.showsScanFab('Warehouse Keeper'), isTrue);
      expect(RoleGuard.showsScanFab('Governance Manager'), isFalse);
    });
  });
}
