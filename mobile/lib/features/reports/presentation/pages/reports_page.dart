import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  ReportTimeRange _selectedRange = ReportTimeRange.last24Hours;
  ReportChartMode _chartMode = ReportChartMode.line;
  bool _isLoading = false;
  bool _isExporting = false;

  _ReportSnapshot? get _snapshot => _snapshotByRange[_selectedRange];

  static final Map<ReportTimeRange, _ReportSnapshot?> _snapshotByRange =
      <ReportTimeRange, _ReportSnapshot?>{
        ReportTimeRange.today: _ReportSnapshot(
          updatedAt: DateTime.now().subtract(const Duration(minutes: 2)),
          totalInventory: 46520,
          inboundToday: 412,
          outboundToday: 365,
          utilizationPercent: 78,
          openAlerts: 9,
          trendLabels: const <String>['08h', '10h', '12h', '14h', '16h', '18h'],
          inboundTrend: const <double>[34, 52, 74, 61, 48, 40],
          outboundTrend: const <double>[18, 30, 44, 55, 63, 58],
          ownerBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'VinFast', value: '8,420', percent: 23),
            _BreakdownItem(label: 'THACO', value: '6,180', percent: 17),
            _BreakdownItem(label: 'TH True Milk', value: '5,790', percent: 16),
            _BreakdownItem(label: 'Sabeco', value: '4,520', percent: 13),
            _BreakdownItem(label: 'Khác', value: '21,610', percent: 31),
          ],
          warehouseBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'WH-A', value: '19,120', percent: 41),
            _BreakdownItem(label: 'WH-B', value: '13,900', percent: 30),
            _BreakdownItem(label: 'WH-C', value: '8,740', percent: 19),
            _BreakdownItem(label: 'Transit', value: '4,760', percent: 10),
          ],
          statusBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'Available', value: '32,480', percent: 70),
            _BreakdownItem(label: 'Hold', value: '6,050', percent: 13),
            _BreakdownItem(label: 'Damaged', value: '1,880', percent: 4),
            _BreakdownItem(label: 'In Transit', value: '6,110', percent: 13),
          ],
          anomalies: const <_AnomalyItem>[
            _AnomalyItem(
              title: 'Tồn tăng đột biến tại WH-B',
              detail: '+18% trong 3 giờ gần nhất',
              level: AnomalyLevel.warning,
              actionLabel: 'Xem tồn kho',
              route: AppRoutePaths.inventory,
            ),
            _AnomalyItem(
              title: 'Phiếu cân chờ xử lý vượt SLA',
              detail: '7 task quá 45 phút',
              level: AnomalyLevel.danger,
              actionLabel: 'Mở hàng chờ',
              route: AppRoutePaths.tasks,
            ),
          ],
        ),
        ReportTimeRange.last24Hours: _ReportSnapshot(
          updatedAt: DateTime.now().subtract(const Duration(minutes: 4)),
          totalInventory: 45820,
          inboundToday: 1284,
          outboundToday: 1132,
          utilizationPercent: 74,
          openAlerts: 6,
          trendLabels: const <String>['00h', '04h', '08h', '12h', '16h', '20h'],
          inboundTrend: const <double>[44, 36, 52, 69, 58, 47],
          outboundTrend: const <double>[38, 31, 41, 60, 63, 52],
          ownerBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'VinFast', value: '8,010', percent: 22),
            _BreakdownItem(label: 'THACO', value: '6,340', percent: 17),
            _BreakdownItem(label: 'TH True Milk', value: '5,640', percent: 15),
            _BreakdownItem(label: 'Sabeco', value: '4,310', percent: 12),
            _BreakdownItem(label: 'Khác', value: '21,520', percent: 34),
          ],
          warehouseBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'WH-A', value: '18,950', percent: 41),
            _BreakdownItem(label: 'WH-B', value: '13,510', percent: 29),
            _BreakdownItem(label: 'WH-C', value: '9,030', percent: 20),
            _BreakdownItem(label: 'Transit', value: '4,330', percent: 10),
          ],
          statusBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'Available', value: '31,870', percent: 70),
            _BreakdownItem(label: 'Hold', value: '5,920', percent: 13),
            _BreakdownItem(label: 'Damaged', value: '1,750', percent: 4),
            _BreakdownItem(label: 'In Transit', value: '6,280', percent: 13),
          ],
          anomalies: const <_AnomalyItem>[
            _AnomalyItem(
              title: 'OCR queue tăng bất thường',
              detail: '12 chứng từ đang chờ review',
              level: AnomalyLevel.warning,
              actionLabel: 'Mở OCR',
              route: AppRoutePaths.ocrInbox,
            ),
            _AnomalyItem(
              title: 'Sai lệch đối soát outbound',
              detail: '3 phiếu cần xác minh lại',
              level: AnomalyLevel.info,
              actionLabel: 'Xem phiếu xuất',
              route: AppRoutePaths.shipmentList,
            ),
          ],
        ),
        ReportTimeRange.last7Days: _ReportSnapshot(
          updatedAt: DateTime.now().subtract(const Duration(minutes: 6)),
          totalInventory: 45160,
          inboundToday: 7290,
          outboundToday: 6884,
          utilizationPercent: 71,
          openAlerts: 11,
          trendLabels: const <String>['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
          inboundTrend: const <double>[70, 81, 62, 74, 77, 66, 58],
          outboundTrend: const <double>[61, 74, 55, 69, 72, 58, 52],
          ownerBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'VinFast', value: '7,840', percent: 21),
            _BreakdownItem(label: 'THACO', value: '6,050', percent: 17),
            _BreakdownItem(label: 'TH True Milk', value: '5,720', percent: 16),
            _BreakdownItem(label: 'Sabeco', value: '4,620', percent: 13),
            _BreakdownItem(label: 'Khác', value: '20,930', percent: 33),
          ],
          warehouseBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'WH-A', value: '18,620', percent: 41),
            _BreakdownItem(label: 'WH-B', value: '12,980', percent: 29),
            _BreakdownItem(label: 'WH-C', value: '8,940', percent: 20),
            _BreakdownItem(label: 'Transit', value: '4,620', percent: 10),
          ],
          statusBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'Available', value: '31,250', percent: 69),
            _BreakdownItem(label: 'Hold', value: '5,980', percent: 13),
            _BreakdownItem(label: 'Damaged', value: '1,920', percent: 4),
            _BreakdownItem(label: 'In Transit', value: '6,010', percent: 14),
          ],
          anomalies: const <_AnomalyItem>[
            _AnomalyItem(
              title: 'Tỷ lệ sử dụng WH-A vượt ngưỡng',
              detail: '87% công suất trong 2 ngày liên tiếp',
              level: AnomalyLevel.danger,
              actionLabel: 'Xem chi tiết',
              route: AppRoutePaths.inventory,
            ),
            _AnomalyItem(
              title: 'Độ chính xác cân giảm nhẹ',
              detail: 'Sai lệch trung bình 1.8%',
              level: AnomalyLevel.warning,
              actionLabel: 'Mở hàng chờ',
              route: AppRoutePaths.tasks,
            ),
          ],
        ),
        ReportTimeRange.last30Days: _ReportSnapshot(
          updatedAt: DateTime.now().subtract(const Duration(minutes: 19)),
          totalInventory: 44920,
          inboundToday: 30140,
          outboundToday: 28990,
          utilizationPercent: 69,
          openAlerts: 4,
          trendLabels: const <String>['W1', 'W2', 'W3', 'W4', 'W5'],
          inboundTrend: const <double>[58, 63, 55, 61, 57],
          outboundTrend: const <double>[52, 60, 49, 58, 54],
          ownerBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'VinFast', value: '7,420', percent: 20),
            _BreakdownItem(label: 'THACO', value: '6,230', percent: 17),
            _BreakdownItem(label: 'TH True Milk', value: '5,970', percent: 17),
            _BreakdownItem(label: 'Sabeco', value: '4,810', percent: 13),
            _BreakdownItem(label: 'Khác', value: '20,490', percent: 33),
          ],
          warehouseBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'WH-A', value: '18,170', percent: 40),
            _BreakdownItem(label: 'WH-B', value: '12,650', percent: 28),
            _BreakdownItem(label: 'WH-C', value: '9,240', percent: 21),
            _BreakdownItem(label: 'Transit', value: '4,860', percent: 11),
          ],
          statusBreakdown: const <_BreakdownItem>[
            _BreakdownItem(label: 'Available', value: '30,760', percent: 68),
            _BreakdownItem(label: 'Hold', value: '6,120', percent: 14),
            _BreakdownItem(label: 'Damaged', value: '1,780', percent: 4),
            _BreakdownItem(label: 'In Transit', value: '6,260', percent: 14),
          ],
          anomalies: const <_AnomalyItem>[
            _AnomalyItem(
              title: 'Dữ liệu đang stale',
              detail: 'Lần đồng bộ gần nhất cách đây hơn 15 phút',
              level: AnomalyLevel.warning,
              actionLabel: 'Tải lại',
              route: AppRoutePaths.reports,
            ),
          ],
        ),
        ReportTimeRange.custom: null,
      };

  Future<void> _onSelectRange(ReportTimeRange range) async {
    if (_selectedRange == range) {
      return;
    }

    setState(() {
      _selectedRange = range;
      _isLoading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 320));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 420));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _exportSnapshot() async {
    if (_isExporting) {
      return;
    }

    setState(() {
      _isExporting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 850));

    if (!mounted) {
      return;
    }

    setState(() {
      _isExporting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã tạo snapshot báo cáo (PNG) thành công.'),
      ),
    );
  }

  bool _isStale(DateTime updatedAt) {
    return DateTime.now().difference(updatedAt).inMinutes >= 15;
  }

  String _formatTimestamp(DateTime updatedAt) {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);

    if (diff.inMinutes < 1) {
      return 'vừa xong';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes} phút trước';
    }

    return '${diff.inHours} giờ trước';
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo realtime'),
        actions: [
          IconButton(
            tooltip: 'Bộ lọc nhanh',
            onPressed: _showQuickFilterSheet,
            icon: const Icon(Icons.tune_rounded),
          ),
          IconButton(
            tooltip: 'Export snapshot',
            onPressed: _isExporting ? null : _exportSnapshot,
            icon: _isExporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  )
                : const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const AppLoadingView(message: 'Đang tải dữ liệu báo cáo...')
          : snapshot == null
          ? AppEmptyState(
              title: 'Chưa có dữ liệu cho bộ lọc hiện tại',
              message:
                  'Custom range chưa có snapshot. Thử chọn 24 giờ hoặc 7 ngày để xem số liệu realtime.',
              retryLabel: 'Chọn 24 giờ',
              onRetry: () => _onSelectRange(ReportTimeRange.last24Hours),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.xxl,
                ),
                children: [
                  _ReportsHeaderCard(
                    updatedAtLabel: _formatTimestamp(snapshot.updatedAt),
                    isStale: _isStale(snapshot.updatedAt),
                    alertCount: snapshot.openAlerts,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _TimeRangeSelector(
                    selectedRange: _selectedRange,
                    onSelect: _onSelectRange,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeading(title: 'KPI tổng quan'),
                  const SizedBox(height: AppSpacing.sm),
                  _KpiGrid(snapshot: snapshot),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeading(title: 'Xu hướng xuất / nhập'),
                  const SizedBox(height: AppSpacing.sm),
                  _TrendSection(
                    chartMode: _chartMode,
                    snapshot: snapshot,
                    onModeChanged: (mode) {
                      setState(() {
                        _chartMode = mode;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeading(title: 'Breakdown top 5'),
                  const SizedBox(height: AppSpacing.sm),
                  _BreakdownSection(snapshot: snapshot),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeading(title: 'Bất thường cần xử lý'),
                  const SizedBox(height: AppSpacing.sm),
                  _AnomalySection(items: snapshot.anomalies),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeading(title: 'Drill down nhanh'),
                  const SizedBox(height: AppSpacing.sm),
                  _DrillDownActions(),
                ],
              ),
            ),
    );
  }

  Future<void> _showQuickFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bộ lọc nhanh',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Ưu tiên bộ lọc nhẹ trên mobile để xem KPI nhanh.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _SmallPill(
                      icon: Icons.warehouse_outlined,
                      text: 'Kho: Tất cả',
                    ),
                    _SmallPill(
                      icon: Icons.inventory_2_outlined,
                      text: 'Chủ hàng: Top 5',
                    ),
                    _SmallPill(
                      icon: Icons.warning_amber_rounded,
                      text: 'Chỉ cảnh báo mở',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Đóng'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum ReportTimeRange { today, last24Hours, last7Days, last30Days, custom }

extension _ReportTimeRangeLabel on ReportTimeRange {
  String get label {
    switch (this) {
      case ReportTimeRange.today:
        return 'Hôm nay';
      case ReportTimeRange.last24Hours:
        return '24 giờ';
      case ReportTimeRange.last7Days:
        return '7 ngày';
      case ReportTimeRange.last30Days:
        return '30 ngày';
      case ReportTimeRange.custom:
        return 'Custom';
    }
  }
}

enum ReportChartMode { line, bar }

class _ReportsHeaderCard extends StatelessWidget {
  const _ReportsHeaderCard({
    required this.updatedAtLabel,
    required this.isStale,
    required this.alertCount,
  });

  final String updatedAtLabel;
  final bool isStale;
  final int alertCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giám sát KPI vận hành theo thời gian thực',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Cập nhật: $updatedAtLabel', style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _SmallPill(
                icon: Icons.notifications_active_outlined,
                text: '$alertCount cảnh báo mở',
                tone: alertCount > 8 ? PillTone.warning : PillTone.neutral,
              ),
              _SmallPill(
                icon: isStale ? Icons.warning_rounded : Icons.check_circle,
                text: isStale ? 'Dữ liệu stale' : 'Dữ liệu mới',
                tone: isStale ? PillTone.warning : PillTone.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeRangeSelector extends StatelessWidget {
  const _TimeRangeSelector({
    required this.selectedRange,
    required this.onSelect,
  });

  final ReportTimeRange selectedRange;
  final ValueChanged<ReportTimeRange> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final range in ReportTimeRange.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: ChoiceChip(
                label: Text(range.label),
                selected: range == selectedRange,
                onSelected: (_) => onSelect(range),
              ),
            ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.snapshot});

  final _ReportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final kpis = <_KpiMetric>[
      _KpiMetric(
        title: 'Tổng tồn kho',
        value: _formatNumber(snapshot.totalInventory),
        icon: Icons.inventory_2_outlined,
        tone: PillTone.neutral,
      ),
      _KpiMetric(
        title: 'Nhập hôm nay',
        value: _formatNumber(snapshot.inboundToday),
        icon: Icons.call_received_rounded,
        tone: PillTone.success,
      ),
      _KpiMetric(
        title: 'Xuất hôm nay',
        value: _formatNumber(snapshot.outboundToday),
        icon: Icons.call_made_rounded,
        tone: PillTone.info,
      ),
      _KpiMetric(
        title: 'Tỷ lệ sử dụng',
        value: '${snapshot.utilizationPercent}%',
        icon: Icons.speed_rounded,
        tone: snapshot.utilizationPercent >= 80
            ? PillTone.warning
            : PillTone.neutral,
      ),
      _KpiMetric(
        title: 'Cảnh báo mở',
        value: '${snapshot.openAlerts}',
        icon: Icons.warning_amber_rounded,
        tone: snapshot.openAlerts >= 8 ? PillTone.warning : PillTone.neutral,
      ),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final metric in kpis)
          SizedBox(
            width: (MediaQuery.of(context).size.width - 44) / 2,
            child: _KpiCard(metric: metric),
          ),
      ],
    );
  }

  String _formatNumber(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }
}

