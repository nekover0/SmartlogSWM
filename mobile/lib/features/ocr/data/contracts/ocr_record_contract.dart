import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

part 'ocr_record_contract.freezed.dart';
part 'ocr_record_contract.g.dart';

@freezed
abstract class OcrExtractedFieldsEntity with _$OcrExtractedFieldsEntity {
  @JsonSerializable(explicitToJson: true)
  const factory OcrExtractedFieldsEntity({
    String? documentNo,
    String? vehiclePlate,
    String? ownerCode,
    String? ownerName,
    String? itemCode,
    String? itemName,
    double? grossWeightKg,
    double? netWeightKg,
  }) = _OcrExtractedFieldsEntity;

  factory OcrExtractedFieldsEntity.fromJson(Map<String, dynamic> json) =>
      _$OcrExtractedFieldsEntityFromJson(json);
}

@freezed
abstract class OcrRecordEntity with _$OcrRecordEntity {
  @JsonSerializable(explicitToJson: true)
  const factory OcrRecordEntity({
    required String id,
    required DocumentDirection direction,
    required OcrRecordStatus status,
    required double confidenceScore,
    required ConfidenceLevel confidenceLevel,
    required OcrExtractedFieldsEntity extractedFields,
    @Default(<FieldReviewFlag>[]) List<FieldReviewFlag> reviewFlags,
    required String sourceImageUrl,
    required LinkedTargetType linkedTargetType,
    String? linkedTargetId,
    String? linkedTargetNo,
    String? errorMessage,
    required DateTime capturedAt,
    DateTime? processedAt,
    DateTime? linkedAt,
    required SyncState syncState,
  }) = _OcrRecordEntity;

  factory OcrRecordEntity.fromJson(Map<String, dynamic> json) =>
      _$OcrRecordEntityFromJson(json);
}

@freezed
abstract class OcrExtractedFieldsDto with _$OcrExtractedFieldsDto {
  @JsonSerializable(explicitToJson: true)
  const factory OcrExtractedFieldsDto({
    @JsonKey(name: 'document_no') String? documentNo,
    @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
    @JsonKey(name: 'owner_code') String? ownerCode,
    @JsonKey(name: 'owner_name') String? ownerName,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'item_name') String? itemName,
    @JsonKey(name: 'gross_weight_kg') double? grossWeightKg,
    @JsonKey(name: 'net_weight_kg') double? netWeightKg,
  }) = _OcrExtractedFieldsDto;

  factory OcrExtractedFieldsDto.fromJson(Map<String, dynamic> json) =>
      _$OcrExtractedFieldsDtoFromJson(json);
}

@freezed
abstract class OcrRecordDto with _$OcrRecordDto {
  @JsonSerializable(explicitToJson: true)
  const factory OcrRecordDto({
    required String id,
    required DocumentDirection direction,
    required OcrRecordStatus status,
    @JsonKey(name: 'confidence_score') required double confidenceScore,
    @JsonKey(name: 'confidence_level') required ConfidenceLevel confidenceLevel,
    @JsonKey(name: 'extracted_fields')
    required OcrExtractedFieldsDto extractedFields,
    @JsonKey(name: 'review_flags')
    @Default(<FieldReviewFlag>[])
    List<FieldReviewFlag> reviewFlags,
    @JsonKey(name: 'source_image_url') required String sourceImageUrl,
    @JsonKey(name: 'linked_target_type')
    @Default(LinkedTargetType.none)
    LinkedTargetType linkedTargetType,
    @JsonKey(name: 'linked_target_id') String? linkedTargetId,
    @JsonKey(name: 'linked_target_no') String? linkedTargetNo,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'captured_at') required DateTime capturedAt,
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    @JsonKey(name: 'linked_at') DateTime? linkedAt,
    @JsonKey(name: 'sync_state') required SyncState syncState,
  }) = _OcrRecordDto;

  factory OcrRecordDto.fromJson(Map<String, dynamic> json) =>
      _$OcrRecordDtoFromJson(json);
}

extension OcrExtractedFieldsDtoMapper on OcrExtractedFieldsDto {
  OcrExtractedFieldsEntity toEntity() {
    return OcrExtractedFieldsEntity(
      documentNo: documentNo,
      vehiclePlate: vehiclePlate,
      ownerCode: ownerCode,
      ownerName: ownerName,
      itemCode: itemCode,
      itemName: itemName,
      grossWeightKg: grossWeightKg,
      netWeightKg: netWeightKg,
    );
  }
}

extension OcrRecordDtoMapper on OcrRecordDto {
  OcrRecordEntity toEntity() {
    return OcrRecordEntity(
      id: id,
      direction: direction,
      status: status,
      confidenceScore: confidenceScore,
      confidenceLevel: confidenceLevel,
      extractedFields: extractedFields.toEntity(),
      reviewFlags: reviewFlags,
      sourceImageUrl: sourceImageUrl,
      linkedTargetType: linkedTargetType,
      linkedTargetId: linkedTargetId,
      linkedTargetNo: linkedTargetNo,
      errorMessage: errorMessage,
      capturedAt: capturedAt,
      processedAt: processedAt,
      linkedAt: linkedAt,
      syncState: syncState,
    );
  }
}
