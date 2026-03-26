import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

part 'scan_session_contract.freezed.dart';
part 'scan_session_contract.g.dart';

/// API-aligned lookup request DTO for `scan.lookupReceive`.
///
/// Field set is validated against implementation plan API section:
/// mode, lookupCode, warehouseId, referenceId.
class LookupReceiveRequestDto {
  const LookupReceiveRequestDto({
    required this.mode,
    required this.lookupCode,
    this.warehouseId,
    this.referenceId,
  });

  final ScanMode mode;
  final String lookupCode;
  final String? warehouseId;
  final String? referenceId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mode': mode.name,
      'lookup_code': lookupCode,
      'warehouse_id': warehouseId,
      'reference_id': referenceId,
    };
  }
}

/// API-aligned lookup response DTO for `scan.lookupReceive`.
///
/// Field set is validated against implementation plan API section:
/// sessionId, state, resolvedItemCode, resolvedLocationCode,
/// referenceId, warehouseId, message.
class LookupReceiveResponseDto {
  const LookupReceiveResponseDto({
    required this.sessionId,
    required this.state,
    this.resolvedItemCode,
    this.resolvedLocationCode,
    this.referenceId,
    this.warehouseId,
    this.message,
  });

  final String sessionId;
  final ScanSessionState state;
  final String? resolvedItemCode;
  final String? resolvedLocationCode;
  final String? referenceId;
  final String? warehouseId;
  final String? message;

  factory LookupReceiveResponseDto.fromSession(ScanSessionEntity session) {
    return LookupReceiveResponseDto(
      sessionId: session.id,
      state: session.state,
      resolvedItemCode: session.resolvedItemCode,
      resolvedLocationCode: session.resolvedLocationCode,
      referenceId: session.referenceId,
      warehouseId: session.warehouseId,
      message: session.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'session_id': sessionId,
      'state': state.name,
      'resolved_item_code': resolvedItemCode,
      'resolved_location_code': resolvedLocationCode,
      'reference_id': referenceId,
      'warehouse_id': warehouseId,
      'message': message,
    };
  }
}

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
    @JsonKey(name: 'session_id') String? sessionId,
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
    @JsonKey(name: 'idempotency_key') String? idempotencyKey,
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
      sessionId: id,
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
      idempotencyKey: _buildSubmitIdempotencyKey(
        sessionId: id,
        mode: mode,
        itemCode: resolvedItemCode,
        locationCode: resolvedLocationCode,
        quantity: quantity,
      ),
    );
  }
}

String _buildSubmitIdempotencyKey({
  required String sessionId,
  required ScanMode mode,
  String? itemCode,
  String? locationCode,
  double? quantity,
}) {
  final normalizedItemCode = itemCode?.trim().toUpperCase() ?? 'NA';
  final normalizedLocationCode = locationCode?.trim().toUpperCase() ?? 'NA';
  final normalizedQuantity = quantity?.toStringAsFixed(3) ?? '0.000';

  return 'mobile-$sessionId-${mode.name}-$normalizedItemCode-$normalizedLocationCode-$normalizedQuantity';
}
