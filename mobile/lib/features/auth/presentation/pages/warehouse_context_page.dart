import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/application/services/auth_security_service.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class WarehouseContextPage extends ConsumerStatefulWidget {
  const WarehouseContextPage({super.key});

  @override
  ConsumerState<WarehouseContextPage> createState() =>
      _WarehouseContextPageState();
}

class _WarehouseContextPageState extends ConsumerState<WarehouseContextPage> {
  String? _selectedWarehouseId;
  String _submitError = '';
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(authMeProvider);

    if (profileState.isLoading) {
      return const Scaffold(
        body: AppLoadingView(message: 'Đang tải danh sách kho khả dụng...'),
      );
    }

    if (profileState.hasError) {
      return Scaffold(
        body: AppErrorState(
          title: 'Không thể tải hồ sơ người dùng',
          message: '${profileState.error}',
          onRetry: () {
            ref.invalidate(authMeProvider);
          },
        ),
      );
    }

    final profile = profileState.valueOrNull;
    if (profile == null) {
      return const Scaffold(
        body: AppErrorState(
          title: 'Không tìm thấy hồ sơ đăng nhập',
          message: 'Vui lòng thử đăng nhập lại để chọn kho làm việc.',
        ),
      );
    }

    final options = profile.warehouseOptions;
    if (options.isEmpty) {
      return const Scaffold(
        body: AppErrorState(
          title: 'Không có kho khả dụng',
          message:
              'Tài khoản của bạn chưa được cấp kho làm việc. Vui lòng liên hệ quản trị hệ thống.',
        ),
      );
    }

    _selectedWarehouseId = _normalizeSelectedWarehouseId(
      profile: profile,
      fallbackWarehouseId: options.first.id,
      previousSelection: _selectedWarehouseId,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn kho làm việc')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          Text(
            'Chọn kho để bắt đầu phiên làm việc. Mọi thao tác nhập, xuất, quét sẽ chạy theo kho này.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          ...options.map((option) {
            final selected = option.id == _selectedWarehouseId;

            return ListTile(
              key: Key('warehouse_context_option_${option.id}'),
              enabled: !_isSubmitting,
              leading: Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              title: Text(option.name),
              subtitle: Text(option.code),
              onTap: _isSubmitting
                  ? null
                  : () {
                      setState(() {
                        _selectedWarehouseId = option.id;
                        _submitError = '';
                      });
                    },
            );
          }),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            key: const Key('warehouse_context_submit_button'),
            onPressed: _isSubmitting
                ? null
                : () async {
                    final selectedWarehouseId = _selectedWarehouseId;
                    if (selectedWarehouseId == null ||
                        selectedWarehouseId.trim().isEmpty) {
                      setState(() {
                        _submitError = 'Vui lòng chọn kho trước khi tiếp tục.';
                      });
                      return;
                    }

                    final selectedOption = options.firstWhere(
                      (option) => option.id == selectedWarehouseId,
                    );

                    setState(() {
                      _isSubmitting = true;
                      _submitError = '';
                    });

                    try {
                      await ref
                          .read(authSecurityServiceProvider)
                          .selectWarehouse(
                            warehouseId: selectedOption.id,
                            warehouseName: selectedOption.name,
                          );
                      await ref
                          .read(authControllerProvider.notifier)
                          .restoreSession();
                      ref.invalidate(authMeProvider);
                    } catch (error) {
                      setState(() {
                        _submitError = '$error';
                        _isSubmitting = false;
                      });
                    }
                  },
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: Text(
              _isSubmitting ? 'Đang cập nhật...' : 'Bắt đầu làm việc',
            ),
          ),
          if (_submitError.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _submitError,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  String _normalizeSelectedWarehouseId({
    required AuthProfileDto profile,
    required String fallbackWarehouseId,
    required String? previousSelection,
  }) {
    final selectedFromProfile = profile.selectedWarehouseId?.trim();
    if (selectedFromProfile != null && selectedFromProfile.isNotEmpty) {
      for (final option in profile.warehouseOptions) {
        if (option.id == selectedFromProfile) {
          return option.id;
        }
      }
    }

    if (previousSelection != null && previousSelection.trim().isNotEmpty) {
      for (final option in profile.warehouseOptions) {
        if (option.id == previousSelection) {
          return option.id;
        }
      }
    }

    return fallbackWarehouseId;
  }
}
