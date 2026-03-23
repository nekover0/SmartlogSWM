import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

part 'shipment_contract.freezed.dart';
part 'shipment_contract.g.dart';

@freezed
abstract class ShipmentLineEntity with _$ShipmentLineEntity {
  @JsonSerializable(explicitToJson: true)
  const factory ShipmentLineEntity({
    required String id,
    required String itemCode,
    required String itemName,
    required String uomCode,
    required double expectedQty,
    required double shippedQty,
    required bool shortPick,
    LocationSummary? sourceLocation,
  }) = _ShipmentLineEntity;

  factory ShipmentLineEntity.fromJson(Map<String, dynamic> json) =>
      _$ShipmentLineEntityFromJson(json);
}

@freezed
abstract class ShipmentEntity with _$ShipmentEntity {
  @JsonSerializable(explicitToJson: true)
  const factory ShipmentEntity({
    required String id,
    required String shipmentNo,
    required ShipmentStatus status,
    required OwnerSummary owner,
    required WarehouseSummary warehouse,
    required VehicleInfo vehicle,
    String? salesOrderNo,
    String? billOfLadingNo,
    required double expectedWeightKg,
    required double shippedWeightKg,
    double? varianceWeightKg,
    required SyncState syncState,
    @Default(<ActionCapability>[]) List<ActionCapability> availableActions,
    @Default(<ShipmentLineEntity>[]) List<ShipmentLineEntity> lines,
    String? note,
    String? errorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ShipmentEntity;

  factory ShipmentEntity.fromJson(Map<String, dynamic> json) =>
      _$ShipmentEntityFromJson(json);
}

@freezed
abstract class ShipmentLineDto with _$ShipmentLineDto {
  @JsonSerializable(explicitToJson: true)
  const factory ShipmentLineDto({
    required String id,
    @JsonKey(name: 'item_code') required String itemCode,
    @JsonKey(name: 'item_name') required String itemName,
    @JsonKey(name: 'uom_code') required String uomCode,
    @JsonKey(name: 'expected_qty') required double expectedQty,
    @JsonKey(name: 'shipped_qty') required double shippedQty,
    @JsonKey(name: 'short_pick') @Default(false) bool shortPick,
    @JsonKey(name: 'source_location') LocationSummary? sourceLocation,
  }) = _ShipmentLineDto;

  factory ShipmentLineDto.fromJson(Map<String, dynamic> json) =>
      _$ShipmentLineDtoFromJson(json);
}

@freezed
abstract class ShipmentDto with _$ShipmentDto {
  @JsonSerializable(explicitToJson: true)
  const factory ShipmentDto({
    required String id,
    @JsonKey(name: 'shipment_no') required String shipmentNo,
    required ShipmentStatus status,
    required OwnerSummary owner,
    required WarehouseSummary warehouse,
    required VehicleInfo vehicle,
    @JsonKey(name: 'sales_order_no') String? salesOrderNo,
    @JsonKey(name: 'bill_of_lading_no') String? billOfLadingNo,
    @JsonKey(name: 'expected_weight_kg') required double expectedWeightKg,
    @JsonKey(name: 'shipped_weight_kg') required double shippedWeightKg,
    @JsonKey(name: 'variance_weight_kg') double? varianceWeightKg,
    @JsonKey(name: 'sync_state') required SyncState syncState,
    @JsonKey(name: 'available_actions')
    @Default(<ActionCapability>[])
    List<ActionCapability> availableActions,
    @Default(<ShipmentLineDto>[]) List<ShipmentLineDto> lines,
    String? note,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ShipmentDto;

  factory ShipmentDto.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDtoFromJson(json);
}

extension ShipmentLineDtoMapper on ShipmentLineDto {
  ShipmentLineEntity toEntity() {
    return ShipmentLineEntity(
      id: id,
      itemCode: itemCode,
      itemName: itemName,
      uomCode: uomCode,
      expectedQty: expectedQty,
      shippedQty: shippedQty,
      shortPick: shortPick,
      sourceLocation: sourceLocation,
    );
  }
}

extension ShipmentDtoMapper on ShipmentDto {
  ShipmentEntity toEntity() {
    return ShipmentEntity(
      id: id,
      shipmentNo: shipmentNo,
      status: status,
      owner: owner,
      warehouse: warehouse,
      vehicle: vehicle,
      salesOrderNo: salesOrderNo,
      billOfLadingNo: billOfLadingNo,
      expectedWeightKg: expectedWeightKg,
      shippedWeightKg: shippedWeightKg,
      varianceWeightKg: varianceWeightKg,
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
