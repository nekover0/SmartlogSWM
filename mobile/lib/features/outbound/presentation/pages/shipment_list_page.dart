import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/outbound/application/controllers/shipment_list_controller.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/presentation/widgets/shipment_card.dart';
import 'package:smartlog_swm_mobile/features/outbound/presentation/widgets/shipment_status_chip_bar.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class ShipmentListPage extends ConsumerStatefulWidget {
  const ShipmentListPage({super.key});

  @override
  ConsumerState<ShipmentListPage> createState() => _ShipmentListPageState();
}

class _ShipmentListPageState extends ConsumerState<ShipmentListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentState = ref.watch(shipmentListControllerProvider);
    final currentState = shipmentState.valueOrNull;
    final authState = ref.watch(authControllerProvider);
    final roleName = authState.valueOrNull?.currentUser.role;
    final canCreate =
        roleName != null &&
        RoleGuard.canMutateModule(
          roleName: roleName,
          module: AppModule.outbound,
        );

    if (shipmentState.isLoading && currentState == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang tải danh sách phiếu xuất...'),
      );
    }

    if (shipmentState.hasError && currentState == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Phiếu xuất kho')),
        body: AppErrorState(
          title: 'Không tải được phiếu xuất',
          message: '${shipmentState.error}',
          onRetry: () {
            ref.read(shipmentListControllerProvider.notifier).refresh();
          },
        ),
      );
    }

    if (currentState == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang khởi tạo outbound queue...'),
      );
    }

    _syncSearchField(currentState);

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        leading: IconButton(
          key: const Key('shipment_list_back_button'),
          tooltip: 'Quay lại',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutePaths.tasks);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Phiếu xuất kho'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(shipmentListControllerProvider.notifier).refresh();
            },
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(shipmentListControllerProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pagePadding,
          children: [
            _ShipmentListKpiHeader(
              state: currentState,
              canCreate: canCreate,
              onCreatePressed: canCreate
                  ? () => context.go(AppRoutePaths.shipmentCreate)
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            _SearchFilterBar(
              controller: _searchController,
              query: currentState.searchQuery,
              overdueOnly: currentState.overdueOnly,
              onToggleOverdue: (enabled) {
                ref
                    .read(shipmentListControllerProvider.notifier)
                    .setOverdueOnly(enabled);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            ShipmentStatusChipBar(
              state: currentState,
              onSelected: (status) {
                ref
                    .read(shipmentListControllerProvider.notifier)
                    .setStatusFilter(status);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _OwnerWarehouseFilterRow(state: currentState),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách ưu tiên giao trước',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (currentState.hasActiveFilters)
                  TextButton.icon(
                    key: const Key('shipment_filter_clear_button'),
                    onPressed: () {
                      ref
                          .read(shipmentListControllerProvider.notifier)
                          .clearFilters();
                    },
                    icon: const Icon(Icons.filter_alt_off_rounded),
                    label: const Text('Xóa bộ lọc'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (currentState.isEmpty)
              SizedBox(
                height: 260,
                child: AppEmptyState(
                  title: currentState.hasActiveFilters
                      ? 'Không có phiếu phù hợp'
                      : 'Chưa có phiếu xuất',
                  message: currentState.hasActiveFilters
                      ? 'Thử nới bộ lọc hoặc tìm bằng từ khóa khác.'
                      : 'Phiếu xuất mới sẽ xuất hiện tại đây khi outbound queue có dữ liệu.',
                  onRetry: currentState.hasActiveFilters
                      ? () {
                          ref
                              .read(shipmentListControllerProvider.notifier)
                              .clearFilters();
                        }
                      : () {
                          ref
                              .read(shipmentListControllerProvider.notifier)
                              .refresh();
                        },
                  retryLabel: currentState.hasActiveFilters
                      ? 'Xóa bộ lọc'
                      : 'Tải lại',
                ),
              )
            else
              for (
                var index = 0;
                index < currentState.visibleItems.length;
                index++
              ) ...[
                ShipmentCard(
                  shipment: currentState.visibleItems[index],
                  isOverdue: currentState.isOverdue(
                    currentState.visibleItems[index],
                  ),
                  isBlocked: currentState.isBlocked(
                    currentState.visibleItems[index],
                  ),
                  onOpen: () {
                    context.go(
                      AppRoutePaths.shipmentDetailPath(
                        currentState.visibleItems[index].id,
                      ),
                    );
                  },
                  onQuickActions: () {
                    _showShipmentActions(currentState.visibleItems[index]);
                  },
                ),
                if (index < currentState.visibleItems.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
          ],
        ),
      ),
    );
  }

  void _handleSearchChanged() {
    ref
        .read(shipmentListControllerProvider.notifier)
        .setSearchQuery(_searchController.text);
  }

  void _syncSearchField(ShipmentListState currentState) {
    final currentText = _searchController.text;
    if (currentText == currentState.searchQuery) {
      return;
    }

    _searchController.removeListener(_handleSearchChanged);
    _searchController.value = TextEditingValue(
      text: currentState.searchQuery,
      selection: TextSelection.collapsed(
        offset: currentState.searchQuery.length,
      ),
    );
    _searchController.addListener(_handleSearchChanged);
  }

  Future<void> _showShipmentActions(ShipmentEntity shipment) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_new_rounded),
                title: const Text('Xem phiếu'),
                onTap: () {
                  Navigator.of(context).pop();
                  this.context.go(
                    AppRoutePaths.shipmentDetailPath(shipment.id),
                  );
                },
              ),
              for (final action in shipment.availableActions)
                if (action.enabled && action.type != TaskActionType.open)
                  ListTile(
                    leading: Icon(_actionIcon(action.type)),
                    title: Text(action.label),
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${action.label}: sẽ được hoàn thiện ở phase sau.',
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _ShipmentListKpiHeader extends StatelessWidget {
  const _ShipmentListKpiHeader({
    required this.state,
    required this.canCreate,
    required this.onCreatePressed,
  });

  final ShipmentListState state;
  final bool canCreate;
  final VoidCallback? onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.brand, Color(0xFF1B4D88)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phiếu đang xử lý',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${state.processingCount}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Outbound queue ưu tiên',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.surface.withValues(alpha: 0.84),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (canCreate)
                ElevatedButton.icon(
                  key: const Key('shipment_list_create_button'),
                  onPressed: onCreatePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.brand,
                    minimumSize: const Size(0, 38),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tạo phiếu xuất'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _HeaderStatPill(
                label: 'Tổng hôm nay',
                value: '${state.totalCount}',
              ),
              _HeaderStatPill(
                label: 'Trễ xử lý',
                value: '${state.overdueCount}',
                highlight: true,
              ),
              _HeaderStatPill(label: 'Blocked', value: '${state.blockedCount}'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _HeaderPill(label: '${state.processingCount} phiếu ưu tiên'),
              _HeaderPill(
                label: state.selectedStatus == null
                    ? 'Đang xem toàn bộ'
                    : 'Bộ lọc: ${shipmentStatusLabel(state.selectedStatus!)}',
              ),
              if (state.searchQuery.trim().isNotEmpty)
                _HeaderPill(label: 'Từ khóa: ${state.searchQuery.trim()}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  const _SearchFilterBar({
    required this.controller,
    required this.query,
    required this.overdueOnly,
    required this.onToggleOverdue,
  });

  final TextEditingController controller;
  final String query;
  final bool overdueOnly;
  final ValueChanged<bool> onToggleOverdue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: const Key('shipment_search_field'),
            controller: controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Tìm số phiếu, SO, B/L, biển số xe...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.trim().isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        controller.clear();
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        FilterChip(
          key: const Key('shipment_overdue_chip'),
          label: const Text('Trễ'),
          selected: overdueOnly,
          onSelected: onToggleOverdue,
          selectedColor: AppColors.warning.withValues(alpha: 0.2),
          checkmarkColor: AppColors.warning,
        ),
      ],
    );
  }
}

class _OwnerWarehouseFilterRow extends ConsumerWidget {
  const _OwnerWarehouseFilterRow({required this.state});

  final ShipmentListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(shipmentListControllerProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String?>(
            key: const Key('shipment_warehouse_filter'),
            initialValue: state.selectedWarehouseId,
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Tất cả kho'),
              ),
              ...state.availableWarehouses.map(
                (warehouse) => DropdownMenuItem<String?>(
                  value: warehouse.id,
                  child: Text(warehouse.code),
                ),
              ),
            ],
            onChanged: controller.setWarehouseFilter,
            decoration: const InputDecoration(labelText: 'Kho'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: DropdownButtonFormField<String?>(
            key: const Key('shipment_owner_filter'),
            initialValue: state.selectedOwnerId,
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Tất cả chủ hàng'),
              ),
              ...state.availableOwners.map(
                (owner) => DropdownMenuItem<String?>(
                  value: owner.id,
                  child: Text(owner.code),
                ),
              ),
            ],
            onChanged: controller.setOwnerFilter,
            decoration: const InputDecoration(labelText: 'Chủ hàng'),
          ),
        ),
      ],
    );
  }
}

class _HeaderStatPill extends StatelessWidget {
  const _HeaderStatPill({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.surface.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: highlight ? const Color(0xFFFFE7BA) : AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

IconData _actionIcon(TaskActionType type) {
  return switch (type) {
    TaskActionType.open => Icons.open_in_new_rounded,
    TaskActionType.approve => Icons.check_circle_outline_rounded,
    TaskActionType.dismiss => Icons.close_rounded,
    TaskActionType.acknowledge => Icons.notifications_active_outlined,
    TaskActionType.startWeighing => Icons.scale_outlined,
    TaskActionType.startPicking => Icons.inventory_2_outlined,
    TaskActionType.reviewOcr => Icons.document_scanner_outlined,
    TaskActionType.viewInventory => Icons.warehouse_outlined,
    TaskActionType.custom => Icons.bolt_rounded,
  };
}
