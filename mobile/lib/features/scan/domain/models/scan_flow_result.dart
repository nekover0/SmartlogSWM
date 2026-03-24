import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

class ScanFlowResult {
  const ScanFlowResult({
    required this.mode,
    this.success = true,
    this.sessionId,
    this.referenceId,
    this.warehouseId,
    this.itemCode,
    this.locationCode,
    this.quantity,
    this.submittedAt,
    this.message,
  });

  final ScanMode mode;
  final bool success;
  final String? sessionId;
  final String? referenceId;
  final String? warehouseId;
  final String? itemCode;
  final String? locationCode;
  final double? quantity;
  final DateTime? submittedAt;
  final String? message;

  factory ScanFlowResult.fromJson(Map<String, dynamic> json) {
    return ScanFlowResult(
      mode: _scanModeFromJson(json['mode'] as String),
      success: json['success'] as bool? ?? true,
      sessionId: json['session_id'] as String?,
      referenceId: json['reference_id'] as String?,
      warehouseId: json['warehouse_id'] as String?,
      itemCode: json['item_code'] as String?,
      locationCode: json['location_code'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      submittedAt: json['submitted_at'] == null
          ? null
          : DateTime.parse(json['submitted_at'] as String),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mode': mode.name,
      'success': success,
      'session_id': sessionId,
      'reference_id': referenceId,
      'warehouse_id': warehouseId,
      'item_code': itemCode,
      'location_code': locationCode,
      'quantity': quantity,
      'submitted_at': submittedAt?.toIso8601String(),
      'message': message,
    };
  }

  ScanFlowResult copyWith({
    ScanMode? mode,
    bool? success,
    String? sessionId,
    String? referenceId,
    String? warehouseId,
    String? itemCode,
    String? locationCode,
    double? quantity,
    DateTime? submittedAt,
    String? message,
  }) {
    return ScanFlowResult(
      mode: mode ?? this.mode,
      success: success ?? this.success,
      sessionId: sessionId ?? this.sessionId,
      referenceId: referenceId ?? this.referenceId,
      warehouseId: warehouseId ?? this.warehouseId,
      itemCode: itemCode ?? this.itemCode,
      locationCode: locationCode ?? this.locationCode,
      quantity: quantity ?? this.quantity,
      submittedAt: submittedAt ?? this.submittedAt,
      message: message ?? this.message,
    );
  }
}

ScanMode _scanModeFromJson(String rawValue) {
  return ScanMode.values.firstWhere(
    (mode) => mode.name == rawValue,
    orElse: () => ScanMode.receive,
  );
}
