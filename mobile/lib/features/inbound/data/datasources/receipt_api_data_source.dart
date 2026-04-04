import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';

final receiptApiDataSourceProvider = Provider<ReceiptApiDataSource>((
  Ref<Object?> ref,
) {
  return ReceiptApiDataSource(httpClient: ref.watch(appHttpClientProvider));
});

class ReceiptApiDataSource {
  ReceiptApiDataSource({required AppHttpClient httpClient})
    : _httpClient = httpClient;

  static const String _receiptsPath = '/api/v1/inbound/receipts';

  final AppHttpClient _httpClient;

  Future<List<ReceiptDto>> getReceiptList() async {
    final payload = await _httpClient.getList(_receiptsPath);

    return payload
        .map((entry) => _unwrapReceiptPayload(entry))
        .map((entry) => ReceiptDto.fromJson(_normalizeReceiptJson(entry)))
        .toList(growable: false);
  }

  Future<ReceiptDto> getReceiptDetail(String receiptId) async {
    final payload = await _httpClient.getMap('$_receiptsPath/$receiptId');
    final receiptPayload = _unwrapReceiptPayload(payload);

    return ReceiptDto.fromJson(_normalizeReceiptJson(_toMap(receiptPayload)));
  }

  Map<String, dynamic> _unwrapReceiptPayload(Object? value, {int depth = 0}) {
    final map = _toMap(value);
    if (_looksLikeReceiptPayload(map) || depth >= 4) {
      return map;
    }

    for (final key in const <String>['receipt', 'data', 'item']) {
      final nested = map[key];
      if (nested is Map) {
        final unwrapped = _unwrapReceiptPayload(nested, depth: depth + 1);
        if (_looksLikeReceiptPayload(unwrapped) || map.length == 1) {
          return unwrapped;
        }
      }
    }

    return map;
  }

  bool _looksLikeReceiptPayload(Map<String, dynamic> payload) {
    return payload.containsKey('receipt_no') ||
        payload.containsKey('receiptNo') ||
        payload.containsKey('receiptNumber') ||
        payload.containsKey('status') ||
        payload.containsKey('owner') ||
        payload.containsKey('warehouse') ||
        payload.containsKey('vehicle');
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

    throw const FormatException('Receipt payload must be an object.');
  }

