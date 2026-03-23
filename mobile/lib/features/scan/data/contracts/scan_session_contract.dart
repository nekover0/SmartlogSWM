import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

part 'scan_session_contract.freezed.dart';
part 'scan_session_contract.g.dart';

@freezed
abstract class ScanSessionEntity with _$ScanSessionEntity {
  @JsonSerializable(explicitToJson: true)
  const factory ScanSessionEntity({
    required String id,
    required ScanMode mode,
    required ScanSessionState state,
    @Default(false) bool cameraGranted,
    String? lookupCode,
    String? resolvedItemCode,
    String? resolvedLocationCode,
    String? referenceId,
    String? warehouseId,
    double? quantity,
    double? countedQuantity,
    String? sourceLocationCode,
    String? destinationLocationCode,
    String? reasonCode,
    String? errorMessage,
    required SyncState syncState,
    required DateTime startedAt,
    required DateTime updatedAt,
    DateTime? submittedAt,
  }) = _ScanSessionEntity;

  factory ScanSessionEntity.fromJson(Map<String, dynamic> json) =>
      _$ScanSessionEntityFromJson(json);
}

@freezed
abstract class ScanSessionDraftDto with _$ScanSessionDraftDto {
  @JsonSerializable(explicitToJson: true)
  const factory ScanSessionDraftDto({
    required String id,
    required ScanMode mode,
    required ScanSessionState state,
    @JsonKey(name: 'camera_granted') @Default(false) bool cameraGranted,
    @JsonKey(name: 'lookup_code') String? lookupCode,
    @JsonKey(name: 'resolved_item_code') String? resolvedItemCode,
    @JsonKey(name: 'resolved_location_code') String? resolvedLocationCode,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'warehouse_id') String? warehouseId,
    double? quantity,
    @JsonKey(name: 'counted_quantity') double? countedQuantity,
    @JsonKey(name: 'source_location_code') String? sourceLocationCode,
    @JsonKey(name: 'destination_location_code') String? destinationLocationCode,
    @JsonKey(name: 'reason_code') String? reasonCode,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'sync_state') required SyncState syncState,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
  }) = _ScanSessionDraftDto;

  factory ScanSessionDraftDto.fromJson(Map<String, dynamic> json) =>
      _$ScanSessionDraftDtoFromJson(json);
}

@freezed
abstract class ScanSubmitRequestDto with _$ScanSubmitRequestDto {
  @JsonSerializable(explicitToJson: true)
  const factory ScanSubmitRequestDto({
    required ScanMode mode,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'warehouse_id') String? warehouseId,
    @JsonKey(name: 'item_code') String? itemCode,
    @JsonKey(name: 'location_code') String? locationCode,
    @JsonKey(name: 'source_location_code') String? sourceLocationCode,
    @JsonKey(name: 'destination_location_code') String? destinationLocationCode,
    double? quantity,
    @JsonKey(name: 'counted_quantity') double? countedQuantity,
    @JsonKey(name: 'reason_code') String? reasonCode,
  }) = _ScanSubmitRequestDto;

  factory ScanSubmitRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ScanSubmitRequestDtoFromJson(json);
}

extension ScanSessionDraftDtoMapper on ScanSessionDraftDto {
  ScanSessionEntity toEntity() {
    return ScanSessionEntity(
      id: id,
      mode: mode,
      state: state,
      cameraGranted: cameraGranted,
      lookupCode: lookupCode,
      resolvedItemCode: resolvedItemCode,
      resolvedLocationCode: resolvedLocationCode,
      referenceId: referenceId,
      warehouseId: warehouseId,
      quantity: quantity,
      countedQuantity: countedQuantity,
      sourceLocationCode: sourceLocationCode,
      destinationLocationCode: destinationLocationCode,
      reasonCode: reasonCode,
      errorMessage: errorMessage,
      syncState: syncState,
      startedAt: startedAt,
      updatedAt: updatedAt,
      submittedAt: submittedAt,
    );
  }
}

extension ScanSessionEntityMapper on ScanSessionEntity {
  ScanSessionDraftDto toDraftDto() {
    return ScanSessionDraftDto(
      id: id,
      mode: mode,
      state: state,
      cameraGranted: cameraGranted,
      lookupCode: lookupCode,
      resolvedItemCode: resolvedItemCode,
      resolvedLocationCode: resolvedLocationCode,
      referenceId: referenceId,
      warehouseId: warehouseId,
      quantity: quantity,
      countedQuantity: countedQuantity,
      sourceLocationCode: sourceLocationCode,
      destinationLocationCode: destinationLocationCode,
      reasonCode: reasonCode,
      errorMessage: errorMessage,
      syncState: syncState,
      startedAt: startedAt,
      updatedAt: updatedAt,
      submittedAt: submittedAt,
    );
  }

  ScanSubmitRequestDto toSubmitRequest() {
    return ScanSubmitRequestDto(
      mode: mode,
      referenceId: referenceId,
      warehouseId: warehouseId,
      itemCode: resolvedItemCode,
      locationCode: resolvedLocationCode,
      sourceLocationCode: sourceLocationCode,
      destinationLocationCode: destinationLocationCode,
      quantity: quantity,
      countedQuantity: countedQuantity,
      reasonCode: reasonCode,
    );
  }
}
