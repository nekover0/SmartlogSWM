import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';

class InventoryDetailPage extends StatelessWidget {
  const InventoryDetailPage({super.key, required this.inventoryId});

  final String inventoryId;

  @override
  Widget build(BuildContext context) {
    final detail = _inventoryDetails[inventoryId];

    if (detail == null) {
      return Scaffold(
        appBar: _InventoryDetailAppBar(onBack: () => _handleBack(context)),
        body: AppErrorState(
          title: 'Không tìm thấy hàng hóa',
          message: 'Mã hàng $inventoryId không tồn tại hoặc đã bị xóa.',
          onRetry: () => context.go(AppRoutePaths.inventory),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: _InventoryDetailAppBar(onBack: () => _handleBack(context)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: [
          _HeaderSection(detail: detail),
          const SizedBox(height: AppSpacing.md),
          _SummarySection(detail: detail),
          const SizedBox(height: AppSpacing.md),
          _LocationSection(detail: detail),
          const SizedBox(height: AppSpacing.md),
          _TimelineSection(detail: detail),
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle(
            icon: Icons.bolt_rounded,
            title: 'HÀNH ĐỘNG NHANH',
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _ActionButton(
                key: const Key('inventory_detail_action_inbound'),
                icon: Icons.add_box_outlined,
                label: 'Nhập kho',
                onPressed: () => context.go(AppRoutePaths.receiptCreate),
              ),
              _ActionButton(
                key: const Key('inventory_detail_action_outbound'),
                icon: Icons.outbox_outlined,
                label: 'Xuất kho',
                onPressed: () => context.go(AppRoutePaths.shipmentCreate),
              ),
              _ActionButton(
                key: const Key('inventory_detail_action_move'),
                icon: Icons.swap_horiz_rounded,
                label: 'Chuyển vị trí',
                onPressed: () {
                  context.go(AppRoutePaths.inventoryControlFlowPath('move'));
                },
              ),
              _ActionButton(
                key: const Key('inventory_detail_action_alert'),
                icon: Icons.notification_important_outlined,
                label: 'Gắn cảnh báo',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã thêm mặt hàng vào danh sách cảnh báo.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.inventory);
  }
}

class _InventoryDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _InventoryDetailAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        key: const Key('inventory_detail_back_button'),
        tooltip: 'Quay lại',
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text('Chi tiết tồn kho'),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.detail});

  final _InventoryDetailData detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('inventory_detail_header'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  detail.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _StatusBadge(status: detail.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'SKU: ${detail.sku}',
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

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.detail});

  final _InventoryDetailData detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('inventory_detail_summary'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.analytics_outlined,
            title: 'TỔNG QUAN',
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetricRow(
            label: 'Số lượng hiện tại',
            value: '${detail.currentQty} ${detail.uom}',
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetricRow(
            label: 'Số lượng khả dụng',
            value: '${detail.availableQty} ${detail.uom}',
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetricRow(
            label: 'Ngưỡng cảnh báo',
            value: '${detail.warningThreshold} ${detail.uom}',
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetricRow(label: 'Ưu tiên xử lý', value: detail.priority),
        ],
      ),
    );
  }
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({required this.detail});

  final _InventoryDetailData detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('inventory_detail_location'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.location_on_outlined,
            title: 'THÔNG TIN VỊ TRÍ',
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetricRow(label: 'Kho', value: detail.warehouse),
          const SizedBox(height: AppSpacing.xs),
          _MetricRow(label: 'Kệ', value: detail.shelf),
          const SizedBox(height: AppSpacing.xs),
          _MetricRow(label: 'Lô', value: detail.batch),
          const SizedBox(height: AppSpacing.xs),
          _MetricRow(label: 'Khu vực', value: detail.zone),
        ],
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.detail});

  final _InventoryDetailData detail;

  @override
  Widget build(BuildContext context) {
    if (detail.timelineEvents.isEmpty) {
      return AppEmptyState(
        title: 'Chưa có lịch sử thay đổi',
        message: 'Timeline sẽ hiển thị khi có nhập/xuất hoặc kiểm kê.',
        onRetry: () {},
        retryLabel: 'Đóng',
      );
    }

    return Container(
      key: const Key('inventory_detail_timeline'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.timeline_rounded,
            title: 'LỊCH SỬ GIAO DỊCH',
          ),
          const SizedBox(height: AppSpacing.sm),
          ...detail.timelineEvents.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == detail.timelineEvents.length - 1
                    ? 0
                    : AppSpacing.sm,
              ),
              child: _TimelineItem(event: event),
            );
          }),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.brand),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final _InventoryHealthStatus status;

  @override
  Widget build(BuildContext context) {
    final tone = switch (status) {
      _InventoryHealthStatus.low => (
        background: const Color(0xFFFDECEC),
        foreground: AppColors.danger,
      ),
      _InventoryHealthStatus.stable => (
        background: const Color(0xFFE8F5EE),
        foreground: AppColors.success,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: tone.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event});

  final _InventoryTimelineEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(event.icon, color: AppColors.brand, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.timestamp,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            event.delta,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: event.delta.startsWith('-')
                  ? AppColors.danger
                  : AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

enum _InventoryHealthStatus {
  low('Tồn thấp'),
  stable('Ổn định');

  const _InventoryHealthStatus(this.label);

  final String label;
}

class _InventoryTimelineEvent {
  const _InventoryTimelineEvent({
    required this.icon,
    required this.label,
    required this.timestamp,
    required this.delta,
  });

  final IconData icon;
  final String label;
  final String timestamp;
  final String delta;
}

class _InventoryDetailData {
  const _InventoryDetailData({
    required this.id,
    required this.sku,
    required this.name,
    required this.status,
    required this.uom,
    required this.currentQty,
    required this.availableQty,
    required this.warningThreshold,
    required this.priority,
    required this.warehouse,
    required this.shelf,
    required this.batch,
    required this.zone,
    required this.timelineEvents,
  });

  final String id;
  final String sku;
  final String name;
  final _InventoryHealthStatus status;
  final String uom;
  final int currentQty;
  final int availableQty;
  final int warningThreshold;
  final String priority;
  final String warehouse;
  final String shelf;
  final String batch;
  final String zone;
  final List<_InventoryTimelineEvent> timelineEvents;
}

const Map<String, _InventoryDetailData> _inventoryDetails =
    <String, _InventoryDetailData>{
      'inv-smt-9022-x': _InventoryDetailData(
        id: 'inv-smt-9022-x',
        sku: 'SMT-9022-X',
        name: 'Cảm biến nhiệt Thermal GX-90',
        status: _InventoryHealthStatus.low,
        uom: 'PCS',
        currentQty: 12,
        availableQty: 9,
        warningThreshold: 15,
        priority: 'Cao',
        warehouse: 'Sai Gon Distribution Center',
        shelf: 'Aisle 4 / Bin B-12',
        batch: 'LOT-24-03-21',
        zone: 'Khu cảm biến',
        timelineEvents: <_InventoryTimelineEvent>[
          _InventoryTimelineEvent(
            icon: Icons.login_rounded,
            label: 'Nhập kho gần nhất',
            timestamp: '24/03/2026 10:15',
            delta: '+20',
          ),
          _InventoryTimelineEvent(
            icon: Icons.logout_rounded,
            label: 'Xuất kho gần nhất',
            timestamp: '25/03/2026 08:40',
            delta: '-8',
          ),
          _InventoryTimelineEvent(
            icon: Icons.fact_check_outlined,
            label: 'Kiểm kê gần nhất',
            timestamp: '25/03/2026 09:20',
            delta: '-0',
          ),
        ],
      ),
      'inv-net-4402-b': _InventoryDetailData(
        id: 'inv-net-4402-b',
        sku: 'NET-4402-B',
        name: 'Industrial Hub Switch 24-Port',
        status: _InventoryHealthStatus.stable,
        uom: 'PCS',
        currentQty: 450,
        availableQty: 432,
        warningThreshold: 50,
        priority: 'Bình thường',
        warehouse: 'Sai Gon Distribution Center',
        shelf: 'Zone C / Shelf 09',
        batch: 'LOT-24-02-11',
        zone: 'Khu thiết bị mạng',
        timelineEvents: <_InventoryTimelineEvent>[],
      ),
    };
