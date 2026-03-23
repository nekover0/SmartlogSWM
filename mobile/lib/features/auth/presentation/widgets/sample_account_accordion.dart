import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class SampleAccountAccordion extends ConsumerWidget {
  const SampleAccountAccordion({super.key, this.onSelectAccount});

  final ValueChanged<AuthSampleAccount>? onSelectAccount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsState = ref.watch(authSampleAccountsProvider);
    final theme = Theme.of(context);

    return Card(
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: const Key('sample_accounts_accordion'),
          tilePadding: AppSpacing.cardPadding,
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.badge_outlined, color: AppColors.brand),
          ),
          title: Text('Tài khoản mẫu', style: theme.textTheme.titleMedium),
          subtitle: Text(
            'Dùng nhanh để kiểm tra các role chính.',
            style: theme.textTheme.bodySmall,
          ),
          children: [
            accountsState.when(
              data: (List<AuthSampleAccount> accounts) {
                return Column(
                  children: accounts
                      .map(
                        (AuthSampleAccount account) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _SampleAccountTile(
                            account: account,
                            onPressed: onSelectAccount == null
                                ? null
                                : () => onSelectAccount!(account),
                          ),
                        ),
                      )
                      .toList(growable: false),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  ),
                ),
              ),
              error: (Object error, StackTrace stackTrace) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Không thể tải tài khoản mẫu: $error',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleAccountTile extends StatelessWidget {
  const _SampleAccountTile({required this.account, required this.onPressed});

  final AuthSampleAccount account;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppSpacing.controlRadius,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.displayName, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${account.role} · ${account.siteName}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _AccountPill(label: account.username),
                    _AccountPill(label: account.password),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          OutlinedButton(onPressed: onPressed, child: const Text('Dùng')),
        ],
      ),
    );
  }
}

class _AccountPill extends StatelessWidget {
  const _AccountPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
