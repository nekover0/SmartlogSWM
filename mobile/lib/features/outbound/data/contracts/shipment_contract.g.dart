// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShipmentLineEntity _$ShipmentLineEntityFromJson(Map<String, dynamic> json) =>
    _ShipmentLineEntity(
      id: json['id'] as String,
      itemCode: json['itemCode'] as String,
      itemName: json['itemName'] as String,
      uomCode: json['uomCode'] as String,
      expectedQty: (json['expectedQty'] as num).toDouble(),
      shippedQty: (json['shippedQty'] as num).toDouble(),
      shortPick: json['shortPick'] as bool,
      sourceLocation: json['sourceLocation'] == null
          ? null
          : LocationSummary.fromJson(
              json['sourceLocation'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ShipmentLineEntityToJson(_ShipmentLineEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemCode': instance.itemCode,
      'itemName': instance.itemName,
      'uomCode': instance.uomCode,
      'expectedQty': instance.expectedQty,
      'shippedQty': instance.shippedQty,
      'shortPick': instance.shortPick,
      'sourceLocation': instance.sourceLocation?.toJson(),
    };

_ShipmentEntity _$ShipmentEntityFromJson(Map<String, dynamic> json) =>
    _ShipmentEntity(
      id: json['id'] as String,
      shipmentNo: json['shipmentNo'] as String,
      status: $enumDecode(_$ShipmentStatusEnumMap, json['status']),
      owner: OwnerSummary.fromJson(json['owner'] as Map<String, dynamic>),
      warehouse: WarehouseSummary.fromJson(
        json['warehouse'] as Map<String, dynamic>,
      ),
      vehicle: VehicleInfo.fromJson(json['vehicle'] as Map<String, dynamic>),
      salesOrderNo: json['salesOrderNo'] as String?,
      billOfLadingNo: json['billOfLadingNo'] as String?,
      expectedWeightKg: (json['expectedWeightKg'] as num).toDouble(),
      shippedWeightKg: (json['shippedWeightKg'] as num).toDouble(),
      varianceWeightKg: (json['varianceWeightKg'] as num?)?.toDouble(),
      syncState: $enumDecode(_$SyncStateEnumMap, json['syncState']),
      availableActions:
          (json['availableActions'] as List<dynamic>?)
              ?.map((e) => ActionCapability.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActionCapability>[],
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map(
                (e) => ShipmentLineEntity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <ShipmentLineEntity>[],
      note: json['note'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ShipmentEntityToJson(
  _ShipmentEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'shipmentNo': instance.shipmentNo,
  'status': _$ShipmentStatusEnumMap[instance.status]!,
  'owner': instance.owner.toJson(),
  'warehouse': instance.warehouse.toJson(),
  'vehicle': instance.vehicle.toJson(),
  'salesOrderNo': instance.salesOrderNo,
  'billOfLadingNo': instance.billOfLadingNo,
  'expectedWeightKg': instance.expectedWeightKg,
  'shippedWeightKg': instance.shippedWeightKg,
  'varianceWeightKg': instance.varianceWeightKg,
  'syncState': _$SyncStateEnumMap[instance.syncState]!,
  'availableActions': instance.availableActions.map((e) => e.toJson()).toList(),
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'note': instance.note,
  'errorMessage': instance.errorMessage,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$ShipmentStatusEnumMap = {
  ShipmentStatus.draft: 'draft',
  ShipmentStatus.confirmed: 'confirmed',
  ShipmentStatus.picking: 'picking',
  ShipmentStatus.loading: 'loading',
  ShipmentStatus.weighCompleted: 'weigh_completed',
  ShipmentStatus.shipped: 'shipped',
  ShipmentStatus.closed: 'closed',
  ShipmentStatus.error: 'error',
  ShipmentStatus.cancelled: 'cancelled',
};

const _$SyncStateEnumMap = {
  SyncState.synced: 'synced',
  SyncState.pending: 'pending',
  SyncState.failed: 'failed',
};

_ShipmentLineDto _$ShipmentLineDtoFromJson(Map<String, dynamic> json) =>
    _ShipmentLineDto(
      id: json['id'] as String,
      itemCode: json['item_code'] as String,
      itemName: json['item_name'] as String,
      uomCode: json['uom_code'] as String,
      expectedQty: (json['expected_qty'] as num).toDouble(),
      shippedQty: (json['shipped_qty'] as num).toDouble(),
      shortPick: json['short_pick'] as bool? ?? false,
      sourceLocation: json['source_location'] == null
          ? null
          : LocationSummary.fromJson(
              json['source_location'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ShipmentLineDtoToJson(_ShipmentLineDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_code': instance.itemCode,
      'item_name': instance.itemName,
      'uom_code': instance.uomCode,
      'expected_qty': instance.expectedQty,
      'shipped_qty': instance.shippedQty,
      'short_pick': instance.shortPick,
      'source_location': instance.sourceLocation?.toJson(),
    };

_ShipmentDto _$ShipmentDtoFromJson(Map<String, dynamic> json) => _ShipmentDto(
  id: json['id'] as String,
  shipmentNo: json['shipment_no'] as String,
  status: $enumDecode(_$ShipmentStatusEnumMap, json['status']),
  owner: OwnerSummary.fromJson(json['owner'] as Map<String, dynamic>),
  warehouse: WarehouseSummary.fromJson(
    json['warehouse'] as Map<String, dynamic>,
  ),
  vehicle: VehicleInfo.fromJson(json['vehicle'] as Map<String, dynamic>),
  salesOrderNo: json['sales_order_no'] as String?,
  billOfLadingNo: json['bill_of_lading_no'] as String?,
  expectedWeightKg: (json['expected_weight_kg'] as num).toDouble(),
  shippedWeightKg: (json['shipped_weight_kg'] as num).toDouble(),
  varianceWeightKg: (json['variance_weight_kg'] as num?)?.toDouble(),
  syncState: $enumDecode(_$SyncStateEnumMap, json['sync_state']),
  availableActions:
      (json['available_actions'] as List<dynamic>?)
          ?.map((e) => ActionCapability.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ActionCapability>[],
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => ShipmentLineDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ShipmentLineDto>[],
  note: json['note'] as String?,
  errorMessage: json['error_message'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ShipmentDtoToJson(_ShipmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shipment_no': instance.shipmentNo,
      'status': _$ShipmentStatusEnumMap[instance.status]!,
      'owner': instance.owner.toJson(),
      'warehouse': instance.warehouse.toJson(),
      'vehicle': instance.vehicle.toJson(),
      'sales_order_no': instance.salesOrderNo,
      'bill_of_lading_no': instance.billOfLadingNo,
      'expected_weight_kg': instance.expectedWeightKg,
      'shipped_weight_kg': instance.shippedWeightKg,
      'variance_weight_kg': instance.varianceWeightKg,
      'sync_state': _$SyncStateEnumMap[instance.syncState]!,
      'available_actions': instance.availableActions
          .map((e) => e.toJson())
          .toList(),
      'lines': instance.lines.map((e) => e.toJson()).toList(),
      'note': instance.note,
      'error_message': instance.errorMessage,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
