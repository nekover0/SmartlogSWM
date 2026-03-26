import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/data/datasources/scan_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/repositories/scan_repository.dart';

final scanFixtureDataSourceProvider = Provider<ScanFixtureDataSource>((
  Ref<Object?> ref,
) {
  return ScanFixtureDataSource();
});

final scanRepositoryProvider = Provider<ScanRepository>((Ref<Object?> ref) {
  // TODO(real-api): replace fixture datasource provider with API datasource
  // once scan.lookupReceive and scan.submitReceive endpoints are available.
  return ScanRepositoryImpl(
    fixtureDataSource: ref.watch(scanFixtureDataSourceProvider),
  );
});

class ScanRepositoryImpl implements ScanRepository {
  ScanRepositoryImpl({required ScanFixtureDataSource fixtureDataSource})
    : _fixtureDataSource = fixtureDataSource;

  final ScanFixtureDataSource _fixtureDataSource;

  @override
  Future<ScanSessionEntity> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  }) async {
    // TODO(real-api): route lookup to API datasource and keep fixture fallback
    // behind a feature flag for local/offline test scenarios.
    final draft = await _fixtureDataSource.lookupReceive(
      context: context,
      lookupCode: lookupCode,
    );
    return draft.toEntity();
  }

  @override
  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  }) {
    // TODO(real-api): call submit endpoint with idempotency key and map
    // backend error codes to domain-safe messages.
    return _fixtureDataSource.submitReceive(request: request);
  }
}
