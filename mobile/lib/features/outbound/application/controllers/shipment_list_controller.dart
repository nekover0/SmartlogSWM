import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/repositories/shipment_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/outbound/domain/repositories/shipment_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final shipmentListControllerProvider =
    AsyncNotifierProvider<ShipmentListController, ShipmentListState>(
      ShipmentListController.new,
    );

class ShipmentListController extends AsyncNotifier<ShipmentListState> {
  ShipmentRepository get _repository => ref.read(shipmentRepositoryProvider);

  @override
  Future<ShipmentListState> build() async {
    final shipments = await _repository.getShipments();
    return ShipmentListState(allItems: shipments);
  }

  Future<void> refresh() async {
    final currentState = state.valueOrNull;
    state = const AsyncLoading<ShipmentListState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final shipments = await _repository.getShipments();
      return ShipmentListState(
        allItems: shipments,
        selectedStatus: currentState?.selectedStatus,
        searchQuery: currentState?.searchQuery ?? '',
        selectedWarehouseId: currentState?.selectedWarehouseId,
        selectedOwnerId: currentState?.selectedOwnerId,
        overdueOnly: currentState?.overdueOnly ?? false,
      );
    });
  }

  void setStatusFilter(ShipmentStatus? status) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      ShipmentListState(
        allItems: currentState.allItems,
        selectedStatus: status,
        searchQuery: currentState.searchQuery,
        selectedWarehouseId: currentState.selectedWarehouseId,
        selectedOwnerId: currentState.selectedOwnerId,
        overdueOnly: currentState.overdueOnly,
      ),
    );
  }

  void setSearchQuery(String query) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      ShipmentListState(
        allItems: currentState.allItems,
        selectedStatus: currentState.selectedStatus,
        searchQuery: query,
        selectedWarehouseId: currentState.selectedWarehouseId,
        selectedOwnerId: currentState.selectedOwnerId,
        overdueOnly: currentState.overdueOnly,
      ),
    );
  }

  void setWarehouseFilter(String? warehouseId) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      ShipmentListState(
        allItems: currentState.allItems,
        selectedStatus: currentState.selectedStatus,
        searchQuery: currentState.searchQuery,
        selectedWarehouseId: warehouseId,
        selectedOwnerId: currentState.selectedOwnerId,
        overdueOnly: currentState.overdueOnly,
      ),
    );
  }

  void setOwnerFilter(String? ownerId) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      ShipmentListState(
        allItems: currentState.allItems,
        selectedStatus: currentState.selectedStatus,
        searchQuery: currentState.searchQuery,
        selectedWarehouseId: currentState.selectedWarehouseId,
        selectedOwnerId: ownerId,
        overdueOnly: currentState.overdueOnly,
      ),
    );
  }

  void setOverdueOnly(bool overdueOnly) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      ShipmentListState(
        allItems: currentState.allItems,
        selectedStatus: currentState.selectedStatus,
        searchQuery: currentState.searchQuery,
        selectedWarehouseId: currentState.selectedWarehouseId,
        selectedOwnerId: currentState.selectedOwnerId,
        overdueOnly: overdueOnly,
      ),
    );
  }

  void clearFilters() {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(ShipmentListState(allItems: currentState.allItems));
  }
}

class ShipmentListState {
  const ShipmentListState({
    required this.allItems,
    this.selectedStatus,
    this.searchQuery = '',
    this.selectedWarehouseId,
    this.selectedOwnerId,
    this.overdueOnly = false,
  });

  final List<ShipmentEntity> allItems;
  final ShipmentStatus? selectedStatus;
  final String searchQuery;
  final String? selectedWarehouseId;
  final String? selectedOwnerId;
  final bool overdueOnly;

  List<ShipmentEntity> get visibleItems {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    final items =
        allItems
            .where((shipment) {
              final statusMatches =
                  selectedStatus == null || shipment.status == selectedStatus;
              final queryMatches = _matchesQuery(shipment, normalizedQuery);
              final warehouseMatches =
                  selectedWarehouseId == null ||
                  shipment.warehouse.id == selectedWarehouseId;
              final ownerMatches =
                  selectedOwnerId == null ||
                  shipment.owner.id == selectedOwnerId;
              final overdueMatches = !overdueOnly || isOverdue(shipment);

              return statusMatches &&
                  queryMatches &&
                  warehouseMatches &&
                  ownerMatches &&
                  overdueMatches;
            })
            .toList(growable: false)
          ..sort(_compareShipments);

    return UnmodifiableListView<ShipmentEntity>(items);
  }

