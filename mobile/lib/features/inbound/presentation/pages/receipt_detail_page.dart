import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_names.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_action_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_detail_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_list_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/widgets/receipt_action_footer.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_flow_projection_controller.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/tasks/application/controllers/task_queue_controller.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class ReceiptDetailPage extends ConsumerStatefulWidget {
  const ReceiptDetailPage({super.key, required this.receiptId});

  final String receiptId;

  @override
  ConsumerState<ReceiptDetailPage> createState() => _ReceiptDetailPageState();
}

class _ReceiptDetailPageState extends ConsumerState<ReceiptDetailPage> {
  @override
  Widget build(BuildContext context) {
    final receiptState = ref.watch(
      receiptDetailControllerProvider(widget.receiptId),
    );
    final actionState = ref.watch(
      receiptActionControllerProvider(widget.receiptId),
    );
    final receipt = receiptState.valueOrNull;

    if (receiptState.isLoading && receipt == null) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang tải chi tiết phiếu nhập...'),
      );
    }

    if (receiptState.hasError && receipt == null) {
      if (_isMissingReceiptError(receiptState.error)) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _handleBack,
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Quay lại',
            ),
            title: const Text('Chi tiết phiếu nhập'),
          ),
          body: AppEmptyState(
            title: 'Không tìm thấy phiếu nhập',
            message:
                'Phiếu nhập này không còn tồn tại hoặc bạn cần tải lại queue inbound.',
            retryLabel: 'Quay về danh sách',
            onRetry: () {
              context.go(AppRoutePaths.receiptList);
            },
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _handleBack,
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Quay lại',
          ),
          title: const Text('Chi tiết phiếu nhập'),
        ),
        body: AppErrorState(
          title: 'Không tải được chi tiết phiếu nhập',
          message: '${receiptState.error}',
          onRetry: () {
            ref
                .read(
                  receiptDetailControllerProvider(widget.receiptId).notifier,
                )
                .refresh();
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
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        leading: IconButton(
          onPressed: _handleBack,
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Quay lại',
        ),
        title: const Text('Chi tiết phiếu nhập'),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(
                    receiptDetailControllerProvider(widget.receiptId).notifier,
                  )
                  .refresh();
            },
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      bottomNavigationBar: ReceiptActionFooter(
        primaryActions: actionState.primaryActions,
        secondaryActions: actionState.secondaryActions,
        onActionSelected: (action) {
          _handleAction(receipt, action);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return ref
              .read(receiptDetailControllerProvider(widget.receiptId).notifier)
              .refresh();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pagePadding,
          children: [
            _ManifestHeader(receipt: receipt),
            const SizedBox(height: AppSpacing.lg),
            _MetadataGrid(receipt: receipt),
            const SizedBox(height: AppSpacing.lg),
            _WeighingFlowSection(receipt: receipt),
            const SizedBox(height: AppSpacing.lg),
            _SkuListSection(receipt: receipt),
            const SizedBox(height: AppSpacing.lg),
            _DocumentsSection(receipt: receipt),
            if (_hasValue(receipt.note)) ...[
              const SizedBox(height: AppSpacing.lg),
              _SimpleSection(
                title: 'Ghi chú',
                child: Text(
                  receipt.note!.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (_hasValue(receipt.errorMessage)) ...[
              const SizedBox(height: AppSpacing.lg),
              _SimpleSection(
                title: 'Lỗi hiện tại',
                child: Text(
                  receipt.errorMessage!.trim(),
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

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.receiptList);
  }

  Future<void> _handleAction(
    ReceiptEntity receipt,
    ActionCapability action,
  ) async {
    if (!action.enabled) {
      return;
    }

    if (action.type == TaskActionType.startWeighing) {
      await _launchReceiveScan(receipt);
      return;
    }

    final location = resolveNamedRouteLocation(
      router: GoRouter.of(context),
      routeName: action.routeName,
      pathParameters: action.routeParams,
    );

    if (location != null) {
      await context.push(location);
      return;
    }

    if (!mounted) {
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

  Future<void> _launchReceiveScan(ReceiptEntity receipt) async {
    final result = await context.push<ScanFlowResult>(
      buildScanBarcodeLocation(
        launchContext: ScanLaunchContext(
          mode: ScanMode.receive,
          referenceId: receipt.id,
          referenceNo: receipt.receiptNo,
          warehouseId: receipt.warehouse.id,
          warehouseCode: receipt.warehouse.code,
          originRouteName: AppRouteNames.receiptDetail,
          originRouteParams: <String, String>{
            AppRoutePaths.receiptIdParam: receipt.id,
          },
        ),
      ),
    );

    if (!mounted || result == null || !result.success) {
      return;
    }

    ref
        .read(scanFlowProjectionControllerProvider.notifier)
        .applyReceiveResult(result);

    await ref
        .read(receiptDetailControllerProvider(widget.receiptId).notifier)
        .refresh();
    await ref.read(taskQueueControllerProvider.notifier).refresh();
    ref.invalidate(receiptListControllerProvider);
    ref.invalidate(appShellControllerProvider);

    if (!mounted) {
      return;
    }

    final itemCode = result.itemCode?.trim();
    final locationCode = result.locationCode?.trim();
    final quantityLabel = result.quantity == null
        ? null
        : _formatQuantity(result.quantity!);
    final content = <String>[
      'Đã cập nhật ${receipt.receiptNo}.',
      if (quantityLabel != null && itemCode != null)
        'Nhận $quantityLabel cho $itemCode.',
      if (locationCode != null && locationCode.isNotEmpty)
        'Vị trí $locationCode.',
    ].join(' ');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
          action: SnackBarAction(
            label: 'Về task queue',
            onPressed: () {
              context.go(AppRoutePaths.tasks);
            },
          ),
        ),
      );
  }
}

class _ManifestHeader extends StatelessWidget {
  const _ManifestHeader({required this.receipt});

  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) {
    final statusLabel = _statusLabel(receipt.status);
    final statusColor = _statusColor(receipt.status);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.receiptNo,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.brand,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _dateTimeFormat.format(receipt.updatedAt.toLocal()),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      receipt.owner.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  statusLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetadataGrid extends StatelessWidget {
  const _MetadataGrid({required this.receipt});

  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetaGridItem(
                  label: 'Số PO',
                  value: _valueOrFallback(receipt.purchaseOrderNo),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetaGridItem(
                  label: 'Số Vận Đơn',
                  value: _valueOrFallback(receipt.billOfLadingNo),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _MetaGridItem(
                  label: 'Kho Đích',
                  value: receipt.warehouse.code,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetaGridItem(
                  label: 'Biển Số',
                  value: _valueOrFallback(receipt.vehicle.plateNumber),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaGridItem extends StatelessWidget {
  const _MetaGridItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.brand,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeighingFlowSection extends StatelessWidget {
  const _WeighingFlowSection({required this.receipt});

  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) {
    final variancePercent = _variancePercent(receipt);
    final exceedsThreshold = variancePercent.abs() > 0.2;

    return _SimpleSection(
      title: 'Quy trình cân hàng',
      trailing: Text(
        'Bước 2/3',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (exceedsThreshold)
            Container(
              key: const Key('receipt_variance_warning'),
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.danger.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chênh Lệch',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${variancePercent.toStringAsFixed(2)}%',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.surface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${receipt.varianceWeightKg > 0 ? '+' : ''}${_weightFormat.format(receipt.varianceWeightKg)} KG',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '* Vượt ngưỡng cho phép (0.2%)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.danger),
                  ),
                ],
              ),
            ),
          if (exceedsThreshold) const SizedBox(height: AppSpacing.sm),
          _WeightFlowCard(
            title: 'Cân Cảng (Expected)',
            value: receipt.portWeightKg ?? receipt.expectedWeightKg,
            tone: AppColors.info,
          ),
          const SizedBox(height: AppSpacing.sm),
          _WeightFlowCard(
            title: 'Thực Nhận (Actual)',
            value: receipt.receivedWeightKg,
            tone: AppColors.brand,
          ),
        ],
      ),
    );
  }
}

class _WeightFlowCard extends StatelessWidget {
  const _WeightFlowCard({
    required this.title,
    required this.value,
    required this.tone,
  });

  final String title;
  final double value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tone.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${_weightFormat.format(value)} KG',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.brand,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkuListSection extends StatelessWidget {
  const _SkuListSection({required this.receipt});

  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) {
    return _SimpleSection(
      title: 'Danh sách hàng hóa',
      trailing: Text(
        '${receipt.lines.length} SKUs',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Column(
        children: [
          for (var index = 0; index < receipt.lines.length; index++) ...[
            _SkuLineCard(line: receipt.lines[index]),
            if (index < receipt.lines.length - 1)
              const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _SkuLineCard extends StatelessWidget {
  const _SkuLineCard({required this.line});

  final ReceiptLineEntity line;

  @override
  Widget build(BuildContext context) {
    final hasVariance = line.varianceQty.abs() > 0;
    final varianceColor = hasVariance ? AppColors.danger : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: varianceColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.itemCode,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.brand,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            line.itemName,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _SkuQty(
                  label: 'Dự kiến (Exp)',
                  value: line.expectedQty,
                  uom: line.uomCode,
                ),
              ),
              Expanded(
                child: _SkuQty(
                  label: 'Thực nhận (Act)',
                  value: line.receivedQty,
                  uom: line.uomCode,
                  valueColor: varianceColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkuQty extends StatelessWidget {
  const _SkuQty({
    required this.label,
    required this.value,
    required this.uom,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final double value;
  final String uom;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${_weightFormat.format(value)} $uom',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({required this.receipt});

  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) {
    return _SimpleSection(
      title: 'Chứng từ & Hình ảnh',
      child: Row(
        children: [
          _DocActionTile(
            icon: Icons.photo_camera_outlined,
            label: 'Chụp Ảnh',
            onTap: () {},
          ),
          const SizedBox(width: AppSpacing.sm),
          _DocPreviewTile(label: 'Weight_Slip.jpg'),
          const SizedBox(width: AppSpacing.sm),
          _DocPreviewTile(label: 'Plate_Verify.png'),
          const SizedBox(width: AppSpacing.sm),
          _DocActionTile(
            icon: Icons.file_upload_outlined,
            label: 'Tải Lên',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _DocActionTile extends StatelessWidget {
  const _DocActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: const Color(0xFFF6FAFF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.brand),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.brand,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocPreviewTile extends StatelessWidget {
  const _DocPreviewTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: const Color(0xFFE5EDF7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleSection extends StatelessWidget {
  const _SimpleSection({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ..._asWidgetList(trailing),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
final NumberFormat _weightFormat = NumberFormat('#,##0.##');

List<Widget> _asWidgetList(Widget? widget) {
  if (widget == null) {
    return const <Widget>[];
  }

  return <Widget>[widget];
}

String _valueOrFallback(String? value) {
  if (!_hasValue(value)) {
    return 'Chưa cập nhật';
  }
  return value!.trim();
}

String _formatQuantity(double value) {
  if (value.truncateToDouble() == value) {
    return value.toStringAsFixed(0);
  }

  return value.toString();
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

bool _isMissingReceiptError(Object? error) {
  if (error is StateError) {
    return true;
  }

  final normalizedError = '$error'.toLowerCase();
  return normalizedError.contains('not found') ||
      normalizedError.contains('no element');
}

double _variancePercent(ReceiptEntity receipt) {
  final baseline = receipt.portWeightKg ?? receipt.expectedWeightKg;
  if (baseline == 0) {
    return 0;
  }

  return (receipt.varianceWeightKg / baseline) * 100;
}

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
