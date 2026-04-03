import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class PostLoginBootstrapPage extends ConsumerStatefulWidget {
  const PostLoginBootstrapPage({super.key});

  @override
  ConsumerState<PostLoginBootstrapPage> createState() =>
      _PostLoginBootstrapPageState();
}

class _PostLoginBootstrapPageState
    extends ConsumerState<PostLoginBootstrapPage> {
  late final Timer _minDisplayTimer;
  bool _minDisplayElapsed = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _minDisplayTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _minDisplayElapsed = true;
      });
    });
  }

  @override
  void dispose() {
    _minDisplayTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final session = authState.valueOrNull;

    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final meState = ref.watch(authMeProvider);
    final permissionsState = ref.watch(authPermissionsSnapshotProvider);

    final resolvedDisplayName = _resolveDisplayName(
      fallbackDisplayName: session.currentUser.displayName,
      profileDisplayName: meState.valueOrNull?.fullName,
    );
    final resolvedUsername = _resolveUsername(
      fallbackUsername: session.currentUser.username,
      profileUsername: meState.valueOrNull?.username,
    );
    final roleLabel = RoleGuard.canonicalRoleLabel(session.currentUser.role);
    final landingPath = RoleGuard.defaultLandingPathForRoleName(
      session.currentUser.role,
    );
    final warehouseLabel = _resolveWarehouseLabel(
      session: session,
      profile: meState.valueOrNull,
    );

    final totalModules = AppModule.values.length;
    final accessibleModules = AppModule.values.where((AppModule module) {
      return RoleGuard.canAccessModule(
        roleName: session.currentUser.role,
        module: module,
      );
    }).length;

    final permissionsCount = permissionsState.valueOrNull?.permissions.length;

    final meStatus = _statusFromAsync(meState);
    final permissionsStatus = _statusFromAsync(permissionsState);
    final moduleStatus = switch (permissionsStatus) {
      _RowStatus.loading => _RowStatus.loading,
      _RowStatus.success => _RowStatus.success,
      _RowStatus.failed => _RowStatus.failed,
    };
    final settled = !meState.isLoading && !permissionsState.isLoading;
    final routeStatus = settled && _minDisplayElapsed
        ? _RowStatus.success
        : _RowStatus.loading;

    final steps = <_BootstrapStepItem>[
      _BootstrapStepItem(
        title: 'Phiên đăng nhập',
        description:
            'Đã xác thực phiên ${_shortSessionId(session.sessionId)} (${session.tokenType ?? 'Bearer'})',
        status: _RowStatus.success,
        source: 'Local Session',
      ),
      _BootstrapStepItem(
        title: 'Hồ sơ tài khoản',
        description: switch (meStatus) {
          _RowStatus.loading => 'Đang tải dữ liệu hồ sơ người dùng',
          _RowStatus.success =>
            'Đã đồng bộ tên, vai trò và ngữ cảnh kho làm việc',
          _RowStatus.failed =>
            'Không tải được hồ sơ từ API, đang dùng dữ liệu phiên',
        },
        status: meStatus,
        source: '/api/v1/auth/me',
      ),
      _BootstrapStepItem(
        title: 'Quyền truy cập',
        description: switch (permissionsStatus) {
          _RowStatus.loading => 'Đang tải danh sách quyền phân hệ',
          _RowStatus.success =>
            '${permissionsCount ?? 0} quyền đã được đồng bộ',
          _RowStatus.failed =>
            'Không tải được quyền từ API, kiểm tra backend auth',
        },
        status: permissionsStatus,
        source: '/api/v1/auth/me/permissions',
      ),
      _BootstrapStepItem(
        title: 'Ma trận module',
        description:
            '$accessibleModules/$totalModules module khả dụng cho vai trò $roleLabel',
        status: moduleStatus,
        source: 'Role Matrix',
      ),
      _BootstrapStepItem(
        title: 'Điều hướng workspace',
        description: switch (routeStatus) {
          _RowStatus.loading => 'Đang chuẩn bị vào $landingPath',
          _RowStatus.success => 'Sẵn sàng chuyển tới $landingPath',
          _RowStatus.failed => 'Không thể chuẩn bị điều hướng mặc định',
        },
        status: routeStatus,
        source: 'Router',
      ),
    ];

    if (settled && _minDisplayElapsed && !_hasNavigated) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        context.go(landingPath);
      });
    }

    final completedItems = steps
        .where((item) => item.status == _RowStatus.success)
        .length;
    final progress = completedItems / steps.length;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFE9F0FB),
              AppColors.background,
              Color(0xFFF8FAFD),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x140E274A),
                              blurRadius: 24,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.brand.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.cloud_sync_outlined,
                                    color: AppColors.brand,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Đang lấy dữ liệu liên quan, vui lòng chờ',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'Hệ thống đang đồng bộ dữ liệu truy cập trước khi mở không gian làm việc.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '$completedItems/${steps.length} mục đã hoàn tất',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: <Widget>[
                                _BootstrapStatChip(
                                  label: 'Tên tài khoản',
                                  value: resolvedDisplayName,
                                ),
                                _BootstrapStatChip(
                                  label: 'Username',
                                  value: resolvedUsername,
                                ),
                                _BootstrapStatChip(
                                  label: 'Vai trò',
                                  value: roleLabel,
                                ),
                                _BootstrapStatChip(
                                  label: 'Quyền',
                                  value: permissionsCount == null
                                      ? 'Đang tải...'
                                      : '$permissionsCount quyền',
                                ),
                                _BootstrapStatChip(
                                  label: 'Kho làm việc',
                                  value: warehouseLabel,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            for (final step in steps) ...<Widget>[
                              _BootstrapStepTile(step: step),
                              if (step != steps.last)
                                const SizedBox(height: AppSpacing.sm),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _resolveDisplayName({
    required String fallbackDisplayName,
    required String? profileDisplayName,
  }) {
    final normalized = profileDisplayName?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }

    final fallback = fallbackDisplayName.trim();
    return fallback.isEmpty ? 'Unknown User' : fallback;
  }

  String _resolveUsername({
    required String fallbackUsername,
    required String? profileUsername,
  }) {
    final normalized = profileUsername?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }

    final fallback = fallbackUsername.trim();
    return fallback.isEmpty ? 'unknown' : fallback;
  }

  String _resolveWarehouseLabel({
    required AuthSession session,
    required AuthProfileDto? profile,
  }) {
    final selectedWarehouseId = profile?.selectedWarehouseId?.trim();
    final warehouseOptions = profile?.warehouseOptions;

    if (warehouseOptions != null && warehouseOptions.isNotEmpty) {
      if (selectedWarehouseId != null && selectedWarehouseId.isNotEmpty) {
        for (final option in warehouseOptions) {
          if (option.id == selectedWarehouseId) {
            return '${option.code} - ${option.name}';
          }
        }
      }

      final first = warehouseOptions.first;
      return '${first.code} - ${first.name}';
    }

    final fallbackSiteName = (session.currentUser.siteName).trim();
    if (fallbackSiteName.isNotEmpty) {
      return fallbackSiteName;
    }

    final fallbackSiteId = (session.currentUser.siteId).trim();
    if (fallbackSiteId.isNotEmpty) {
      return fallbackSiteId;
    }

    return 'Chưa có ngữ cảnh kho';
  }

  String _shortSessionId(String? sessionId) {
    final normalized = sessionId?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'n/a';
    }
    if (normalized.length <= 8) {
      return normalized;
    }

    return '${normalized.substring(0, 8)}...';
  }

  _RowStatus _statusFromAsync<T>(AsyncValue<T?> value) {
    if (value.hasError) {
      return _RowStatus.failed;
    }
    if (value.isLoading) {
      return _RowStatus.loading;
    }

    return _RowStatus.success;
  }
}

enum _RowStatus { loading, success, failed }

class _BootstrapStepItem {
  const _BootstrapStepItem({
    required this.title,
    required this.description,
    required this.status,
    required this.source,
  });

  final String title;
  final String description;
  final _RowStatus status;
  final String source;
}

class _BootstrapStatChip extends StatelessWidget {
  const _BootstrapStatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall,
          children: <InlineSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BootstrapStepTile extends StatelessWidget {
  const _BootstrapStepTile({required this.step});

  final _BootstrapStepItem step;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (step.status) {
      _RowStatus.loading => (Icons.hourglass_top_rounded, AppColors.info),
      _RowStatus.success => (Icons.check_circle_rounded, AppColors.success),
      _RowStatus.failed => (Icons.error_rounded, AppColors.danger),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withValues(alpha: 0.08),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(step.title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  step.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  step.source,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
