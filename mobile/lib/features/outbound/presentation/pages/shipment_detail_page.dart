import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_names.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/features/outbound/application/controllers/shipment_detail_controller.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/presentation/widgets/shipment_card.dart';
import 'package:smartlog_swm_mobile/features/outbound/presentation/widgets/shipment_status_chip_bar.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class ShipmentDetailPage extends ConsumerWidget {
  const ShipmentDetailPage({super.key, required this.shipmentId});

  final String shipmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipmentState = ref.watch(
      shipmentDetailControllerProvider(shipmentId),
    );
    final shipment = shipmentState.valueOrNull;

    if (shipmentState.isLoading && shipment == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang tải chi tiết phiếu xuất...'),
      );
    }

    if (shipmentState.hasError && shipment == null) {
      final error = shipmentState.error;
      if (_isMissingShipment(error)) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => _handleBack(context),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Quay lại',
            ),
            title: const Text('Chi tiết phiếu xuất'),
          ),
          body: AppEmptyState(
            title: 'Không tìm thấy phiếu xuất',
            message: 'Phiếu xuất này không còn tồn tại hoặc chưa đồng bộ.',
            retryLabel: 'Về danh sách',
            onRetry: () => context.go(AppRoutePaths.shipmentList),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _handleBack(context),
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Quay lại',
          ),
          title: const Text('Chi tiết phiếu xuất'),
        ),
        body: AppErrorState(
          title: 'Không tải được chi tiết phiếu xuất',
          message: '$error',
          onRetry: () {
            ref
                .read(shipmentDetailControllerProvider(shipmentId).notifier)
                .refresh();
          },
        ),
      );
    }

    if (shipment == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang khởi tạo phiếu xuất...'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        leading: IconButton(
          key: const Key('shipment_detail_back_button'),
          onPressed: () => _handleBack(context),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Quay lại',
        ),
        title: const Text('Chi tiết phiếu xuất'),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(shipmentDetailControllerProvider(shipmentId).notifier)
                  .refresh();
            },
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      bottomNavigationBar: _ShipmentActionFooter(
        shipment: shipment,
        onPrimaryAction: () {
          _showActionToast(
            context,
            'Đã ghi nhận thao tác "${_resolvePrimaryActionLabel(shipment)}" cho ${shipment.shipmentNo}.',
          );
        },
        onScanAction: () {
          context.push(
            buildScanBarcodeLocation(
              launchContext: ScanLaunchContext(
                mode: ScanMode.issue,
                referenceId: shipment.id,
                referenceNo: shipment.shipmentNo,
                warehouseId: shipment.warehouse.id,
                warehouseCode: shipment.warehouse.code,
                originRouteName: AppRouteNames.shipmentDetail,
                originRouteParams: <String, String>{
                  AppRoutePaths.shipmentIdParam: shipment.id,
                },
              ),
            ),
          );
        },
        onReportIssue: () {
          _showActionToast(
            context,
            'Đã mở luồng báo lỗi cho ${shipment.shipmentNo}.',
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return ref
              .read(shipmentDetailControllerProvider(shipmentId).notifier)
              .refresh();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pagePadding,
          children: [
            _ManifestHeaderCard(shipment: shipment),
            const SizedBox(height: AppSpacing.md),
            _StatusStepperCard(shipment: shipment),
            const SizedBox(height: AppSpacing.md),
            _MetadataCard(shipment: shipment),
            const SizedBox(height: AppSpacing.md),
            _WeightSummaryCard(shipment: shipment),
            const SizedBox(height: AppSpacing.md),
            _LineItemsCard(shipment: shipment),
            if (_hasValue(shipment.note)) ...[
              const SizedBox(height: AppSpacing.md),
              _SimpleInfoCard(
                title: 'Ghi chú',
                child: Text(
                  shipment.note!.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (_hasValue(shipment.errorMessage)) ...[
              const SizedBox(height: AppSpacing.md),
              _SimpleInfoCard(
                title: 'Lỗi hiện tại',
                child: Text(
                  shipment.errorMessage!.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  bool _isMissingShipment(Object? error) {
    final message = '$error'.toLowerCase();
    return message.contains('not found') ||
        message.contains('statuscode: 404') ||
        message.contains('bad state: no element');
  }

  void _showActionToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutePaths.shipmentList);
  }
}

class _ManifestHeaderCard extends StatelessWidget {
  const _ManifestHeaderCard({required this.shipment});

  final ShipmentEntity shipment;

  @override
  Widget build(BuildContext context) {
    final statusColor = shipmentStatusColor(shipment.status);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã phiếu xuất',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    shipment.shipmentNo,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    shipmentStatusLabel(shipment.status),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              shipment.owner.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _Pill(label: shipment.owner.code),
                _Pill(label: shipment.warehouse.code),
                _Pill(
                  label: shipment.vehicle.plateNumber?.trim().isNotEmpty == true
                      ? shipment.vehicle.plateNumber!.trim()
                      : '--',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusStepperCard extends StatelessWidget {
  const _StatusStepperCard({required this.shipment});

  final ShipmentEntity shipment;

  @override
  Widget build(BuildContext context) {
    final statuses = <ShipmentStatus>[
      ShipmentStatus.draft,
      ShipmentStatus.confirmed,
      ShipmentStatus.picking,
      ShipmentStatus.loading,
      ShipmentStatus.weighCompleted,
      ShipmentStatus.shipped,
    ];

    final currentIndex = statuses.indexOf(shipment.status);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiến độ trạng thái',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (var index = 0; index < statuses.length; index++)
                  _StatusNode(
                    index: index + 1,
                    label: shipmentStatusLabel(statuses[index]),
                    active: currentIndex >= index,
                    current: currentIndex == index,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataCard extends StatelessWidget {
  const _MetadataCard({required this.shipment});

  final ShipmentEntity shipment;

  @override
  Widget build(BuildContext context) {
    final soOrBl = [
      if (_hasValue(shipment.salesOrderNo)) shipment.salesOrderNo!.trim(),
      if (_hasValue(shipment.billOfLadingNo)) shipment.billOfLadingNo!.trim(),
    ].join(' / ');

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            _MetadataCell(
              label: 'SO / BL',
              value: soOrBl.isEmpty ? '--' : soOrBl,
            ),
            _MetadataCell(label: 'Kho xuất', value: shipment.warehouse.code),
            _MetadataCell(
              label: 'Biển số xe',
              value: _displayOrDash(shipment.vehicle.plateNumber),
            ),
            _MetadataCell(
              label: 'Tài xế',
              value: _displayOrDash(shipment.vehicle.driverName),
            ),
            _MetadataCell(
              label: 'Tên tàu',
              value: _displayOrDash(shipment.vehicle.vesselName),
            ),
            _MetadataCell(
              label: 'Ngày tạo',
              value: _dateTimeFormat.format(shipment.createdAt.toLocal()),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightSummaryCard extends StatelessWidget {
  const _WeightSummaryCard({required this.shipment});

  final ShipmentEntity shipment;

  @override
  Widget build(BuildContext context) {
    final variance =
        shipment.varianceWeightKg ??
        (shipment.shippedWeightKg - shipment.expectedWeightKg);
    final hasVarianceAlert = variance.abs() >= 0.1;

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin khối lượng',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _WeightCell(
                    label: 'Dự kiến',
                    value:
                        '${_weightFormat.format(shipment.expectedWeightKg)} T',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _WeightCell(
                    label: 'Đã xuất',
                    value:
                        '${_weightFormat.format(shipment.shippedWeightKg)} T',
                    valueColor: AppColors.brand,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _WeightCell(
                    label: 'Chênh lệch',
                    value: '${_weightFormat.format(variance)} T',
                    valueColor: variance < 0
                        ? AppColors.warning
                        : (variance > 0 ? AppColors.danger : AppColors.success),
                  ),
                ),
              ],
            ),
            if (hasVarianceAlert) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: AppSpacing.controlRadius,
                ),
                child: Text(
                  'Cần kiểm tra lại khối lượng trước khi đóng phiếu.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LineItemsCard extends StatelessWidget {
  const _LineItemsCard({required this.shipment});

  final ShipmentEntity shipment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách mặt hàng (${shipment.lines.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_rounded),
                  label: const Text('Lọc'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (shipment.lines.isEmpty)
              const AppEmptyState(
                title: 'Chưa có line hàng',
                message:
                    'Phiếu xuất này chưa có danh sách pick/ship. Hãy cập nhật từ WMS.',
              )
            else
              for (var index = 0; index < shipment.lines.length; index++) ...[
                _ShipmentLineTile(line: shipment.lines[index]),
                if (index < shipment.lines.length - 1)
                  const SizedBox(height: AppSpacing.xs),
              ],
          ],
        ),
      ),
    );
  }
}

class _ShipmentLineTile extends StatelessWidget {
  const _ShipmentLineTile({required this.line});

  final ShipmentLineEntity line;

  @override
  Widget build(BuildContext context) {
    final isCompleted = line.shippedQty >= line.expectedQty && !line.shortPick;
    final qtyColor = line.shortPick
        ? AppColors.warning
        : (isCompleted ? AppColors.success : AppColors.brand);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: line.shortPick
              ? AppColors.warning.withValues(alpha: 0.4)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKU: ${line.itemCode}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  line.itemName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  line.shortPick
                      ? 'Lỗi: thiếu hàng so với kế hoạch pick.'
                      : 'Vị trí: ${line.sourceLocation?.code ?? '--'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: line.shortPick
                        ? AppColors.danger
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Số lượng',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                '${_qtyFormat.format(line.shippedQty)} / ${_qtyFormat.format(line.expectedQty)} ${line.uomCode}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: qtyColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SimpleInfoCard extends StatelessWidget {
  const _SimpleInfoCard({required this.title, required this.child});

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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}

class _ShipmentActionFooter extends StatelessWidget {
  const _ShipmentActionFooter({
    required this.shipment,
    required this.onPrimaryAction,
    required this.onScanAction,
    required this.onReportIssue,
  });

  final ShipmentEntity shipment;
  final VoidCallback onPrimaryAction;
  final VoidCallback onScanAction;
  final VoidCallback onReportIssue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const Key('shipment_detail_primary_action_button'),
                onPressed: onPrimaryAction,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(_resolvePrimaryActionLabel(shipment)),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('shipment_detail_scan_action_button'),
                    onPressed: onScanAction,
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    label: const Text('Chuyển sang scan'),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('shipment_detail_report_action_button'),
                    onPressed: onReportIssue,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                    ),
                    icon: const Icon(Icons.report_problem_outlined),
                    label: const Text('Báo lỗi'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _resolvePrimaryActionLabel(ShipmentEntity shipment) {
  final action = shipment.availableActions.firstWhere(
    (capability) =>
        capability.enabled && capability.type != TaskActionType.open,
    orElse: () => const ActionCapability(
      type: TaskActionType.custom,
      label: '',
      enabled: false,
    ),
  );

  if (_hasValue(action.label)) {
    return action.label.trim();
  }

  return switch (shipment.status) {
    ShipmentStatus.draft => 'Xác nhận phiếu',
    ShipmentStatus.confirmed => 'Bắt đầu lấy hàng',
    ShipmentStatus.picking => 'Tiếp tục lấy hàng',
    ShipmentStatus.loading => 'Xác nhận xếp hàng',
    ShipmentStatus.weighCompleted => 'Đóng phiếu xuất',
    ShipmentStatus.shipped => 'Đã xuất',
    ShipmentStatus.closed => 'Đóng',
    ShipmentStatus.error => 'Báo lỗi',
    ShipmentStatus.cancelled => 'Đã hủy',
  };
}

class _StatusNode extends StatelessWidget {
  const _StatusNode({
    required this.index,
    required this.label,
    required this.active,
    required this.current,
  });

  final int index;
  final String label;
  final bool active;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final tone = current
        ? AppColors.brand
        : (active ? AppColors.success : AppColors.textSecondary);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tone.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: tone,
            foregroundColor: AppColors.surface,
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: tone,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetadataCell extends StatelessWidget {
  const _MetadataCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _WeightCell extends StatelessWidget {
  const _WeightCell({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _displayOrDash(String? value) {
  if (!_hasValue(value)) {
    return '--';
  }

  return value!.trim();
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
final NumberFormat _weightFormat = NumberFormat('#,##0.00');
final NumberFormat _qtyFormat = NumberFormat('#,##0.#');