  Map<String, dynamic> _normalizeReceiptJson(Map<String, dynamic> json) {
    final owner = _normalizeOwner(json);
    final warehouse = _normalizeWarehouse(json);
    final vehicle = _normalizeVehicle(json);
    final expectedWeightKg =
        _numberFromKeys(json, const <String>[
          'expected_weight_kg',
          'expectedWeightKg',
          'expectedQty',
          'expected_quantity',
        ]) ??
        0;
    final receivedWeightKg =
        _numberFromKeys(json, const <String>[
          'received_weight_kg',
          'receivedWeightKg',
          'receivedQty',
          'actualQty',
          'netWeightKg',
          'net_weight_kg',
        ]) ??
        0;
    final varianceWeightKg =
        _numberFromKeys(json, const <String>[
          'variance_weight_kg',
          'varianceWeightKg',
          'varianceQty',
          'variance_quantity',
        ]) ??
        (receivedWeightKg - expectedWeightKg);

    final createdAt =
        _dateIsoFromKeys(json, const <String>['created_at', 'createdAt']) ??
        DateTime.now().toUtc().toIso8601String();
    final updatedAt =
        _dateIsoFromKeys(json, const <String>['updated_at', 'updatedAt']) ??
        createdAt;

    return <String, dynamic>{
      'id': _stringFromKeys(json, const <String>['id']) ?? 'unknown-receipt',
      'receipt_no':
          _stringFromKeys(json, const <String>[
            'receipt_no',
            'receiptNo',
            'receiptNumber',
          ]) ??
          (_stringFromKeys(json, const <String>['id']) ?? 'unknown-receipt'),
      'status': _normalizeStatus(
        _stringFromKeys(json, const <String>['status', 'receiptStatus']),
      ),
      'owner': owner,
      'warehouse': warehouse,
      'vehicle': vehicle,
      'purchase_order_no': _stringFromKeys(json, const <String>[
        'purchase_order_no',
        'purchaseOrderNo',
        'poNumber',
        'poNo',
        'poId',
      ]),
      'bill_of_lading_no': _stringFromKeys(json, const <String>[
        'bill_of_lading_no',
        'billOfLadingNo',
        'blNumber',
      ]),
      'vessel_name': _stringFromKeys(json, const <String>[
        'vessel_name',
        'vesselName',
      ]),
      'expected_weight_kg': expectedWeightKg,
      'received_weight_kg': receivedWeightKg,
      'port_weight_kg': _numberFromKeys(json, const <String>[
        'port_weight_kg',
        'portWeightKg',
      ]),
      'variance_weight_kg': varianceWeightKg,
      'source_ocr_record_id': _stringFromKeys(json, const <String>[
        'source_ocr_record_id',
        'sourceOcrRecordId',
        'ocrRecordId',
      ]),
      'sync_state': _normalizeSyncState(
        _stringFromKeys(json, const <String>['sync_state', 'syncState']),
      ),
      'available_actions': _normalizeActions(
        _listFromKeys(json, const <String>[
          'available_actions',
          'availableActions',
        ]),
      ),
      'lines': _normalizeLines(
        _listFromKeys(json, const <String>['lines', 'items', 'details']),
      ),
      'note': _stringFromKeys(json, const <String>['note', 'notes']),
      'error_message': _stringFromKeys(json, const <String>[
        'error_message',
        'errorMessage',
        'message',
      ]),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Map<String, dynamic> _normalizeOwner(Map<String, dynamic> payload) {
    final owner =
        _mapFromKeys(payload, const <String>['owner']) ??
        const <String, dynamic>{};
    final ownerId =
        _stringFromKeys(owner, const <String>['id']) ??
        _stringFromKeys(payload, const <String>['owner_id', 'ownerId']) ??
        'unknown-owner';
    final ownerCode =
        _stringFromKeys(owner, const <String>['code']) ??
        _stringFromKeys(payload, const <String>['owner_code', 'ownerCode']) ??
        ownerId;
    final ownerName =
        _stringFromKeys(owner, const <String>['name']) ??
        _stringFromKeys(payload, const <String>['owner_name', 'ownerName']) ??
        ownerCode;

    return <String, dynamic>{
      'id': ownerId,
      'code': ownerCode,
      'name': ownerName,
    };
  }

  Map<String, dynamic> _normalizeWarehouse(Map<String, dynamic> payload) {
    final warehouse =
        _mapFromKeys(payload, const <String>['warehouse']) ??
        const <String, dynamic>{};
    final warehouseId =
        _stringFromKeys(warehouse, const <String>['id']) ??
        _stringFromKeys(payload, const <String>[
          'warehouse_id',
          'warehouseId',
        ]) ??
        'unknown-warehouse';
    final warehouseCode =
        _stringFromKeys(warehouse, const <String>['code']) ??
        _stringFromKeys(payload, const <String>[
          'warehouse_code',
          'warehouseCode',
        ]) ??
        warehouseId;
    final warehouseName =
        _stringFromKeys(warehouse, const <String>['name']) ??
        _stringFromKeys(payload, const <String>[
          'warehouse_name',
          'warehouseName',
        ]) ??
        warehouseCode;

    return <String, dynamic>{
      'id': warehouseId,
      'code': warehouseCode,
      'name': warehouseName,
    };
  }

  Map<String, dynamic> _normalizeVehicle(Map<String, dynamic> payload) {
    final vehicle =
        _mapFromKeys(payload, const <String>['vehicle']) ??
        const <String, dynamic>{};
    return <String, dynamic>{
      'plateNumber':
          _stringFromKeys(vehicle, const <String>[
            'plateNumber',
            'plate_number',
          ]) ??
          _stringFromKeys(payload, const <String>[
            'vehicleNumber',
            'vehicle_number',
            'plateNumber',
            'plate_number',
          ]),
      'vesselName':
          _stringFromKeys(vehicle, const <String>[
            'vesselName',
            'vessel_name',
          ]) ??
          _stringFromKeys(payload, const <String>['vesselName', 'vessel_name']),
      'driverName':
          _stringFromKeys(vehicle, const <String>[
            'driverName',
            'driver_name',
          ]) ??
          _stringFromKeys(payload, const <String>['driverName', 'driver_name']),
    };
  }

  List<Map<String, dynamic>> _normalizeLines(List<dynamic> lines) {
    return lines
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final line = _toMap(entry.value);
          final expectedQty =
              _numberFromKeys(line, const <String>[
                'expected_qty',
                'expectedQty',
                'quantity',
              ]) ??
              0;
          final receivedQty =
              _numberFromKeys(line, const <String>[
                'received_qty',
                'receivedQty',
                'actualQty',
              ]) ??
              0;

          return <String, dynamic>{
            'id':
                _stringFromKeys(line, const <String>['id', 'lineId']) ??
                'line-$index',
            'item_code':
                _stringFromKeys(line, const <String>[
                  'item_code',
                  'itemCode',
                  'sku',
                  'code',
                  'itemId',
                ]) ??
                'UNKNOWN-$index',
            'item_name':
                _stringFromKeys(line, const <String>[
                  'item_name',
                  'itemName',
                  'name',
                ]) ??
                (_stringFromKeys(line, const <String>[
                      'item_code',
                      'itemCode',
                    ]) ??
                    'Unknown item'),
            'uom_code':
                _stringFromKeys(line, const <String>[
                  'uom_code',
                  'uomCode',
                  'uom',
                  'uomId',
                ]) ??
                'EA',
            'expected_qty': expectedQty,
            'received_qty': receivedQty,
            'variance_qty':
                _numberFromKeys(line, const <String>[
                  'variance_qty',
                  'varianceQty',
                ]) ??
                (receivedQty - expectedQty),
          };
        })
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _normalizeActions(List<dynamic> actions) {
    return actions
        .map(_toMap)
        .map((action) {
          final typeRaw =
              _stringFromKeys(action, const <String>['type', 'actionType']) ??
              'custom';
          final routeParams = _mapFromKeys(action, const <String>[
            'routeParams',
            'route_params',
          ]);

          return <String, dynamic>{
            'type': _normalizeActionType(typeRaw),
            'label':
                _stringFromKeys(action, const <String>[
                  'label',
                  'name',
                  'title',
                ]) ??
                typeRaw,
            'routeName': _stringFromKeys(action, const <String>[
              'routeName',
              'route_name',
            ]),
            'routeParams': routeParams,
            'enabled': _boolFromKeys(action, const <String>['enabled']) ?? true,
          };
        })
        .toList(growable: false);
  }

  String _normalizeStatus(String? rawStatus) {
    final normalized = rawStatus?.trim().toLowerCase();
    return switch (normalized) {
      null || '' => 'draft',
      'draft' || 'new' => 'draft',
      'confirmed' => 'confirmed',
      'waiting_for_weighing' || 'awaiting_weighing' => 'waiting_for_weighing',
      'weighing_1' || 'weighing1' => 'weighing1',
      'weighing_2' || 'weighing2' => 'weighing2',
      'completed' || 'closed' || 'received' => 'completed',
      'error' || 'rejected' => 'error',
      'cancelled' || 'canceled' => 'cancelled',
      _ => 'draft',
    };
  }

  String _normalizeSyncState(String? rawSyncState) {
    return switch (rawSyncState?.trim().toLowerCase()) {
      'pending' => 'pending',
      'failed' => 'failed',
      _ => 'synced',
    };
  }

  String _normalizeActionType(String rawType) {
    final normalized = rawType.trim().toLowerCase().replaceAll('-', '_');
    return switch (normalized) {
      'open' => 'open',
      'approve' => 'approve',
      'dismiss' => 'dismiss',
      'acknowledge' => 'acknowledge',
      'start_weighing' => 'start_weighing',
      'start_picking' => 'start_picking',
      'review_ocr' => 'review_ocr',
      'view_inventory' => 'view_inventory',
      'custom' => 'custom',
      _ => 'custom',
    };
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
