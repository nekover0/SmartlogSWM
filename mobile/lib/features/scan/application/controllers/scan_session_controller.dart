import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_service.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/data/repositories/scan_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/repositories/scan_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final scanSessionControllerProvider = NotifierProviderFamily<
  ScanSessionController,
  ScanSessionControllerState,
  ScanLaunchContext
>(ScanSessionController.new);

class ScanSessionController
    extends FamilyNotifier<ScanSessionControllerState, ScanLaunchContext> {
  PermissionService get _permissionService => ref.read(permissionServiceProvider);
  ScanRepository get _scanRepository => ref.read(scanRepositoryProvider);

  @override
  ScanSessionControllerState build(ScanLaunchContext context) {
    return ScanSessionControllerState.initial(context);
  }

  Future<void> requestCameraAccess() async {
    state = state.copyWith(
      session: _mutateSession(
        state.session,
        state: ScanSessionState.permissionPending,
        errorMessage: null,
      ),
      flowResult: null,
    );

    final currentStatus = await _permissionService.getCameraPermissionStatus();
    final resolvedStatus = currentStatus == CameraPermissionStatus.granted
        ? currentStatus
        : await _permissionService.requestCameraPermission();

    if (resolvedStatus == CameraPermissionStatus.granted) {
      state = state.copyWith(
        session: _mutateSession(
          state.session,
          state: ScanSessionState.scanning,
          cameraGranted: true,
          errorMessage: null,
          syncState: SyncState.pending,
        ),
      );
      return;
    }

    state = state.copyWith(
      session: _mutateSession(
        state.session,
        state: ScanSessionState.cameraDenied,
        cameraGranted: false,
        errorMessage: 'Cần cấp quyền camera để tiếp tục quét barcode.',
        syncState: SyncState.failed,
      ),
    );
  }

  Future<void> restartScanning() async {
    if (!state.session.cameraGranted) {
      await requestCameraAccess();
      return;
    }

    state = state.copyWith(
      session: _mutateSession(
        state.session,
        state: ScanSessionState.scanning,
        lookupCode: null,
        errorMessage: null,
        syncState: SyncState.pending,
      ),
      flowResult: null,
    );
  }

  Future<void> lookupReceiveCode(String lookupCode) async {
    if (!state.context.isReceive) {
      state = state.copyWith(
        session: _mutateSession(
          state.session,
          state: ScanSessionState.lookupNotFound,
          lookupCode: lookupCode.trim(),
          errorMessage: 'Chỉ hỗ trợ luồng receive ở phiên bản hiện tại.',
          syncState: SyncState.failed,
        ),
      );
      return;
    }

    state = state.copyWith(
      session: _mutateSession(
        state.session,
        state: ScanSessionState.scanning,
        lookupCode: lookupCode.trim(),
        errorMessage: null,
      ),
      flowResult: null,
    );

    try {
      final lookedUpSession = await _scanRepository.lookupReceive(
        context: state.context,
        lookupCode: lookupCode,
      );
      final mergedSession = lookedUpSession.copyWith(
        referenceId: lookedUpSession.referenceId ?? state.context.referenceId,
        warehouseId: lookedUpSession.warehouseId ?? state.context.warehouseId,
        cameraGranted: true,
      );

      state = state.copyWith(session: mergedSession);
    } catch (error) {
      state = state.copyWith(
        session: _mutateSession(
          state.session,
          state: ScanSessionState.lookupNotFound,
          lookupCode: lookupCode.trim(),
          errorMessage: '$error',
          syncState: SyncState.failed,
        ),
      );
    }
  }

  void prepareReceiveForm() {
    if (state.session.state != ScanSessionState.lookupSuccess &&
        state.session.state != ScanSessionState.formReady) {
      return;
    }

    state = state.copyWith(
      session: _mutateSession(
        state.session,
        state: ScanSessionState.formReady,
        errorMessage: null,
      ),
    );
  }

  void updateReferenceId(String value) {
    state = state.copyWith(
      session: _mutateSession(
        state.session,
        referenceId: _normalizeText(value),
      ),
    );
  }

  void updateWarehouseId(String value) {
    state = state.copyWith(
      session: _mutateSession(
        state.session,
        warehouseId: _normalizeText(value),
      ),
    );
  }

  void updateResolvedLocationCode(String value) {
    state = state.copyWith(
      session: _mutateSession(
        state.session,
        resolvedLocationCode: _normalizeText(value),
      ),
    );
  }

  void updateQuantity(double quantity) {
    state = state.copyWith(
      session: _mutateSession(
        state.session,
        quantity: quantity,
      ),
    );
  }

  Future<void> submitReceive() async {
    if (!state.canSubmit) {
      state = state.copyWith(
        session: _mutateSession(
          state.session,
          state: ScanSessionState.submitFailed,
          errorMessage: 'Phiên scan chưa đủ dữ liệu để submit.',
          syncState: SyncState.failed,
        ),
      );
      return;
    }

    state = state.copyWith(
      session: _mutateSession(
        state.session,
        state: ScanSessionState.submitting,
        errorMessage: null,
      ),
      flowResult: null,
    );

    try {
      final request = state.submitRequest;
      final result = await _scanRepository.submitReceive(request: request);
      final submittedAt = result.submittedAt ?? DateTime.now().toUtc();

      state = state.copyWith(
        session: state.session.copyWith(
          state: ScanSessionState.submitSuccess,
          syncState: SyncState.synced,
          submittedAt: submittedAt,
          updatedAt: submittedAt,
          errorMessage: null,
        ),
        flowResult: result.copyWith(
          sessionId: result.sessionId ?? state.session.id,
          referenceId: result.referenceId ?? request.referenceId,
          warehouseId: result.warehouseId ?? request.warehouseId,
          itemCode: result.itemCode ?? request.itemCode,
          locationCode: result.locationCode ?? request.locationCode,
          quantity: result.quantity ?? request.quantity,
          submittedAt: submittedAt,
        ),
      );
    } catch (error) {
      state = state.copyWith(
        session: _mutateSession(
          state.session,
          state: ScanSessionState.submitFailed,
          errorMessage: '$error',
          syncState: SyncState.failed,
        ),
      );
    }
  }

  ScanSessionEntity _mutateSession(
    ScanSessionEntity session, {
    ScanSessionState? state,
    bool? cameraGranted,
    String? lookupCode,
    String? resolvedLocationCode,
    String? referenceId,
    String? warehouseId,
    double? quantity,
    String? errorMessage,
    SyncState? syncState,
  }) {
    return session.copyWith(
      state: state ?? session.state,
      cameraGranted: cameraGranted ?? session.cameraGranted,
      lookupCode: lookupCode ?? session.lookupCode,
      resolvedLocationCode: resolvedLocationCode ?? session.resolvedLocationCode,
      referenceId: referenceId ?? session.referenceId,
      warehouseId: warehouseId ?? session.warehouseId,
      quantity: quantity ?? session.quantity,
      errorMessage: errorMessage ?? session.errorMessage,
      syncState: syncState ?? session.syncState,
      updatedAt: DateTime.now().toUtc(),
    );
  }
}

