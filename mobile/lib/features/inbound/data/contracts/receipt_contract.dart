import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

part 'receipt_contract.freezed.dart';
part 'receipt_contract.g.dart';

@freezed
abstract class ReceiptLineEntity with _$ReceiptLineEntity {
  @JsonSerializable(explicitToJson: true)
  const factory ReceiptLineEntity({
    required String id,
    required String itemCode,
    required String itemName,
    required String uomCode,
    required double expectedQty,
    required double receivedQty,
    required double varianceQty,
  }) = _ReceiptLineEntity;

  factory ReceiptLineEntity.fromJson(Map<String, dynamic> json) =>
      _$ReceiptLineEntityFromJson(json);
}

@freezed
abstract class ReceiptEntity with _$ReceiptEntity {
  @JsonSerializable(explicitToJson: true)
  const factory ReceiptEntity({
    required String id,
    required String receiptNo,
    required ReceiptStatus status,
    required OwnerSummary owner,
    required WarehouseSummary warehouse,
    required VehicleInfo vehicle,
    String? purchaseOrderNo,
    String? billOfLadingNo,
    String? vesselName,
    required double expectedWeightKg,
    required double receivedWeightKg,
    double? portWeightKg,
    required double varianceWeightKg,
    String? sourceOcrRecordId,
    required SyncState syncState,
    @Default(<ActionCapability>[]) List<ActionCapability> availableActions,
    @Default(<ReceiptLineEntity>[]) List<ReceiptLineEntity> lines,
    String? note,
    String? errorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReceiptEntity;

  factory ReceiptEntity.fromJson(Map<String, dynamic> json) =>
      _$ReceiptEntityFromJson(json);
}

@freezed
abstract class ReceiptLineDto with _$ReceiptLineDto {
  @JsonSerializable(explicitToJson: true)
  const factory ReceiptLineDto({
    required String id,
    @JsonKey(name: 'item_code') required String itemCode,
    @JsonKey(name: 'item_name') required String itemName,
    @JsonKey(name: 'uom_code') required String uomCode,
    @JsonKey(name: 'expected_qty') required double expectedQty,
    @JsonKey(name: 'received_qty') required double receivedQty,
    @JsonKey(name: 'variance_qty') required double varianceQty,
  }) = _ReceiptLineDto;

  factory ReceiptLineDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptLineDtoFromJson(json);
}

@freezed
abstract class ReceiptDto with _$ReceiptDto {
  @JsonSerializable(explicitToJson: true)
  const factory ReceiptDto({
    required String id,
    @JsonKey(name: 'receipt_no') required String receiptNo,
    required ReceiptStatus status,
    required OwnerSummary owner,
    required WarehouseSummary warehouse,
    required VehicleInfo vehicle,
    @JsonKey(name: 'purchase_order_no') String? purchaseOrderNo,
    @JsonKey(name: 'bill_of_lading_no') String? billOfLadingNo,
    @JsonKey(name: 'vessel_name') String? vesselName,
    @JsonKey(name: 'expected_weight_kg') required double expectedWeightKg,
    @JsonKey(name: 'received_weight_kg') required double receivedWeightKg,
    @JsonKey(name: 'port_weight_kg') double? portWeightKg,
    @JsonKey(name: 'variance_weight_kg') required double varianceWeightKg,
    @JsonKey(name: 'source_ocr_record_id') String? sourceOcrRecordId,
    @JsonKey(name: 'sync_state') required SyncState syncState,
    @JsonKey(name: 'available_actions')
    @Default(<ActionCapability>[])
    List<ActionCapability> availableActions,
    @Default(<ReceiptLineDto>[]) List<ReceiptLineDto> lines,
    String? note,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ReceiptDto;

  factory ReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDtoFromJson(json);
}

extension ReceiptLineDtoMapper on ReceiptLineDto {
  ReceiptLineEntity toEntity() {
    return ReceiptLineEntity(
      id: id,
      itemCode: itemCode,
      itemName: itemName,
      uomCode: uomCode,
      expectedQty: expectedQty,
      receivedQty: receivedQty,
      varianceQty: varianceQty,
    );
  }
}

extension ReceiptDtoMapper on ReceiptDto {
  ReceiptEntity toEntity() {
    return ReceiptEntity(
      id: id,
      receiptNo: receiptNo,
      status: status,
      owner: owner,
      warehouse: warehouse,
      vehicle: vehicle,
      purchaseOrderNo: purchaseOrderNo,
      billOfLadingNo: billOfLadingNo,
      vesselName: vesselName,
      expectedWeightKg: expectedWeightKg,
      receivedWeightKg: receivedWeightKg,
      portWeightKg: portWeightKg,
      varianceWeightKg: varianceWeightKg,
      sourceOcrRecordId: sourceOcrRecordId,
      syncState: syncState,
      availableActions: availableActions,
      lines: lines.map((line) => line.toEntity()).toList(),
      note: note,
      errorMessage: errorMessage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
