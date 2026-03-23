import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_contracts.freezed.dart';
part 'shared_contracts.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum DocumentDirection { inbound, outbound }

@JsonEnum(fieldRename: FieldRename.snake)
enum SyncState { synced, pending, failed }

@JsonEnum(fieldRename: FieldRename.snake)
enum Severity { low, medium, high, critical }

@JsonEnum(fieldRename: FieldRename.snake)
enum ReceiptStatus {
  draft,
  confirmed,
  waitingForWeighing,
  weighing1,
  weighing2,
  completed,
  error,
  cancelled,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum ShipmentStatus {
  draft,
  confirmed,
  picking,
  loading,
  weighCompleted,
  shipped,
  closed,
  error,
  cancelled,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum OcrRecordStatus {
  captured,
  processing,
  extracted,
  reviewRequired,
  confirmed,
  linked,
  failed,
  rejected,
  relinkRequired,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum LinkedTargetType { none, receipt, shipment }

@JsonEnum(fieldRename: FieldRename.snake)
enum ConfidenceLevel { low, medium, high }

@JsonEnum(fieldRename: FieldRename.snake)
enum TaskItemType {
  receipt,
  shipment,
  ocr,
  inventory,
  aiSuggestion,
  systemAlert,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum TaskItemStatus { open, acknowledged, snoozed, completed }

@JsonEnum(fieldRename: FieldRename.snake)
enum TaskActionType {
  open,
  approve,
  dismiss,
  acknowledge,
  startWeighing,
  startPicking,
  reviewOcr,
  viewInventory,
  custom,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum ScanMode { receive, issue, count, move }

@JsonEnum(fieldRename: FieldRename.snake)
enum ScanSessionState {
  idle,
  permissionPending,
  cameraDenied,
  scanning,
  lookupSuccess,
  lookupNotFound,
  formReady,
  submitting,
  submitSuccess,
  submitFailed,
}

@freezed
abstract class OwnerSummary with _$OwnerSummary {
  const factory OwnerSummary({
    required String id,
    required String code,
    required String name,
  }) = _OwnerSummary;

  factory OwnerSummary.fromJson(Map<String, dynamic> json) =>
      _$OwnerSummaryFromJson(json);
}

@freezed
abstract class WarehouseSummary with _$WarehouseSummary {
  const factory WarehouseSummary({
    required String id,
    required String code,
    required String name,
  }) = _WarehouseSummary;

  factory WarehouseSummary.fromJson(Map<String, dynamic> json) =>
      _$WarehouseSummaryFromJson(json);
}

@freezed
abstract class LocationSummary with _$LocationSummary {
  const factory LocationSummary({
    required String id,
    required String code,
    required String name,
  }) = _LocationSummary;

  factory LocationSummary.fromJson(Map<String, dynamic> json) =>
      _$LocationSummaryFromJson(json);
}

@freezed
abstract class VehicleInfo with _$VehicleInfo {
  const factory VehicleInfo({
    String? plateNumber,
    String? vesselName,
    String? driverName,
  }) = _VehicleInfo;

  factory VehicleInfo.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoFromJson(json);
}

@freezed
abstract class ActionCapability with _$ActionCapability {
  const factory ActionCapability({
    required TaskActionType type,
    required String label,
    String? routeName,
    Map<String, String>? routeParams,
    @Default(true) bool enabled,
  }) = _ActionCapability;

  factory ActionCapability.fromJson(Map<String, dynamic> json) =>
      _$ActionCapabilityFromJson(json);
}

@freezed
abstract class FieldReviewFlag with _$FieldReviewFlag {
  const factory FieldReviewFlag({
    required String fieldName,
    String? rawValue,
    required double confidenceScore,
    required ConfidenceLevel level,
    @Default(false) bool requiredReview,
  }) = _FieldReviewFlag;

  factory FieldReviewFlag.fromJson(Map<String, dynamic> json) =>
      _$FieldReviewFlagFromJson(json);
}
