// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_record_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OcrExtractedFieldsEntity _$OcrExtractedFieldsEntityFromJson(
  Map<String, dynamic> json,
) => _OcrExtractedFieldsEntity(
  documentNo: json['documentNo'] as String?,
  vehiclePlate: json['vehiclePlate'] as String?,
  ownerCode: json['ownerCode'] as String?,
  ownerName: json['ownerName'] as String?,
  itemCode: json['itemCode'] as String?,
  itemName: json['itemName'] as String?,
  grossWeightKg: (json['grossWeightKg'] as num?)?.toDouble(),
  netWeightKg: (json['netWeightKg'] as num?)?.toDouble(),
);

Map<String, dynamic> _$OcrExtractedFieldsEntityToJson(
  _OcrExtractedFieldsEntity instance,
) => <String, dynamic>{
  'documentNo': instance.documentNo,
  'vehiclePlate': instance.vehiclePlate,
  'ownerCode': instance.ownerCode,
  'ownerName': instance.ownerName,
  'itemCode': instance.itemCode,
  'itemName': instance.itemName,
  'grossWeightKg': instance.grossWeightKg,
  'netWeightKg': instance.netWeightKg,
};

_OcrRecordEntity _$OcrRecordEntityFromJson(Map<String, dynamic> json) =>
    _OcrRecordEntity(
      id: json['id'] as String,
      direction: $enumDecode(_$DocumentDirectionEnumMap, json['direction']),
      status: $enumDecode(_$OcrRecordStatusEnumMap, json['status']),
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      confidenceLevel: $enumDecode(
        _$ConfidenceLevelEnumMap,
        json['confidenceLevel'],
      ),
      extractedFields: OcrExtractedFieldsEntity.fromJson(
        json['extractedFields'] as Map<String, dynamic>,
      ),
      reviewFlags:
          (json['reviewFlags'] as List<dynamic>?)
              ?.map((e) => FieldReviewFlag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FieldReviewFlag>[],
      sourceImageUrl: json['sourceImageUrl'] as String,
      linkedTargetType: $enumDecode(
        _$LinkedTargetTypeEnumMap,
        json['linkedTargetType'],
      ),
      linkedTargetId: json['linkedTargetId'] as String?,
      linkedTargetNo: json['linkedTargetNo'] as String?,
      errorMessage: json['errorMessage'] as String?,
      capturedAt: DateTime.parse(json['capturedAt'] as String),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      linkedAt: json['linkedAt'] == null
          ? null
          : DateTime.parse(json['linkedAt'] as String),
      syncState: $enumDecode(_$SyncStateEnumMap, json['syncState']),
    );

Map<String, dynamic> _$OcrRecordEntityToJson(_OcrRecordEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'direction': _$DocumentDirectionEnumMap[instance.direction]!,
      'status': _$OcrRecordStatusEnumMap[instance.status]!,
      'confidenceScore': instance.confidenceScore,
      'confidenceLevel': _$ConfidenceLevelEnumMap[instance.confidenceLevel]!,
      'extractedFields': instance.extractedFields.toJson(),
      'reviewFlags': instance.reviewFlags.map((e) => e.toJson()).toList(),
      'sourceImageUrl': instance.sourceImageUrl,
      'linkedTargetType': _$LinkedTargetTypeEnumMap[instance.linkedTargetType]!,
      'linkedTargetId': instance.linkedTargetId,
      'linkedTargetNo': instance.linkedTargetNo,
      'errorMessage': instance.errorMessage,
      'capturedAt': instance.capturedAt.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
      'linkedAt': instance.linkedAt?.toIso8601String(),
      'syncState': _$SyncStateEnumMap[instance.syncState]!,
    };

const _$DocumentDirectionEnumMap = {
  DocumentDirection.inbound: 'inbound',
  DocumentDirection.outbound: 'outbound',
};

const _$OcrRecordStatusEnumMap = {
  OcrRecordStatus.captured: 'captured',
  OcrRecordStatus.processing: 'processing',
  OcrRecordStatus.extracted: 'extracted',
  OcrRecordStatus.reviewRequired: 'review_required',
  OcrRecordStatus.confirmed: 'confirmed',
  OcrRecordStatus.linked: 'linked',
  OcrRecordStatus.failed: 'failed',
  OcrRecordStatus.rejected: 'rejected',
  OcrRecordStatus.relinkRequired: 'relink_required',
};

const _$ConfidenceLevelEnumMap = {
  ConfidenceLevel.low: 'low',
  ConfidenceLevel.medium: 'medium',
  ConfidenceLevel.high: 'high',
};

const _$LinkedTargetTypeEnumMap = {
  LinkedTargetType.none: 'none',
  LinkedTargetType.receipt: 'receipt',
  LinkedTargetType.shipment: 'shipment',
};

const _$SyncStateEnumMap = {
  SyncState.synced: 'synced',
  SyncState.pending: 'pending',
  SyncState.failed: 'failed',
};

_OcrExtractedFieldsDto _$OcrExtractedFieldsDtoFromJson(
  Map<String, dynamic> json,
) => _OcrExtractedFieldsDto(
  documentNo: json['document_no'] as String?,
  vehiclePlate: json['vehicle_plate'] as String?,
  ownerCode: json['owner_code'] as String?,
  ownerName: json['owner_name'] as String?,
  itemCode: json['item_code'] as String?,
  itemName: json['item_name'] as String?,
  grossWeightKg: (json['gross_weight_kg'] as num?)?.toDouble(),
  netWeightKg: (json['net_weight_kg'] as num?)?.toDouble(),
);

Map<String, dynamic> _$OcrExtractedFieldsDtoToJson(
  _OcrExtractedFieldsDto instance,
) => <String, dynamic>{
  'document_no': instance.documentNo,
  'vehicle_plate': instance.vehiclePlate,
  'owner_code': instance.ownerCode,
  'owner_name': instance.ownerName,
  'item_code': instance.itemCode,
  'item_name': instance.itemName,
  'gross_weight_kg': instance.grossWeightKg,
  'net_weight_kg': instance.netWeightKg,
};

_OcrRecordDto _$OcrRecordDtoFromJson(Map<String, dynamic> json) =>
    _OcrRecordDto(
      id: json['id'] as String,
      direction: $enumDecode(_$DocumentDirectionEnumMap, json['direction']),
      status: $enumDecode(_$OcrRecordStatusEnumMap, json['status']),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      confidenceLevel: $enumDecode(
        _$ConfidenceLevelEnumMap,
        json['confidence_level'],
      ),
      extractedFields: OcrExtractedFieldsDto.fromJson(
        json['extracted_fields'] as Map<String, dynamic>,
      ),
      reviewFlags:
          (json['review_flags'] as List<dynamic>?)
              ?.map((e) => FieldReviewFlag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FieldReviewFlag>[],
      sourceImageUrl: json['source_image_url'] as String,
      linkedTargetType:
          $enumDecodeNullable(
            _$LinkedTargetTypeEnumMap,
            json['linked_target_type'],
          ) ??
          LinkedTargetType.none,
      linkedTargetId: json['linked_target_id'] as String?,
      linkedTargetNo: json['linked_target_no'] as String?,
      errorMessage: json['error_message'] as String?,
      capturedAt: DateTime.parse(json['captured_at'] as String),
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
      linkedAt: json['linked_at'] == null
          ? null
          : DateTime.parse(json['linked_at'] as String),
      syncState: $enumDecode(_$SyncStateEnumMap, json['sync_state']),
    );

Map<String, dynamic> _$OcrRecordDtoToJson(
  _OcrRecordDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'direction': _$DocumentDirectionEnumMap[instance.direction]!,
  'status': _$OcrRecordStatusEnumMap[instance.status]!,
  'confidence_score': instance.confidenceScore,
  'confidence_level': _$ConfidenceLevelEnumMap[instance.confidenceLevel]!,
  'extracted_fields': instance.extractedFields.toJson(),
  'review_flags': instance.reviewFlags.map((e) => e.toJson()).toList(),
  'source_image_url': instance.sourceImageUrl,
  'linked_target_type': _$LinkedTargetTypeEnumMap[instance.linkedTargetType]!,
  'linked_target_id': instance.linkedTargetId,
  'linked_target_no': instance.linkedTargetNo,
  'error_message': instance.errorMessage,
  'captured_at': instance.capturedAt.toIso8601String(),
  'processed_at': instance.processedAt?.toIso8601String(),
  'linked_at': instance.linkedAt?.toIso8601String(),
  'sync_state': _$SyncStateEnumMap[instance.syncState]!,
};