class ScanSessionControllerState {
  const ScanSessionControllerState({
    required this.context,
    required this.session,
    this.flowResult,
  });

  final ScanLaunchContext context;
  final ScanSessionEntity session;
  final ScanFlowResult? flowResult;

  factory ScanSessionControllerState.initial(ScanLaunchContext context) {
    final timestamp = DateTime.now().toUtc();
    return ScanSessionControllerState(
      context: context,
      session: ScanSessionEntity(
        id: 'scan-${context.mode.name}-${context.referenceId ?? 'local'}',
        mode: context.mode,
        state: ScanSessionState.idle,
        cameraGranted: false,
        referenceId: context.referenceId,
        warehouseId: context.warehouseId,
        syncState: SyncState.pending,
        startedAt: timestamp,
        updatedAt: timestamp,
      ),
    );
  }

  ScanSubmitRequestDto get submitRequest {
    final draft = session.toSubmitRequest();
    return draft.copyWith(
      referenceId: draft.referenceId ?? context.referenceId,
      warehouseId: draft.warehouseId ?? context.warehouseId,
    );
  }

  bool get canSubmit {
    final request = submitRequest;
    final quantity = request.quantity ?? 0;
    return context.isReceive &&
        session.state == ScanSessionState.formReady &&
        quantity > 0 &&
        _hasValue(request.referenceId) &&
        _hasValue(request.warehouseId) &&
        _hasValue(request.itemCode) &&
        _hasValue(request.locationCode);
  }

  ScanSessionControllerState copyWith({
    ScanLaunchContext? context,
    ScanSessionEntity? session,
    ScanFlowResult? flowResult,
    bool clearFlowResult = false,
  }) {
    return ScanSessionControllerState(
      context: context ?? this.context,
      session: session ?? this.session,
      flowResult: clearFlowResult ? null : flowResult ?? this.flowResult,
    );
  }
}

String? _normalizeText(String value) {
  final normalizedValue = value.trim();
  return normalizedValue.isEmpty ? null : normalizedValue;
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
