import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_service.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_session_controller.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/data/repositories/scan_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/repositories/scan_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer createContainer({
    PermissionService? permissionService,
    ScanRepository? scanRepository,
  }) {
    final resolvedScanRepository = scanRepository ?? _CountingScanRepository();

    return ProviderContainer(
      overrides: [
        permissionServiceProvider.overrideWithValue(
          permissionService ?? const FakePermissionService(),
        ),
        scanRepositoryProvider.overrideWithValue(resolvedScanRepository),
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

    test('onCodeDetected triggers lookup path for scanned payload', () async {
      final repository = _CountingScanRepository();
      final container = createContainer(scanRepository: repository);
      addTearDown(container.dispose);

      const context = ScanLaunchContext(mode: ScanMode.receive);
      final controller = container.read(
        scanSessionControllerProvider(context).notifier,
      );

      await controller.requestCameraAccess();
      await controller.onCodeDetected('  RCV-240325-001  ');

      final state = container.read(scanSessionControllerProvider(context));
      expect(repository.lookupCodes, ['RCV-240325-001']);
      expect(state.session.state, ScanSessionState.lookupSuccess);
    });

    test('dedupe guard suppresses immediate duplicate scan payload', () async {
      final repository = _CountingScanRepository();
      final container = createContainer(scanRepository: repository);
      addTearDown(container.dispose);

      const context = ScanLaunchContext(mode: ScanMode.receive);
      final controller = container.read(
        scanSessionControllerProvider(context).notifier,
      );

      await controller.requestCameraAccess();
      await controller.onCodeDetected('rcv-dup-001');
      await controller.onCodeDetected('RCV-DUP-001');

      expect(repository.lookupCodes.length, 1);
      expect(repository.lookupCodes.first, 'rcv-dup-001');
    });

    test(
      'restartScanning clears dedupe memory for next identical scan',
      () async {
        final repository = _CountingScanRepository();
        final container = createContainer(scanRepository: repository);
        addTearDown(container.dispose);

        const context = ScanLaunchContext(mode: ScanMode.receive);
        final controller = container.read(
          scanSessionControllerProvider(context).notifier,
        );

        await controller.requestCameraAccess();
        await controller.onCodeDetected('RCV-RESET-001');
        await controller.restartScanning();
        await controller.onCodeDetected('RCV-RESET-001');

        expect(repository.lookupCodes.length, 2);
      },
    );
  });
}

class _CountingScanRepository implements ScanRepository {
  final List<String> lookupCodes = <String>[];

  @override
  Future<ScanSessionEntity> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  }) async {
    final trimmedCode = lookupCode.trim();
    lookupCodes.add(trimmedCode);

    final isNotFound = trimmedCode.toUpperCase() == 'NOT-FOUND';
    final now = DateTime.now().toUtc();

    return ScanSessionEntity(
      id: 'scan-${context.mode.name}-$trimmedCode',
      mode: context.mode,
      state: isNotFound
          ? ScanSessionState.lookupNotFound
          : ScanSessionState.lookupSuccess,
      cameraGranted: true,
      lookupCode: trimmedCode,
      resolvedItemCode: isNotFound ? null : 'SKU-MILK-18L',
      resolvedLocationCode: isNotFound ? null : 'RCV-STAGE-01',
      referenceId: context.referenceId,
      warehouseId: context.warehouseId,
      quantity: isNotFound ? null : 12,
      errorMessage: isNotFound ? 'Không tìm thấy mã quét.' : null,
      syncState: isNotFound ? SyncState.failed : SyncState.pending,
      startedAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  }) async {
    return ScanFlowResult(
      mode: request.mode,
      sessionId: request.sessionId,
      referenceId: request.referenceId,
      warehouseId: request.warehouseId,
      itemCode: request.itemCode,
      locationCode: request.locationCode,
      quantity: request.quantity,
      submittedAt: DateTime.now().toUtc(),
      success: true,
    );
  }
}
