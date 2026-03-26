import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_service.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_session_controller.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_flow_result.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/pages/barcode_scan_page.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

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
    ScanLaunchContext launchContext = const ScanLaunchContext(
      mode: ScanMode.receive,
      referenceId: 'rcp-20260323-001',
      warehouseId: 'warehouse-001',
    ),
  }) {
    return ProviderScope(
      overrides: [
        permissionServiceProvider.overrideWithValue(permissionService),
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
}
