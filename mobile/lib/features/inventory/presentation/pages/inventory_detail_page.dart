import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';

class InventoryDetailPage extends StatefulWidget {
  const InventoryDetailPage({super.key, required this.inventoryId});

  final String inventoryId;

  @override
  State<InventoryDetailPage> createState() => _InventoryDetailPageState();
}

class _InventoryDetailPageState extends State<InventoryDetailPage> {
  _TimelineRange _timelineRange = _TimelineRange.all;

  @override
  Widget build(BuildContext context) {
    final detail = _inventoryDetails[widget.inventoryId];

    if (detail == null) {
      return Scaffold(
        appBar: _InventoryDetailAppBar(onBack: () => _handleBack(context)),
        body: AppErrorState(
          title: 'Không tìm thấy hàng hóa',
          message:
              'Mã hàng ${widget.inventoryId} không tồn tại hoặc đã bị xóa.',
          onRetry: () => context.go(AppRoutePaths.inventory),
        ),
      );
    }

    final visibleTimelineEvents = detail.timelineEvents
        .where((event) => _timelineRange.accepts(event.occurredAt))
        .toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.background,
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
          _TimelineSection(
            detail: detail,
            selectedRange: _timelineRange,
            visibleEvents: visibleTimelineEvents,
            onRangeSelected: (range) {
              setState(() {
                _timelineRange = range;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _ActionSection(
            onInbound: () => context.go(AppRoutePaths.receiptCreate),
            onOutbound: () => context.go(AppRoutePaths.shipmentCreate),
            onMove: () =>
                context.go(AppRoutePaths.inventoryControlFlowPath('move')),
            onAlert: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã thêm mặt hàng vào danh sách cảnh báo.'),
                ),
              );
            },
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

enum _TimelineRange {
  all('Tất cả'),
  last7Days('7 ngày'),
  last30Days('30 ngày');

  const _TimelineRange(this.label);

  final String label;

  bool accepts(DateTime occurredAt) {
    final now = DateTime.now();
    final difference = now.difference(occurredAt);

    return switch (this) {
      _TimelineRange.all => true,
      _TimelineRange.last7Days => difference.inDays <= 7,
      _TimelineRange.last30Days => difference.inDays <= 30,
    };
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D103B73),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.detail});

  final _InventoryDetailData detail;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      key: const Key('inventory_detail_header'),
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
                      detail.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _Pill(
                      icon: Icons.qr_code_2_rounded,
                      label: 'SKU ${detail.sku}',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusBadge(status: detail.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Số lượng hiện tại',
                  value: '${detail.currentQty}',
                  suffix: detail.uom,
                  tone: detail.status == _InventoryHealthStatus.low
                      ? _MetricTone.warning
                      : _MetricTone.brand,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  children: [
                    _CompactInfoTile(
                      label: 'Khả dụng',
                      value: '${detail.availableQty} ${detail.uom}',
                      tone: _MetricTone.success,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _CompactInfoTile(
                      label: 'Ưu tiên',
                      value: detail.priority,
                      tone: _MetricTone.neutral,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (detail.status == _InventoryHealthStatus.low)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E8),
                borderRadius: AppSpacing.controlRadius,
                border: Border.all(color: const Color(0xFFF4D3A0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Tồn kho đang thấp hơn ngưỡng cảnh báo. Ưu tiên xử lý ngay để tránh thiếu hàng.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
    return _SectionCard(
      key: const Key('inventory_detail_summary'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.analytics_outlined,
            title: 'TỔNG QUAN',
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.45,
            children: [
              _SummaryMetricTile(
                label: 'Số lượng hiện tại',
                value: '${detail.currentQty}',
                suffix: detail.uom,
                tone: detail.status == _InventoryHealthStatus.low
                    ? _MetricTone.warning
                    : _MetricTone.brand,
              ),
              _SummaryMetricTile(
                label: 'Số lượng khả dụng',
                value: '${detail.availableQty}',
                suffix: detail.uom,
                tone: _MetricTone.success,
              ),
              _SummaryMetricTile(
                label: 'Ngưỡng cảnh báo',
                value: '${detail.warningThreshold}',
                suffix: detail.uom,
                tone: _MetricTone.warning,
              ),
              _SummaryMetricTile(
                label: 'Ưu tiên xử lý',
                value: detail.priority,
                tone: _MetricTone.neutral,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetricTile extends StatelessWidget {
  const _SummaryMetricTile({
    required this.label,
    required this.value,
    required this.tone,
    this.suffix,
  });

  final String label;
  final String value;
  final String? suffix;
  final _MetricTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      _MetricTone.brand => (
        background: const Color(0xFFEFF4FF),
        foreground: AppColors.brand,
      ),
      _MetricTone.success => (
        background: const Color(0xFFE9F8F1),
        foreground: AppColors.success,
      ),
      _MetricTone.warning => (
        background: const Color(0xFFFFF6E8),
        foreground: AppColors.warning,
      ),
      _MetricTone.neutral => (
        background: const Color(0xFFF6F8FC),
        foreground: AppColors.textPrimary,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppSpacing.controlRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(height: 2),
                Text(
                  suffix!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
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
    return _SectionCard(
      key: const Key('inventory_detail_location'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.location_on_outlined,
            title: 'THÔNG TIN VỊ TRÍ',
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            constraints: const BoxConstraints(minHeight: 96),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7FF),
              borderRadius: AppSpacing.controlRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    color: AppColors.brand,
                    size: 34,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        detail.warehouse,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _Pill(icon: Icons.place_outlined, label: detail.zone),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _MetricRow(label: 'Kho', value: detail.warehouse),
          const SizedBox(height: AppSpacing.sm),
          _MetricRow(label: 'Kệ', value: detail.shelf),
          const SizedBox(height: AppSpacing.sm),
          _MetricRow(label: 'Lô', value: detail.batch),
          const SizedBox(height: AppSpacing.sm),
          _MetricRow(label: 'Khu vực', value: detail.zone),
        ],
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({
    required this.detail,
    required this.selectedRange,
    required this.visibleEvents,
    required this.onRangeSelected,
  });

  final _InventoryDetailData detail;
  final _TimelineRange selectedRange;
  final List<_InventoryTimelineEvent> visibleEvents;
  final ValueChanged<_TimelineRange> onRangeSelected;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      key: const Key('inventory_detail_timeline'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.timeline_rounded,
            title: 'LỊCH SỬ GIAO DỊCH',
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: _TimelineRange.values
                .map(
                  (range) => _TimelineFilterChip(
                    label: range.label,
                    selected: selectedRange == range,
                    onSelected: () => onRangeSelected(range),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: AppSpacing.md),
          if (visibleEvents.isEmpty)
            const _TimelineEmptyState()
          else
            Column(
              children: [
                for (final entry in visibleEvents.asMap().entries)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key == visibleEvents.length - 1
                          ? 0
                          : AppSpacing.sm,
                    ),
                    child: _TimelineItem(
                      event: entry.value,
                      isLast: entry.key == visibleEvents.length - 1,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TimelineFilterChip extends StatelessWidget {
  const _TimelineFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.brand.withValues(alpha: 0.12),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: selected ? AppColors.brand : AppColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(color: selected ? AppColors.brand : AppColors.border),
      ),
      backgroundColor: AppColors.surface,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event, required this.isLast});

  final _InventoryTimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(event.icon, color: AppColors.brand, size: 18),
            ),
            if (!isLast)
              Container(width: 2, height: 44, color: AppColors.border),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFE),
              borderRadius: AppSpacing.controlRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        event.timestamp,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _DeltaBadge(delta: event.delta),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineEmptyState extends StatelessWidget {
  const _TimelineEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFE),
        borderRadius: AppSpacing.controlRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: AppColors.info),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Chưa có lịch sử thay đổi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Timeline sẽ hiển thị khi có nhập/xuất hoặc kiểm kê.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.onInbound,
    required this.onOutbound,
    required this.onMove,
    required this.onAlert,
  });

  final VoidCallback onInbound;
  final VoidCallback onOutbound;
  final VoidCallback onMove;
  final VoidCallback onAlert;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.bolt_rounded,
            title: 'HÀNH ĐỘNG NHANH',
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.65,
            children: [
              _ActionButton.filled(
                key: const Key('inventory_detail_action_inbound'),
                icon: Icons.add_box_outlined,
                label: 'Nhập kho',
                onPressed: onInbound,
              ),
              _ActionButton.outlined(
                key: const Key('inventory_detail_action_outbound'),
                icon: Icons.outbox_outlined,
                label: 'Xuất kho',
                onPressed: onOutbound,
              ),
              _ActionButton.outlined(
                key: const Key('inventory_detail_action_move'),
                icon: Icons.swap_horiz_rounded,
                label: 'Chuyển vị trí',
                onPressed: onMove,
              ),
              _ActionButton.outlined(
                key: const Key('inventory_detail_action_alert'),
                icon: Icons.notification_important_outlined,
                label: 'Gắn cảnh báo',
                onPressed: onAlert,
                tone: _MetricTone.warning,
              ),
            ],
          ),
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
            letterSpacing: 0.2,
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
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tone.foreground.withValues(alpha: 0.2)),
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

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.brand),
          const SizedBox(width: 6),
          Text(
            label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.suffix,
    required this.tone,
  });

  final String label;
  final String value;
  final String suffix;
  final _MetricTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      _MetricTone.brand => (
        background: const Color(0xFFEFF4FF),
        foreground: AppColors.brand,
      ),
      _MetricTone.success => (
        background: const Color(0xFFE9F8F1),
        foreground: AppColors.success,
      ),
      _MetricTone.warning => (
        background: const Color(0xFFFFF6E8),
        foreground: AppColors.warning,
      ),
      _MetricTone.neutral => (
        background: const Color(0xFFF6F8FC),
        foreground: AppColors.textPrimary,
      ),
    };

    return Container(
      height: 140,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppSpacing.controlRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                suffix,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactInfoTile extends StatelessWidget {
  const _CompactInfoTile({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final _MetricTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      _MetricTone.brand => (
        background: const Color(0xFFEFF4FF),
        foreground: AppColors.brand,
      ),
      _MetricTone.success => (
        background: const Color(0xFFE9F8F1),
        foreground: AppColors.success,
      ),
      _MetricTone.warning => (
        background: const Color(0xFFFFF6E8),
        foreground: AppColors.warning,
      ),
      _MetricTone.neutral => (
        background: const Color(0xFFF6F8FC),
        foreground: AppColors.textPrimary,
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppSpacing.controlRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeltaBadge extends StatelessWidget {
  const _DeltaBadge({required this.delta});

  final String delta;

  @override
  Widget build(BuildContext context) {
    final isNegative = delta.startsWith('-');
    final isNeutral = delta == '0' || delta == '-0';
    final backgroundColor = switch ((isNegative, isNeutral)) {
      (true, _) => const Color(0xFFFDECEC),
      (_, true) => const Color(0xFFF6F8FC),
      _ => const Color(0xFFE9F8F1),
    };
    final foregroundColor = switch ((isNegative, isNeutral)) {
      (true, _) => AppColors.danger,
      (_, true) => AppColors.textSecondary,
      _ => AppColors.success,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        delta,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

enum _MetricTone { brand, success, warning, neutral }

class _ActionButton extends StatelessWidget {
  const _ActionButton.filled({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : filled = true,
       tone = _MetricTone.brand;

  const _ActionButton.outlined({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tone = _MetricTone.neutral,
  }) : filled = false;

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final _MetricTone tone;

  @override
  Widget build(BuildContext context) {
    final actionForeground = filled ? AppColors.surface : AppColors.textPrimary;

    final colors = switch (tone) {
      _MetricTone.brand => (
        background: AppColors.brand,
        foreground: AppColors.surface,
        border: AppColors.brand,
      ),
      _MetricTone.success => (
        background: const Color(0xFFE9F8F1),
        foreground: AppColors.textPrimary,
        border: AppColors.success,
      ),
      _MetricTone.warning => (
        background: const Color(0xFFFFF6E8),
        foreground: AppColors.textPrimary,
        border: AppColors.warning,
      ),
      _MetricTone.neutral => (
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
        border: AppColors.border,
      ),
    };

    final child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: actionForeground),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: actionForeground,
          ),
        ),
      ],
    );

    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.controlRadius),
          padding: const EdgeInsets.all(AppSpacing.md),
          minimumSize: const Size.fromHeight(88),
        ),
        child: child,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.foreground,
        backgroundColor: colors.background,
        side: BorderSide(color: colors.border),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.controlRadius),
        padding: const EdgeInsets.all(AppSpacing.md),
        minimumSize: const Size.fromHeight(88),
      ),
      child: child,
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
  _InventoryTimelineEvent({
    required this.icon,
    required this.label,
    required this.timestamp,
    required this.occurredAt,
    required this.delta,
  });

  final IconData icon;
  final String label;
  final String timestamp;
  final DateTime occurredAt;
  final String delta;
}

class _InventoryDetailData {
  _InventoryDetailData({
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

final Map<String, _InventoryDetailData> _inventoryDetails =
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
            icon: Icons.fact_check_outlined,
            label: 'Kiểm kê gần nhất',
            timestamp: '25/03/2026 09:20',
            occurredAt: DateTime(2026, 3, 25, 9, 20),
            delta: '0',
          ),
          _InventoryTimelineEvent(
            icon: Icons.logout_rounded,
            label: 'Xuất kho gần nhất',
            timestamp: '25/03/2026 08:40',
            occurredAt: DateTime(2026, 3, 25, 8, 40),
            delta: '-8',
          ),
          _InventoryTimelineEvent(
            icon: Icons.login_rounded,
            label: 'Nhập kho gần nhất',
            timestamp: '24/03/2026 10:15',
            occurredAt: DateTime(2026, 3, 24, 10, 15),
            delta: '+20',
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
