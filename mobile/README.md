# Smartlog SWM Mobile

Flutter mobile shell for the Smartlog SWM vertical slice demo. The current slice covers:

- auth bootstrap with fixture-backed sample accounts
- shell navigation and task badge projection
- task queue to receipt detail navigation
- barcode receive flow with optimistic projection back into receipt/task state
- shared loading, empty, error, and forbidden states

## Requirements

- Flutter SDK compatible with `sdk: ^3.11.3`
- Dart SDK bundled with the matching Flutter version
- Android Studio or VS Code with Flutter tooling

## Project Structure

- `lib/app/`: router, shell, global navigation contracts
- `lib/features/auth/`: sample-account login and persisted session bootstrap
- `lib/features/tasks/`: queue, filters, badge counts
- `lib/features/inbound/`: receipt list and receipt detail
- `lib/features/scan/`: barcode receive session and projection logic
- `assets/fixtures/`: demo payloads used by repositories and tests
- `test/`: widget/unit/regression coverage
- `integration_test/`: vertical-slice happy/error path coverage

## Fixture Accounts

Source: [assets/fixtures/auth/sample_accounts.json](/E:/Work/SmartlogSWM/mobile/assets/fixtures/auth/sample_accounts.json)

All fixture accounts use the password `smartlog123`.

| Username | Role | Default Landing | Typical Use |
| --- | --- | --- | --- |
| `admin` | Administrator | `/home` | full-access smoke |
| `ops.supervisor` | Operations Supervisor | `/tasks` | cross-module checks |
| `warehouse.keeper` | Warehouse Keeper | `/tasks` | vertical slice happy path |
| `weighbridge.operator` | Weighbridge Operator | `/tasks?type=weighing` | weighing-first flow |

## Local Run

```bash
cd mobile
flutter pub get
flutter run
```

## API Base URL Configuration

The mobile app uses a centralized API base URL and loads it automatically
from this file:

- `assets/config/app_environment.json`

Current structure:

```json
{
	"apiBaseUrl": "https://swm.ap.ngrok.io"
}
```

Default value:

```text
https://swm.ap.ngrok.io
```

When the ngrok URL changes, update `apiBaseUrl` in that JSON file and run normally:

```bash
flutter run
```

Optional: you can still override from CI/CD with `--dart-define` if needed:

```bash
flutter build apk --dart-define=API_BASE_URL=https://api.your-domain.com
```

The default repositories load demo data from `assets/fixtures/`, so no backend is required for slice 1 verification.

## Vertical Slice 1 Flow

Happy path:

1. Restore or log in as `warehouse.keeper`
2. Open the critical inbound task from `/tasks`
3. Enter receipt detail
4. Start barcode receive
5. Lookup the receive fixture and submit
6. Return to receipt detail with projected received quantity
7. Jump back to task queue and confirm the badge count dropped

Failure path highlights:

- empty task queue renders `AppEmptyState`
- no-result receipt search renders `AppEmptyState`
- missing receipt detail renders explicit not-found state
- denied camera permission renders `AppForbiddenState`
- forbidden routes redirect to the first allowed shell route for that role

## Verification Commands

Run these from [mobile](/E:/Work/SmartlogSWM/mobile):

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter test integration_test/vertical_slice_1_happy_path_test.dart
flutter test integration_test/vertical_slice_1_error_path_test.dart
```

Recommended targeted checks while iterating:

```bash
flutter test test/features/slice_1/vertical_slice_navigation_test.dart
flutter test test/features/slice_1/error_state_regression_test.dart
flutter test test/features/scan/presentation/barcode_scan_page_test.dart
flutter test test/features/inbound/presentation/receipt_detail_page_test.dart
```

## Notes

- `integration_test/` uses fixture repositories and fake auth/permission providers; it is intended for deterministic local verification.
- `scan_flow_projection_controller.dart` is the glue that reflects a successful barcode receive back into receipt detail, receipt list, task queue, and shell badge state.
- `build_runner` is part of the standard verification checklist even when no generated files change, so the command stays green before backend replacement work starts.
- iOS camera permission for QR/barcode scanning only requires `NSCameraUsageDescription` in `ios/Runner/Info.plist`; no additional iOS compile-time entitlement is required for the current Runner target.
- macOS camera entitlement is not required for the current mobile scope, but must be added to macOS entitlements if camera scanning is enabled on macOS in future.

## Scan API Migration Mapping

Repository mapping for upcoming fixture-to-API swap:

- `ScanRepository.lookupReceive(...)` -> `POST /trpc/scan.lookupReceive`
	- Request: `mode`, `lookup_code`, `warehouse_id`, `reference_id`
	- Response: `session_id`, `state`, `resolved_item_code`, `resolved_location_code`, `reference_id`, `warehouse_id`, `message`
- `ScanRepository.submitReceive(...)` -> `POST /trpc/scan.submitReceive`
	- Request: `session_id`, `mode`, `reference_id`, `warehouse_id`, `item_code`, `location_code`, `quantity`, `idempotency_key`
	- Response: `success`, `session_id`, `receipt_id`, `submitted_at`, `message`

Expected API error mapping to mobile behavior:

- `400`: keep current screen and show validation banner.
- `401`: redirect to authentication flow.
- `403`: show forbidden state and stop submit retry.
- `404` on lookup: map to `lookupNotFound` and keep scan retry action.
- `409` on submit: show duplicate-submit message and keep form context.
- `422`: map to `submitFailed` with actionable guidance.
- `429`: show rate-limit message with retry guidance.
- `500`: map to generic failure banner and keep retry path.
