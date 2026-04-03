import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final scanApiDataSourceProvider = Provider<ScanApiDataSource>((
  Ref<Object?> ref,
) {
  return ScanApiDataSource(httpClient: ref.watch(appHttpClientProvider));
});

class ScanApiDataSource {
  ScanApiDataSource({required AppHttpClient httpClient})
    : _httpClient = httpClient;

  static const String _lookupReceivePath = '/api/v1/scan/lookup-receive';
  static const String _submitReceivePath = '/api/v1/scan/submit-receive';

  final AppHttpClient _httpClient;

  Future<ScanSessionDraftDto> lookupReceive({
    required ScanLaunchContext context,
    required String lookupCode,
  }) async {
    final normalizedLookupCode = lookupCode.trim();
    final request = LookupReceiveRequestDto(
      mode: context.mode,
      lookupCode: normalizedLookupCode,
      warehouseId: context.warehouseId,
      referenceId: context.referenceId,
    );

    final response = await _httpClient.postMap(
      _lookupReceivePath,
      data: request.toJson(),
    );

    return _mapLookupResponseToDraft(
      response: response,
      context: context,
      lookupCode: normalizedLookupCode,
    );
  }

  Future<ScanFlowResult> submitReceive({
    required ScanSubmitRequestDto request,
  }) async {
    final response = await _httpClient.postMap(
      _submitReceivePath,
      data: request.toJson(),
    );

    final normalizedResponse = <String, dynamic>{
      ...response,
      'mode': response['mode'] ?? request.mode.name,
      'success': response['success'] ?? true,
      'reference_id': response['reference_id'] ?? request.referenceId,
      'warehouse_id': response['warehouse_id'] ?? request.warehouseId,
      'item_code': response['item_code'] ?? request.itemCode,
      'location_code': response['location_code'] ?? request.locationCode,
      'quantity': response['quantity'] ?? request.quantity,
      if (!response.containsKey('session_id') && request.sessionId != null)
        'session_id': request.sessionId,
    };

    return ScanFlowResult.fromJson(normalizedResponse);
  }

  ScanSessionDraftDto _mapLookupResponseToDraft({
    required Map<String, dynamic> response,
    required ScanLaunchContext context,
    required String lookupCode,
  }) {
    final now = DateTime.now().toUtc();
    if (_isSessionDraftPayload(response)) {
      return ScanSessionDraftDto.fromJson(<String, dynamic>{
        ...response,
        'lookup_code': response['lookup_code'] ?? lookupCode,
        'reference_id': response['reference_id'] ?? context.referenceId,
        'warehouse_id': response['warehouse_id'] ?? context.warehouseId,
        'mode': response['mode'] ?? context.mode.name,
        'sync_state': response['sync_state'] ?? SyncState.synced.name,
        'started_at': response['started_at'] ?? now.toIso8601String(),
        'updated_at': response['updated_at'] ?? now.toIso8601String(),
      });
    }

    final state =
        _enumFromString(ScanSessionState.values, response['state']) ??
        ScanSessionState.lookupSuccess;

    return ScanSessionDraftDto(
      id:
          _stringOrNull(response['session_id']) ??
          'scan-${context.mode.name}-${lookupCode.toLowerCase()}',
      mode: context.mode,
      state: state,
      cameraGranted: _boolOrFalse(response['camera_granted']),
      lookupCode: lookupCode,
      resolvedItemCode: _stringOrNull(response['resolved_item_code']),
      resolvedLocationCode: _stringOrNull(response['resolved_location_code']),
      referenceId:
          _stringOrNull(response['reference_id']) ?? context.referenceId,
      warehouseId:
          _stringOrNull(response['warehouse_id']) ?? context.warehouseId,
      quantity: _doubleOrNull(response['quantity']),
      countedQuantity: _doubleOrNull(response['counted_quantity']),
      sourceLocationCode: _stringOrNull(response['source_location_code']),
      destinationLocationCode: _stringOrNull(
        response['destination_location_code'],
      ),
      reasonCode: _stringOrNull(response['reason_code']),
      errorMessage:
          _stringOrNull(response['error_message']) ??
          _stringOrNull(response['message']),
      syncState:
          _enumFromString(SyncState.values, response['sync_state']) ??
          SyncState.synced,
      startedAt: _dateTimeOrNow(response['started_at'], now),
      updatedAt: _dateTimeOrNow(response['updated_at'], now),
      submittedAt: _dateTimeOrNull(response['submitted_at']),
    );
  }

  bool _isSessionDraftPayload(Map<String, dynamic> payload) {
    return payload.containsKey('id') &&
        payload.containsKey('mode') &&
        payload.containsKey('state');
  }

  T? _enumFromString<T extends Enum>(List<T> values, Object? rawValue) {
    if (rawValue is! String) {
      return null;
    }

    final normalizedRaw = _normalizeEnumName(rawValue);
    for (final value in values) {
      if (_normalizeEnumName(value.name) == normalizedRaw) {
        return value;
      }
    }

    return null;
  }

  String _normalizeEnumName(String value) {
    return value.trim().toLowerCase().replaceAll('_', '');
  }

  String? _stringOrNull(Object? value) {
    if (value is! String) {
      return null;
    }

    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  bool _boolOrFalse(Object? value) {
    return value == true;
  }

  double? _doubleOrNull(Object? value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim());
    }

    return null;
  }

  DateTime _dateTimeOrNow(Object? value, DateTime fallback) {
    return _dateTimeOrNull(value) ?? fallback;
  }

  DateTime? _dateTimeOrNull(Object? value) {
    if (value is DateTime) {
      return value.toUtc();
    }

    if (value is! String) {
      return null;
    }

    return DateTime.tryParse(value)?.toUtc();
  }
}
