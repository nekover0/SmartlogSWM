# Smartlog SWM Flutter Vertical Slice 1 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the first demoable Flutter slice for Smartlog SWM: `login -> app shell -> task queue -> receipt list/detail -> scan receive`, runnable on a real device with fixture-backed data and protected by tests.

**Status:** Completed on 2026-03-25

**Architecture:** Create a new `mobile/` Flutter app inside this repository, following the feature-first structure from `Docs/mobile-implementation/03-flutter-folder-structure-route-state-map.md`. Start with fixture-backed repositories and Riverpod controllers, keep enum/DTO/entity naming aligned with `Docs/mobile-implementation/contracts/*.dart`, and use `go_router` + `StatefulShellRoute` for shell navigation and RBAC redirects.

**Tech Stack:** Flutter stable, Dart 3, Material 3, `go_router`, `flutter_riverpod`, `riverpod_annotation`, `dio`, `freezed`, `json_serializable`, `build_runner`, `flutter_test`, `integration_test`, `mocktail`.

---

## Refactor Format

- This plan is now split into commit-sized task files.
- Each task should fit in one commit or one very short red/green commit pair.
- The execution order is fixed and matches the original vertical slice priority.
- Root index file:
  - `Docs/plans/2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan.md`
- Task folder:
  - `Docs/plans/2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/`

## Scope Lock

- In scope:
  - Login screen and persisted session.
  - App shell with top bar, 4 tabs, FAB Scan, role-based visibility.
  - Task queue screen with task cards and severity filtering.
  - Receipt list screen.
  - Receipt detail screen.
  - Scan flow for `ScanMode.receive` opened from shell FAB and receipt detail.
  - Refresh path after successful receive scan back into receipt/task state.
- Out of scope:
  - Real backend integration.
  - OCR implementation.
  - Outbound, inventory control, reports, admin.
  - Complex offline sync.
  - Multi-site picker beyond a single fixture site.

## Assumptions

- Flutter source root is `mobile/`.
- Android is the required target for slice 1.
- `Warehouse Keeper` is the happy-path role and should land on `/tasks`.
- Contracts are copied from `Docs/mobile-implementation/contracts/*.dart` into source before feature implementation.

## Task Index

### Phase A. Bootstrap
1. [01-create-mobile-project-scaffold.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/01-create-mobile-project-scaffold.md)
2. [02-add-dependencies-assets-and-lints.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/02-add-dependencies-assets-and-lints.md)
3. [03-bootstrap-smartlog-app-entry.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/03-bootstrap-smartlog-app-entry.md)
4. [04-add-shared-theme-and-state-widgets.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/04-add-shared-theme-and-state-widgets.md)

### Phase B. Contracts
5. [05-import-shared-and-task-contracts.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/05-import-shared-and-task-contracts.md)
6. [06-import-receipt-scan-ocr-shipment-contracts-and-generate-code.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/06-import-receipt-scan-ocr-shipment-contracts-and-generate-code.md)

### Phase C. Auth
7. [07-add-auth-models-storage-and-fixture-repository.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/07-add-auth-models-storage-and-fixture-repository.md)
8. [08-add-auth-controller-and-restore-flow.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/08-add-auth-controller-and-restore-flow.md)
9. [09-build-login-page-and-widget-tests.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/09-build-login-page-and-widget-tests.md)

### Phase D. Shell
10. [10-add-route-constants-and-role-matrix.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/10-add-route-constants-and-role-matrix.md)
11. [11-add-redirect-guard-and-router-skeleton.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/11-add-redirect-guard-and-router-skeleton.md)
12. [12-build-app-shell-layout-and-placeholders.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/12-build-app-shell-layout-and-placeholders.md)

### Phase E. Tasks
13. [13-add-task-fixtures-repository-and-controller.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/13-add-task-fixtures-repository-and-controller.md)
14. [14-build-task-queue-page-and-shell-badges.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/14-build-task-queue-page-and-shell-badges.md)

### Phase F. Inbound
15. [15-add-receipt-fixtures-repository-and-controllers.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/15-add-receipt-fixtures-repository-and-controllers.md)
16. [16-build-receipt-list-and-detail-pages.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/16-build-receipt-list-and-detail-pages.md)

### Phase G. Scan Receive
17. [17-add-scan-models-permission-service-and-controller.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/17-add-scan-models-permission-service-and-controller.md)
18. [18-build-barcode-scan-page-and-receive-form.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/18-build-barcode-scan-page-and-receive-form.md)

### Phase H. Wiring And Stabilization
19. [19-wire-task-receipt-scan-navigation-and-refresh.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/19-wire-task-receipt-scan-navigation-and-refresh.md)
20. [20-harden-states-and-add-integration-tests.md](./2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/20-harden-states-and-add-integration-tests.md)

## Final Acceptance Criteria

- `Warehouse Keeper` can log in and land on `/tasks`.
- Shell shows role-appropriate tabs and scan FAB.
- Task queue badge and list are driven by controller state, not hardcoded widget literals.
- User can reach receipt detail from both task queue and receipt list.
- Receipt detail shows status, metadata, weight summary, lines, and footer actions.
- User can open `ScanMode.receive`, submit a receive action, and return with refreshed UI.
- Loading, empty, denied, and error states are handled across the slice.
- `flutter analyze`, `flutter test`, and the slice integration tests all pass.

## Completion Summary

- Tasks `01` through `20` are implemented.
- Slice 1 now includes regression coverage for empty, no-result, missing, denied, and forbidden states.
- End-to-end coverage exists for both happy-path and error-path flows under `mobile/integration_test/`.
- Local execution and verification instructions are documented in `mobile/README.md`.

## Final Verification

Validated from `mobile/` with:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter test integration_test/vertical_slice_1_happy_path_test.dart -r expanded
flutter test integration_test/vertical_slice_1_error_path_test.dart -r expanded
```

Note: the two integration files should be run sequentially on Windows to avoid `flutter_tools`
temporary listener contention.

Plan complete and saved to `Docs/plans/2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan.md`, with task files under `Docs/plans/2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/`.
