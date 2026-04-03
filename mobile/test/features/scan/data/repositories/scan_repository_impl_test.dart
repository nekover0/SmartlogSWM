import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/data/datasources/scan_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/scan/data/datasources/scan_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/scan/data/repositories/scan_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('ScanRepositoryImpl', () {
    test('uses API datasource for lookup when API succeeds', () async {
      final apiDataSource = _FakeScanApiDataSource(
        lookupResponse: _buildDraft(
          id: 'api-scan-001',
          lookupCode: 'RCV-001',
          mode: ScanMode.receive,
          state: ScanSessionState.lookupSuccess,
          referenceId: 'ref-001',
          warehouseId: 'wh-001',
        ),
      );
      final fixtureDataSource = _FakeScanFixtureDataSource(
        lookupResponse: _buildDraft(
          id: 'fixture-scan-001',
          lookupCode: 'RCV-001',
          mode: ScanMode.receive,
          state: ScanSessionState.lookupSuccess,
          referenceId: 'ref-001',
          warehouseId: 'wh-001',
        ),
      );
      final repository = ScanRepositoryImpl(
        apiDataSource: apiDataSource,
        fixtureDataSource: fixtureDataSource,
      );

      final result = await repository.lookupReceive(
        context: const ScanLaunchContext(
          mode: ScanMode.receive,
          referenceId: 'ref-001',
          warehouseId: 'wh-001',
        ),
        lookupCode: 'RCV-001',
      );

      expect(result.id, 'api-scan-001');
      expect(apiDataSource.lookupCallCount, 1);
      expect(fixtureDataSource.lookupCallCount, 0);
    });

    test('falls back to fixture datasource when lookup API fails', () async {
      final apiDataSource = _FakeScanApiDataSource(
        lookupError: StateError('backend unavailable'),
      );
      final fixtureDataSource = _FakeScanFixtureDataSource(
        lookupResponse: _buildDraft(
          id: 'fixture-scan-002',
          lookupCode: 'RCV-002',
          mode: ScanMode.receive,
          state: ScanSessionState.lookupSuccess,
          referenceId: 'ref-002',
          warehouseId: 'wh-002',
        ),
      );
      final repository = ScanRepositoryImpl(
        apiDataSource: apiDataSource,
        fixtureDataSource: fixtureDataSource,
      );

      final result = await repository.lookupReceive(
        context: const ScanLaunchContext(
          mode: ScanMode.receive,
          referenceId: 'ref-002',
          warehouseId: 'wh-002',
        ),
        lookupCode: 'RCV-002',
      );

      expect(result.id, 'fixture-scan-002');
      expect(apiDataSource.lookupCallCount, 1);
      expect(fixtureDataSource.lookupCallCount, 1);
    });

    test('uses API datasource for submit when API succeeds', () async {
      final apiDataSource = _FakeScanApiDataSource(
        submitResponse: _buildFlowResult(
          mode: ScanMode.receive,
          sessionId: 'api-session-001',
          referenceId: 'ref-003',
          warehouseId: 'wh-003',
        ),
      );
      final fixtureDataSource = _FakeScanFixtureDataSource(
        submitResponse: _buildFlowResult(
          mode: ScanMode.receive,
          sessionId: 'fixture-session-001',
          referenceId: 'ref-003',
          warehouseId: 'wh-003',
        ),
      );
      final repository = ScanRepositoryImpl(
        apiDataSource: apiDataSource,
        fixtureDataSource: fixtureDataSource,
      );

      final result = await repository.submitReceive(
        request: const ScanSubmitRequestDto(
          sessionId: 'api-session-001',
          mode: ScanMode.receive,
          referenceId: 'ref-003',
          warehouseId: 'wh-003',
          itemCode: 'ITEM-003',
          locationCode: 'C-01-01',
          quantity: 12,
        ),
      );

      expect(result.sessionId, 'api-session-001');
      expect(apiDataSource.submitCallCount, 1);
      expect(fixtureDataSource.submitCallCount, 0);
    });

    test('falls back to fixture datasource when submit API fails', () async {
      final apiDataSource = _FakeScanApiDataSource(
        submitError: StateError('submit failed'),
      );
      final fixtureDataSource = _FakeScanFixtureDataSource(
        submitResponse: _buildFlowResult(
          mode: ScanMode.receive,
          sessionId: 'fixture-session-002',
          referenceId: 'ref-004',
          warehouseId: 'wh-004',
        ),
      );
      final repository = ScanRepositoryImpl(
        apiDataSource: apiDataSource,
        fixtureDataSource: fixtureDataSource,
      );

      final result = await repository.submitReceive(
        request: const ScanSubmitRequestDto(
          sessionId: 'api-session-002',
          mode: ScanMode.receive,
          referenceId: 'ref-004',
          warehouseId: 'wh-004',
          itemCode: 'ITEM-004',
          locationCode: 'D-01-01',
          quantity: 7,
        ),
      );

      expect(result.sessionId, 'fixture-session-002');
      expect(apiDataSource.submitCallCount, 1);
      expect(fixtureDataSource.submitCallCount, 1);
    });
  });
}

