import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';

abstract interface class ScanRepository {
  Future<ScanSessionEntity> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  });

  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  });
}
