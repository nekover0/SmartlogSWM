import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/repositories/ocr_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/ocr/domain/repositories/ocr_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final ocrInboxControllerProvider =
    AsyncNotifierProvider<OcrInboxController, OcrInboxState>(
      OcrInboxController.new,
    );

class OcrInboxController extends AsyncNotifier<OcrInboxState> {
  OcrRepository get _repository => ref.read(ocrRepositoryProvider);

  @override
  Future<OcrInboxState> build() async {
    final records = await _repository.getRecords();
    return OcrInboxState(allItems: records);
  }

  Future<void> refresh() async {
    final currentState = state.valueOrNull;
    state = const AsyncLoading<OcrInboxState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final records = await _repository.getRecords();
      return OcrInboxState(
        allItems: records,
        directionFilter: currentState?.directionFilter,
        statusFilter: currentState?.statusFilter,
        searchQuery: currentState?.searchQuery ?? '',
      );
    });
  }

  void setDirectionFilter(DocumentDirection? direction) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      OcrInboxState(
        allItems: currentState.allItems,
        directionFilter: direction,
        statusFilter: currentState.statusFilter,
        searchQuery: currentState.searchQuery,
      ),
    );
  }

  void setStatusFilter(OcrRecordStatus? status) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      OcrInboxState(
        allItems: currentState.allItems,
        directionFilter: currentState.directionFilter,
        statusFilter: status,
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
      OcrInboxState(
        allItems: currentState.allItems,
        directionFilter: currentState.directionFilter,
        statusFilter: currentState.statusFilter,
        searchQuery: query,
      ),
    );
  }

  void clearFilters() {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(OcrInboxState(allItems: currentState.allItems));
  }
}

class OcrInboxState {
  const OcrInboxState({
    required this.allItems,
    this.directionFilter,
    this.statusFilter,
    this.searchQuery = '',
  });

  final List<OcrRecordEntity> allItems;
  final DocumentDirection? directionFilter;
  final OcrRecordStatus? statusFilter;
  final String searchQuery;

  List<OcrRecordEntity> get visibleItems {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    final filtered =
        allItems
            .where((record) {
              final directionMatches =
                  directionFilter == null ||
                  record.direction == directionFilter;
              final statusMatches =
                  statusFilter == null || record.status == statusFilter;
              final queryMatches = _matchesQuery(record, normalizedQuery);
              return directionMatches && statusMatches && queryMatches;
            })
            .toList(growable: false)
          ..sort((left, right) {
            final statusComparison = _statusPriority(
              left.status,
            ).compareTo(_statusPriority(right.status));
            if (statusComparison != 0) {
              return statusComparison;
            }

            return right.capturedAt.compareTo(left.capturedAt);
          });

    return UnmodifiableListView<OcrRecordEntity>(filtered);
  }

  bool get isEmpty => visibleItems.isEmpty;

  bool get hasActiveFilters =>
      directionFilter != null ||
      statusFilter != null ||
      searchQuery.trim().isNotEmpty;

  int get totalCount => allItems.length;

  int countForStatus(OcrRecordStatus status) {
    return allItems.where((entry) => entry.status == status).length;
  }

  static bool _matchesQuery(OcrRecordEntity record, String normalizedQuery) {
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final extracted = record.extractedFields;
    final candidates = <String?>[
      extracted.documentNo,
      extracted.vehiclePlate,
      extracted.itemCode,
      extracted.itemName,
      record.linkedTargetNo,
      record.errorMessage,
    ];

    return candidates.any(
      (value) => value != null && value.toLowerCase().contains(normalizedQuery),
    );
  }

  static int _statusPriority(OcrRecordStatus status) {
    return switch (status) {
      OcrRecordStatus.reviewRequired => 0,
      OcrRecordStatus.failed => 1,
      OcrRecordStatus.processing => 2,
      OcrRecordStatus.extracted => 3,
      OcrRecordStatus.confirmed => 4,
      OcrRecordStatus.relinkRequired => 5,
      OcrRecordStatus.captured => 6,
      OcrRecordStatus.linked => 7,
      OcrRecordStatus.rejected => 8,
    };
  }
}
