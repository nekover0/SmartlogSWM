import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_action_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_detail_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/widgets/receipt_action_footer.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/widgets/receipt_line_tile.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/widgets/receipt_weight_summary.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class ReceiptDetailPage extends ConsumerWidget {
  const ReceiptDetailPage({
    super.key,
    required this.receiptId,
  });

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptState = ref.watch(receiptDetailControllerProvider(receiptId));
    final actionState = ref.watch(receiptActionControllerProvider(receiptId));
    final receipt = receiptState.valueOrNull;

    if (receiptState.isLoading && receipt == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang tải chi tiết phiếu nhập...'),
      );
    }

    if (receiptState.hasError && receipt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết phiếu nhập')),
        body: AppErrorState(
          title: 'Không tải được chi tiết phiếu nhập',
          message: '${receiptState.error}',
          onRetry: () {
            ref.read(receiptDetailControllerProvider(receiptId).notifier).refresh();
          },
        ),
      );
    }

    if (receipt == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang khởi tạo phiếu nhập...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết phiếu nhập'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(receiptDetailControllerProvider(receiptId).notifier).refresh();
            },
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      bottomNavigationBar: ReceiptActionFooter(
        primaryActions: actionState.primaryActions,
        secondaryActions: actionState.secondaryActions,
        onActionSelected: (action) => _handleAction(context, receipt, action),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(receiptDetailControllerProvider(receiptId).notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pagePadding,
          children: [
            _ReceiptHeaderCard(receipt: receipt),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'Thông tin chứng từ',
              child: Column(
                children: [
                  _MetadataRow(
                    label: 'Số phiếu',
                    value: receipt.receiptNo,
                  ),
                  _MetadataRow(
                    label: 'PO',
                    value: _valueOrFallback(receipt.purchaseOrderNo),
                  ),
                  _MetadataRow(
                    label: 'B/L',
                    value: _valueOrFallback(receipt.billOfLadingNo),
                  ),
                  _MetadataRow(
                    label: 'Kho đích',
                    value: '${receipt.warehouse.code} · ${receipt.warehouse.name}',
                  ),
                  _MetadataRow(
                    label: 'Biển số xe',
                    value: _valueOrFallback(receipt.vehicle.plateNumber),
                  ),
                  _MetadataRow(
                    label: 'Tài xế',
                    value: _valueOrFallback(receipt.vehicle.driverName),
                  ),
                  _MetadataRow(
                    label: 'Tạo lúc',
                    value: _dateTimeFormat.format(receipt.createdAt.toLocal()),
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ReceiptWeightSummary(receipt: receipt),
            const SizedBox(height: AppSpacing.lg),
            _SectionCard(
              title: 'Chứng từ liên quan',
              child: Column(
                children: [
                  _MetadataRow(
                    label: 'Nguồn OCR',
                    value: _valueOrFallback(receipt.sourceOcrRecordId),
                  ),
                  _MetadataRow(
                    label: 'Tàu / chuyến',
                    value: _valueOrFallback(
                      receipt.vesselName ?? receipt.vehicle.vesselName,
                    ),
                  ),
                  _MetadataRow(
                    label: 'Ghi chú',
                    value: _valueOrFallback(receipt.note),
                  ),
                  if (_hasValue(receipt.errorMessage))
                    _MetadataRow(
                      label: 'Lỗi hiện tại',
                      value: receipt.errorMessage!.trim(),
                      valueColor: AppColors.danger,
                      isLast: true,
                    )
                  else
                    const _MetadataRow(
                      label: 'Lỗi hiện tại',
                      value: 'Không có',
                      isLast: true,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Line hàng hóa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (var index = 0; index < receipt.lines.length; index++) ...[
              ReceiptLineTile(line: receipt.lines[index]),
              if (index < receipt.lines.length - 1)
                const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    ReceiptEntity receipt,
    ActionCapability action,
  ) {
    final location = resolveNamedRouteLocation(
      router: GoRouter.of(context),
      routeName: action.routeName,
      pathParameters: action.routeParams,
    );

    if (location != null) {
      context.go(location);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã ghi nhận thao tác "${action.label}" cho ${receipt.receiptNo}.',
        ),
      ),
    );
  }
}

class _ReceiptHeaderCard extends StatelessWidget {
  const _ReceiptHeaderCard({required this.receipt});

  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) {
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
                      receipt.receiptNo,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      receipt.owner.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.surface.withValues(alpha: 0.84),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _HeaderPill(
                label: _statusLabel(receipt.status),
                color: _statusColor(receipt.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _HeaderGhostPill(label: 'Kho: ${receipt.warehouse.code}'),
              _HeaderGhostPill(label: _syncLabel(receipt.syncState)),
              if (_hasValue(receipt.vehicle.plateNumber))
                _HeaderGhostPill(label: receipt.vehicle.plateNumber!.trim()),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _HeaderGhostPill extends StatelessWidget {
  const _HeaderGhostPill({required this.label});

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

final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

String _valueOrFallback(String? value) {
  if (!_hasValue(value)) {
    return 'Chưa cập nhật';
  }
  return value!.trim();
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

String _statusLabel(ReceiptStatus status) {
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

Color _statusColor(ReceiptStatus status) {
  return switch (status) {
    ReceiptStatus.draft => AppColors.textSecondary,
    ReceiptStatus.confirmed => AppColors.info,
    ReceiptStatus.waitingForWeighing => AppColors.warning,
    ReceiptStatus.weighing1 => AppColors.brandAccent,
    ReceiptStatus.weighing2 => AppColors.brand,
    ReceiptStatus.completed => AppColors.success,
    ReceiptStatus.error => AppColors.danger,
    ReceiptStatus.cancelled => AppColors.textSecondary,
  };
}

String _syncLabel(SyncState syncState) {
  return switch (syncState) {
    SyncState.synced => 'Đã sync',
    SyncState.pending => 'Chờ sync',
    SyncState.failed => 'Sync lỗi',
  };
}
