import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.title = 'Không có dữ liệu',
    this.message = 'Thử đổi bộ lọc hoặc tải lại dữ liệu.',
    this.onRetry,
    this.retryLabel = 'Tải lại',
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inbox_outlined,
                  size: 40,
                  color: AppColors.info,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  OutlinedButton(
                    onPressed: onRetry,
                    child: Text(retryLabel),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
