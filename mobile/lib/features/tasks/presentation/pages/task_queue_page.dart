import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/features/tasks/application/controllers/task_queue_controller.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/presentation/widgets/task_card.dart';
import 'package:smartlog_swm_mobile/features/tasks/presentation/widgets/task_filter_bar.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class TaskQueuePage extends ConsumerStatefulWidget {
  const TaskQueuePage({super.key, this.queueType});

  final String? queueType;

  @override
  ConsumerState<TaskQueuePage> createState() => _TaskQueuePageState();
}

class _TaskQueuePageState extends ConsumerState<TaskQueuePage> {
  String? _appliedQueueType;

  @override
  void didUpdateWidget(covariant TaskQueuePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.queueType != widget.queueType) {
      _appliedQueueType = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shellState = ref.watch(appShellControllerProvider);
    final taskQueueState = ref.watch(taskQueueControllerProvider);
    final currentState = taskQueueState.valueOrNull;

    _applyInitialFilter(currentState);

    if (taskQueueState.isLoading && currentState == null) {
      return const AppLoadingView(message: 'Đang tải hàng chờ xử lý...');
    }

    if (taskQueueState.hasError && currentState == null) {
      return AppErrorState(
        title: 'Không tải được hàng chờ xử lý',
        message: '${taskQueueState.error}',
        onRetry: () {
          ref.read(taskQueueControllerProvider.notifier).refresh();
        },
      );
    }

    if (currentState == null) {
      return const AppLoadingView(message: 'Đang khởi tạo task queue...');
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(taskQueueControllerProvider.notifier).refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.pagePadding,
        children: [
          _HeaderCard(
            shellState: shellState,
            state: currentState,
            queueTypeLabel: _formatQueueType(widget.queueType),
          ),
          const SizedBox(height: AppSpacing.lg),
          TaskFilterBar(
            state: currentState,
            onSeveritySelected: (severity) {
              ref
                  .read(taskQueueControllerProvider.notifier)
                  .setSeverityFilter(severity);
            },
            onTypeSelected: (type) {
              ref
                  .read(taskQueueControllerProvider.notifier)
                  .setTypeFilter(type);
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
                  key: const Key('task_filter_clear_button'),
                  onPressed: () {
                    ref
                        .read(taskQueueControllerProvider.notifier)
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
                title: 'Không có task phù hợp',
                message: currentState.hasActiveFilters
                    ? 'Thử đổi bộ lọc để xem lại toàn bộ hàng chờ.'
                    : 'Chưa có task nào đang mở trong ca hiện tại.',
                onRetry: currentState.hasActiveFilters
                    ? () {
                        ref
                            .read(taskQueueControllerProvider.notifier)
                            .clearFilters();
                      }
                    : () {
                        ref
                            .read(taskQueueControllerProvider.notifier)
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
              TaskCard(
                item: currentState.visibleItems[index],
                onPrimaryAction:
                    _resolvePrimaryLocation(
                          context,
                          currentState.visibleItems[index],
                        ) ==
                        null
                    ? null
                    : () => _openPrimaryAction(
                        context,
                        currentState.visibleItems[index],
                      ),
                onMorePressed: () => _showQuickActions(
                  context,
                  currentState.visibleItems[index],
                ),
              ),
              if (index < currentState.visibleItems.length - 1)
                const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }

  void _applyInitialFilter(TaskQueueState? currentState) {
    final queueType = widget.queueType;
    if (queueType == null ||
        currentState == null ||
        _appliedQueueType == queueType) {
      return;
    }

    final type = _parseQueueType(queueType);
    _appliedQueueType = queueType;

    if (type == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(taskQueueControllerProvider.notifier).setTypeFilter(type);
    });
  }

  void _openPrimaryAction(BuildContext context, TaskItemEntity item) {
    final location = _resolvePrimaryLocation(context, item);
    if (location == null) {
      return;
    }

    context.go(location);
  }

  void _showQuickActions(BuildContext context, TaskItemEntity item) {
    final primaryLocation = _resolvePrimaryLocation(context, item);
    final hasQuickActions =
        item.secondaryActions.isNotEmpty || primaryLocation != null;

    if (!hasQuickActions) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);

        return SafeArea(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Quick actions cho task đang được ưu tiên.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (primaryLocation != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(_actionIcon(item.primaryAction.type)),
                    title: Text(item.primaryAction.label),
                    subtitle: const Text('Mở flow chi tiết'),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      context.go(primaryLocation);
                    },
                  ),
                for (final action in item.secondaryActions)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(_actionIcon(action.type)),
                    title: Text(action.label),
                    subtitle: Text(_secondaryActionSubtitle(action.type)),
                    onTap: action.enabled
                        ? () {
                            Navigator.of(sheetContext).pop();
                            _handleSecondaryAction(context, item, action);
                          }
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSecondaryAction(
    BuildContext context,
    TaskItemEntity item,
    ActionCapability action,
  ) {
    final location = _resolveLocation(
      context,
      routeName: action.routeName,
      routeParams: action.routeParams,
    );

    if (location != null) {
      context.go(location);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã ghi nhận thao tác "${action.label}" cho task ${item.sourceEntityNo ?? item.id}.',
        ),
      ),
    );
  }

  String? _resolvePrimaryLocation(BuildContext context, TaskItemEntity item) {
    return _resolveLocation(
      context,
      routeName: item.primaryAction.routeName ?? item.routeName,
      routeParams: item.primaryAction.routeParams ?? item.routeParams,
    );
  }

  String? _resolveLocation(
    BuildContext context, {
    String? routeName,
    Map<String, String>? routeParams,
  }) {
    return resolveNamedRouteLocation(
      router: GoRouter.of(context),
      routeName: routeName,
      pathParameters: routeParams,
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.shellState,
    required this.state,
    required this.queueTypeLabel,
  });

  final AppShellState shellState;
  final TaskQueueState state;
  final String? queueTypeLabel;

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
          Text(
            'Hàng chờ xử lý',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${shellState.currentSite.label} · ${shellState.currentRole.label}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.surface.withValues(alpha: 0.84),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  key: const Key('task_queue_header_total'),
                  label: 'Đang mở',
                  value: '${state.pendingTaskCount}',
                  accentColor: AppColors.surface,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetricTile(
                  key: const Key('task_queue_header_critical'),
                  label: 'Nghiêm trọng',
                  value: '${state.criticalTaskCount}',
                  accentColor: const Color(0xFFFFD6D5),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _HeaderPill(label: '${state.pendingTaskCount} task mở'),
              _HeaderPill(label: '${state.criticalTaskCount} cần xử lý ngay'),
              if (queueTypeLabel != null) _HeaderPill(label: queueTypeLabel!),
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
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

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
              color: accentColor,
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

TaskItemType? _parseQueueType(String? queueType) {
  if (queueType == null || queueType.trim().isEmpty) {
    return null;
  }

  switch (queueType.trim()) {
    case 'weighing':
      return TaskItemType.receipt;
    case 'receipt':
      return TaskItemType.receipt;
    case 'shipment':
      return TaskItemType.shipment;
    case 'ocr':
      return TaskItemType.ocr;
    case 'inventory':
      return TaskItemType.inventory;
    case 'ai':
    case 'ai_suggestion':
    case 'aiSuggestion':
      return TaskItemType.aiSuggestion;
    case 'system':
    case 'system_alert':
    case 'systemAlert':
      return TaskItemType.systemAlert;
    default:
      return null;
  }
}

String? _formatQueueType(String? queueType) {
  if (queueType == null || queueType.trim().isEmpty) {
    return null;
  }

  switch (queueType.trim()) {
    case 'weighing':
      return 'Luồng mặc định: Cân hàng';
    case 'receipt':
      return 'Luồng mặc định: Phiếu nhập';
    case 'shipment':
      return 'Luồng mặc định: Phiếu xuất';
    case 'ocr':
      return 'Luồng mặc định: OCR';
    case 'inventory':
      return 'Luồng mặc định: Tồn kho';
    case 'ai':
    case 'ai_suggestion':
    case 'aiSuggestion':
      return 'Luồng mặc định: AI đề xuất';
    case 'system':
    case 'system_alert':
    case 'systemAlert':
      return 'Luồng mặc định: Cảnh báo hệ thống';
    default:
      return 'Bộ lọc: $queueType';
  }
}

String _secondaryActionSubtitle(TaskActionType actionType) {
  return switch (actionType) {
    TaskActionType.open => 'Mở nhanh chi tiết task',
    TaskActionType.approve => 'Chấp nhận đề xuất và tiếp tục',
    TaskActionType.dismiss => 'Bỏ qua task trong ca hiện tại',
    TaskActionType.acknowledge => 'Đánh dấu đã đọc cảnh báo',
    TaskActionType.startWeighing => 'Nhảy vào flow cân hàng',
    TaskActionType.startPicking => 'Nhảy vào flow soạn hàng',
    TaskActionType.reviewOcr => 'Mở inbox OCR cần review',
    TaskActionType.viewInventory => 'Mở chi tiết tồn kho',
    TaskActionType.custom => 'Thao tác tùy biến theo task',
  };
}

IconData _actionIcon(TaskActionType actionType) {
  return switch (actionType) {
    TaskActionType.open => Icons.open_in_new_rounded,
    TaskActionType.approve => Icons.check_circle_outline_rounded,
    TaskActionType.dismiss => Icons.do_not_disturb_alt_rounded,
    TaskActionType.acknowledge => Icons.mark_email_read_outlined,
    TaskActionType.startWeighing => Icons.scale_rounded,
    TaskActionType.startPicking => Icons.play_arrow_rounded,
    TaskActionType.reviewOcr => Icons.fact_check_outlined,
    TaskActionType.viewInventory => Icons.inventory_2_outlined,
    TaskActionType.custom => Icons.bolt_rounded,
  };
}
