import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  late ProviderContainer container;
  late GoRouter router;

  Future<void> settleShell(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Widget buildSubject(_FakeAuthRepository repository) {
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
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

  testWidgets('renders shell chrome and opens the scan sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        _FakeAuthRepository(
          role: 'Operations Supervisor',
          displayName: 'Operations Supervisor',
          siteName: 'Sai Gon Distribution Center',
        ),
      ),
    );
    await settleShell(tester);

    expect(find.text('Sai Gon Distribution Center'), findsOneWidget);
    expect(find.byTooltip('Mở scan nhanh'), findsOneWidget);
    expect(find.byIcon(Icons.checklist_rounded), findsOneWidget);
    expect(find.byIcon(Icons.dashboard_rounded), findsNothing);

    await tester.tap(find.byTooltip('Mở scan nhanh'));
    await settleShell(tester);

    expect(find.text('Quét nhanh'), findsOneWidget);
    expect(find.text('OCR chụp chứng từ'), findsOneWidget);
    expect(find.text('Nhập thủ công'), findsOneWidget);
  });

  testWidgets('highlights the active tab after navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        _FakeAuthRepository(
          role: 'Operations Supervisor',
          displayName: 'Operations Supervisor',
          siteName: 'Sai Gon Distribution Center',
        ),
      ),
    );
    await settleShell(tester);

    router.go(AppRoutePaths.inventory);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byIcon(Icons.inventory_2_rounded), findsOneWidget);
    expect(find.byIcon(Icons.dashboard_rounded), findsNothing);
  });

  testWidgets('hides the scan fab for roles without scan access', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        _FakeAuthRepository(
          role: 'Customer Viewer',
          displayName: 'Customer Viewer',
          siteName: 'Ha Noi Hub',
        ),
      ),
    );
    await settleShell(tester);

    expect(find.byTooltip('Mở scan nhanh'), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    required this.role,
    required this.displayName,
    required this.siteName,
  });

  final String role;
  final String displayName;
  final String siteName;

  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    return <AuthSampleAccount>[
      AuthSampleAccount(
        id: 'user-1',
        username: 'ops.supervisor',
        password: 'smartlog123',
        displayName: displayName,
        role: role,
        siteId: 'site-1',
        siteName: siteName,
      ),
    ];
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    return _buildSession(request.username, request.password);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return _buildSession('ops.supervisor', 'smartlog123');
  }

  AuthSession _buildSession(String username, String password) {
    return AuthSession(
      accessToken: 'fixture-token-$username',
      currentUser: AuthUser(
        id: 'user-1',
        username: username,
        displayName: displayName,
        role: role,
        siteId: 'site-1',
        siteName: siteName,
      ),
      loggedInAt: DateTime.utc(2026, 3, 24, 9),
      persistedAt: DateTime.utc(2026, 3, 24, 9),
    );
  }
}
