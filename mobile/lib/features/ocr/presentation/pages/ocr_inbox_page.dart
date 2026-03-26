import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/ocr/application/controllers/ocr_inbox_controller.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class OcrInboxPage extends ConsumerStatefulWidget {
  const OcrInboxPage({super.key});

  @override
  ConsumerState<OcrInboxPage> createState() => _OcrInboxPageState();
}

class _OcrInboxPageState extends ConsumerState<OcrInboxPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref
        .read(ocrInboxControllerProvider.notifier)
        .setSearchQuery(_searchController.text);
  }

  void _syncSearchField(OcrInboxState state) {
    if (_searchController.text == state.searchQuery) {
      return;
    }

    _searchController.removeListener(_onSearchChanged);
    _searchController.value = TextEditingValue(
      text: state.searchQuery,
      selection: TextSelection.collapsed(offset: state.searchQuery.length),
    );
    _searchController.addListener(_onSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(ocrInboxControllerProvider);
    final currentState = asyncState.valueOrNull;

    if (asyncState.isLoading && currentState == null) {
      return const AppLoadingView(message: 'Đang tải OCR inbox...');
    }

    if (asyncState.hasError && currentState == null) {
      return AppErrorState(
        title: 'Không tải được OCR inbox',
        message: '${asyncState.error}',
        onRetry: () {
          ref.read(ocrInboxControllerProvider.notifier).refresh();
        },
      );
    }

    if (currentState == null) {
      return const AppLoadingView(message: 'Đang khởi tạo OCR inbox...');
    }

    _syncSearchField(currentState);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('ocr_inbox_back_button'),
          tooltip: 'Quay lại',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutePaths.more);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('OCR inbox'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: () {
              ref.read(ocrInboxControllerProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Chụp chứng từ',
            onPressed: () => context.push(AppRoutePaths.ocrCapture),
            icon: const Icon(Icons.camera_alt_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(ocrInboxControllerProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pagePadding,
          children: [
            _SummaryCard(state: currentState),
            const SizedBox(height: AppSpacing.lg),
            _SearchBar(controller: _searchController),
            const SizedBox(height: AppSpacing.md),
            _DirectionFilterBar(state: currentState),
            const SizedBox(height: AppSpacing.sm),
            _StatusFilterBar(state: currentState),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách cần xử lý',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (currentState.hasActiveFilters)
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(ocrInboxControllerProvider.notifier)
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
                  title: 'Không có bản OCR phù hợp',
                  message: currentState.hasActiveFilters
                      ? 'Thử đổi filter trạng thái hoặc hướng chứng từ.'
                      : 'Chưa có chứng từ OCR mới trong ca hiện tại.',
                  retryLabel: currentState.hasActiveFilters
                      ? 'Xóa bộ lọc'
                      : 'Chụp chứng từ',
                  onRetry: currentState.hasActiveFilters
                      ? () {
                          ref
                              .read(ocrInboxControllerProvider.notifier)
                              .clearFilters();
                        }
                      : () {
                          context.push(AppRoutePaths.ocrCapture);
                        },
                ),
              )
            else
              for (
                var index = 0;
                index < currentState.visibleItems.length;
                index++
              ) ...[
                _OcrRecordCard(record: currentState.visibleItems[index]),
                if (index < currentState.visibleItems.length - 1)
                  const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutePaths.ocrCapture),
        icon: const Icon(Icons.document_scanner_outlined),
        label: const Text('Chụp OCR'),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});

  final OcrInboxState state;

  @override
  Widget build(BuildContext context) {
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
          Text(
            'OCR cần xem xét',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '${state.countForStatus(OcrRecordStatus.reviewRequired)}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _SummaryPill(
                label: 'Đã trích xuất',
                value: '${state.countForStatus(OcrRecordStatus.extracted)}',
              ),
              _SummaryPill(
                label: 'Đã liên kết',
                value: '${state.countForStatus(OcrRecordStatus.linked)}',
              ),
              _SummaryPill(
                label: 'Lỗi OCR',
                value: '${state.countForStatus(OcrRecordStatus.failed)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.18),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Tìm số phiếu, biển số, SKU...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.trim().isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }
}

class _DirectionFilterBar extends ConsumerWidget {
  const _DirectionFilterBar({required this.state});

  final OcrInboxState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(ocrInboxControllerProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Tất cả'),
            selected: state.directionFilter == null,
            onSelected: (_) => controller.setDirectionFilter(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          ChoiceChip(
            label: const Text('Nhập'),
            selected: state.directionFilter == DocumentDirection.inbound,
            onSelected: (_) {
              controller.setDirectionFilter(DocumentDirection.inbound);
            },
          ),
          const SizedBox(width: AppSpacing.xs),
          ChoiceChip(
            label: const Text('Xuất'),
            selected: state.directionFilter == DocumentDirection.outbound,
            onSelected: (_) {
              controller.setDirectionFilter(DocumentDirection.outbound);
            },
          ),
        ],
      ),
    );
  }
}

class _StatusFilterBar extends ConsumerWidget {
  const _StatusFilterBar({required this.state});

  final OcrInboxState state;

  static const List<OcrRecordStatus> _statusOptions = <OcrRecordStatus>[
    OcrRecordStatus.reviewRequired,
    OcrRecordStatus.extracted,
    OcrRecordStatus.confirmed,
    OcrRecordStatus.linked,
    OcrRecordStatus.failed,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(ocrInboxControllerProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Mọi trạng thái'),
            selected: state.statusFilter == null,
            onSelected: (_) => controller.setStatusFilter(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          for (final status in _statusOptions) ...[
            ChoiceChip(
              label: Text(_statusLabel(status)),
              selected: state.statusFilter == status,
              onSelected: (_) => controller.setStatusFilter(status),
            ),
            if (status != _statusOptions.last)
              const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _OcrRecordCard extends StatelessWidget {
  const _OcrRecordCard({required this.record});

  final OcrRecordEntity record;

  static final DateFormat _dateTimeFormat = DateFormat('dd/MM HH:mm');

  @override
  Widget build(BuildContext context) {
    final extracted = record.extractedFields;
    final title = extracted.documentNo?.trim().isNotEmpty == true
        ? extracted.documentNo!
        : 'Chưa có số phiếu';
    final subtitle = <String>[
      'Scan: ${_dateTimeFormat.format(record.capturedAt)}',
      extracted.vehiclePlate?.trim().isNotEmpty == true
          ? extracted.vehiclePlate!
          : 'Biển số chưa rõ',
      extracted.itemCode?.trim().isNotEmpty == true
          ? extracted.itemCode!
          : 'SKU chưa rõ',
    ].join(' · ');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(AppRoutePaths.ocrReviewPath(record.id)),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _confidenceColor(
                        record.confidenceLevel,
                      ).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.document_scanner_outlined,
                      color: _confidenceColor(record.confidenceLevel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _StatusChip(status: record.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _MetaPill(
                    icon: Icons.swap_horiz_rounded,
                    text: record.direction == DocumentDirection.inbound
                        ? 'Nhập'
                        : 'Xuất',
                  ),
                  _MetaPill(
                    icon: Icons.verified_outlined,
                    text:
                        'Confidence ${(record.confidenceScore * 100).toStringAsFixed(0)}%',
                  ),
                  if (record.linkedTargetNo != null)
                    _MetaPill(
                      icon: Icons.link_rounded,
                      text: 'Đã link ${record.linkedTargetNo}',
                    ),
                ],
              ),
              if (record.errorMessage?.trim().isNotEmpty == true) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  record.errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _confidenceColor(ConfidenceLevel level) {
    return switch (level) {
      ConfidenceLevel.high => AppColors.success,
      ConfidenceLevel.medium => AppColors.warning,
      ConfidenceLevel.low => AppColors.danger,
    };
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

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
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OcrRecordStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      OcrRecordStatus.reviewRequired => AppColors.warning,
      OcrRecordStatus.failed => AppColors.danger,
      OcrRecordStatus.linked => AppColors.success,
      OcrRecordStatus.confirmed => AppColors.info,
      OcrRecordStatus.rejected => AppColors.textSecondary,
      OcrRecordStatus.processing => AppColors.info,
      OcrRecordStatus.extracted => AppColors.info,
      OcrRecordStatus.captured => AppColors.info,
      OcrRecordStatus.relinkRequired => AppColors.warning,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _statusLabel(OcrRecordStatus status) {
  return switch (status) {
    OcrRecordStatus.captured => 'Đã chụp',
    OcrRecordStatus.processing => 'Đang xử lý',
    OcrRecordStatus.extracted => 'Đã trích xuất',
    OcrRecordStatus.reviewRequired => 'Cần xem xét',
    OcrRecordStatus.confirmed => 'Đã xác nhận',
    OcrRecordStatus.linked => 'Đã liên kết',
    OcrRecordStatus.failed => 'OCR thất bại',
    OcrRecordStatus.rejected => 'Đã từ chối',
    OcrRecordStatus.relinkRequired => 'Cần liên kết lại',
  };
}
