import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class InventoryControlPage extends StatelessWidget {
  const InventoryControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('inventory_control_back_button'),
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
        title: const Text('Kiểm kê & chuyển vị trí'),
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          _HeaderCard(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Chọn loại tác vụ',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionCard(
            title: 'Kiểm kê',
            description: 'Đếm thực tế và đối soát chênh lệch tồn kho.',
            icon: Icons.fact_check_outlined,
            color: AppColors.info,
            onTap: () =>
                context.push(AppRoutePaths.inventoryControlFlowPath('count')),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionCard(
            title: 'Chuyển vị trí',
            description: 'Chuyển SKU từ vị trí nguồn sang vị trí đích.',
            icon: Icons.swap_horiz_rounded,
            color: AppColors.brand,
            onTap: () =>
                context.push(AppRoutePaths.inventoryControlFlowPath('move')),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionCard(
            title: 'Đổi trạng thái',
            description: 'Đổi trạng thái hàng từ hold/available/damaged.',
            icon: Icons.autorenew_rounded,
            color: AppColors.warning,
            onTap: () =>
                context.push(AppRoutePaths.inventoryControlFlowPath('status')),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActionCard(
            title: 'Điều chỉnh',
            description: 'Điều chỉnh số lượng theo mã lý do chuẩn.',
            icon: Icons.tune_rounded,
            color: AppColors.danger,
            onTap: () =>
                context.push(AppRoutePaths.inventoryControlFlowPath('adjust')),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Giao dịch gần đây',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          const _RecentTransactionCard(
            transactionNo: 'IC-20260326-0114',
            action: 'Chuyển vị trí',
            itemCode: 'SKU-COIL-01',
            detail: 'A1-01-02 → B2-03-01',
            status: 'Sync pending',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _RecentTransactionCard(
            transactionNo: 'IC-20260326-0109',
            action: 'Kiểm kê',
            itemCode: 'SKU-MILK-12',
            detail: 'Tồn hệ thống 120 · Đếm 118',
            status: 'Đã đồng bộ',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _RecentTransactionCard(
            transactionNo: 'IC-20260326-0105',
            action: 'Đổi trạng thái',
            itemCode: 'SKU-BEER-24',
            detail: 'Available → Hold',
            status: 'Đã đồng bộ',
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
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
            'Tác vụ hiện trường',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '8 tác vụ cần xử lý',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Bắt đầu một flow stepper để kiểm kê, chuyển vị trí hoặc điều chỉnh tồn kho ngay tại hiện trường.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.surface.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactionCard extends StatelessWidget {
  const _RecentTransactionCard({
    required this.transactionNo,
    required this.action,
    required this.itemCode,
    required this.detail,
    required this.status,
  });

  final String transactionNo;
  final String action;
  final String itemCode;
  final String detail;
  final String status;

  @override
  Widget build(BuildContext context) {
    final statusColor = status.contains('pending')
        ? AppColors.warning
        : AppColors.success;

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
                    transactionNo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
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
                    status,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$action · $itemCode',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(detail, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
