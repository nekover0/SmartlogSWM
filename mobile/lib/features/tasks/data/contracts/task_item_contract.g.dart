// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskItemEntity _$TaskItemEntityFromJson(Map<String, dynamic> json) =>
    _TaskItemEntity(
      id: json['id'] as String,
      type: $enumDecode(_$TaskItemTypeEnumMap, json['type']),
      status: $enumDecode(_$TaskItemStatusEnumMap, json['status']),
      severity: $enumDecode(_$SeverityEnumMap, json['severity']),
      title: json['title'] as String,
      description: json['description'] as String?,
      sourceModule: json['sourceModule'] as String,
      sourceEntityType: json['sourceEntityType'] as String?,
      sourceEntityId: json['sourceEntityId'] as String?,
      sourceEntityNo: json['sourceEntityNo'] as String?,
      routeName: json['routeName'] as String?,
      routeParams: (json['routeParams'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      ageMinutes: (json['ageMinutes'] as num?)?.toInt(),
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      primaryAction: ActionCapability.fromJson(
        json['primaryAction'] as Map<String, dynamic>,
      ),
      secondaryActions:
          (json['secondaryActions'] as List<dynamic>?)
              ?.map((e) => ActionCapability.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ActionCapability>[],
      syncState: $enumDecode(_$SyncStateEnumMap, json['syncState']),
    );

Map<String, dynamic> _$TaskItemEntityToJson(
  _TaskItemEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$TaskItemTypeEnumMap[instance.type]!,
  'status': _$TaskItemStatusEnumMap[instance.status]!,
  'severity': _$SeverityEnumMap[instance.severity]!,
  'title': instance.title,
  'description': instance.description,
  'sourceModule': instance.sourceModule,
  'sourceEntityType': instance.sourceEntityType,
  'sourceEntityId': instance.sourceEntityId,
  'sourceEntityNo': instance.sourceEntityNo,
  'routeName': instance.routeName,
  'routeParams': instance.routeParams,
  'ageMinutes': instance.ageMinutes,
  'dueAt': instance.dueAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'primaryAction': instance.primaryAction.toJson(),
  'secondaryActions': instance.secondaryActions.map((e) => e.toJson()).toList(),
  'syncState': _$SyncStateEnumMap[instance.syncState]!,
};

const _$TaskItemTypeEnumMap = {
  TaskItemType.receipt: 'receipt',
  TaskItemType.shipment: 'shipment',
  TaskItemType.ocr: 'ocr',
  TaskItemType.inventory: 'inventory',
  TaskItemType.aiSuggestion: 'ai_suggestion',
  TaskItemType.systemAlert: 'system_alert',
};

const _$TaskItemStatusEnumMap = {
  TaskItemStatus.open: 'open',
  TaskItemStatus.acknowledged: 'acknowledged',
  TaskItemStatus.snoozed: 'snoozed',
  TaskItemStatus.completed: 'completed',
};

const _$SeverityEnumMap = {
  Severity.low: 'low',
  Severity.medium: 'medium',
  Severity.high: 'high',
  Severity.critical: 'critical',
};

const _$SyncStateEnumMap = {
  SyncState.synced: 'synced',
  SyncState.pending: 'pending',
  SyncState.failed: 'failed',
};

_TaskItemDto _$TaskItemDtoFromJson(Map<String, dynamic> json) => _TaskItemDto(
  id: json['id'] as String,
  type: $enumDecode(_$TaskItemTypeEnumMap, json['type']),
  status: $enumDecode(_$TaskItemStatusEnumMap, json['status']),
  severity: $enumDecode(_$SeverityEnumMap, json['severity']),
  title: json['title'] as String,
  description: json['description'] as String?,
  sourceModule: json['source_module'] as String,
  sourceEntityType: json['source_entity_type'] as String?,
  sourceEntityId: json['source_entity_id'] as String?,
  sourceEntityNo: json['source_entity_no'] as String?,
  routeName: json['route_name'] as String?,
  routeParams: (json['route_params'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  ageMinutes: (json['age_minutes'] as num?)?.toInt(),
  dueAt: json['due_at'] == null
      ? null
      : DateTime.parse(json['due_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  primaryAction: ActionCapability.fromJson(
    json['primary_action'] as Map<String, dynamic>,
  ),
  secondaryActions:
      (json['secondary_actions'] as List<dynamic>?)
          ?.map((e) => ActionCapability.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ActionCapability>[],
  syncState: $enumDecode(_$SyncStateEnumMap, json['sync_state']),
);

Map<String, dynamic> _$TaskItemDtoToJson(_TaskItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TaskItemTypeEnumMap[instance.type]!,
      'status': _$TaskItemStatusEnumMap[instance.status]!,
      'severity': _$SeverityEnumMap[instance.severity]!,
      'title': instance.title,
      'description': instance.description,
      'source_module': instance.sourceModule,
      'source_entity_type': instance.sourceEntityType,
      'source_entity_id': instance.sourceEntityId,
      'source_entity_no': instance.sourceEntityNo,
      'route_name': instance.routeName,
      'route_params': instance.routeParams,
      'age_minutes': instance.ageMinutes,
      'due_at': instance.dueAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'primary_action': instance.primaryAction.toJson(),
      'secondary_actions': instance.secondaryActions
          .map((e) => e.toJson())
          .toList(),
      'sync_state': _$SyncStateEnumMap[instance.syncState]!,
    };
