import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_service.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/pages/receipt_detail_page.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/pages/barcode_scan_page.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late GoRouter router;

  Future<void> setLargeSurface(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 2600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  Future<void> settleUi(WidgetTester tester, {int passes = 6}) async {
    await tester.pump();
    for (var index = 0; index < passes; index++) {
      await tester.pump(const Duration(milliseconds: 140));
    }
  }

  Widget buildSubject() {
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(const _FakeAuthRepository()),
        permissionServiceProvider.overrideWithValue(
          const FakePermissionService(
            currentStatus: CameraPermissionStatus.granted,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    router = container.read(appRouterProvider);

    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.light(),
      ),
    );
  }

  testWidgets(
    'login to tasks to receipt to scan success refreshes receipt and task state',
    (WidgetTester tester) async {
      await setLargeSurface(tester);
      await tester.pumpWidget(buildSubject());
      await settleUi(tester);

      router.go(AppRoutePaths.tasks);
      await settleUi(tester);

      final initialBadge = find.byKey(const Key('bottom_nav_badge_1'));
      expect(initialBadge, findsOneWidget);
      expect(
        find.descendant(of: initialBadge, matching: find.text('3')),
        findsOneWidget,
      );
      expect(
        find.text('Phiếu nhập RCP-240323-001 chờ cân lần 1'),
        findsOneWidget,
      );

      final primaryAction = find.byKey(
        const Key('task_card_primary_action_task-receipt-critical-001'),
      );
      await tester.scrollUntilVisible(primaryAction, 300);
      await tester.tap(primaryAction);
      await settleUi(tester);

      expect(find.byType(ReceiptDetailPage), findsOneWidget);
      expect(find.text('RCP-240323-001'), findsWidgets);

      await tester.tap(find.byKey(const Key('receipt_action_startWeighing')));
      await settleUi(tester);

      expect(find.byType(BarcodeScanPage), findsOneWidget);
      await tester.tap(find.byKey(const Key('barcode_scan_lookup_button')));
      await settleUi(tester);

      expect(find.byKey(const Key('receive_form_sheet')), findsOneWidget);
      await tester.tap(find.byKey(const Key('receive_form_submit_button')));
      await settleUi(tester, passes: 10);

      expect(find.byType(BarcodeScanPage), findsNothing);
      expect(find.byType(ReceiptDetailPage), findsOneWidget);
      expect(find.text('Đang cân 1'), findsOneWidget);
      expect(find.text('12 CAN'), findsOneWidget);
      expect(find.text('Về task queue'), findsOneWidget);

      await tester.tap(find.text('Về task queue'));
      await settleUi(tester);

      final refreshedBadge = find.byKey(const Key('bottom_nav_badge_1'));
      expect(refreshedBadge, findsOneWidget);
      expect(
        find.descendant(of: refreshedBadge, matching: find.text('2')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('task_queue_header_total')), findsOneWidget);
      expect(
        find.text('Phiếu nhập RCP-240323-001 chờ cân lần 1'),
        findsNothing,
      );
    },
  );
}

class _FakeAuthRepository implements AuthRepository {
  const _FakeAuthRepository();

  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    return const <AuthSampleAccount>[];
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    return _session;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return _session;
  }

  static final AuthSession _session = AuthSession(
    accessToken: 'fixture-token-user-keeper-001',
    currentUser: const AuthUser(
      id: 'user-keeper-001',
      username: 'warehouse.keeper',
      displayName: 'Warehouse Keeper',
      role: 'Warehouse Keeper',
      siteId: 'bdg-wh-02',
      siteName: 'Binh Duong Overflow Warehouse',
    ),
    loggedInAt: DateTime.utc(2026, 3, 24, 9, 0),
    persistedAt: DateTime.utc(2026, 3, 24, 9, 0),
  );
}
