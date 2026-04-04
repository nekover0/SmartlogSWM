import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final inventoryApiDataSourceProvider = Provider<InventoryApiDataSource>((
  Ref<Object?> ref,
) {
  return InventoryApiDataSource(httpClient: ref.watch(appHttpClientProvider));
});

class InventoryApiDataSource {
  InventoryApiDataSource({required AppHttpClient httpClient})
    : _httpClient = httpClient;

  static const String _onHandPath = '/api/v1/inventory/onhand';
  static const String _transactionsPath = '/api/v1/inventory/transactions';

  final AppHttpClient _httpClient;

  Future<List<InventoryItemEntity>> getInventoryList() async {
    final payload = await _httpClient.getList(
      _onHandPath,
      queryParameters: <String, dynamic>{'hasStock': true, 'pageSize': 100},
    );

    final items = payload
        .map((entry) => _normalizeOnHand(_toMap(entry)))
        .toList(growable: false);

    items.sort((left, right) => left.itemName.compareTo(right.itemName));
    return items;
  }

  Future<InventoryDetailEntity> getInventoryDetail(String inventoryId) async {
    final items = await getInventoryList();
    final item = items.firstWhere((entry) => entry.id == inventoryId);

    final timelineEvents = await _loadTimelineEvents(item.itemId);

    return InventoryDetailEntity(
      item: item,
      priority: item.isLowStock ? 'Cao' : 'Binh thuong',
      timelineEvents: timelineEvents,
    );
  }

  Future<List<InventoryTimelineEventEntity>> _loadTimelineEvents(
    String itemId,
  ) async {
    try {
      final payload = await _httpClient.getList(
        _transactionsPath,
        queryParameters: <String, dynamic>{'itemId': itemId, 'pageSize': 20},
      );

      final events =
          payload
              .map((entry) => _normalizeTimeline(_toMap(entry)))
              .toList(growable: false)
            ..sort(
              (left, right) => right.occurredAt.compareTo(left.occurredAt),
            );

      return events;
    } catch (_) {
      return const <InventoryTimelineEventEntity>[];
    }
  }

  InventoryItemEntity _normalizeOnHand(Map<String, dynamic> payload) {
    final item =
        _mapFromKeys(payload, const <String>['item']) ??
        const <String, dynamic>{};
    final inventDim =
        _mapFromKeys(payload, const <String>['inventDim']) ??
        const <String, dynamic>{};

    final warehouse =
        _mapFromKeys(inventDim, const <String>['warehouse']) ??
        const <String, dynamic>{};
    final location =
        _mapFromKeys(inventDim, const <String>['location']) ??
        const <String, dynamic>{};
    final owner =
        _mapFromKeys(inventDim, const <String>['owner']) ??
        const <String, dynamic>{};
    final status =
        _mapFromKeys(inventDim, const <String>['inventoryStatus']) ??
        const <String, dynamic>{};

    final physicalQty =
        _numberFromKeys(payload, const <String>[
          'physicalQty',
          'physical_qty',
        ]) ??
        0;
    final allocatedQty =
        _numberFromKeys(payload, const <String>[
          'allocatedQty',
          'allocated_qty',
        ]) ??
        0;
    final availableQty =
        _numberFromKeys(payload, const <String>[
          'availableQty',
          'available_qty',
        ]) ??
        (physicalQty - allocatedQty);

    final warningThreshold =
        _numberFromKeys(payload, const <String>[
          'warningThreshold',
          'warning_threshold',
          'minStockLevel',
          'minimumQty',
        ]) ??
        15;

    return InventoryItemEntity(
      id:
          _stringFromKeys(payload, const <String>['id']) ??
          'inventory-${DateTime.now().microsecondsSinceEpoch}',
      itemId:
          _stringFromKeys(payload, const <String>['itemId', 'item_id']) ??
          _stringFromKeys(payload, const <String>['id']) ??
          'unknown-item',
      skuCode:
          _stringFromKeys(item, const <String>[
            'itemCode',
            'item_code',
            'sku',
          ]) ??
          _stringFromKeys(payload, const <String>['itemCode', 'item_code']) ??
          'UNKNOWN',
      itemName:
          _stringFromKeys(item, const <String>[
            'itemName',
            'item_name',
            'name',
          ]) ??
          _stringFromKeys(payload, const <String>['itemName', 'item_name']) ??
          'Khong ro ten hang',
      warehouseCode:
          _stringFromKeys(warehouse, const <String>[
            'warehouseCode',
            'warehouse_code',
            'code',
          ]) ??
          'WH-UNKNOWN',
      warehouseName:
          _stringFromKeys(warehouse, const <String>[
            'warehouseName',
            'warehouse_name',
            'name',
          ]) ??
          _stringFromKeys(warehouse, const <String>[
            'warehouseCode',
            'warehouse_code',
          ]) ??
          'Kho khong xac dinh',
      locationCode:
          _stringFromKeys(location, const <String>[
            'locationCode',
            'location_code',
            'code',
          ]) ??
          'LOC-NA',
      ownerCode:
          _stringFromKeys(owner, const <String>[
            'ownerCode',
            'owner_code',
            'code',
          ]) ??
          'OWNER-NA',
      zoneCode: _stringFromKeys(inventDim, const <String>[
        'zoneCode',
        'zone_code',
      ]),
      shelfCode: _stringFromKeys(inventDim, const <String>[
        'shelfCode',
        'shelf_code',
      ]),
      batchNo: _stringFromKeys(inventDim, const <String>[
        'batchNo',
        'batch_no',
        'lotNo',
      ]),
      physicalQty: physicalQty,
      allocatedQty: allocatedQty,
      availableQty: availableQty,
      warningThreshold: warningThreshold,
      uomCode:
          _stringFromKeys(payload, const <String>['uomCode', 'uom_code']) ??
          _stringFromKeys(
            _mapFromKeys(payload, const <String>['uom']) ??
                const <String, dynamic>{},
            const <String>['uomCode', 'uom_code', 'code'],
          ) ??
          'PCS',
      inventoryStatusCode:
          _stringFromKeys(status, const <String>[
            'statusCode',
            'status_code',
            'code',
          ]) ??
          'AVAILABLE',
      inventoryStatusAllocatable:
          _boolFromKeys(status, const <String>['isAllocatable']) ?? true,
      syncState: _normalizeSyncState(
        _stringFromKeys(payload, const <String>['syncState', 'sync_state']),
      ),
    );
  }

