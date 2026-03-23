import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class AppForbiddenState extends StatelessWidget {
  const AppForbiddenState({
    super.key,
    this.title = 'Bạn không có quyền truy cập',
    this.message = 'Liên hệ quản trị viên nếu bạn cần quyền cho tác vụ này.',
    this.onRetry,
    this.retryLabel = 'Thử lại',
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
                  Icons.lock_outline_rounded,
                  size: 40,
                  color: AppColors.warning,
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