ScanSessionDraftDto _buildDraft({
  required String id,
  required String lookupCode,
  required ScanMode mode,
  required ScanSessionState state,
  required String referenceId,
  required String warehouseId,
}) {
  final now = DateTime.utc(2026, 4, 4, 0, 0, 0);
  return ScanSessionDraftDto(
    id: id,
    mode: mode,
    state: state,
    cameraGranted: true,
    lookupCode: lookupCode,
    resolvedItemCode: 'SKU-001',
    resolvedLocationCode: 'A-01-01',
    referenceId: referenceId,
    warehouseId: warehouseId,
    quantity: 10,
    syncState: SyncState.synced,
    startedAt: now,
    updatedAt: now,
  );
}

ScanFlowResult _buildFlowResult({
  required ScanMode mode,
  required String sessionId,
  required String referenceId,
  required String warehouseId,
}) {
  return ScanFlowResult(
    mode: mode,
    success: true,
    sessionId: sessionId,
    referenceId: referenceId,
    warehouseId: warehouseId,
    itemCode: 'SKU-001',
    locationCode: 'A-01-01',
    quantity: 10,
    submittedAt: DateTime.utc(2026, 4, 4, 0, 10, 0),
    message: 'Submitted',
  );
}

class _FakeScanApiDataSource extends ScanApiDataSource {
  _FakeScanApiDataSource({
    this.lookupResponse,
    this.lookupError,
    this.submitResponse,
    this.submitError,
  }) : super(httpClient: _NoopAppHttpClient());

  final ScanSessionDraftDto? lookupResponse;
  final Object? lookupError;
  final ScanFlowResult? submitResponse;
  final Object? submitError;

  int lookupCallCount = 0;
  int submitCallCount = 0;

  @override
  Future<ScanSessionDraftDto> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  }) async {
    lookupCallCount += 1;
    if (lookupError != null) {
      throw lookupError!;
    }

    return lookupResponse ??
        _buildDraft(
          id: 'api-default',
          lookupCode: lookupCode,
          mode: context.mode,
          state: ScanSessionState.lookupSuccess,
          referenceId: context.referenceId ?? 'ref-default',
          warehouseId: context.warehouseId ?? 'wh-default',
        );
  }

  @override
  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  }) async {
    submitCallCount += 1;
    if (submitError != null) {
      throw submitError!;
    }

    return submitResponse ??
        _buildFlowResult(
          mode: request.mode,
          sessionId: request.sessionId ?? 'api-default',
          referenceId: request.referenceId ?? 'ref-default',
          warehouseId: request.warehouseId ?? 'wh-default',
        );
  }
}

class _FakeScanFixtureDataSource extends ScanFixtureDataSource {
  _FakeScanFixtureDataSource({
    this.lookupResponse,
    this.lookupError,
    this.submitResponse,
    this.submitError,
  }) : super(assetBundle: rootBundle);

  final ScanSessionDraftDto? lookupResponse;
  final Object? lookupError;
  final ScanFlowResult? submitResponse;
  final Object? submitError;

  int lookupCallCount = 0;
  int submitCallCount = 0;

  @override
  Future<ScanSessionDraftDto> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  }) async {
    lookupCallCount += 1;
    if (lookupError != null) {
      throw lookupError!;
    }

    return lookupResponse ??
        _buildDraft(
          id: 'fixture-default',
          lookupCode: lookupCode,
          mode: context.mode,
          state: ScanSessionState.lookupSuccess,
          referenceId: context.referenceId ?? 'ref-default',
          warehouseId: context.warehouseId ?? 'wh-default',
        );
  }

  @override
  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  }) async {
    submitCallCount += 1;
    if (submitError != null) {
      throw submitError!;
    }

    return submitResponse ??
        _buildFlowResult(
          mode: request.mode,
          sessionId: request.sessionId ?? 'fixture-default',
          referenceId: request.referenceId ?? 'ref-default',
          warehouseId: request.warehouseId ?? 'wh-default',
        );
  }
}

class _NoopAppHttpClient implements AppHttpClient {
  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }
}
