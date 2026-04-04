import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';

final shipmentApiDataSourceProvider = Provider<ShipmentApiDataSource>((
  Ref<Object?> ref,
) {
  return ShipmentApiDataSource(httpClient: ref.watch(appHttpClientProvider));
});

class ShipmentApiDataSource {
  ShipmentApiDataSource({required AppHttpClient httpClient})
    : _httpClient = httpClient;

  static const String _shipmentsPath = '/api/v1/outbound/shipments';

  final AppHttpClient _httpClient;

  Future<List<ShipmentDto>> getShipmentList() async {
    final payload = await _httpClient.getList(_shipmentsPath);

    return payload
        .map((entry) => _unwrapShipmentPayload(entry))
        .map((entry) => ShipmentDto.fromJson(_normalizeShipmentJson(entry)))
        .toList(growable: false);
  }

  Future<ShipmentDto> getShipmentDetail(String shipmentId) async {
    final payload = await _httpClient.getMap('$_shipmentsPath/$shipmentId');
    final shipmentPayload = _unwrapShipmentPayload(payload);

    return ShipmentDto.fromJson(_normalizeShipmentJson(shipmentPayload));
  }

  Map<String, dynamic> _unwrapShipmentPayload(Object? value, {int depth = 0}) {
    final map = _toMap(value);
    if (_looksLikeShipmentPayload(map) || depth >= 4) {
      return map;
    }

    for (final key in const <String>['shipment', 'data', 'item']) {
      final nested = map[key];
      if (nested is! Map) {
        continue;
      }

      final unwrapped = _unwrapShipmentPayload(nested, depth: depth + 1);
      if (_looksLikeShipmentPayload(unwrapped) || map.length == 1) {
        return unwrapped;
      }
    }

    return map;
  }

  bool _looksLikeShipmentPayload(Map<String, dynamic> payload) {
    return payload.containsKey('shipment_no') ||
        payload.containsKey('shipmentNo') ||
        payload.containsKey('shipmentNumber') ||
        payload.containsKey('status') ||
        payload.containsKey('owner') ||
        payload.containsKey('warehouse') ||
        payload.containsKey('vehicle');
  }

