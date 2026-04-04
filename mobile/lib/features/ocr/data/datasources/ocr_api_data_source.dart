import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final ocrApiDataSourceProvider = Provider<OcrApiDataSource>((Ref<Object?> ref) {
  return OcrApiDataSource(httpClient: ref.watch(appHttpClientProvider));
});

class OcrApiDataSource {
  OcrApiDataSource({required AppHttpClient httpClient})
    : _httpClient = httpClient;

  static const String _ocrResultsPath = '/api/v1/integration/ocr/results';
  static const String _ocrUploadsPath = '/api/v1/integration/ocr/uploads';

  final AppHttpClient _httpClient;

  Future<List<OcrRecordDto>> getRecords() async {
    final payload = await _httpClient.getList(_ocrResultsPath);

    return payload
        .map((entry) => _unwrapOcrPayload(entry))
        .map((entry) => OcrRecordDto.fromJson(_normalizeOcrRecordJson(entry)))
        .toList(growable: false);
  }

  Future<OcrRecordDto> getRecordById(String recordId) async {
    final payload = await _httpClient.getMap('$_ocrResultsPath/$recordId');
    final recordPayload = _unwrapOcrPayload(payload);

    return OcrRecordDto.fromJson(_normalizeOcrRecordJson(recordPayload));
  }

  Future<OcrRecordDto> upload({
    required DocumentDirection direction,
    required bool fromGallery,
  }) async {
    final response = await _httpClient.postMap(
      _ocrUploadsPath,
      data: <String, dynamic>{
        'imagePath': fromGallery
            ? '/uploads/ocr/mobile-gallery-${DateTime.now().millisecondsSinceEpoch}.jpg'
            : '/uploads/ocr/mobile-camera-${DateTime.now().millisecondsSinceEpoch}.jpg',
        'providerName': 'default',
        'direction': direction.name,
      },
    );

    final payload = _unwrapOcrPayload(response);
    payload.putIfAbsent('direction', () => direction.name);

    return OcrRecordDto.fromJson(_normalizeOcrRecordJson(payload));
  }

  Future<OcrRecordDto> confirm({
    required String recordId,
    required OcrExtractedFieldsEntity extractedFields,
    required List<FieldReviewFlag> reviewFlags,
    String? remarks,
  }) async {
    final response = await _httpClient.postMap(
      '$_ocrResultsPath/$recordId/confirm',
      data: <String, dynamic>{
        'confirmedBlNumber': extractedFields.documentNo,
        'confirmedVehicleNumber': extractedFields.vehiclePlate,
        'confirmedProductName': extractedFields.itemName,
        'confirmedQty':
            extractedFields.netWeightKg ?? extractedFields.grossWeightKg,
        'confirmedQtyUom': 'KG',
        'corrections': _buildCorrections(reviewFlags),
        'remarks': remarks,
      },
    );

    final payload = _unwrapOcrPayload(response);
    payload.putIfAbsent('id', () => recordId);

    return OcrRecordDto.fromJson(_normalizeOcrRecordJson(payload));
  }

  Future<OcrRecordDto> link({
    required String recordId,
    required LinkedTargetType targetType,
    required String targetId,
    required String targetNo,
  }) async {
    final response = await _httpClient.postMap(
      '$_ocrResultsPath/$recordId/link',
      data: <String, dynamic>{
        'targetType': targetType.name,
        'targetId': targetId,
        'targetNo': targetNo,
      },
    );

    final payload = _unwrapOcrPayload(response);
    payload.putIfAbsent('id', () => recordId);
    payload.putIfAbsent('linked_target_type', () => targetType.name);
    payload.putIfAbsent('linked_target_id', () => targetId);
    payload.putIfAbsent('linked_target_no', () => targetNo);

    return OcrRecordDto.fromJson(_normalizeOcrRecordJson(payload));
  }

  Future<OcrRecordDto> reject({
    required String recordId,
    String? reason,
  }) async {
    final response = await _httpClient.postMap(
      '$_ocrResultsPath/$recordId/reject',
      data: <String, dynamic>{'reason': reason, 'remarks': reason},
    );

    final payload = _unwrapOcrPayload(response);
    payload.putIfAbsent('id', () => recordId);
    payload.putIfAbsent('status', () => 'REJECTED');
    payload.putIfAbsent('error_message', () => reason);

    return OcrRecordDto.fromJson(_normalizeOcrRecordJson(payload));
  }

  Map<String, dynamic> _buildCorrections(List<FieldReviewFlag> reviewFlags) {
    final map = <String, dynamic>{};

    for (final flag in reviewFlags) {
      final fieldName = flag.fieldName.trim();
      if (fieldName.isEmpty) {
        continue;
      }

      map[fieldName] = <String, dynamic>{
        'from': flag.rawValue,
        'to': flag.rawValue,
        'confidence': flag.confidenceScore,
      };
    }

    return map;
  }

