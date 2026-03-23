enum AppRole {
  administrator('Administrator'),
  operationsSupervisor('Operations Supervisor'),
  warehouseManager('Warehouse Manager'),
  warehouseKeeper('Warehouse Keeper'),
  weighbridgeOperator('Weighbridge Operator'),
  customerViewer('Customer Viewer'),
  billingOfficer('Billing Officer'),
  governanceManager('Governance Manager');

  const AppRole(this.label);

  final String label;

  static AppRole fromName(String value) {
    final normalizedValue = value.trim();

    for (final role in AppRole.values) {
      if (role.label == normalizedValue) {
        return role;
      }
    }

    throw ArgumentError.value(value, 'value', 'Unknown app role.');
  }
}

enum AppModule {
  home,
  tasks,
  scan,
  inventory,
  inbound,
  outbound,
  ocr,
  inventoryControl,
  reports,
  account,
  admin,
}

enum ModuleAccess {
  hidden,
  readOnly,
  full;

  bool get canView => this != ModuleAccess.hidden;
  bool get canMutate => this == ModuleAccess.full;
}

abstract final class RoleMatrix {
  static const Map<AppRole, Map<AppModule, ModuleAccess>> _accessByRole = {
    AppRole.administrator: {
      AppModule.home: ModuleAccess.full,
      AppModule.tasks: ModuleAccess.full,
      AppModule.scan: ModuleAccess.full,
      AppModule.inventory: ModuleAccess.full,
      AppModule.inbound: ModuleAccess.full,
      AppModule.outbound: ModuleAccess.full,
      AppModule.ocr: ModuleAccess.full,
      AppModule.inventoryControl: ModuleAccess.full,
      AppModule.reports: ModuleAccess.full,
      AppModule.account: ModuleAccess.full,
      AppModule.admin: ModuleAccess.full,
    },
    AppRole.operationsSupervisor: {
      AppModule.home: ModuleAccess.full,
      AppModule.tasks: ModuleAccess.full,
      AppModule.scan: ModuleAccess.full,
      AppModule.inventory: ModuleAccess.full,
      AppModule.inbound: ModuleAccess.full,
      AppModule.outbound: ModuleAccess.full,
      AppModule.ocr: ModuleAccess.full,
      AppModule.inventoryControl: ModuleAccess.full,
      AppModule.reports: ModuleAccess.full,
      AppModule.account: ModuleAccess.full,
      AppModule.admin: ModuleAccess.hidden,
    },
    AppRole.warehouseManager: {
      AppModule.home: ModuleAccess.full,
      AppModule.tasks: ModuleAccess.full,
      AppModule.scan: ModuleAccess.full,
      AppModule.inventory: ModuleAccess.full,
      AppModule.inbound: ModuleAccess.full,
      AppModule.outbound: ModuleAccess.full,
      AppModule.ocr: ModuleAccess.readOnly,
      AppModule.inventoryControl: ModuleAccess.full,
      AppModule.reports: ModuleAccess.full,
      AppModule.account: ModuleAccess.full,
      AppModule.admin: ModuleAccess.hidden,
    },
    AppRole.warehouseKeeper: {
      AppModule.home: ModuleAccess.full,
      AppModule.tasks: ModuleAccess.full,
      AppModule.scan: ModuleAccess.full,
      AppModule.inventory: ModuleAccess.full,
      AppModule.inbound: ModuleAccess.full,
      AppModule.outbound: ModuleAccess.full,
      AppModule.ocr: ModuleAccess.readOnly,
      AppModule.inventoryControl: ModuleAccess.full,
      AppModule.reports: ModuleAccess.readOnly,
      AppModule.account: ModuleAccess.full,
      AppModule.admin: ModuleAccess.hidden,
    },
    AppRole.weighbridgeOperator: {
      AppModule.home: ModuleAccess.readOnly,
      AppModule.tasks: ModuleAccess.full,
      AppModule.scan: ModuleAccess.full,
      AppModule.inventory: ModuleAccess.readOnly,
      AppModule.inbound: ModuleAccess.full,
      AppModule.outbound: ModuleAccess.full,
      AppModule.ocr: ModuleAccess.readOnly,
      AppModule.inventoryControl: ModuleAccess.hidden,
      AppModule.reports: ModuleAccess.readOnly,
      AppModule.account: ModuleAccess.full,
      AppModule.admin: ModuleAccess.hidden,
    },
    AppRole.customerViewer: {
      AppModule.home: ModuleAccess.readOnly,
      AppModule.tasks: ModuleAccess.hidden,
      AppModule.scan: ModuleAccess.hidden,
      AppModule.inventory: ModuleAccess.readOnly,
      AppModule.inbound: ModuleAccess.hidden,
      AppModule.outbound: ModuleAccess.hidden,
      AppModule.ocr: ModuleAccess.hidden,
      AppModule.inventoryControl: ModuleAccess.hidden,
      AppModule.reports: ModuleAccess.readOnly,
      AppModule.account: ModuleAccess.full,
      AppModule.admin: ModuleAccess.hidden,
    },
    AppRole.billingOfficer: {
      AppModule.home: ModuleAccess.readOnly,
      AppModule.tasks: ModuleAccess.readOnly,
      AppModule.scan: ModuleAccess.hidden,
      AppModule.inventory: ModuleAccess.readOnly,
      AppModule.inbound: ModuleAccess.readOnly,
      AppModule.outbound: ModuleAccess.readOnly,
      AppModule.ocr: ModuleAccess.hidden,
      AppModule.inventoryControl: ModuleAccess.hidden,
      AppModule.reports: ModuleAccess.full,
      AppModule.account: ModuleAccess.full,
      AppModule.admin: ModuleAccess.hidden,
    },
    AppRole.governanceManager: {
      AppModule.home: ModuleAccess.readOnly,
      AppModule.tasks: ModuleAccess.readOnly,
      AppModule.scan: ModuleAccess.hidden,
      AppModule.inventory: ModuleAccess.readOnly,
      AppModule.inbound: ModuleAccess.readOnly,
      AppModule.outbound: ModuleAccess.readOnly,
      AppModule.ocr: ModuleAccess.readOnly,
      AppModule.inventoryControl: ModuleAccess.readOnly,
      AppModule.reports: ModuleAccess.full,
      AppModule.account: ModuleAccess.full,
      AppModule.admin: ModuleAccess.hidden,
    },
  };

  static ModuleAccess accessFor({
    required AppRole role,
    required AppModule module,
  }) {
    return _accessByRole[role]?[module] ?? ModuleAccess.hidden;
  }

  static bool canAccess({
    required AppRole role,
    required AppModule module,
  }) {
    return accessFor(role: role, module: module).canView;
  }
}