  Map<String, dynamic> _normalizeShipmentJson(Map<String, dynamic> payload) {
    final owner = _normalizeOwner(payload);
    final warehouse = _normalizeWarehouse(payload);
    final vehicle = _normalizeVehicle(payload);

    final expectedWeightKg =
        _numberFromKeys(payload, const <String>[
          'expected_weight_kg',
          'expectedWeightKg',
          'expectedQtyKg',
          'expectedQty',
          'plannedWeightKg',
        ]) ??
        0;
    final shippedWeightKg =
        _numberFromKeys(payload, const <String>[
          'shipped_weight_kg',
          'shippedWeightKg',
          'actualWeightKg',
          'loadedWeightKg',
          'shippedQtyKg',
        ]) ??
        0;

    final createdAt =
        _dateIsoFromKeys(payload, const <String>['created_at', 'createdAt']) ??
        DateTime.now().toUtc().toIso8601String();
    final updatedAt =
        _dateIsoFromKeys(payload, const <String>['updated_at', 'updatedAt']) ??
        createdAt;

    return <String, dynamic>{
      'id':
          _stringFromKeys(payload, const <String>['id']) ?? 'unknown-shipment',
      'shipment_no':
          _stringFromKeys(payload, const <String>[
            'shipment_no',
            'shipmentNo',
            'shipmentNumber',
          ]) ??
          (_stringFromKeys(payload, const <String>['id']) ??
              'unknown-shipment'),
      'status': _normalizeStatus(
        _stringFromKeys(payload, const <String>['status']),
      ),
      'owner': owner,
      'warehouse': warehouse,
      'vehicle': vehicle,
      'sales_order_no': _stringFromKeys(payload, const <String>[
        'sales_order_no',
        'salesOrderNo',
        'soNumber',
        'salesOrderNumber',
      ]),
      'bill_of_lading_no': _stringFromKeys(payload, const <String>[
        'bill_of_lading_no',
        'billOfLadingNo',
        'blNumber',
      ]),
      'expected_weight_kg': expectedWeightKg,
      'shipped_weight_kg': shippedWeightKg,
      'variance_weight_kg':
          _numberFromKeys(payload, const <String>[
            'variance_weight_kg',
            'varianceWeightKg',
            'varianceQtyKg',
          ]) ??
          (shippedWeightKg - expectedWeightKg),
      'sync_state': _normalizeSyncState(
        _stringFromKeys(payload, const <String>['sync_state', 'syncState']),
      ),
      'available_actions': _normalizeActions(
        _listFromKeys(payload, const <String>[
          'available_actions',
          'availableActions',
        ]),
      ),
      'lines': _normalizeLines(
        _listFromKeys(payload, const <String>['lines', 'items', 'details']),
      ),
      'note': _stringFromKeys(payload, const <String>['note', 'notes']),
      'error_message': _stringFromKeys(payload, const <String>[
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

    return <String, dynamic>{
      'id': ownerId,
      'code':
          _stringFromKeys(owner, const <String>['code', 'ownerCode']) ??
          _stringFromKeys(payload, const <String>['owner_code', 'ownerCode']) ??
          ownerId,
      'name':
          _stringFromKeys(owner, const <String>['name', 'ownerName']) ??
          _stringFromKeys(payload, const <String>['owner_name', 'ownerName']) ??
          ownerId,
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

    return <String, dynamic>{
      'id': warehouseId,
      'code':
          _stringFromKeys(warehouse, const <String>['code', 'warehouseCode']) ??
          _stringFromKeys(payload, const <String>[
            'warehouse_code',
            'warehouseCode',
          ]) ??
          warehouseId,
      'name':
          _stringFromKeys(warehouse, const <String>['name', 'warehouseName']) ??
          _stringFromKeys(payload, const <String>[
            'warehouse_name',
            'warehouseName',
          ]) ??
          warehouseId,
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
                'expectedQtyKg',
              ]) ??
              0;
          final shippedQty =
              _numberFromKeys(line, const <String>[
                'shipped_qty',
                'shippedQty',
                'actualQty',
                'loadedQty',
              ]) ??
              0;

          final sourceLocationId = _stringFromKeys(line, const <String>[
            'source_location_id',
            'sourceLocationId',
            'locationId',
          ]);
          final sourceLocationCode = _stringFromKeys(line, const <String>[
            'source_location_code',
            'sourceLocationCode',
            'locationCode',
          ]);

          return <String, dynamic>{
            'id':
                _stringFromKeys(line, const <String>['id', 'lineId']) ??
                'line-$index',
            'item_code':
                _stringFromKeys(line, const <String>[
                  'item_code',
                  'itemCode',
                  'sku',
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
                ]) ??
                'EA',
            'expected_qty': expectedQty,
            'shipped_qty': shippedQty,
            'short_pick':
                _boolFromKeys(line, const <String>[
                  'short_pick',
                  'shortPick',
                ]) ??
                (shippedQty < expectedQty),
            'source_location':
                sourceLocationId != null || sourceLocationCode != null
                ? <String, dynamic>{
                    'id':
                        sourceLocationId ??
                        sourceLocationCode ??
                        'unknown-location',
                    'code': sourceLocationCode ?? sourceLocationId ?? 'UNKNOWN',
                    'name':
                        _stringFromKeys(line, const <String>[
                          'source_location_name',
                          'sourceLocationName',
                        ]) ??
                        sourceLocationCode ??
                        sourceLocationId ??
                        'Unknown location',
                  }
                : null,
          };
        })
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _normalizeActions(List<dynamic> actions) {
    final normalized = actions
        .map(_toMap)
        .map((action) {
          final typeRaw =
              _stringFromKeys(action, const <String>['type', 'actionType']) ??
              'open';

          return <String, dynamic>{
            'type': _normalizeActionType(typeRaw),
            'label':
                _stringFromKeys(action, const <String>['label', 'name']) ??
                'Mở chi tiết',
            'routeName': _stringFromKeys(action, const <String>[
              'routeName',
              'route_name',
            ]),
            'routeParams': _mapFromKeys(action, const <String>[
              'routeParams',
              'route_params',
            ]),
            'enabled': _boolFromKeys(action, const <String>['enabled']) ?? true,
          };
        })
        .toList(growable: false);

    if (normalized.isNotEmpty) {
      return normalized;
    }

    return const <Map<String, dynamic>>[
      <String, dynamic>{
        'type': 'open',
        'label': 'Mở phiếu',
        'routeName': 'shipment_detail',
        'enabled': true,
      },
    ];
  }

  String _normalizeStatus(String? rawStatus) {
    return switch (_normalizeToken(rawStatus)) {
      'draft' || 'new' => 'draft',
      'confirmed' => 'confirmed',
      'picking' => 'picking',
      'loading' => 'loading',
      'loaded' || 'weighcompleted' || 'weigh_completed' => 'weigh_completed',
      'shipped' => 'shipped',
      'closed' || 'completed' => 'closed',
      'error' || 'failed' || 'reportederror' => 'error',
      'cancelled' || 'canceled' => 'cancelled',
      _ => 'draft',
    };
  }

  String _normalizeActionType(String rawType) {
    return switch (_normalizeToken(rawType)) {
      'open' => 'open',
      'approve' => 'approve',
      'dismiss' => 'dismiss',
      'acknowledge' => 'acknowledge',
      'startpicking' => 'start_picking',
      'viewinventory' => 'view_inventory',
      _ => 'custom',
    };
  }

  String _normalizeSyncState(String? rawState) {
    return switch (_normalizeToken(rawState)) {
      'pending' => 'pending',
      'failed' => 'failed',
      _ => 'synced',
    };
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

    throw const FormatException('Shipment payload must be an object.');
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
