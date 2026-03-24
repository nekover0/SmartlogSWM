import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_redirect_guard.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_names.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/router/app_shell_route.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/pages/notifications_page.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/account/presentation/pages/account_page.dart';
import 'package:smartlog_swm_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/pages/receipt_detail_page.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/pages/receipt_list_page.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/pages/barcode_scan_page.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

const String _scanOriginParamPrefix = 'originParam.';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _GoRouterRefreshNotifier();
  ref.onDispose(refreshNotifier.dispose);
  ref.listen<AsyncValue<AuthSession?>>(authControllerProvider, (
    AsyncValue<AuthSession?>? previous,
    AsyncValue<AuthSession?> next,
  ) {
    refreshNotifier.markNeedsRefresh();
  });

  return GoRouter(
    initialLocation: AppRoutePaths.login,
    refreshListenable: refreshNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authControllerProvider);
      final lastOperation = ref
          .read(authControllerProvider.notifier)
          .lastOperation;
      return appRedirectGuard(
        state: state,
        authState: authState,
        lastOperation: lastOperation,
      );
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePaths.login,
        name: AppRouteNames.login,
        builder: (BuildContext context, GoRouterState state) {
          return const AppAuthGatePage();
        },
      ),
      buildAppShellRoute(),
      GoRoute(
        path: AppRoutePaths.notifications,
        name: AppRouteNames.notifications,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationsPage();
        },
      ),
      GoRoute(
        path: AppRoutePaths.account,
        name: AppRouteNames.account,
        builder: (BuildContext context, GoRouterState state) {
          return const AccountPage();
        },
      ),
      GoRoute(
        path: AppRoutePaths.inventoryDetail,
        name: AppRouteNames.inventoryDetail,
        builder: (BuildContext context, GoRouterState state) {
          final inventoryId =
              state.pathParameters[AppRoutePaths.inventoryIdParam] ?? 'unknown';
          return AppRoutePlaceholderPage(
            icon: Icons.inventory_2_outlined,
            frameLabel: '05. Inventory Details Screen',
            routePath: AppRoutePaths.inventoryDetailPath(inventoryId),
            title: 'Chi tiết tồn kho',
            description:
                'Chi tiết hàng hóa, trạng thái và hành động liên quan sẽ được thay bằng màn Figma tương ứng.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.inventoryControl,
        name: AppRouteNames.inventoryControl,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.swap_horiz_rounded,
            frameLabel: '13. Kiểm kê & Chuyển vị trí',
            routePath: AppRoutePaths.inventoryControl,
            title: 'Kiểm kê & chuyển vị trí',
            description:
                'Màn điều phối kiểm kê / chuyển vị trí giữ chỗ cho phase vận hành kho.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.inventoryControlFlow,
        name: AppRouteNames.inventoryControlFlow,
        builder: (BuildContext context, GoRouterState state) {
          final mode =
              state.pathParameters[AppRoutePaths.inventoryControlModeParam] ??
              'unknown';
          return AppRoutePlaceholderPage(
            icon: Icons.tune_rounded,
            frameLabel: '13. Kiểm kê & Chuyển vị trí',
            routePath: AppRoutePaths.inventoryControlFlowPath(mode),
            title: 'Luồng kiểm kê',
            description:
                'Biến thể luồng kiểm kê/chuyển vị trí theo mode sẽ được gắn sau khi hoàn thiện business rules.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.receiptList,
        name: AppRouteNames.receiptList,
        builder: (BuildContext context, GoRouterState state) {
          return const ReceiptListPage();
        },
      ),
      GoRoute(
        path: AppRoutePaths.receiptCreate,
        name: AppRouteNames.receiptCreate,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.add_box_outlined,
            frameLabel: '09. Chi tiết Phiếu Nhập (Refined Flow)',
            routePath: AppRoutePaths.receiptCreate,
            title: 'Tạo phiếu nhập',
            description:
                'Màn tạo phiếu nhập đang là placeholder cho flow chi tiết inbound.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.receiptDetail,
        name: AppRouteNames.receiptDetail,
        builder: (BuildContext context, GoRouterState state) {
          final receiptId =
              state.pathParameters[AppRoutePaths.receiptIdParam] ?? 'unknown';
          return ReceiptDetailPage(receiptId: receiptId);
        },
      ),
      GoRoute(
        path: AppRoutePaths.shipmentList,
        name: AppRouteNames.shipmentList,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.call_made_rounded,
            frameLabel: '10. Danh sách Phiếu Xuất Kho (v3)',
            routePath: AppRoutePaths.shipmentList,
            title: 'Phiếu xuất',
            description:
                'Danh sách phiếu xuất map sang khung outbound của Figma.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.shipmentCreate,
        name: AppRouteNames.shipmentCreate,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.playlist_add_rounded,
            frameLabel: '11. Chi tiết Phiếu Xuất Kho',
            routePath: AppRoutePaths.shipmentCreate,
            title: 'Tạo phiếu xuất',
            description:
                'Flow tạo phiếu xuất sẽ được thay bằng chi tiết outbound thật ở phase sau.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.shipmentDetail,
        name: AppRouteNames.shipmentDetail,
        builder: (BuildContext context, GoRouterState state) {
          final shipmentId =
              state.pathParameters[AppRoutePaths.shipmentIdParam] ?? 'unknown';
          return AppRoutePlaceholderPage(
            icon: Icons.local_shipping_outlined,
            frameLabel: '11. Chi tiết Phiếu Xuất Kho',
            routePath: AppRoutePaths.shipmentDetailPath(shipmentId),
            title: 'Chi tiết phiếu xuất',
            description:
                'Chi tiết phiếu xuất giữ chỗ cho màn outbound refine flow.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.scanBarcode,
        name: AppRouteNames.scanBarcode,
        builder: (BuildContext context, GoRouterState state) {
          final queryParameters = state.uri.queryParameters;
          return BarcodeScanPage(
            launchContext: ScanLaunchContext(
              mode: _parseScanMode(queryParameters['mode']) ?? ScanMode.receive,
              referenceId: queryParameters['referenceId'],
              referenceNo: queryParameters['referenceNo'],
              warehouseId: queryParameters['warehouseId'],
              warehouseCode: queryParameters['warehouseCode'],
              originRouteName: queryParameters['originRouteName'],
              originRouteParams: _extractScanOriginRouteParams(queryParameters),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.scanManual,
        name: AppRouteNames.scanManual,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.keyboard_alt_outlined,
            frameLabel: '03. Refined Quick Scan Screen',
            routePath: AppRoutePaths.scanManual,
            title: 'Nhập mã thủ công',
            description:
                'Biến thể nhập tay trong nhóm scan được giữ chỗ cho phase sau.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.ocrInbox,
        name: AppRouteNames.ocrInbox,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.document_scanner_outlined,
            frameLabel: '12. OCR Chụp và Xử lý',
            routePath: AppRoutePaths.ocrInbox,
            title: 'OCR',
            description:
                'Hàng đợi OCR gắn với màn chụp và xử lý chứng từ trong Figma.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.ocrCapture,
        name: AppRouteNames.ocrCapture,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.camera_alt_outlined,
            frameLabel: '12. OCR Chụp và Xử lý',
            routePath: AppRoutePaths.ocrCapture,
            title: 'Chụp OCR',
            description:
                'Màn chụp OCR sẽ được hiện thực sau khi chốt camera flow.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.ocrReview,
        name: AppRouteNames.ocrReview,
        builder: (BuildContext context, GoRouterState state) {
          final ocrId =
              state.pathParameters[AppRoutePaths.ocrIdParam] ?? 'unknown';
          return AppRoutePlaceholderPage(
            icon: Icons.fact_check_outlined,
            frameLabel: '12. OCR Chụp và Xử lý',
            routePath: AppRoutePaths.ocrReviewPath(ocrId),
            title: 'Review OCR',
            description:
                'Bước review OCR được giữ chỗ cho luồng xác nhận dữ liệu.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.ocrLink,
        name: AppRouteNames.ocrLink,
        builder: (BuildContext context, GoRouterState state) {
          final ocrId =
              state.pathParameters[AppRoutePaths.ocrIdParam] ?? 'unknown';
          return AppRoutePlaceholderPage(
            icon: Icons.link_rounded,
            frameLabel: '12. OCR Chụp và Xử lý',
            routePath: AppRoutePaths.ocrLinkPath(ocrId),
            title: 'Link OCR',
            description:
                'Bước liên kết OCR với chứng từ sẽ được hoàn thiện ở phase sau.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.reports,
        name: AppRouteNames.reports,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.bar_chart_rounded,
            frameLabel: '06. Real-time Reports Screen',
            routePath: AppRoutePaths.reports,
            title: 'Báo cáo',
            description:
                'Màn báo cáo real-time được giữ chỗ theo design hệ thống.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.permissions,
        name: AppRouteNames.rbacProfile,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.admin_panel_settings_outlined,
            frameLabel: '07. Refined Account & RBAC Screen',
            routePath: AppRoutePaths.permissions,
            title: 'Phân quyền',
            description:
                'Profile quyền và audit access sẽ được triển khai ở phase RBAC.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.userAdmin,
        name: AppRouteNames.userAdmin,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.people_alt_outlined,
            frameLabel: '07. Refined Account & RBAC Screen',
            routePath: AppRoutePaths.userAdmin,
            title: 'Quản lý người dùng',
            description:
                'Trang admin users giữ chỗ cho luồng quản trị trong shell more.',
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.roleAdmin,
        name: AppRouteNames.roleAdmin,
        builder: (BuildContext context, GoRouterState state) {
          return const AppRoutePlaceholderPage(
            icon: Icons.rule_folder_outlined,
            frameLabel: '07. Refined Account & RBAC Screen',
            routePath: AppRoutePaths.roleAdmin,
            title: 'Quản lý vai trò',
            description:
                'Trang admin roles giữ chỗ cho cấu hình role matrix theo thiết kế.',
          );
        },
      ),
    ],
  );
});

String buildScanBarcodeLocation({required ScanLaunchContext launchContext}) {
  return Uri(
    path: AppRoutePaths.scanBarcode,
    queryParameters: _buildScanBarcodeQueryParameters(launchContext),
  ).toString();
}

String? resolveNamedRouteLocation({
  required GoRouter router,
  String? routeName,
  Map<String, String>? pathParameters,
  Map<String, String>? queryParameters,
}) {
  final normalizedRouteName = routeName?.trim();
  if (normalizedRouteName == null || normalizedRouteName.isEmpty) {
    return null;
  }

  try {
    return router.namedLocation(
      normalizedRouteName,
      pathParameters: pathParameters ?? const <String, String>{},
      queryParameters: queryParameters ?? const <String, String>{},
    );
  } catch (_) {
    return null;
  }
}

Map<String, String> _buildScanBarcodeQueryParameters(
  ScanLaunchContext launchContext,
) {
  final queryParameters = <String, String>{
    'mode': launchContext.mode.name,
  };

  _addQueryParameter(queryParameters, 'referenceId', launchContext.referenceId);
  _addQueryParameter(queryParameters, 'referenceNo', launchContext.referenceNo);
  _addQueryParameter(queryParameters, 'warehouseId', launchContext.warehouseId);
  _addQueryParameter(
    queryParameters,
    'warehouseCode',
    launchContext.warehouseCode,
  );
  _addQueryParameter(
    queryParameters,
    'originRouteName',
    launchContext.originRouteName,
  );

  for (final entry in launchContext.originRouteParams.entries) {
    queryParameters['$_scanOriginParamPrefix${entry.key}'] = entry.value;
  }

  return queryParameters;
}

Map<String, String> _extractScanOriginRouteParams(
  Map<String, String> queryParameters,
) {
  final originRouteParams = <String, String>{};

  for (final entry in queryParameters.entries) {
    if (!entry.key.startsWith(_scanOriginParamPrefix)) {
      continue;
    }

    originRouteParams[entry.key.substring(_scanOriginParamPrefix.length)] =
        entry.value;
  }

  return originRouteParams;
}

void _addQueryParameter(
  Map<String, String> queryParameters,
  String key,
  String? value,
) {
  final normalizedValue = value?.trim();
  if (normalizedValue == null || normalizedValue.isEmpty) {
    return;
  }

  queryParameters[key] = normalizedValue;
}

class AppAuthGatePage extends ConsumerWidget {
  const AppAuthGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final session = authState.valueOrNull;
    final isRestoreLoading =
        authState.isLoading &&
        authController.lastOperation == AuthOperation.restore &&
        session == null;
    final isRestoreError =
        authState.hasError &&
        authController.lastOperation == AuthOperation.restore &&
        session == null;

    return Scaffold(
      body: isRestoreLoading
          ? const AppLoadingView(message: 'Đang khôi phục phiên đăng nhập...')
          : isRestoreError
          ? AppErrorState(
              title: 'Không thể khôi phục phiên đăng nhập',
              message: '${authState.error}',
              onRetry: () {
                ref.read(authControllerProvider.notifier).restoreSession();
              },
            )
          : session == null
          ? const LoginPage()
          : const AppLoadingView(message: 'Đang mở không gian làm việc...'),
    );
  }
}

class AppRoutePlaceholderPage extends StatelessWidget {
  const AppRoutePlaceholderPage({
    super.key,
    required this.icon,
    required this.frameLabel,
    required this.routePath,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String frameLabel;
  final String routePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
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
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: _PlaceholderPanel(
                  icon: icon,
                  frameLabel: frameLabel,
                  routePath: routePath,
                  title: title,
                  description: description,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel({
    required this.icon,
    required this.frameLabel,
    required this.routePath,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String frameLabel;
  final String routePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.brand.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: AppColors.brand, size: 28),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        frameLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _MiniChip(label: 'Route: $routePath'),
                _MiniChip(label: 'Figma: $frameLabel'),
                const _MiniChip(label: 'Route placeholder'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      side: const BorderSide(color: AppColors.border),
      backgroundColor: AppColors.surface,
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _GoRouterRefreshNotifier extends ChangeNotifier {
  void markNeedsRefresh() {
    notifyListeners();
  }
}

ScanMode? _parseScanMode(String? rawValue) {
  if (rawValue == null || rawValue.trim().isEmpty) {
    return null;
  }

  for (final mode in ScanMode.values) {
    if (mode.name == rawValue.trim()) {
      return mode;
    }
  }

  return null;
}
