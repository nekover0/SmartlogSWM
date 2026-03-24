import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_service.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_session_controller.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer createContainer({
    PermissionService? permissionService,
  }) {
    return ProviderContainer(
      overrides: [
        permissionServiceProvider.overrideWithValue(
          permissionService ?? const FakePermissionService(),
        ),
      ],
    );
  }

  group('ScanSessionController', () {
    test('moves to scanning when camera access is granted', () async {
      final container = createContainer(
        permissionService: const FakePermissionService(
          currentStatus: CameraPermissionStatus.granted,
        ),
      );
      addTearDown(container.dispose);

      const context = ScanLaunchContext(mode: ScanMode.receive);
      final controller = container.read(
        scanSessionControllerProvider(context).notifier,
      );

      await controller.requestCameraAccess();
      final state = container.read(scanSessionControllerProvider(context));

      expect(state.session.state, ScanSessionState.scanning);
      expect(state.session.cameraGranted, isTrue);
    });

    test('moves to denied state when camera access is rejected', () async {
      final container = createContainer(
        permissionService: const FakePermissionService(
          currentStatus: CameraPermissionStatus.denied,
          requestStatus: CameraPermissionStatus.denied,
        ),
      );
      addTearDown(container.dispose);

      const context = ScanLaunchContext(mode: ScanMode.receive);
      final controller = container.read(
        scanSessionControllerProvider(context).notifier,
      );

      await controller.requestCameraAccess();
      final state = container.read(scanSessionControllerProvider(context));

      expect(state.session.state, ScanSessionState.cameraDenied);
      expect(state.session.cameraGranted, isFalse);
      expect(state.session.errorMessage, contains('quyền camera'));
    });

    test('maps successful lookup into form state and submit request', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      const context = ScanLaunchContext(
        mode: ScanMode.receive,
        referenceId: 'rcp-20260323-001',
        warehouseId: 'warehouse-001',
      );
      final controller = container.read(
        scanSessionControllerProvider(context).notifier,
      );

      await controller.requestCameraAccess();
      await controller.lookupReceiveCode('RCV-240325-001');

      var state = container.read(scanSessionControllerProvider(context));
      expect(state.session.state, ScanSessionState.lookupSuccess);
      expect(state.session.resolvedItemCode, 'SKU-MILK-18L');
      expect(state.session.referenceId, 'rcp-20260323-001');
      expect(state.session.warehouseId, 'warehouse-001');

      controller.prepareReceiveForm();
      controller.updateResolvedLocationCode('DOCK-01');
      controller.updateQuantity(18.5);

      state = container.read(scanSessionControllerProvider(context));
      expect(state.session.state, ScanSessionState.formReady);

      final request = state.submitRequest;
      expect(request.mode, ScanMode.receive);
      expect(request.referenceId, 'rcp-20260323-001');
      expect(request.warehouseId, 'warehouse-001');
      expect(request.itemCode, 'SKU-MILK-18L');
      expect(request.locationCode, 'DOCK-01');
      expect(request.quantity, 18.5);
      expect(state.canSubmit, isTrue);
    });

    test('keeps lookup-not-found state for missing code', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      const context = ScanLaunchContext(mode: ScanMode.receive);
      final controller = container.read(
        scanSessionControllerProvider(context).notifier,
      );

      await controller.requestCameraAccess();
      await controller.lookupReceiveCode('NOT-FOUND');

      final state = container.read(scanSessionControllerProvider(context));
      expect(state.session.state, ScanSessionState.lookupNotFound);
      expect(state.session.errorMessage, contains('Không tìm thấy'));
    });

    test('submits receive flow and stores success result', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      const context = ScanLaunchContext(
        mode: ScanMode.receive,
        referenceId: 'rcp-20260323-001',
        warehouseId: 'warehouse-001',
      );
      final controller = container.read(
        scanSessionControllerProvider(context).notifier,
      );

      await controller.requestCameraAccess();
      await controller.lookupReceiveCode('RCV-240325-001');
      controller.prepareReceiveForm();
      controller.updateResolvedLocationCode('DOCK-01');
      controller.updateQuantity(20);

      await controller.submitReceive();
      final state = container.read(scanSessionControllerProvider(context));

      expect(state.session.state, ScanSessionState.submitSuccess);
      expect(state.flowResult, isNotNull);
      expect(state.flowResult?.referenceId, 'rcp-20260323-001');
      expect(state.flowResult?.warehouseId, 'warehouse-001');
      expect(state.flowResult?.itemCode, 'SKU-MILK-18L');
      expect(state.flowResult?.locationCode, 'DOCK-01');
      expect(state.flowResult?.quantity, 20);
    });
  });
}
