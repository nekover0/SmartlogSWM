import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ScanActionSelector extends StatelessWidget {
  const ScanActionSelector({
    super.key,
    required this.selectedMode,
    required this.supportedModes,
    this.onSelected,
  });

  final ScanMode selectedMode;
  final Set<ScanMode> supportedModes;
  final ValueChanged<ScanMode>? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tac vu quet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Task 18 chi mo happy path cho nhap kho, cac luong khac de mo sau.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: ScanMode.values
                  .map((mode) {
                    final isSupported = supportedModes.contains(mode);
                    final isSelected = mode == selectedMode;

                    return ChoiceChip(
                      key: Key('scan_action_selector_${mode.name}'),
                      selected: isSelected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_modeLabel(mode)),
                          if (!isSupported) ...[
                            const SizedBox(width: AppSpacing.xs),
                            const Icon(Icons.lock_outline_rounded, size: 16),
                          ],
                        ],
                      ),
                      onSelected: isSupported && onSelected != null
                          ? (_) => onSelected!(mode)
                          : null,
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.brand.withValues(alpha: 0.06),
                borderRadius: AppSpacing.controlRadius,
                border: Border.all(
                  color: AppColors.brand.withValues(alpha: 0.12),
                ),
              ),
              child: Text(
                _modeDescription(selectedMode),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _modeLabel(ScanMode mode) {
  return switch (mode) {
    ScanMode.receive => 'Nhap kho',
    ScanMode.issue => 'Xuat kho',
    ScanMode.count => 'Kiem ke',
    ScanMode.move => 'Chuyen vi tri',
  };
}

String _modeDescription(ScanMode mode) {
  return switch (mode) {
    ScanMode.receive =>
      'Quet barcode, doi chieu API receive va mo form xac nhan nhap kho.',
    ScanMode.issue => 'Flow xuat kho chua duoc mo trong phien ban hien tai.',
    ScanMode.count => 'Flow kiem ke se duoc bat trong task tiep theo.',
    ScanMode.move => 'Flow chuyen vi tri se duoc bat trong task tiep theo.',
  };
}