  InventoryTimelineEventEntity _normalizeTimeline(
    Map<String, dynamic> payload,
  ) {
    final transactionType =
        _stringFromKeys(payload, const <String>['transType', 'trans_type']) ??
        'UNKNOWN';

    final qty =
        _numberFromKeys(payload, const <String>['qty', 'quantity']) ?? 0;

    final occurredAt =
        _dateTimeFromKeys(payload, const <String>[
          'postedAt',
          'posted_at',
          'createdAt',
          'created_at',
        ]) ??
        DateTime.now().toUtc();

    final refType =
        _stringFromKeys(payload, const <String>['refType', 'ref_type']) ??
        'TRANSACTION';

    return InventoryTimelineEventEntity(
      type: transactionType,
      label: _buildTimelineLabel(
        transactionType: transactionType,
        referenceType: refType,
      ),
      occurredAt: occurredAt,
      deltaQty: qty,
    );
  }

  String _buildTimelineLabel({
    required String transactionType,
    required String referenceType,
  }) {
    final normalizedType = _normalizeToken(transactionType);
    final normalizedRef = _normalizeToken(referenceType);

    if (normalizedType == 'receipt' || normalizedType == 'receive') {
      return 'Nhap kho gan nhat';
    }

    if (normalizedType == 'issue' || normalizedType == 'shipment') {
      return 'Xuat kho gan nhat';
    }

    if (normalizedType == 'adjust' || normalizedType == 'adjustment') {
      return 'Dieu chinh ton kho';
    }

    if (normalizedRef == 'shipment') {
      return 'Xuat kho gan nhat';
    }

    if (normalizedRef == 'receipt') {
      return 'Nhap kho gan nhat';
    }

    return 'Cap nhat ton kho';
  }

  SyncState _normalizeSyncState(String? rawState) {
    return switch (_normalizeToken(rawState)) {
      'pending' => SyncState.pending,
      'failed' => SyncState.failed,
      _ => SyncState.synced,
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

    throw const FormatException('Inventory payload must be an object.');
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
        final normalized = value.trim();
        if (normalized.isEmpty) {
          continue;
        }
        final parsed = double.tryParse(normalized);
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

  DateTime? _dateTimeFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is DateTime) {
        return value.toUtc();
      }
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed.toUtc();
        }
      }
    }

    return null;
  }
}
