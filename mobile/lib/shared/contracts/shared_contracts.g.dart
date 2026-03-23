// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_contracts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerSummary _$OwnerSummaryFromJson(Map<String, dynamic> json) =>
    _OwnerSummary(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$OwnerSummaryToJson(_OwnerSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
    };

_WarehouseSummary _$WarehouseSummaryFromJson(Map<String, dynamic> json) =>
    _WarehouseSummary(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$WarehouseSummaryToJson(_WarehouseSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
    };

_LocationSummary _$LocationSummaryFromJson(Map<String, dynamic> json) =>
    _LocationSummary(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LocationSummaryToJson(_LocationSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
    };

_VehicleInfo _$VehicleInfoFromJson(Map<String, dynamic> json) => _VehicleInfo(
  plateNumber: json['plateNumber'] as String?,
  vesselName: json['vesselName'] as String?,
  driverName: json['driverName'] as String?,
);

Map<String, dynamic> _$VehicleInfoToJson(_VehicleInfo instance) =>
    <String, dynamic>{
      'plateNumber': instance.plateNumber,
      'vesselName': instance.vesselName,
      'driverName': instance.driverName,
    };

_ActionCapability _$ActionCapabilityFromJson(Map<String, dynamic> json) =>
    _ActionCapability(
      type: $enumDecode(_$TaskActionTypeEnumMap, json['type']),
      label: json['label'] as String,
      routeName: json['routeName'] as String?,
      routeParams: (json['routeParams'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$ActionCapabilityToJson(_ActionCapability instance) =>
    <String, dynamic>{
      'type': _$TaskActionTypeEnumMap[instance.type]!,
      'label': instance.label,
      'routeName': instance.routeName,
      'routeParams': instance.routeParams,
      'enabled': instance.enabled,
    };

const _$TaskActionTypeEnumMap = {
  TaskActionType.open: 'open',
  TaskActionType.approve: 'approve',
  TaskActionType.dismiss: 'dismiss',
  TaskActionType.acknowledge: 'acknowledge',
  TaskActionType.startWeighing: 'start_weighing',
  TaskActionType.startPicking: 'start_picking',
  TaskActionType.reviewOcr: 'review_ocr',
  TaskActionType.viewInventory: 'view_inventory',
  TaskActionType.custom: 'custom',
};

_FieldReviewFlag _$FieldReviewFlagFromJson(Map<String, dynamic> json) =>
    _FieldReviewFlag(
      fieldName: json['fieldName'] as String,
      rawValue: json['rawValue'] as String?,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      level: $enumDecode(_$ConfidenceLevelEnumMap, json['level']),
      requiredReview: json['requiredReview'] as bool? ?? false,
    );

Map<String, dynamic> _$FieldReviewFlagToJson(_FieldReviewFlag instance) =>
    <String, dynamic>{
      'fieldName': instance.fieldName,
      'rawValue': instance.rawValue,
      'confidenceScore': instance.confidenceScore,
      'level': _$ConfidenceLevelEnumMap[instance.level]!,
      'requiredReview': instance.requiredReview,
    };

const _$ConfidenceLevelEnumMap = {
  ConfidenceLevel.low: 'low',
  ConfidenceLevel.medium: 'medium',
  ConfidenceLevel.high: 'high',
};
