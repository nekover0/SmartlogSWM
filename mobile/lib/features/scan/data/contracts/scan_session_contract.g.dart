// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_session_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanSessionEntity _$ScanSessionEntityFromJson(Map<String, dynamic> json) =>
    _ScanSessionEntity(
      id: json['id'] as String,
      mode: $enumDecode(_$ScanModeEnumMap, json['mode']),
      state: $enumDecode(_$ScanSessionStateEnumMap, json['state']),
      cameraGranted: json['cameraGranted'] as bool? ?? false,
      lookupCode: json['lookupCode'] as String?,
      resolvedItemCode: json['resolvedItemCode'] as String?,
      resolvedLocationCode: json['resolvedLocationCode'] as String?,
      referenceId: json['referenceId'] as String?,
      warehouseId: json['warehouseId'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      countedQuantity: (json['countedQuantity'] as num?)?.toDouble(),
      sourceLocationCode: json['sourceLocationCode'] as String?,
      destinationLocationCode: json['destinationLocationCode'] as String?,
      reasonCode: json['reasonCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      syncState: $enumDecode(_$SyncStateEnumMap, json['syncState']),
      startedAt: DateTime.parse(json['startedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
    );

Map<String, dynamic> _$ScanSessionEntityToJson(_ScanSessionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mode': _$ScanModeEnumMap[instance.mode]!,
      'state': _$ScanSessionStateEnumMap[instance.state]!,
      'cameraGranted': instance.cameraGranted,
      'lookupCode': instance.lookupCode,
      'resolvedItemCode': instance.resolvedItemCode,
      'resolvedLocationCode': instance.resolvedLocationCode,
      'referenceId': instance.referenceId,
      'warehouseId': instance.warehouseId,
      'quantity': instance.quantity,
      'countedQuantity': instance.countedQuantity,
      'sourceLocationCode': instance.sourceLocationCode,
      'destinationLocationCode': instance.destinationLocationCode,
      'reasonCode': instance.reasonCode,
      'errorMessage': instance.errorMessage,
      'syncState': _$SyncStateEnumMap[instance.syncState]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'submittedAt': instance.submittedAt?.toIso8601String(),
    };

const _$ScanModeEnumMap = {
  ScanMode.receive: 'receive',
  ScanMode.issue: 'issue',
  ScanMode.count: 'count',
  ScanMode.move: 'move',
};

const _$ScanSessionStateEnumMap = {
  ScanSessionState.idle: 'idle',
  ScanSessionState.permissionPending: 'permission_pending',
  ScanSessionState.cameraDenied: 'camera_denied',
  ScanSessionState.scanning: 'scanning',
  ScanSessionState.lookupSuccess: 'lookup_success',
  ScanSessionState.lookupNotFound: 'lookup_not_found',
  ScanSessionState.formReady: 'form_ready',
  ScanSessionState.submitting: 'submitting',
  ScanSessionState.submitSuccess: 'submit_success',
  ScanSessionState.submitFailed: 'submit_failed',
};

const _$SyncStateEnumMap = {
  SyncState.synced: 'synced',
  SyncState.pending: 'pending',
  SyncState.failed: 'failed',
};

_ScanSessionDraftDto _$ScanSessionDraftDtoFromJson(Map<String, dynamic> json) =>
    _ScanSessionDraftDto(
      id: json['id'] as String,
      mode: $enumDecode(_$ScanModeEnumMap, json['mode']),
      state: $enumDecode(_$ScanSessionStateEnumMap, json['state']),
      cameraGranted: json['camera_granted'] as bool? ?? false,
      lookupCode: json['lookup_code'] as String?,
      resolvedItemCode: json['resolved_item_code'] as String?,
      resolvedLocationCode: json['resolved_location_code'] as String?,
      referenceId: json['reference_id'] as String?,
      warehouseId: json['warehouse_id'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      countedQuantity: (json['counted_quantity'] as num?)?.toDouble(),
      sourceLocationCode: json['source_location_code'] as String?,
      destinationLocationCode: json['destination_location_code'] as String?,
      reasonCode: json['reason_code'] as String?,
      errorMessage: json['error_message'] as String?,
      syncState: $enumDecode(_$SyncStateEnumMap, json['sync_state']),
      startedAt: DateTime.parse(json['started_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      submittedAt: json['submitted_at'] == null
          ? null
          : DateTime.parse(json['submitted_at'] as String),
    );

Map<String, dynamic> _$ScanSessionDraftDtoToJson(
  _ScanSessionDraftDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'mode': _$ScanModeEnumMap[instance.mode]!,
  'state': _$ScanSessionStateEnumMap[instance.state]!,
  'camera_granted': instance.cameraGranted,
  'lookup_code': instance.lookupCode,
  'resolved_item_code': instance.resolvedItemCode,
  'resolved_location_code': instance.resolvedLocationCode,
  'reference_id': instance.referenceId,
  'warehouse_id': instance.warehouseId,
  'quantity': instance.quantity,
  'counted_quantity': instance.countedQuantity,
  'source_location_code': instance.sourceLocationCode,
  'destination_location_code': instance.destinationLocationCode,
  'reason_code': instance.reasonCode,
  'error_message': instance.errorMessage,
  'sync_state': _$SyncStateEnumMap[instance.syncState]!,
  'started_at': instance.startedAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'submitted_at': instance.submittedAt?.toIso8601String(),
};

_ScanSubmitRequestDto _$ScanSubmitRequestDtoFromJson(
  Map<String, dynamic> json,
) => _ScanSubmitRequestDto(
  mode: $enumDecode(_$ScanModeEnumMap, json['mode']),
  referenceId: json['reference_id'] as String?,
  warehouseId: json['warehouse_id'] as String?,
  itemCode: json['item_code'] as String?,
  locationCode: json['location_code'] as String?,
  sourceLocationCode: json['source_location_code'] as String?,
  destinationLocationCode: json['destination_location_code'] as String?,
  quantity: (json['quantity'] as num?)?.toDouble(),
  countedQuantity: (json['counted_quantity'] as num?)?.toDouble(),
  reasonCode: json['reason_code'] as String?,
);

Map<String, dynamic> _$ScanSubmitRequestDtoToJson(
  _ScanSubmitRequestDto instance,
) => <String, dynamic>{
  'mode': _$ScanModeEnumMap[instance.mode]!,
  'reference_id': instance.referenceId,
  'warehouse_id': instance.warehouseId,
  'item_code': instance.itemCode,
  'location_code': instance.locationCode,
  'source_location_code': instance.sourceLocationCode,
  'destination_location_code': instance.destinationLocationCode,
  'quantity': instance.quantity,
  'counted_quantity': instance.countedQuantity,
  'reason_code': instance.reasonCode,
};