class _KpiMetric {
  const _KpiMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String value;
  final IconData icon;
  final PillTone tone;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.metric});

  final _KpiMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SmallPill(icon: metric.icon, text: metric.title, tone: metric.tone),
          const SizedBox(height: AppSpacing.sm),
          Text(
            metric.value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.brand,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendSection extends StatelessWidget {
  const _TrendSection({
    required this.chartMode,
    required this.snapshot,
    required this.onModeChanged,
  });

  final ReportChartMode chartMode;
  final _ReportSnapshot snapshot;
  final ValueChanged<ReportChartMode> onModeChanged;

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
                Text(
                  'Xu hướng trong kỳ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                SegmentedButton<ReportChartMode>(
                  segments: const [
                    ButtonSegment<ReportChartMode>(
                      value: ReportChartMode.line,
                      icon: Icon(Icons.show_chart_rounded),
                    ),
                    ButtonSegment<ReportChartMode>(
                      value: ReportChartMode.bar,
                      icon: Icon(Icons.bar_chart_rounded),
                    ),
                  ],
                  selected: <ReportChartMode>{chartMode},
                  onSelectionChanged: (selection) {
                    onModeChanged(selection.first);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 180,
              child: _TrendChart(
                mode: chartMode,
                inboundTrend: snapshot.inboundTrend,
                outboundTrend: snapshot.outboundTrend,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const _LegendDot(color: AppColors.brand, label: 'Nhập'),
                const SizedBox(width: AppSpacing.md),
                const _LegendDot(color: AppColors.info, label: 'Xuất'),
                const Spacer(),
                Text(
                  snapshot.trendLabels.join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({
    required this.mode,
    required this.inboundTrend,
    required this.outboundTrend,
  });

  final ReportChartMode mode;
  final List<double> inboundTrend;
  final List<double> outboundTrend;

  @override
  Widget build(BuildContext context) {
    if (mode == ReportChartMode.bar) {
      return _BarTrendChart(
        inboundTrend: inboundTrend,
        outboundTrend: outboundTrend,
      );
    }

    return CustomPaint(
      painter: _LineTrendPainter(
        inboundTrend: inboundTrend,
        outboundTrend: outboundTrend,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _BarTrendChart extends StatelessWidget {
  const _BarTrendChart({
    required this.inboundTrend,
    required this.outboundTrend,
  });

  final List<double> inboundTrend;
  final List<double> outboundTrend;

  @override
  Widget build(BuildContext context) {
    final maxValue = <double>[
      ...inboundTrend,
      ...outboundTrend,
    ].reduce(math.max);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < inboundTrend.length; i++) ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: inboundTrend[i] / maxValue,
                    child: Container(
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.brand,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: outboundTrend[i] / maxValue,
                    child: Container(
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.info,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (i != inboundTrend.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _LineTrendPainter extends CustomPainter {
  _LineTrendPainter({required this.inboundTrend, required this.outboundTrend});

  final List<double> inboundTrend;
  final List<double> outboundTrend;

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = <double>[
      ...inboundTrend,
      ...outboundTrend,
    ].reduce(math.max);

    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    final inboundPaint = Paint()
      ..color = AppColors.brand
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke;
    final outboundPaint = Paint()
      ..color = AppColors.info
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke;

    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final inboundPath = Path();
    final outboundPath = Path();

    for (var i = 0; i < inboundTrend.length; i++) {
      final x = inboundTrend.length == 1
          ? 0.0
          : size.width * i / (inboundTrend.length - 1);
      final inboundY =
          size.height - (inboundTrend[i] / maxValue * (size.height - 8));
      final outboundY =
          size.height - (outboundTrend[i] / maxValue * (size.height - 8));

      if (i == 0) {
        inboundPath.moveTo(x, inboundY);
        outboundPath.moveTo(x, outboundY);
      } else {
        inboundPath.lineTo(x, inboundY);
        outboundPath.lineTo(x, outboundY);
      }

      canvas.drawCircle(
        Offset(x, inboundY),
        2.8,
        Paint()..color = AppColors.brand,
      );
      canvas.drawCircle(
        Offset(x, outboundY),
        2.8,
        Paint()..color = AppColors.info,
      );
    }

    canvas.drawPath(inboundPath, inboundPaint);
    canvas.drawPath(outboundPath, outboundPaint);
  }

  @override
  bool shouldRepaint(covariant _LineTrendPainter oldDelegate) {
    return oldDelegate.inboundTrend != inboundTrend ||
        oldDelegate.outboundTrend != outboundTrend;
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _BreakdownSection extends StatelessWidget {
  const _BreakdownSection({required this.snapshot});

  final _ReportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _BreakdownCardData(
        title: 'Theo chủ hàng',
        icon: Icons.inventory_2_outlined,
        items: snapshot.ownerBreakdown,
      ),
      _BreakdownCardData(
        title: 'Theo kho/khu vực',
        icon: Icons.warehouse_outlined,
        items: snapshot.warehouseBreakdown,
      ),
      _BreakdownCardData(
        title: 'Theo trạng thái',
        icon: Icons.pie_chart_outline_rounded,
        items: snapshot.statusBreakdown,
      ),
    ];

    return SizedBox(
      height: 228,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SizedBox(
          width: math.max(MediaQuery.of(context).size.width - 56, 280),
          child: _BreakdownCard(card: cards[index]),
        ),
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemCount: cards.length,
      ),
    );
  }
}

class _BreakdownCardData {
  const _BreakdownCardData({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<_BreakdownItem> items;
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.card});

  final _BreakdownCardData card;

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
                Icon(card.icon, color: AppColors.brand),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  card.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final item in card.items)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      item.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    SizedBox(
                      width: 46,
                      child: Text(
                        '${item.percent}%',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AnomalySection extends StatelessWidget {
  const _AnomalySection({required this.items});

  final List<_AnomalyItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _AnomalyCard(item: items[index]),
          if (index != items.length - 1) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _AnomalyCard extends StatelessWidget {
  const _AnomalyCard({required this.item});

  final _AnomalyItem item;

  @override
  Widget build(BuildContext context) {
    final (icon, tone) = switch (item.level) {
      AnomalyLevel.info => (Icons.info_outline_rounded, PillTone.info),
      AnomalyLevel.warning => (Icons.warning_amber_rounded, PillTone.warning),
      AnomalyLevel.danger => (Icons.error_outline_rounded, PillTone.danger),
    };

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SmallPill(icon: icon, text: item.title, tone: tone),
            const SizedBox(height: AppSpacing.xs),
            Text(item.detail, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => context.go(item.route),
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(item.actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrillDownActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _ActionChipButton(
              icon: Icons.inventory_2_outlined,
              label: 'Tồn kho',
              onTap: () => context.go(AppRoutePaths.inventory),
            ),
            _ActionChipButton(
              icon: Icons.pending_actions_rounded,
              label: 'Hàng chờ',
              onTap: () => context.go(AppRoutePaths.tasks),
            ),
            _ActionChipButton(
              icon: Icons.call_received_rounded,
              label: 'Phiếu nhập',
              onTap: () => context.go(AppRoutePaths.receiptList),
            ),
            _ActionChipButton(
              icon: Icons.call_made_rounded,
              label: 'Phiếu xuất',
              onTap: () => context.go(AppRoutePaths.shipmentList),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: AppColors.brand),
      label: Text(label),
      onPressed: onTap,
      side: const BorderSide(color: AppColors.border),
      backgroundColor: AppColors.surface,
    );
  }
}

enum PillTone { neutral, info, success, warning, danger }

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.icon,
    required this.text,
    this.tone = PillTone.neutral,
  });

  final IconData icon;
  final String text;
  final PillTone tone;

  @override
  Widget build(BuildContext context) {
    final palette = switch (tone) {
      PillTone.neutral => (
        AppColors.brand,
        AppColors.brand.withValues(alpha: 0.1),
      ),
      PillTone.info => (AppColors.info, AppColors.info.withValues(alpha: 0.12)),
      PillTone.success => (
        AppColors.success,
        AppColors.success.withValues(alpha: 0.12),
      ),
      PillTone.warning => (
        AppColors.warning,
        AppColors.warning.withValues(alpha: 0.16),
      ),
      PillTone.danger => (
        AppColors.danger,
        AppColors.danger.withValues(alpha: 0.12),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: palette.$2,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: palette.$1),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: palette.$1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        letterSpacing: 1.1,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ReportSnapshot {
  const _ReportSnapshot({
    required this.updatedAt,
    required this.totalInventory,
    required this.inboundToday,
    required this.outboundToday,
    required this.utilizationPercent,
    required this.openAlerts,
    required this.trendLabels,
    required this.inboundTrend,
    required this.outboundTrend,
    required this.ownerBreakdown,
    required this.warehouseBreakdown,
    required this.statusBreakdown,
    required this.anomalies,
  });

  final DateTime updatedAt;
  final int totalInventory;
  final int inboundToday;
  final int outboundToday;
  final int utilizationPercent;
  final int openAlerts;
  final List<String> trendLabels;
  final List<double> inboundTrend;
  final List<double> outboundTrend;
  final List<_BreakdownItem> ownerBreakdown;
  final List<_BreakdownItem> warehouseBreakdown;
  final List<_BreakdownItem> statusBreakdown;
  final List<_AnomalyItem> anomalies;
}

class _BreakdownItem {
  const _BreakdownItem({
    required this.label,
    required this.value,
    required this.percent,
  });

  final String label;
  final String value;
  final int percent;
}

enum AnomalyLevel { info, warning, danger }

class _AnomalyItem {
  const _AnomalyItem({
    required this.title,
    required this.detail,
    required this.level,
    required this.actionLabel,
    required this.route,
  });

  final String title;
  final String detail;
  final AnomalyLevel level;
  final String actionLabel;
  final String route;
}
