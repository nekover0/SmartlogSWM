import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final receiptListControllerProvider =
    AsyncNotifierProvider<ReceiptListController, ReceiptListState>(
      ReceiptListController.new,
    );

class ReceiptListController extends AsyncNotifier<ReceiptListState> {
  ReceiptRepository get _repository => ref.read(receiptRepositoryProvider);

  @override
  Future<ReceiptListState> build() async {
    final receipts = await _repository.getReceipts();
    return ReceiptListState(allItems: receipts);
  }

  Future<void> refresh() async {
    final currentState = state.valueOrNull;
    state = const AsyncLoading<ReceiptListState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final receipts = await _repository.getReceipts();
      return ReceiptListState(
        allItems: receipts,
        selectedStatus: currentState?.selectedStatus,
        searchQuery: currentState?.searchQuery ?? '',
      );
    });
  }

  void setStatusFilter(ReceiptStatus? status) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      ReceiptListState(
        allItems: currentState.allItems,
        selectedStatus: status,
        searchQuery: currentState.searchQuery,
      ),
    );
  }

  void setSearchQuery(String query) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      ReceiptListState(
        allItems: currentState.allItems,
        selectedStatus: currentState.selectedStatus,
        searchQuery: query,
      ),
    );
  }

  void clearFilters() {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(ReceiptListState(allItems: currentState.allItems));
  }
}

class ReceiptListState {
  const ReceiptListState({
    required this.allItems,
    this.selectedStatus,
    this.searchQuery = '',
  });

  final List<ReceiptEntity> allItems;
  final ReceiptStatus? selectedStatus;
  final String searchQuery;

  List<ReceiptEntity> get visibleItems {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    final items =
        allItems
            .where((receipt) {
              final statusMatches =
                  selectedStatus == null || receipt.status == selectedStatus;
              final queryMatches = _matchesQuery(receipt, normalizedQuery);
              return statusMatches && queryMatches;
            })
            .toList(growable: false)
          ..sort(_compareReceipts);

    return UnmodifiableListView<ReceiptEntity>(items);
  }

  List<ReceiptStatus> get availableStatuses {
    final statuses = ReceiptStatus.values.where(
      (status) => allItems.any((receipt) => receipt.status == status),
    );
    return UnmodifiableListView<ReceiptStatus>(statuses);
  }

  int get totalCount => allItems.length;

  int get activeCount => allItems.where(_isActiveReceipt).length;

  bool get hasActiveFilters =>
      selectedStatus != null || searchQuery.trim().isNotEmpty;

  bool get isEmpty => visibleItems.isEmpty;

  int countForStatus(ReceiptStatus? status) {
    if (status == null) {
      return totalCount;
    }

    return allItems.where((receipt) => receipt.status == status).length;
  }

  static bool _matchesQuery(ReceiptEntity receipt, String normalizedQuery) {
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final searchTerms = <String?>[
      receipt.receiptNo,
      receipt.purchaseOrderNo,
      receipt.billOfLadingNo,
      receipt.owner.code,
      receipt.owner.name,
      receipt.warehouse.code,
      receipt.warehouse.name,
      receipt.vehicle.plateNumber,
      receipt.vehicle.driverName,
      receipt.vehicle.vesselName,
    ];

    return searchTerms.any(
      (term) => term != null && term.toLowerCase().contains(normalizedQuery),
    );
  }

  static bool _isActiveReceipt(ReceiptEntity receipt) {
    return switch (receipt.status) {
      ReceiptStatus.completed || ReceiptStatus.cancelled => false,
      _ => true,
    };
  }

  static int _compareReceipts(ReceiptEntity left, ReceiptEntity right) {
    final statusComparison = _statusRank(
      left.status,
    ).compareTo(_statusRank(right.status));
    if (statusComparison != 0) {
      return statusComparison;
    }

    final updatedAtComparison = right.updatedAt.compareTo(left.updatedAt);
    if (updatedAtComparison != 0) {
      return updatedAtComparison;
    }

    return left.receiptNo.compareTo(right.receiptNo);
  }

  static int _statusRank(ReceiptStatus status) {
    return switch (status) {
      ReceiptStatus.waitingForWeighing => 0,
      ReceiptStatus.weighing1 => 1,
      ReceiptStatus.weighing2 => 2,
      ReceiptStatus.error => 3,
      ReceiptStatus.confirmed => 4,
      ReceiptStatus.draft => 5,
      ReceiptStatus.completed => 6,
      ReceiptStatus.cancelled => 7,
    };
  }
}
