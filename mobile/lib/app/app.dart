import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class SmartlogApp extends ConsumerWidget {
  const SmartlogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smartlog WMS',
      theme: AppTheme.light(),
      home: const _AuthBootstrapPage(),
    );
  }
}

class _AuthBootstrapPage extends ConsumerWidget {
  const _AuthBootstrapPage();

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
          : _AuthenticatedPlaceholderView(session: session),
    );
  }
}

class _AuthenticatedPlaceholderView extends ConsumerWidget {
  const _AuthenticatedPlaceholderView({required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Xin chào ${session.currentUser.displayName}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${session.currentUser.role} · ${session.currentUser.siteName}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logout();
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
