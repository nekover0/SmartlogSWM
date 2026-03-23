import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
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

    return Scaffold(
      body: authState.when(
        loading: () =>
            const AppLoadingView(message: 'Đang khôi phục phiên đăng nhập...'),
        error: (Object error, StackTrace stackTrace) {
          return AppErrorState(
            title: 'Không thể khôi phục phiên đăng nhập',
            message: '$error',
            onRetry: () {
              ref.read(authControllerProvider.notifier).restoreSession();
            },
          );
        },
        data: (AuthSession? session) {
          if (session == null) {
            return const _UnauthenticatedPlaceholderView();
          }

          return _AuthenticatedPlaceholderView(session: session);
        },
      ),
    );
  }
}

class _UnauthenticatedPlaceholderView extends StatelessWidget {
  const _UnauthenticatedPlaceholderView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Smartlog auth bootstrap ready',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Phiên đăng nhập hiện chưa tồn tại. LoginPage sẽ được nối ở task kế tiếp.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
