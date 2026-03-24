import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';

class ScanFixtureDataSource {
  ScanFixtureDataSource({
    AssetBundle? assetBundle,
    this.lookupSuccessPath = _defaultLookupSuccessPath,
    this.lookupNotFoundPath = _defaultLookupNotFoundPath,
    this.submitSuccessPath = _defaultSubmitSuccessPath,
  }) : _assetBundle = assetBundle ?? rootBundle;

  static const String _defaultLookupSuccessPath =
      'assets/fixtures/scan/lookup_receive_success.json';
  static const String _defaultLookupNotFoundPath =
      'assets/fixtures/scan/lookup_receive_not_found.json';
  static const String _defaultSubmitSuccessPath =
      'assets/fixtures/scan/submit_receive_success.json';

  final AssetBundle _assetBundle;
  final String lookupSuccessPath;
  final String lookupNotFoundPath;
  final String submitSuccessPath;

  Future<ScanSessionDraftDto> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  }) async {
    final fixturePath = _isNotFoundCode(lookupCode)
        ? lookupNotFoundPath
        : lookupSuccessPath;
    final dto = await _loadDraft(fixturePath);

    return dto.copyWith(
      id: 'scan-${context.mode.name}-${lookupCode.trim().toLowerCase()}',
      lookupCode: lookupCode.trim(),
      referenceId: context.referenceId ?? dto.referenceId,
      warehouseId: context.warehouseId ?? dto.warehouseId,
    );
  }

  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  }) async {
    final result = await _loadResult(submitSuccessPath);
    return result.copyWith(
      referenceId: request.referenceId ?? result.referenceId,
      warehouseId: request.warehouseId ?? result.warehouseId,
      itemCode: request.itemCode ?? result.itemCode,
      locationCode: request.locationCode ?? result.locationCode,
      quantity: request.quantity ?? result.quantity,
    );
  }

  Future<ScanSessionDraftDto> _loadDraft(String fixturePath) async {
    final rawJson = await _assetBundle.loadString(fixturePath);
    return ScanSessionDraftDto.fromJson(
      jsonDecode(rawJson) as Map<String, dynamic>,
    );
  }

  Future<ScanFlowResult> _loadResult(String fixturePath) async {
    final rawJson = await _assetBundle.loadString(fixturePath);
    return ScanFlowResult.fromJson(jsonDecode(rawJson) as Map<String, dynamic>);
  }

  bool _isNotFoundCode(String lookupCode) {
    final normalizedCode = lookupCode.trim().toUpperCase();
    return normalizedCode == 'NOT-FOUND' || normalizedCode == 'NOT_FOUND';
  }
}
