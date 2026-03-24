import 'package:flutter/foundation.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

@immutable
class ScanLaunchContext {
  const ScanLaunchContext({
    required this.mode,
    this.referenceId,
    this.referenceNo,
    this.warehouseId,
    this.warehouseCode,
    this.originRouteName,
    this.originRouteParams = const <String, String>{},
  });

  final ScanMode mode;
  final String? referenceId;
  final String? referenceNo;
  final String? warehouseId;
  final String? warehouseCode;
  final String? originRouteName;
  final Map<String, String> originRouteParams;

  bool get isReceive => mode == ScanMode.receive;

  ScanLaunchContext copyWith({
    ScanMode? mode,
    String? referenceId,
    String? referenceNo,
    String? warehouseId,
    String? warehouseCode,
    String? originRouteName,
    Map<String, String>? originRouteParams,
  }) {
    return ScanLaunchContext(
      mode: mode ?? this.mode,
      referenceId: referenceId ?? this.referenceId,
      referenceNo: referenceNo ?? this.referenceNo,
      warehouseId: warehouseId ?? this.warehouseId,
      warehouseCode: warehouseCode ?? this.warehouseCode,
      originRouteName: originRouteName ?? this.originRouteName,
      originRouteParams: originRouteParams ?? this.originRouteParams,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ScanLaunchContext &&
            runtimeType == other.runtimeType &&
            mode == other.mode &&
            referenceId == other.referenceId &&
            referenceNo == other.referenceNo &&
            warehouseId == other.warehouseId &&
            warehouseCode == other.warehouseCode &&
            originRouteName == other.originRouteName &&
            mapEquals(originRouteParams, other.originRouteParams);
  }

  @override
  int get hashCode {
    return Object.hash(
      mode,
      referenceId,
      referenceNo,
      warehouseId,
      warehouseCode,
      originRouteName,
      Object.hashAll(
        originRouteParams.entries.map(
          (entry) => Object.hash(entry.key, entry.value),
        ),
      ),
    );
  }
}
