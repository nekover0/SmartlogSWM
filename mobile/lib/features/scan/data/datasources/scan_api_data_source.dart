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
    final payload = _extractLookupPayload(response);

    return _mapLookupResponseToDraft(
      response: payload,
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
    final payload = _extractSubmitPayload(response);
    final mode =
        _enumFromString(ScanMode.values, _stringFromKeys(payload, ['mode'])) ??
        request.mode;

    final normalizedResponse = <String, dynamic>{
      'mode': mode.name,
      'success':
          _boolFromKeys(payload, ['success']) ?? !payload.containsKey('error'),
      'session_id':
          _stringFromKeys(payload, ['session_id', 'sessionId', 'id']) ??
          request.sessionId,
      'reference_id':
          _stringFromKeys(payload, ['reference_id', 'referenceId']) ??
          request.referenceId,
      'warehouse_id':
          _stringFromKeys(payload, ['warehouse_id', 'warehouseId']) ??
          request.warehouseId,
      'item_code':
          _stringFromKeys(payload, [
            'item_code',
            'itemCode',
            'resolved_item_code',
            'resolvedItemCode',
          ]) ??
          request.itemCode,
      'location_code':
          _stringFromKeys(payload, [
            'location_code',
            'locationCode',
            'resolved_location_code',
            'resolvedLocationCode',
          ]) ??
          request.locationCode,
      'quantity': _doubleFromKeys(payload, ['quantity']) ?? request.quantity,
      'submitted_at': _dateIsoFromKeys(payload, [
        'submitted_at',
        'submittedAt',
      ]),
      'message': _stringFromKeys(payload, [
        'message',
        'error_message',
        'errorMessage',
      ]),
    };

    return ScanFlowResult.fromJson(normalizedResponse);
  }

  Map<String, dynamic> _extractLookupPayload(Map<String, dynamic> response) {
    return _extractPayloadMap(response, const <String>[
      'state',
      'session_id',
      'sessionId',
      'id',
      'resolved_item_code',
      'resolvedItemCode',
    ]);
  }

  Map<String, dynamic> _extractSubmitPayload(Map<String, dynamic> response) {
    return _extractPayloadMap(response, const <String>[
      'success',
      'session_id',
      'sessionId',
      'id',
      'mode',
      'quantity',
      'message',
    ]);
  }

  Map<String, dynamic> _extractPayloadMap(
    Map<String, dynamic> response,
    List<String> expectedKeys,
  ) {
    var current = _toMap(response);
    for (var depth = 0; depth < 4; depth++) {
      if (_containsAnyKey(current, expectedKeys)) {
        return current;
      }

      Map<String, dynamic>? next;
      for (final candidate in <Object?>[
        current['data'],
        current['session'],
        current['result'],
        current['payload'],
      ]) {
        if (candidate is! Map) {
          continue;
        }

        final nested = _toMap(candidate);
        if (_containsAnyKey(nested, expectedKeys) || current.length == 1) {
          next = nested;
          break;
        }
      }

      if (next == null) {
        break;
      }

      current = next;
    }

    return current;
  }

  ScanSessionDraftDto _mapLookupResponseToDraft({
    required Map<String, dynamic> response,
    required ScanLaunchContext context,
    required String lookupCode,
  }) {
    final now = DateTime.now().toUtc();
    if (_isSessionDraftPayload(response)) {
      final mode =
          _enumFromString(
            ScanMode.values,
            _stringFromKeys(response, ['mode']),
          ) ??
          context.mode;
      final state =
          _enumFromString(
            ScanSessionState.values,
            _stringFromKeys(response, ['state']),
          ) ??
          ScanSessionState.lookupSuccess;
      final syncState =
          _enumFromString(
            SyncState.values,
            _stringFromKeys(response, ['sync_state', 'syncState']),
          ) ??
          SyncState.synced;

      return ScanSessionDraftDto.fromJson(<String, dynamic>{
        'id':
            _stringFromKeys(response, ['id', 'session_id', 'sessionId']) ??
            'scan-${context.mode.name}-${lookupCode.toLowerCase()}',
        'mode': _enumToWireName(mode),
        'state': _enumToWireName(state),
        'camera_granted':
            _boolFromKeys(response, ['camera_granted', 'cameraGranted']) ??
            false,
        'lookup_code':
            _stringFromKeys(response, ['lookup_code', 'lookupCode']) ??
            lookupCode,
        'resolved_item_code': _stringFromKeys(response, [
          'resolved_item_code',
          'resolvedItemCode',
        ]),
        'resolved_location_code': _stringFromKeys(response, [
          'resolved_location_code',
          'resolvedLocationCode',
        ]),
        'reference_id':
            _stringFromKeys(response, ['reference_id', 'referenceId']) ??
            context.referenceId,
        'warehouse_id':
            _stringFromKeys(response, ['warehouse_id', 'warehouseId']) ??
            context.warehouseId,
        'quantity': _doubleFromKeys(response, ['quantity']),
        'counted_quantity': _doubleFromKeys(response, [
          'counted_quantity',
          'countedQuantity',
        ]),
        'source_location_code': _stringFromKeys(response, [
          'source_location_code',
          'sourceLocationCode',
        ]),
        'destination_location_code': _stringFromKeys(response, [
          'destination_location_code',
          'destinationLocationCode',
        ]),
        'reason_code': _stringFromKeys(response, ['reason_code', 'reasonCode']),
        'error_message': _stringFromKeys(response, [
          'error_message',
          'errorMessage',
          'message',
        ]),
        'sync_state': _enumToWireName(syncState),
        'started_at':
            _dateIsoFromKeys(response, ['started_at', 'startedAt']) ??
            now.toIso8601String(),
        'updated_at':
            _dateIsoFromKeys(response, ['updated_at', 'updatedAt']) ??
            now.toIso8601String(),
        'submitted_at': _dateIsoFromKeys(response, [
          'submitted_at',
          'submittedAt',
        ]),
      });
    }

    final state =
        _enumFromString(
          ScanSessionState.values,
          _stringFromKeys(response, ['state']),
        ) ??
        ScanSessionState.lookupSuccess;

    return ScanSessionDraftDto(
      id:
          _stringFromKeys(response, ['session_id', 'sessionId', 'id']) ??
          'scan-${context.mode.name}-${lookupCode.toLowerCase()}',
      mode: context.mode,
      state: state,
      cameraGranted:
          _boolFromKeys(response, ['camera_granted', 'cameraGranted']) ?? false,
      lookupCode: lookupCode,
      resolvedItemCode: _stringFromKeys(response, [
        'resolved_item_code',
        'resolvedItemCode',
      ]),
      resolvedLocationCode: _stringFromKeys(response, [
        'resolved_location_code',
        'resolvedLocationCode',
      ]),
      referenceId:
          _stringFromKeys(response, ['reference_id', 'referenceId']) ??
          context.referenceId,
      warehouseId:
          _stringFromKeys(response, ['warehouse_id', 'warehouseId']) ??
          context.warehouseId,
      quantity: _doubleFromKeys(response, ['quantity']),
      countedQuantity: _doubleFromKeys(response, [
        'counted_quantity',
        'countedQuantity',
      ]),
      sourceLocationCode: _stringFromKeys(response, [
        'source_location_code',
        'sourceLocationCode',
      ]),
      destinationLocationCode: _stringFromKeys(response, [
        'destination_location_code',
        'destinationLocationCode',
      ]),
      reasonCode: _stringFromKeys(response, ['reason_code', 'reasonCode']),
      errorMessage:
          _stringFromKeys(response, ['error_message', 'errorMessage']) ??
          _stringFromKeys(response, ['message']),
      syncState:
          _enumFromString(
            SyncState.values,
            _stringFromKeys(response, ['sync_state', 'syncState']),
          ) ??
          SyncState.synced,
      startedAt:
          _dateTimeOrNull(_firstValue(response, ['started_at', 'startedAt'])) ??
          now,
      updatedAt:
          _dateTimeOrNull(_firstValue(response, ['updated_at', 'updatedAt'])) ??
          now,
      submittedAt: _dateTimeOrNull(
        _firstValue(response, ['submitted_at', 'submittedAt']),
      ),
    );
  }

  bool _isSessionDraftPayload(Map<String, dynamic> payload) {
    return payload.containsKey('state') ||
        payload.containsKey('lookup_code') ||
        payload.containsKey('lookupCode') ||
        payload.containsKey('resolved_item_code') ||
        payload.containsKey('resolvedItemCode');
  }

  bool _containsAnyKey(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      if (payload.containsKey(key)) {
        return true;
      }
    }
    return false;
  }

  Map<String, dynamic> _toMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (Object? key, Object? nestedValue) =>
            MapEntry(key?.toString() ?? '', nestedValue),
      );
    }
    throw const FormatException('Scan payload must be an object.');
  }

  Object? _firstValue(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key)) {
        return map[key];
      }
    }
    return null;
  }

  String? _stringFromKeys(Map<String, dynamic> map, List<String> keys) {
    final value = _firstValue(map, keys);
    if (value == null) {
      return null;
    }
    if (value is String) {
      final normalized = value.trim();
      return normalized.isEmpty ? null : normalized;
    }
    return value.toString();
  }

  bool? _boolFromKeys(Map<String, dynamic> map, List<String> keys) {
    final value = _firstValue(map, keys);
    if (value is bool) {
      return value;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true') {
        return true;
      }
      if (normalized == 'false') {
        return false;
      }
    }
    return null;
  }

  double? _doubleFromKeys(Map<String, dynamic> map, List<String> keys) {
    final value = _firstValue(map, keys);
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  String? _dateIsoFromKeys(Map<String, dynamic> map, List<String> keys) {
    final value = _firstValue(map, keys);
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed.toUtc().toIso8601String();
      }
    }
    return null;
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

  String _enumToWireName(Enum value) {
    return value.name
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (Match match) => '${match.group(1)}_${match.group(2)}',
        )
        .toLowerCase();
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
