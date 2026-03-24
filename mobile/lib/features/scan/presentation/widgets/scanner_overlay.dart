import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IgnorePointer(
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 252,
              height: 252,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.surface.withValues(alpha: 0.72),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Stack(
                children: const [
                  _CornerMarker(alignment: Alignment.topLeft),
                  _CornerMarker(alignment: Alignment.topRight),
                  _CornerMarker(alignment: Alignment.bottomLeft),
                  _CornerMarker(alignment: Alignment.bottomRight),
                ],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.44),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.surface.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.surface.withValues(alpha: 0.86),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  const _CornerMarker({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Stack(
            children: [
              Align(
                alignment: isTop
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                child: Container(
                  height: 4,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Align(
                alignment: isLeft
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: 4,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
