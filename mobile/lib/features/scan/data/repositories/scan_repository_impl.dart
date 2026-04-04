import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/data/datasources/scan_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/repositories/scan_repository.dart';

final scanRepositoryProvider = Provider<ScanRepository>((Ref<Object?> ref) {
  return ScanRepositoryImpl(
    apiDataSource: ref.watch(scanApiDataSourceProvider),
  );
});

class ScanRepositoryImpl implements ScanRepository {
  ScanRepositoryImpl({required ScanApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  final ScanApiDataSource _apiDataSource;

  @override
  Future<ScanSessionEntity> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  }) async {
    final draft = await _apiDataSource.lookupReceive(
      context: context,
      lookupCode: lookupCode,
    );
    return draft.toEntity();
  }

  @override
  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  }) async {
    return _apiDataSource.submitReceive(request: request);
  }
}
