import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final scanFlowProjectionControllerProvider =
    NotifierProvider<ScanFlowProjectionController, ScanFlowProjectionState>(
      ScanFlowProjectionController.new,
    );

class ScanFlowProjectionController extends Notifier<ScanFlowProjectionState> {
  @override
  ScanFlowProjectionState build() {
    return const ScanFlowProjectionState();
  }

  void applyReceiveResult(ScanFlowResult result) {
    final receiptId = _normalizeText(result.referenceId);
    final itemCode = _normalizeText(result.itemCode);
    final quantity = result.quantity ?? 0;

    if (!result.success ||
        result.mode != ScanMode.receive ||
        receiptId == null ||
        itemCode == null ||
        quantity <= 0) {
      return;
    }

    final submittedAt = result.submittedAt ?? DateTime.now().toUtc();
    final currentProjection = state.receiptOverlays[receiptId];
    final nextProjection =
        (currentProjection ?? const ReceiveReceiptProjection()).merge(
          itemCode: itemCode,
          quantity: quantity,
          locationCode: _normalizeText(result.locationCode),
          submittedAt: submittedAt,
          message: _normalizeText(result.message),
        );

    state = state.copyWith(
      receiptOverlays: <String, ReceiveReceiptProjection>{
        ...state.receiptOverlays,
        receiptId: nextProjection,
      },
      resolvedReceiptIds: <String>{...state.resolvedReceiptIds, receiptId},
    );
  }
}

class ScanFlowProjectionState {
  const ScanFlowProjectionState({
    this.receiptOverlays = const <String, ReceiveReceiptProjection>{},
    this.resolvedReceiptIds = const <String>{},
  });

  final Map<String, ReceiveReceiptProjection> receiptOverlays;
  final Set<String> resolvedReceiptIds;

  ReceiptEntity projectReceipt(ReceiptEntity receipt) {
    final overlay = receiptOverlays[receipt.id];
    if (overlay == null) {
      return receipt;
    }

    return overlay.applyToReceipt(receipt);
  }

  List<ReceiptEntity> projectReceipts(Iterable<ReceiptEntity> receipts) {
    return receipts.map(projectReceipt).toList(growable: false);
  }

  List<TaskItemEntity> projectTasks(Iterable<TaskItemEntity> tasks) {
    return tasks.map((item) {
      final receiptId = _resolveReceiptId(item);
      final shouldResolveTask =
          item.type == TaskItemType.receipt &&
          item.primaryAction.type == TaskActionType.startWeighing &&
          receiptId != null &&
          resolvedReceiptIds.contains(receiptId);

      if (!shouldResolveTask) {
        return item;
      }

      return item.copyWith(
        status: TaskItemStatus.completed,
        syncState: SyncState.synced,
        description: 'Da bat dau nhan hang bang barcode.',
      );
    }).toList(growable: false);
  }

  ScanFlowProjectionState copyWith({
    Map<String, ReceiveReceiptProjection>? receiptOverlays,
    Set<String>? resolvedReceiptIds,
  }) {
    return ScanFlowProjectionState(
      receiptOverlays: receiptOverlays ?? this.receiptOverlays,
      resolvedReceiptIds: resolvedReceiptIds ?? this.resolvedReceiptIds,
    );
  }

  String? _resolveReceiptId(TaskItemEntity item) {
    return _normalizeText(item.sourceEntityId) ??
        _normalizeText(item.routeParams?[AppRoutePaths.receiptIdParam]) ??
        _normalizeText(
          item.primaryAction.routeParams?[AppRoutePaths.receiptIdParam],
        );
  }
}

class ReceiveReceiptProjection {
  const ReceiveReceiptProjection({
    this.receivedQuantitiesByItemCode = const <String, double>{},
    this.latestLocationByItemCode = const <String, String>{},
    this.lastItemCode,
    this.lastLocationCode,
    this.lastQuantity,
    this.submittedAt,
    this.message,
  });

  final Map<String, double> receivedQuantitiesByItemCode;
  final Map<String, String> latestLocationByItemCode;
  final String? lastItemCode;
  final String? lastLocationCode;
  final double? lastQuantity;
  final DateTime? submittedAt;
  final String? message;

  ReceiveReceiptProjection merge({
    required String itemCode,
    required double quantity,
    required DateTime submittedAt,
    String? locationCode,
    String? message,
  }) {
    final nextQuantities = Map<String, double>.of(receivedQuantitiesByItemCode);
    nextQuantities[itemCode] = (nextQuantities[itemCode] ?? 0) + quantity;

    final nextLocations = Map<String, String>.of(latestLocationByItemCode);
    if (_hasValue(locationCode)) {
      nextLocations[itemCode] = locationCode!;
    }

    return ReceiveReceiptProjection(
      receivedQuantitiesByItemCode: nextQuantities,
      latestLocationByItemCode: nextLocations,
      lastItemCode: itemCode,
      lastLocationCode: locationCode ?? lastLocationCode,
      lastQuantity: quantity,
      submittedAt: submittedAt,
      message: message ?? this.message,
    );
  }

  ReceiptEntity applyToReceipt(ReceiptEntity receipt) {
    final updatedLines = receipt.lines.map((line) {
      final quantityDelta = receivedQuantitiesByItemCode[line.itemCode];
      if (quantityDelta == null) {
        return line;
      }

      final nextReceivedQty = line.receivedQty + quantityDelta;
      return line.copyWith(
        receivedQty: nextReceivedQty,
        varianceQty: nextReceivedQty - line.expectedQty,
      );
    }).toList(growable: false);

    final hasReceiveProgress = updatedLines.any(
      (line) => line.receivedQty > 0,
    );

    return receipt.copyWith(
      status: _nextStatus(receipt.status, hasReceiveProgress),
      lines: updatedLines,
      note: _buildProjectedNote(receipt.note),
      syncState: SyncState.synced,
      errorMessage: null,
      updatedAt: submittedAt ?? receipt.updatedAt,
    );
  }

  ReceiptStatus _nextStatus(ReceiptStatus currentStatus, bool hasProgress) {
    if (!hasProgress) {
      return currentStatus;
    }

    return switch (currentStatus) {
      ReceiptStatus.draft ||
      ReceiptStatus.confirmed ||
      ReceiptStatus.waitingForWeighing => ReceiptStatus.weighing1,
      _ => currentStatus,
    };
  }

  String _buildProjectedNote(String? currentNote) {
    final segments = <String>[
      if (_hasValue(message)) message!.trim(),
      if (_hasValue(lastItemCode) && lastQuantity != null)
        'Cap nhat moi nhat: da quet ${_formatQuantity(lastQuantity!)} $lastItemCode${_hasValue(lastLocationCode) ? ' vao $lastLocationCode' : ''}.',
    ];

    final summary = segments.join(' ');
    if (!_hasValue(summary)) {
      return currentNote ?? '';
    }

    final normalizedCurrentNote = _normalizeText(currentNote);
    if (normalizedCurrentNote == null) {
      return summary;
    }

    if (normalizedCurrentNote.contains(summary)) {
      return normalizedCurrentNote;
    }

    return '$normalizedCurrentNote\n$summary';
  }
}

String _formatQuantity(double value) {
  if (value.truncateToDouble() == value) {
    return value.toStringAsFixed(0);
  }

  return value.toString();
}

String? _normalizeText(String? value) {
  if (value == null) {
    return null;
  }

  final normalizedValue = value.trim();
  return normalizedValue.isEmpty ? null : normalizedValue;
}

bool _hasValue(String? value) => _normalizeText(value) != null;
