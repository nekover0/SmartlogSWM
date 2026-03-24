# Task 20 - Harden Empty/Error/Forbidden States And Add Integration Coverage

**Priority:** P0  
**Depends on:** `19-wire-task-receipt-scan-navigation-and-refresh.md`  
**Goal:** Stabilize the slice for demo and internal execution with explicit failure states and end-to-end test coverage.

**Files:**
- Modify: `mobile/lib/features/tasks/presentation/pages/task_queue_page.dart`
- Modify: `mobile/lib/features/inbound/presentation/pages/receipt_list_page.dart`
- Modify: `mobile/lib/features/inbound/presentation/pages/receipt_detail_page.dart`
- Modify: `mobile/lib/features/scan/presentation/pages/barcode_scan_page.dart`
- Modify: `mobile/lib/app/router/app_redirect_guard.dart`
- Create: `mobile/test/features/slice_1/error_state_regression_test.dart`
- Create: `mobile/integration_test/vertical_slice_1_happy_path_test.dart`
- Create: `mobile/integration_test/vertical_slice_1_error_path_test.dart`
- Create: `mobile/README.md`

**Implementation:**
1. Normalize loading, empty, retry, and forbidden states across the slice using shared widgets.
2. Add regression coverage for:
   - empty task queue
   - no-result receipt list
   - missing receipt detail
   - denied scan permission
   - forbidden route redirect
3. Add happy-path integration coverage for the whole slice.
4. Document setup, fixture accounts, codegen, and test commands in `mobile/README.md`.

**Verification:**

Run:

```bash
cd mobile
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter test integration_test/vertical_slice_1_happy_path_test.dart
flutter test integration_test/vertical_slice_1_error_path_test.dart
```

Expected: all commands pass.

**Done when:**
- The slice is stable under happy-path and failure-path tests.
- `mobile/README.md` explains how to run and verify the slice locally.
- The vertical slice is ready for real-device smoke and then backend replacement work.

**Suggested commit:** `test(slice1): harden states and add end-to-end coverage`

---

## Completion Notes

**Status:** Done  
**Completed on:** 2026-03-25

### Delivered

- Added explicit missing-receipt handling in `receipt_detail_page.dart`.
- Reused shared `AppForbiddenState` for denied camera access in `barcode_scan_page.dart`.
- Added regression coverage in `mobile/test/features/slice_1/error_state_regression_test.dart` for:
  - empty task queue
  - no-result receipt list
  - missing receipt detail
  - denied scan permission
  - forbidden route redirect
- Added end-to-end integration coverage in:
  - `mobile/integration_test/vertical_slice_1_happy_path_test.dart`
  - `mobile/integration_test/vertical_slice_1_error_path_test.dart`
- Replaced the default `mobile/README.md` stub with fixture accounts, local run, and verification steps.

### Verification Result

Passed:

```bash
cd mobile
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter test integration_test/vertical_slice_1_happy_path_test.dart -r expanded
flutter test integration_test/vertical_slice_1_error_path_test.dart -r expanded
```

### Notes

- Integration tests should be run sequentially on Windows. Running them in parallel can cause
  temporary `flutter_tools` listener or `unit_test_assets` contention.
