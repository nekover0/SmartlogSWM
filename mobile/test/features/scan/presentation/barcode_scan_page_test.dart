import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_service.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_session_controller.dart';
import 'package:smartlog_swm_mobile/features/scan/data/services/fake_scan_code_stream_service.dart';
import 'package:smartlog_swm_mobile/features/scan/data/services/mobile_scanner_code_stream_service.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/pages/barcode_scan_page.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_forbidden_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> setLargeSurface(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 2600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  Future<void> settleUi(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 120));
  }

  Widget buildDirectPage({
    required PermissionService permissionService,
    FakeScanCodeStreamService? fakeScanCodeStreamService,
    ScanLaunchContext launchContext = const ScanLaunchContext(
      mode: ScanMode.receive,
      referenceId: 'rcp-20260323-001',
      warehouseId: 'warehouse-001',
    ),
  }) {
    final scannerService = fakeScanCodeStreamService ?? FakeScanCodeStreamService();

    return ProviderScope(
      overrides: [
        permissionServiceProvider.overrideWithValue(permissionService),
        scanCodeStreamServiceOverrideProvider.overrideWithValue(scannerService),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: BarcodeScanPage(launchContext: launchContext),
      ),
    );
  }

  testWidgets('renders denied, opens receive form, and returns scan result', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);

    await tester.pumpWidget(
      buildDirectPage(
        permissionService: const FakePermissionService(
          currentStatus: CameraPermissionStatus.denied,
          requestStatus: CameraPermissionStatus.denied,
        ),
      ),
    );
    await settleUi(tester);

    expect(find.byKey(const Key('barcode_scan_permission_denied')), findsOneWidget);
    expect(find.text('Cấp quyền lại'), findsOneWidget);
    final fallbackButton = tester.widget<ElevatedButton>(
      find.byKey(const Key('barcode_scan_lookup_button')),
    );
    expect(fallbackButton.onPressed, isNotNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    await tester.pumpWidget(
      buildDirectPage(
        permissionService: const FakePermissionService(
          currentStatus: CameraPermissionStatus.granted,
        ),
      ),
    );
    await settleUi(tester);

    await tester.tap(find.byKey(const Key('barcode_scan_lookup_button')));
    await settleUi(tester);

    expect(find.byKey(const Key('receive_form_sheet')), findsOneWidget);
    expect(find.text('SKU: SKU-MILK-18L'), findsOneWidget);

    final locationField = tester.widget<TextField>(
      find.byKey(const Key('receive_form_location_field')),
    );
    final quantityField = tester.widget<TextField>(
      find.byKey(const Key('receive_form_quantity_field')),
    );

    expect(locationField.controller?.text, 'RCV-STAGE-01');
    expect(quantityField.controller?.text, '12');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    const launchContext = ScanLaunchContext(
      mode: ScanMode.receive,
      referenceId: 'rcp-20260323-001',
      warehouseId: 'warehouse-001',
    );
    final navigatorKey = GlobalKey<NavigatorState>();
    late ProviderContainer container;

    container = ProviderContainer(
      overrides: [
        permissionServiceProvider.overrideWithValue(
          const FakePermissionService(
            currentStatus: CameraPermissionStatus.granted,
          ),
        ),
        scanCodeStreamServiceOverrideProvider.overrideWithValue(
          FakeScanCodeStreamService(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: AppTheme.light(),
          home: const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
    await settleUi(tester);

    ScanFlowResult? capturedResult;
    final resultFuture = navigatorKey.currentState!.push<ScanFlowResult>(
      MaterialPageRoute<ScanFlowResult>(
        builder: (_) {
          return const BarcodeScanPage(launchContext: launchContext);
        },
      ),
    );
    resultFuture.then((value) {
      capturedResult = value;
    });
    await settleUi(tester);

    await container
        .read(scanSessionControllerProvider(launchContext).notifier)
        .requestCameraAccess();
    await container
        .read(scanSessionControllerProvider(launchContext).notifier)
        .lookupReceiveCode('RCV-240325-001');
    container
        .read(scanSessionControllerProvider(launchContext).notifier)
        .prepareReceiveForm();
    await container
        .read(scanSessionControllerProvider(launchContext).notifier)
        .submitReceive();
    await settleUi(tester);

    expect(capturedResult, isNotNull);
    expect(capturedResult?.itemCode, 'SKU-MILK-18L');
    expect(capturedResult?.quantity, 12.0);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('handles denied then retry to granted camera flow', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);

    final permissionService = _MutablePermissionService(
      currentStatus: CameraPermissionStatus.denied,
      requestStatus: CameraPermissionStatus.denied,
    );

    final container = ProviderContainer(
      overrides: [
        permissionServiceProvider.overrideWithValue(permissionService),
        scanCodeStreamServiceOverrideProvider.overrideWithValue(
          FakeScanCodeStreamService(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const BarcodeScanPage(
            launchContext: ScanLaunchContext(mode: ScanMode.receive),
          ),
        ),
      ),
    );
    await settleUi(tester);

    expect(find.byKey(const Key('barcode_scan_permission_denied')), findsOneWidget);

    permissionService.requestStatus = CameraPermissionStatus.granted;
    await tester.tap(find.text('Cấp quyền lại'));
    await settleUi(tester);

    final nextState = container.read(
      scanSessionControllerProvider(const ScanLaunchContext(mode: ScanMode.receive)),
    );
    expect(nextState.session.state, ScanSessionState.scanning);
    expect(nextState.session.cameraGranted, isTrue);
  });

  testWidgets('recovers from lookup-not-found back to scanning state', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);

    const launchContext = ScanLaunchContext(mode: ScanMode.receive);
    final container = ProviderContainer(
      overrides: [
        permissionServiceProvider.overrideWithValue(
          const FakePermissionService(
            currentStatus: CameraPermissionStatus.granted,
          ),
        ),
        scanCodeStreamServiceOverrideProvider.overrideWithValue(
          FakeScanCodeStreamService(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const BarcodeScanPage(launchContext: launchContext),
        ),
      ),
    );
    await settleUi(tester);

    await container
        .read(scanSessionControllerProvider(launchContext).notifier)
        .lookupReceiveCode('NOT-FOUND');
    await settleUi(tester);

    expect(find.byType(AppForbiddenState), findsNothing);
    expect(find.text('Thu lai'), findsOneWidget);

    await tester.tap(find.text('Thu lai'));
    await settleUi(tester);

    final recoveredState = container.read(
      scanSessionControllerProvider(launchContext),
    );
    expect(recoveredState.session.state, ScanSessionState.scanning);
    expect(find.byKey(const Key('barcode_scan_camera_preview')), findsOneWidget);
  });
}


class _MutablePermissionService implements PermissionService {
  _MutablePermissionService({
    required this.currentStatus,
    required this.requestStatus,
  });

  CameraPermissionStatus currentStatus;
  CameraPermissionStatus requestStatus;

  @override
  Future<CameraPermissionStatus> getCameraPermissionStatus() async {
    return currentStatus;
  }

  @override
  Future<CameraPermissionStatus> requestCameraPermission() async {
    return requestStatus;
  }
}