  List<ShipmentStatus> get availableStatuses {
    final statuses = ShipmentStatus.values.where(
      (status) => allItems.any((shipment) => shipment.status == status),
    );
    return UnmodifiableListView<ShipmentStatus>(statuses);
  }

  List<WarehouseSummary> get availableWarehouses {
    final map = <String, WarehouseSummary>{
      for (final shipment in allItems)
        shipment.warehouse.id: shipment.warehouse,
    };

    final warehouses = map.values.toList(growable: false)
      ..sort((left, right) => left.name.compareTo(right.name));

    return UnmodifiableListView<WarehouseSummary>(warehouses);
  }

  List<OwnerSummary> get availableOwners {
    final map = <String, OwnerSummary>{
      for (final shipment in allItems) shipment.owner.id: shipment.owner,
    };

    final owners = map.values.toList(growable: false)
      ..sort((left, right) => left.name.compareTo(right.name));

    return UnmodifiableListView<OwnerSummary>(owners);
  }

  int get totalCount => allItems.length;

  int get processingCount => allItems.where(_isProcessingShipment).length;

  int get blockedCount => allItems.where(isBlocked).length;

  int get overdueCount => allItems.where(isOverdue).length;

  bool get hasActiveFilters {
    return selectedStatus != null ||
        searchQuery.trim().isNotEmpty ||
        selectedWarehouseId != null ||
        selectedOwnerId != null ||
        overdueOnly;
  }

  bool get isEmpty => visibleItems.isEmpty;

  int countForStatus(ShipmentStatus? status) {
    if (status == null) {
      return totalCount;
    }

    return allItems.where((shipment) => shipment.status == status).length;
  }

  bool isBlocked(ShipmentEntity shipment) {
    return shipment.status == ShipmentStatus.error ||
        shipment.syncState == SyncState.failed;
  }

  bool isOverdue(ShipmentEntity shipment) {
    if (isBlocked(shipment) || !_isProcessingShipment(shipment)) {
      return false;
    }

    return shipment.syncState == SyncState.pending;
  }

  static bool _matchesQuery(ShipmentEntity shipment, String normalizedQuery) {
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final searchTerms = <String?>[
      shipment.shipmentNo,
      shipment.salesOrderNo,
      shipment.billOfLadingNo,
      shipment.owner.code,
      shipment.owner.name,
      shipment.warehouse.code,
      shipment.warehouse.name,
      shipment.vehicle.plateNumber,
      shipment.vehicle.driverName,
      shipment.vehicle.vesselName,
    ];

    return searchTerms.any(
      (term) => term != null && term.toLowerCase().contains(normalizedQuery),
    );
  }

  static bool _isProcessingShipment(ShipmentEntity shipment) {
    return switch (shipment.status) {
      ShipmentStatus.shipped ||
      ShipmentStatus.closed ||
      ShipmentStatus.cancelled => false,
      _ => true,
    };
  }

  static int _compareShipments(ShipmentEntity left, ShipmentEntity right) {
    final blockedComparison = _blockedRank(left).compareTo(_blockedRank(right));
    if (blockedComparison != 0) {
      return blockedComparison;
    }

    final overdueComparison = _overdueRank(left).compareTo(_overdueRank(right));
    if (overdueComparison != 0) {
      return overdueComparison;
    }

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

    return left.shipmentNo.compareTo(right.shipmentNo);
  }

  static int _blockedRank(ShipmentEntity shipment) {
    return shipment.status == ShipmentStatus.error ||
            shipment.syncState == SyncState.failed
        ? 0
        : 1;
  }

  static int _overdueRank(ShipmentEntity shipment) {
    final isProcessing = _isProcessingShipment(shipment);
    final isBlocked =
        shipment.status == ShipmentStatus.error ||
        shipment.syncState == SyncState.failed;
    final isOverdue =
        isProcessing && !isBlocked && shipment.syncState == SyncState.pending;
    return isOverdue ? 0 : 1;
  }

  static int _statusRank(ShipmentStatus status) {
    return switch (status) {
      ShipmentStatus.error => 0,
      ShipmentStatus.picking => 1,
      ShipmentStatus.loading => 2,
      ShipmentStatus.weighCompleted => 3,
      ShipmentStatus.confirmed => 4,
      ShipmentStatus.draft => 5,
      ShipmentStatus.shipped => 6,
      ShipmentStatus.closed => 7,
      ShipmentStatus.cancelled => 8,
    };
  }
}
