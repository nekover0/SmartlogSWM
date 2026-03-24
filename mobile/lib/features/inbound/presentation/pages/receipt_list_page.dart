import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_list_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/widgets/receipt_card.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/widgets/receipt_status_chip_bar.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class ReceiptListPage extends ConsumerStatefulWidget {
  const ReceiptListPage({super.key});

  @override
  ConsumerState<ReceiptListPage> createState() => _ReceiptListPageState();
}

class _ReceiptListPageState extends ConsumerState<ReceiptListPage> {
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
    final receiptState = ref.watch(receiptListControllerProvider);
    final currentState = receiptState.valueOrNull;
    final authState = ref.watch(authControllerProvider);
    final roleName = authState.valueOrNull?.currentUser.role;
    final canCreate = roleName != null &&
        RoleGuard.canMutateModule(
          roleName: roleName,
          module: AppModule.inbound,
        );

    if (receiptState.isLoading && currentState == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang tải danh sách phiếu nhập...'),
      );
    }

    if (receiptState.hasError && currentState == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Phiếu nhập')),
        body: AppErrorState(
          title: 'Không tải được phiếu nhập',
          message: '${receiptState.error}',
          onRetry: () {
            ref.read(receiptListControllerProvider.notifier).refresh();
          },
        ),
      );
    }

    if (currentState == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang khởi tạo inbound queue...'),
      );
    }

    _syncSearchField(currentState);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phiếu nhập'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(receiptListControllerProvider.notifier).refresh();
            },
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(receiptListControllerProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pagePadding,
          children: [
            _ReceiptListHeaderCard(
              state: currentState,
              canCreate: canCreate,
              onCreatePressed: canCreate
                  ? () => context.go(AppRoutePaths.receiptCreate)
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              key: const Key('receipt_search_field'),
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Tìm theo mã ASN, PO, B/L, biển số xe',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: currentState.searchQuery.trim().isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ReceiptStatusChipBar(
              state: currentState,
              onSelected: (status) {
                ref
                    .read(receiptListControllerProvider.notifier)
                    .setStatusFilter(status);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách ưu tiên',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                if (currentState.hasActiveFilters)
                  TextButton.icon(
                    key: const Key('receipt_filter_clear_button'),
                    onPressed: () {
                      ref
                          .read(receiptListControllerProvider.notifier)
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
                      : 'Chưa có phiếu nhập',
                  message: currentState.hasActiveFilters
                      ? 'Thử nới bộ lọc hoặc tìm bằng từ khóa khác.'
                      : 'Phiếu nhập mới sẽ xuất hiện tại đây khi inbound queue có dữ liệu.',
                  onRetry: currentState.hasActiveFilters
                      ? () {
                          ref
                              .read(receiptListControllerProvider.notifier)
                              .clearFilters();
                        }
                      : () {
                          ref
                              .read(receiptListControllerProvider.notifier)
                              .refresh();
                        },
                  retryLabel:
                      currentState.hasActiveFilters ? 'Xóa bộ lọc' : 'Tải lại',
                ),
              )
            else
              for (var index = 0;
                  index < currentState.visibleItems.length;
                  index++) ...[
                ReceiptCard(
                  receipt: currentState.visibleItems[index],
                  onOpen: () {
                    context.go(
                      AppRoutePaths.receiptDetailPath(
                        currentState.visibleItems[index].id,
                      ),
                    );
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
        .read(receiptListControllerProvider.notifier)
        .setSearchQuery(_searchController.text);
  }

  void _syncSearchField(ReceiptListState currentState) {
    final currentText = _searchController.text;
    if (currentText == currentState.searchQuery) {
      return;
    }

    _searchController.value = TextEditingValue(
      text: currentState.searchQuery,
      selection: TextSelection.collapsed(
        offset: currentState.searchQuery.length,
      ),
    );
  }
}

class _ReceiptListHeaderCard extends StatelessWidget {
  const _ReceiptListHeaderCard({
    required this.state,
    required this.canCreate,
    required this.onCreatePressed,
  });

  final ReceiptListState state;
  final bool canCreate;
  final VoidCallback? onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
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
                      'Queue inbound',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Ưu tiên các phiếu đang chờ cân hoặc còn vướng chứng từ.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.surface.withValues(alpha: 0.84),
                      ),
                    ),
                  ],
                ),
              ),
              if (canCreate)
                ElevatedButton.icon(
                  key: const Key('receipt_list_create_button'),
                  onPressed: onCreatePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.brand,
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tạo phiếu'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  key: const Key('receipt_list_metric_active'),
                  label: 'Đang mở',
                  value: '${state.activeCount}',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetricTile(
                  key: const Key('receipt_list_metric_total'),
                  label: 'Tổng phiếu',
                  value: '${state.totalCount}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _HeaderPill(label: '${state.activeCount} phiếu cần xử lý'),
              _HeaderPill(
                label: state.selectedStatus == null
                    ? 'Đang xem toàn bộ queue'
                    : 'Bộ lọc: ${_filterStatusLabel(state.selectedStatus!)}',
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

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                  fontWeight: FontWeight.w600,
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
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

String _filterStatusLabel(ReceiptStatus status) {
  return switch (status) {
    ReceiptStatus.draft => 'Tạo mới',
    ReceiptStatus.confirmed => 'Đã xác nhận',
    ReceiptStatus.waitingForWeighing => 'Chờ cân',
    ReceiptStatus.weighing1 => 'Đang cân 1',
    ReceiptStatus.weighing2 => 'Đang cân 2',
    ReceiptStatus.completed => 'Hoàn thành',
    ReceiptStatus.error => 'Lỗi',
    ReceiptStatus.cancelled => 'Đã hủy',
  };
}
