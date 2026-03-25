import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

Future<void> showScanActionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return _ScanActionSheet(
        onBarcodeTap: () {
          Navigator.of(sheetContext).pop();
          context.push(
            Uri(
              path: AppRoutePaths.scanBarcode,
              queryParameters: <String, String>{'mode': ScanMode.receive.name},
            ).toString(),
          );
        },
        onOcrTap: () {
          Navigator.of(sheetContext).pop();
          context.push(AppRoutePaths.ocrCapture);
        },
        onManualTap: () {
          Navigator.of(sheetContext).pop();
          context.push(AppRoutePaths.scanManual);
        },
      );
    },
  );
}

class _ScanActionSheet extends StatelessWidget {
  const _ScanActionSheet({
    required this.onBarcodeTap,
    required this.onOcrTap,
    required this.onManualTap,
  });

  final VoidCallback onBarcodeTap;
  final VoidCallback onOcrTap;
  final VoidCallback onManualTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Quét nhanh',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Chọn luồng cần xử lý ngay từ FAB scan.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ActionTile(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Barcode / QR',
              description:
                  'Mở quick scan receive va tra ve ket qua sau khi submit.',
              onTap: onBarcodeTap,
            ),
            const SizedBox(height: AppSpacing.sm),
            _ActionTile(
              icon: Icons.document_scanner_outlined,
              title: 'OCR chụp chứng từ',
              description: 'Chuyển sang dòng chụp và xử lý OCR.',
              onTap: onOcrTap,
            ),
            const SizedBox(height: AppSpacing.sm),
            _ActionTile(
              icon: Icons.keyboard_alt_outlined,
              title: 'Nhập thủ công',
              description: 'Nhập SKU, vị trí hoặc mã tham chiếu bằng tay.',
              onTap: onManualTap,
            ),
            if (bottomInset > 0) SizedBox(height: bottomInset),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.brand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.brand),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