  Map<String, dynamic> _unwrapOcrPayload(Object? value, {int depth = 0}) {
    final map = _toMap(value);
    if (_looksLikeOcrRecordPayload(map) || depth >= 4) {
      return map;
    }

    for (final key in const <String>['result', 'ocrResult', 'data', 'item']) {
      final nested = map[key];
      if (nested is! Map) {
        continue;
      }

      final unwrapped = _unwrapOcrPayload(nested, depth: depth + 1);
      if (_looksLikeOcrRecordPayload(unwrapped) || map.length == 1) {
        return unwrapped;
      }
    }

    return map;
  }

  bool _looksLikeOcrRecordPayload(Map<String, dynamic> payload) {
    return payload.containsKey('id') ||
        payload.containsKey('ocrRequestId') ||
        payload.containsKey('status') ||
        payload.containsKey('direction') ||
        payload.containsKey('extracted_fields') ||
        payload.containsKey('extractedFields');
  }

  Map<String, dynamic> _normalizeOcrRecordJson(Map<String, dynamic> payload) {
    final nowIso = DateTime.now().toUtc().toIso8601String();

    final confidenceScore =
        _numberFromKeys(payload, const <String>[
          'confidence_score',
          'confidenceScore',
          'overallConfidence',
        ]) ??
        0.0;

    return <String, dynamic>{
      'id':
          _stringFromKeys(payload, const <String>['id', 'ocrRequestId']) ??
          'ocr-${DateTime.now().microsecondsSinceEpoch}',
      'direction': _normalizeDirection(
        _stringFromKeys(payload, const <String>['direction', 'flowDirection']),
      ),
      'status': _normalizeStatus(
        _stringFromKeys(payload, const <String>['status']),
      ),
      'confidence_score': confidenceScore,
      'confidence_level': _normalizeConfidenceLevel(
        rawLevel: _stringFromKeys(payload, const <String>[
          'confidence_level',
          'confidenceLevel',
        ]),
        score: confidenceScore,
      ),
      'extracted_fields': _normalizeExtractedFields(payload),
      'review_flags': _normalizeReviewFlags(
        _listFromKeys(payload, const <String>['review_flags', 'reviewFlags']),
      ),
      'source_image_url':
          _stringFromKeys(payload, const <String>[
            'source_image_url',
            'sourceImageUrl',
            'imagePath',
          ]) ??
          '',
      'linked_target_type': _normalizeLinkedTargetType(
        _stringFromKeys(payload, const <String>[
          'linked_target_type',
          'linkedTargetType',
          'targetType',
        ]),
      ),
      'linked_target_id': _stringFromKeys(payload, const <String>[
        'linked_target_id',
        'linkedTargetId',
        'targetId',
      ]),
      'linked_target_no': _stringFromKeys(payload, const <String>[
        'linked_target_no',
        'linkedTargetNo',
        'targetNo',
      ]),
      'error_message': _stringFromKeys(payload, const <String>[
        'error_message',
        'errorMessage',
        'message',
      ]),
      'captured_at':
          _dateIsoFromKeys(payload, const <String>[
            'captured_at',
            'capturedAt',
            'createdAt',
          ]) ??
          nowIso,
      'processed_at': _dateIsoFromKeys(payload, const <String>[
        'processed_at',
        'processedAt',
        'updatedAt',
      ]),
      'linked_at': _dateIsoFromKeys(payload, const <String>[
        'linked_at',
        'linkedAt',
      ]),
      'sync_state': _normalizeSyncState(
        _stringFromKeys(payload, const <String>['sync_state', 'syncState']),
        status: _stringFromKeys(payload, const <String>['status']),
      ),
    };
  }

  Map<String, dynamic> _normalizeExtractedFields(Map<String, dynamic> payload) {
    final extracted =
        _mapFromKeys(payload, const <String>[
          'extracted_fields',
          'extractedFields',
        ]) ??
        const <String, dynamic>{};

    return <String, dynamic>{
      'document_no':
          _stringFromKeys(extracted, const <String>[
            'document_no',
            'documentNo',
          ]) ??
          _stringFromKeys(payload, const <String>[
            'confirmedBlNumber',
            'blNumber',
            'documentNo',
          ]),
      'vehicle_plate':
          _stringFromKeys(extracted, const <String>[
            'vehicle_plate',
            'vehiclePlate',
          ]) ??
          _stringFromKeys(payload, const <String>[
            'confirmedVehicleNumber',
            'vehicleNumber',
            'vehiclePlate',
          ]),
      'owner_code':
          _stringFromKeys(extracted, const <String>[
            'owner_code',
            'ownerCode',
          ]) ??
          _stringFromKeys(payload, const <String>['ownerCode']),
      'owner_name':
          _stringFromKeys(extracted, const <String>[
            'owner_name',
            'ownerName',
          ]) ??
          _stringFromKeys(payload, const <String>['ownerName']),
      'item_code':
          _stringFromKeys(extracted, const <String>['item_code', 'itemCode']) ??
          _stringFromKeys(payload, const <String>['itemCode']),
      'item_name':
          _stringFromKeys(extracted, const <String>['item_name', 'itemName']) ??
          _stringFromKeys(payload, const <String>[
            'confirmedProductName',
            'itemName',
          ]),
      'gross_weight_kg':
          _numberFromKeys(extracted, const <String>[
            'gross_weight_kg',
            'grossWeightKg',
          ]) ??
          _numberFromKeys(payload, const <String>['grossWeightKg']),
      'net_weight_kg':
          _numberFromKeys(extracted, const <String>[
            'net_weight_kg',
            'netWeightKg',
          ]) ??
          _numberFromKeys(payload, const <String>[
            'confirmedQty',
            'netWeightKg',
          ]),
    };
  }

