import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/data/datasources/scan_api_data_source.dart';
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
  return ScanRepositoryImpl(
    apiDataSource: ref.watch(scanApiDataSourceProvider),
    fixtureDataSource: ref.watch(scanFixtureDataSourceProvider),
  );
});

class ScanRepositoryImpl implements ScanRepository {
  ScanRepositoryImpl({
    required ScanApiDataSource apiDataSource,
    required ScanFixtureDataSource fixtureDataSource,
  }) : _apiDataSource = apiDataSource,
       _fixtureDataSource = fixtureDataSource;

  final ScanApiDataSource _apiDataSource;
  final ScanFixtureDataSource _fixtureDataSource;

  @override
  Future<ScanSessionEntity> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  }) async {
    try {
      final draft = await _apiDataSource.lookupReceive(
        context: context,
        lookupCode: lookupCode,
      );
      return draft.toEntity();
    } catch (_) {
      final draft = await _fixtureDataSource.lookupReceive(
        context: context,
        lookupCode: lookupCode,
      );
      return draft.toEntity();
    }
  }

  @override
  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  }) async {
    try {
      return await _apiDataSource.submitReceive(request: request);
    } catch (_) {
      return _fixtureDataSource.submitReceive(request: request);
    }
  }
}
