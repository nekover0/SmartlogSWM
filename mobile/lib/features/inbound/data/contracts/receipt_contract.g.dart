// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReceiptLineEntity _$ReceiptLineEntityFromJson(Map<String, dynamic> json) =>
    _ReceiptLineEntity(
      id: json['id'] as String,
      itemCode: json['itemCode'] as String,
      itemName: json['itemName'] as String,
      uomCode: json['uomCode'] as String,
      expectedQty: (json['expectedQty'] as num).toDouble(),
      receivedQty: (json['receivedQty'] as num).toDouble(),
      varianceQty: (json['varianceQty'] as num).toDouble(),
    );

Map<String, dynamic> _$ReceiptLineEntityToJson(_ReceiptLineEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemCode': instance.itemCode,
      'itemName': instance.itemName,
      'uomCode': instance.uomCode,
      'expectedQty': instance.expectedQty,
      'receivedQty': instance.receivedQty,
      'varianceQty': instance.varianceQty,
    };

_ReceiptEntity _$ReceiptEntityFromJson(Map<String, dynamic> json) =>
    _ReceiptEntity(
      id: json['id'] as String,
      receiptNo: json['receiptNo'] as String,
      status: $enumDecode(_$ReceiptStatusEnumMap, json['status']),
      owner: OwnerSummary.fromJson(json['owner'] as Map<String, dynamic>),
      warehouse: WarehouseSummary.fromJson(
        json['warehouse'] as Map<String, dynamic>,
      ),
      vehicle: VehicleInfo.fromJson(json['vehicle'] as Map<String, dynamic>),
      purchaseOrderNo: json['purchaseOrderNo'] as String?,
      billOfLadingNo: json['billOfLadingNo'] as String?,
      vesselName: json['vesselName'] as String?,
      expectedWeightKg: (json['expectedWeightKg'] as num).toDouble(),
      receivedWeightKg: (json['receivedWeightKg'] as num).toDouble(),
      portWeightKg: (json['portWeightKg'] as num?)?.toDouble(),
      varianceWeightKg: (json['varianceWeightKg'] as num).toDouble(),
      sourceOcrRecordId: json['sourceOcrRecordId'] as String?,
      syncState: $enumDecode(_$SyncStateEnumMap, json['syncState']),
      availableActions:
          (json['availableActions'] as List<dynamic>?)
              ?.map((e) => ActionCapability.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActionCapability>[],
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map(
                (e) => ReceiptLineEntity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <ReceiptLineEntity>[],
      note: json['note'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ReceiptEntityToJson(
  _ReceiptEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'receiptNo': instance.receiptNo,
  'status': _$ReceiptStatusEnumMap[instance.status]!,
  'owner': instance.owner.toJson(),
  'warehouse': instance.warehouse.toJson(),
  'vehicle': instance.vehicle.toJson(),
  'purchaseOrderNo': instance.purchaseOrderNo,
  'billOfLadingNo': instance.billOfLadingNo,
  'vesselName': instance.vesselName,
  'expectedWeightKg': instance.expectedWeightKg,
  'receivedWeightKg': instance.receivedWeightKg,
  'portWeightKg': instance.portWeightKg,
  'varianceWeightKg': instance.varianceWeightKg,
  'sourceOcrRecordId': instance.sourceOcrRecordId,
  'syncState': _$SyncStateEnumMap[instance.syncState]!,
  'availableActions': instance.availableActions.map((e) => e.toJson()).toList(),
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'note': instance.note,
  'errorMessage': instance.errorMessage,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$ReceiptStatusEnumMap = {
  ReceiptStatus.draft: 'draft',
  ReceiptStatus.confirmed: 'confirmed',
  ReceiptStatus.waitingForWeighing: 'waiting_for_weighing',
  ReceiptStatus.weighing1: 'weighing1',
  ReceiptStatus.weighing2: 'weighing2',
  ReceiptStatus.completed: 'completed',
  ReceiptStatus.error: 'error',
  ReceiptStatus.cancelled: 'cancelled',
};

const _$SyncStateEnumMap = {
  SyncState.synced: 'synced',
  SyncState.pending: 'pending',
  SyncState.failed: 'failed',
};

_ReceiptLineDto _$ReceiptLineDtoFromJson(Map<String, dynamic> json) =>
    _ReceiptLineDto(
      id: json['id'] as String,
      itemCode: json['item_code'] as String,
      itemName: json['item_name'] as String,
      uomCode: json['uom_code'] as String,
      expectedQty: (json['expected_qty'] as num).toDouble(),
      receivedQty: (json['received_qty'] as num).toDouble(),
      varianceQty: (json['variance_qty'] as num).toDouble(),
    );

Map<String, dynamic> _$ReceiptLineDtoToJson(_ReceiptLineDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_code': instance.itemCode,
      'item_name': instance.itemName,
      'uom_code': instance.uomCode,
      'expected_qty': instance.expectedQty,
      'received_qty': instance.receivedQty,
      'variance_qty': instance.varianceQty,
    };

_ReceiptDto _$ReceiptDtoFromJson(Map<String, dynamic> json) => _ReceiptDto(
  id: json['id'] as String,
  receiptNo: json['receipt_no'] as String,
  status: $enumDecode(_$ReceiptStatusEnumMap, json['status']),
  owner: OwnerSummary.fromJson(json['owner'] as Map<String, dynamic>),
  warehouse: WarehouseSummary.fromJson(
    json['warehouse'] as Map<String, dynamic>,
  ),
  vehicle: VehicleInfo.fromJson(json['vehicle'] as Map<String, dynamic>),
  purchaseOrderNo: json['purchase_order_no'] as String?,
  billOfLadingNo: json['bill_of_lading_no'] as String?,
  vesselName: json['vessel_name'] as String?,
  expectedWeightKg: (json['expected_weight_kg'] as num).toDouble(),
  receivedWeightKg: (json['received_weight_kg'] as num).toDouble(),
  portWeightKg: (json['port_weight_kg'] as num?)?.toDouble(),
  varianceWeightKg: (json['variance_weight_kg'] as num).toDouble(),
  sourceOcrRecordId: json['source_ocr_record_id'] as String?,
  syncState: $enumDecode(_$SyncStateEnumMap, json['sync_state']),
  availableActions:
      (json['available_actions'] as List<dynamic>?)
          ?.map((e) => ActionCapability.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ActionCapability>[],
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => ReceiptLineDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ReceiptLineDto>[],
  note: json['note'] as String?,
  errorMessage: json['error_message'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ReceiptDtoToJson(_ReceiptDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receipt_no': instance.receiptNo,
      'status': _$ReceiptStatusEnumMap[instance.status]!,
      'owner': instance.owner.toJson(),
      'warehouse': instance.warehouse.toJson(),
      'vehicle': instance.vehicle.toJson(),
      'purchase_order_no': instance.purchaseOrderNo,
      'bill_of_lading_no': instance.billOfLadingNo,
      'vessel_name': instance.vesselName,
      'expected_weight_kg': instance.expectedWeightKg,
      'received_weight_kg': instance.receivedWeightKg,
      'port_weight_kg': instance.portWeightKg,
      'variance_weight_kg': instance.varianceWeightKg,
      'source_ocr_record_id': instance.sourceOcrRecordId,
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