  List<Map<String, dynamic>> _normalizeReviewFlags(List<dynamic> flags) {
    return flags
        .map(_toMap)
        .map(
          (flag) => <String, dynamic>{
            'field_name':
                _stringFromKeys(flag, const <String>[
                  'field_name',
                  'fieldName',
                ]) ??
                'unknown',
            'raw_value': _stringFromKeys(flag, const <String>[
              'raw_value',
              'rawValue',
            ]),
            'confidence_score':
                _numberFromKeys(flag, const <String>[
                  'confidence_score',
                  'confidenceScore',
                ]) ??
                0.0,
            'level': _normalizeConfidenceLevel(
              rawLevel: _stringFromKeys(flag, const <String>['level']),
              score:
                  _numberFromKeys(flag, const <String>[
                    'confidence_score',
                    'confidenceScore',
                  ]) ??
                  0.0,
            ),
            'required_review':
                _boolFromKeys(flag, const <String>[
                  'required_review',
                  'requiredReview',
                ]) ??
                false,
          },
        )
        .toList(growable: false);
  }

  String _normalizeDirection(String? rawDirection) {
    return switch (_normalizeToken(rawDirection)) {
      'outbound' || 'issue' || 'ship' => 'outbound',
      _ => 'inbound',
    };
  }

  String _normalizeStatus(String? rawStatus) {
    return switch (_normalizeToken(rawStatus)) {
      'uploaded' => 'captured',
      'extracting' || 'processing' => 'processing',
      'extracted' => 'extracted',
      'reviewrequired' => 'review_required',
      'confirmed' => 'confirmed',
      'linked' => 'linked',
      'rejected' => 'rejected',
      'failed' => 'failed',
      _ => 'captured',
    };
  }

  String _normalizeConfidenceLevel({String? rawLevel, required double score}) {
    final normalized = _normalizeToken(rawLevel);
    if (normalized.isNotEmpty) {
      return switch (normalized) {
        'high' => 'high',
        'medium' => 'medium',
        _ => 'low',
      };
    }

    if (score >= 0.85) {
      return 'high';
    }
    if (score >= 0.65) {
      return 'medium';
    }

    return 'low';
  }

  String _normalizeLinkedTargetType(String? rawType) {
    return switch (_normalizeToken(rawType)) {
      'receipt' => 'receipt',
      'shipment' => 'shipment',
      _ => 'none',
    };
  }

  String _normalizeSyncState(String? rawState, {String? status}) {
    final state = _normalizeToken(rawState);
    if (state == 'pending' || state == 'failed') {
      return state;
    }

    final normalizedStatus = _normalizeToken(status);
    if (normalizedStatus == 'uploaded' ||
        normalizedStatus == 'extracting' ||
        normalizedStatus == 'reviewrequired') {
      return 'pending';
    }

    return 'synced';
  }

  String _normalizeToken(String? value) {
    if (value == null) {
      return '';
    }

    return value.trim().toLowerCase().replaceAll(RegExp(r'[_\-\s]+'), '');
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

    throw const FormatException('OCR payload must be an object.');
  }

  Map<String, dynamic>? _mapFromKeys(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = map[key];
      if (value is Map<String, dynamic>) {
        return value;
      }
      if (value is Map) {
        return value.map(
          (Object? nestedKey, Object? nestedValue) =>
              MapEntry(nestedKey?.toString() ?? '', nestedValue),
        );
      }
    }

    return null;
  }

  List<dynamic> _listFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is List<dynamic>) {
        return value;
      }
      if (value is List) {
        return List<dynamic>.from(value);
      }
    }

    return const <dynamic>[];
  }

  String? _stringFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) {
        continue;
      }
      if (value is String) {
        final normalized = value.trim();
        if (normalized.isNotEmpty) {
          return normalized;
        }

        continue;
      }

      return value.toString();
    }

    return null;
  }

  double? _numberFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        final parsed = double.tryParse(value.trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }

    return null;
  }

  bool? _boolFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
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
    }

    return null;
  }

  String? _dateIsoFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is DateTime) {
        return value.toUtc().toIso8601String();
      }
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed.toUtc().toIso8601String();
        }
      }
    }

    return null;
  }
}
