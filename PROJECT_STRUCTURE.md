# Project Structure

Snapshot date: `2026-03-25`
Workspace root: `E:\Work\SmartlogSWM`

This file documents the current project directory structure in a readable form.
It focuses on the logical repo structure used for development and onboarding.

Excluded from the main tree below:
- `.git/`
- `mobile/.dart_tool/`
- `mobile/.idea/`
- `mobile/build/`
- `mobile/android/.gradle/`
- `mobile/ios/Flutter/ephemeral/`
- `mobile/macos/Flutter/ephemeral/`
- other local/generated cache folders created by Flutter, Gradle, Xcode, or IDEs

## Root

```text
SmartlogSWM/
|-- .vscode/
|   `-- settings.json
|-- mobile/
|   |-- android/
|   |   |-- app/
|   |   |   `-- src/
|   |   |       |-- debug/
|   |   |       |-- main/
|   |   |       |   |-- java/
|   |   |       |   |-- kotlin/
|   |   |       |   `-- res/
|   |   |       |       |-- drawable/
|   |   |       |       |-- drawable-v21/
|   |   |       |       |-- mipmap-hdpi/
|   |   |       |       |-- mipmap-mdpi/
|   |   |       |       |-- mipmap-xhdpi/
|   |   |       |       |-- mipmap-xxhdpi/
|   |   |       |       |-- mipmap-xxxhdpi/
|   |   |       |       |-- values/
|   |   |       |       `-- values-night/
|   |   |       `-- profile/
|   |   `-- gradle/
|   |       `-- wrapper/
|   |-- asset/
|   |   `-- fixtures/
|   |-- assets/
|   |   `-- fixtures/
|   |       |-- auth/
|   |       |-- inbound/
|   |       |-- scan/
|   |       `-- tasks/
|   |-- ios/
|   |   |-- Flutter/
|   |   |-- Runner/
|   |   |   |-- Assets.xcassets/
|   |   |   `-- Base.lproj/
|   |   |-- Runner.xcodeproj/
|   |   |   |-- project.xcworkspace/
|   |   |   `-- xcshareddata/
|   |   |-- Runner.xcworkspace/
|   |   |   `-- xcshareddata/
|   |   `-- RunnerTests/
|   |-- lib/
|   |   |-- app/
|   |   |   |-- router/
|   |   |   `-- shell/
|   |   |       |-- application/
|   |   |       |   `-- controllers/
|   |   |       |-- domain/
|   |   |       |   `-- models/
|   |   |       `-- presentation/
|   |   |           |-- pages/
|   |   |           `-- widgets/
|   |   |-- core/
|   |   |   |-- permissions/
|   |   |   `-- storage/
|   |   |-- features/
|   |   |   |-- account/
|   |   |   |   `-- presentation/
|   |   |   |       `-- pages/
|   |   |   |-- auth/
|   |   |   |   |-- application/
|   |   |   |   |   `-- controllers/
|   |   |   |   |-- data/
|   |   |   |   |   |-- datasources/
|   |   |   |   |   |-- dtos/
|   |   |   |   |   `-- repositories/
|   |   |   |   |-- domain/
|   |   |   |   |   |-- entities/
|   |   |   |   |   `-- repositories/
|   |   |   |   `-- presentation/
|   |   |   |       |-- pages/
|   |   |   |       `-- widgets/
|   |   |   |-- home/
|   |   |   |   `-- presentation/
|   |   |   |       `-- pages/
|   |   |   |-- inbound/
|   |   |   |   |-- application/
|   |   |   |   |   `-- controllers/
|   |   |   |   |-- data/
|   |   |   |   |   |-- contracts/
|   |   |   |   |   |-- datasources/
|   |   |   |   |   `-- repositories/
|   |   |   |   `-- domain/
|   |   |   |       `-- repositories/
|   |   |   |-- inventory/
|   |   |   |   `-- presentation/
|   |   |   |       `-- pages/
|   |   |   |-- more/
|   |   |   |   `-- presentation/
|   |   |   |       `-- pages/
|   |   |   |-- ocr/
|   |   |   |   `-- data/
|   |   |   |       `-- contracts/
|   |   |   |-- outbound/
|   |   |   |   `-- data/
|   |   |   |       `-- contracts/
|   |   |   |-- scan/
|   |   |   |   `-- data/
|   |   |   |       `-- contracts/
|   |   |   `-- tasks/
|   |   |       |-- application/
|   |   |       |   `-- controllers/
|   |   |       |-- data/
|   |   |       |   |-- contracts/
|   |   |       |   |-- datasources/
|   |   |       |   `-- repositories/
|   |   |       |-- domain/
|   |   |       |   `-- repositories/
|   |   |       `-- presentation/
|   |   |           |-- pages/
|   |   |           `-- widgets/
|   |   `-- shared/
|   |       |-- contracts/
|   |       |-- theme/
|   |       `-- widgets/
|   |-- linux/
|   |   |-- flutter/
|   |   `-- runner/
|   |-- macos/
|   |   |-- Flutter/
|   |   |-- Runner/
|   |   |   |-- Assets.xcassets/
|   |   |   |-- Base.lproj/
|   |   |   `-- Configs/
|   |   |-- Runner.xcodeproj/
|   |   |   |-- project.xcworkspace/
|   |   |   `-- xcshareddata/
|   |   |-- Runner.xcworkspace/
|   |   |   `-- xcshareddata/
|   |   `-- RunnerTests/
|   |-- test/
|   |   |-- app/
|   |   |   |-- router/
|   |   |   `-- shell/
|   |   |       `-- presentation/
|   |   |-- contracts/
|   |   |-- features/
|   |   |   |-- auth/
|   |   |   |   |-- application/
|   |   |   |   |-- data/
|   |   |   |   `-- presentation/
|   |   |   |-- inbound/
|   |   |   |   `-- application/
|   |   |   `-- tasks/
|   |   |       |-- application/
|   |   |       `-- presentation/
|   |   |-- shared/
|   |   `-- smoke/
|   |-- web/
|   |   `-- icons/
|   `-- windows/
|       |-- flutter/
|       `-- runner/
|           `-- resources/
|-- Plans/
|   |-- mobile-implementation/
|   |   `-- contracts/
|   |-- mobile-wireframes/
|   `-- plans/
|       `-- 2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/
`-- .gitignore
```

## Responsibilities by file and folder

This section explains what the important files are responsible for.
Generated files and platform boilerplate are grouped to avoid noise.

### Root files

- `PROJECT_STRUCTURE.md`
  Purpose: this overview file; explains tree structure and file responsibilities.
- `.gitignore`
  Purpose: excludes local/generated files from version control.
- `.vscode/settings.json`
  Purpose: workspace-level editor configuration for the repo.

### `mobile/` app root

- `mobile/pubspec.yaml`
  Purpose: Flutter package manifest, dependency list, asset registration, app metadata.
- `mobile/pubspec.lock`
  Purpose: locked dependency versions for reproducible local builds.
- `mobile/analysis_options.yaml`
  Purpose: Dart/Flutter lint and analyzer rules.
- `mobile/README.md`
  Purpose: local app-level setup or usage notes for the Flutter project.
- `mobile/.metadata`
  Purpose: Flutter tool metadata for the local project.
- `mobile/smartlog_swm_mobile.iml`
  Purpose: IDE module metadata.

### `mobile/lib/` entry and bootstrap

- `mobile/lib/main.dart`
  Purpose: Flutter entrypoint called by each platform target.
- `mobile/lib/bootstrap.dart`
  Purpose: app bootstrap layer; prepares provider/container/runtime before rendering UI.
- `mobile/lib/app/app.dart`
  Purpose: root `SmartlogApp`; wires global theme and router into `MaterialApp.router`.

### `mobile/lib/app/router/`

- `app_route_paths.dart`
  Purpose: centralized URL/path constants and path builder helpers.
- `app_route_names.dart`
  Purpose: centralized `GoRouter` route names for navigation and deep links.
- `app_redirect_guard.dart`
  Purpose: redirect logic for auth restore, login gating, and permission fallback.
- `app_router.dart`
  Purpose: builds the global `GoRouter`, root routes, placeholders, and named route resolution helper.
- `app_shell_route.dart`
  Purpose: defines the authenticated shell branches (`/home`, `/tasks`, `/inventory`, `/more`).

### `mobile/lib/app/shell/`

#### Application

- `application/controllers/app_shell_controller.dart`
  Purpose: derives shell UI state from auth session and task queue state.

#### Domain models

- `domain/models/app_badge_counts.dart`
  Purpose: badge count model for tabs/top bar.
- `domain/models/current_role.dart`
  Purpose: shell-facing role model with UI capability flags like tasks tab and scan FAB.
- `domain/models/current_site.dart`
  Purpose: shell-facing site summary shown in the app chrome.

#### Presentation pages

- `presentation/pages/app_shell_page.dart`
  Purpose: authenticated shell scaffold with top bar, tab bar, FAB, and branch body.
- `presentation/pages/notifications_page.dart`
  Purpose: notifications placeholder page/sheet entry in the shell.

#### Presentation widgets

- `presentation/widgets/app_bottom_nav.dart`
  Purpose: bottom navigation UI and badge rendering for shell tabs.
- `presentation/widgets/app_top_bar.dart`
  Purpose: top application bar showing site, title, notifications, and avatar entry.
- `presentation/widgets/scan_action_sheet.dart`
  Purpose: quick action sheet for scan-related entry points.

### `mobile/lib/core/`

- `permissions/role_matrix.dart`
  Purpose: central RBAC mapping between app roles and module access capabilities.
- `permissions/role_guard.dart`
  Purpose: helper API to query allowed modules/routes and compute role-based landing pages.
- `storage/secure_storage_service.dart`
  Purpose: wrapper around session persistence in secure storage.

### `mobile/lib/features/account/`

- `presentation/pages/account_page.dart`
  Purpose: account/profile placeholder route from the shell avatar.

### `mobile/lib/features/auth/`

#### Application

- `application/controllers/auth_controller.dart`
  Purpose: auth state machine for restore session, login, and logout.

#### Data

- `data/datasources/auth_fixture_data_source.dart`
  Purpose: loads auth fixture accounts from local asset JSON.
- `data/dtos/login_request_dto.dart`
  Purpose: login request payload model.
- `data/dtos/login_response_dto.dart`
  Purpose: login response payload model.
- `data/repositories/auth_repository_impl.dart`
  Purpose: fixture-backed auth repository and persistence wiring.

#### Domain

- `domain/entities/auth_sample_account.dart`
  Purpose: sample account shown in login helper UI.
- `domain/entities/auth_session.dart`
  Purpose: authenticated session aggregate.
- `domain/entities/auth_user.dart`
  Purpose: authenticated user profile used across app state.
- `domain/repositories/auth_repository.dart`
  Purpose: auth repository interface for login/restore/logout/sample accounts.

#### Presentation

- `presentation/pages/login_page.dart`
  Purpose: login screen shell and page-level UI state.
- `presentation/widgets/login_form.dart`
  Purpose: username/password form, validation, submit flow.
- `presentation/widgets/sample_account_accordion.dart`
  Purpose: quick-fill helper for fixture accounts on the login page.

### `mobile/lib/features/home/`

- `presentation/pages/home_dashboard_page.dart`
  Purpose: shell home branch page; currently dashboard placeholder.

### `mobile/lib/features/inventory/`

- `presentation/pages/inventory_list_page.dart`
  Purpose: inventory branch landing page; currently list placeholder.

### `mobile/lib/features/more/`

- `presentation/pages/more_page.dart`
  Purpose: “More” branch landing page for secondary modules/actions.

### `mobile/lib/features/tasks/`

#### Application

- `application/controllers/task_queue_controller.dart`
  Purpose: loads, sorts, filters, and exposes task queue UI state.

#### Data

- `data/contracts/task_item_contract.dart`
  Purpose: task entity/DTO contract used by the task queue slice.
- `data/datasources/task_queue_fixture_data_source.dart`
  Purpose: loads task queue fixture data from `assets/fixtures/tasks/task_queue.json`.
- `data/repositories/task_repository_impl.dart`
  Purpose: repository implementation that maps fixture DTOs into task entities.

#### Domain

- `domain/repositories/task_repository.dart`
  Purpose: repository interface for fetching task queue data.

#### Presentation

- `presentation/pages/task_queue_page.dart`
  Purpose: working `/tasks` queue screen with counters, filters, cards, quick actions, and CTA deep links.
- `presentation/widgets/task_card.dart`
  Purpose: renders a single queue card with metadata and primary action.
- `presentation/widgets/task_filter_bar.dart`
  Purpose: renders severity/type filters from controller state.

### `mobile/lib/features/inbound/`

#### Application

- `application/controllers/receipt_list_controller.dart`
  Purpose: loads receipt queue state and applies status/search filtering for inbound screens.
- `application/controllers/receipt_detail_controller.dart`
  Purpose: loads a single receipt detail by route id and exposes refreshable async state.
- `application/controllers/receipt_action_controller.dart`
  Purpose: derives footer action ordering from the receipt detail `availableActions` contract.

#### Data

- `data/contracts/receipt_contract.dart`
  Purpose: receipt contract used for inbound slice integration.
- `data/datasources/receipt_fixture_data_source.dart`
  Purpose: loads fixture-backed receipt list/detail JSON from `assets/fixtures/inbound/`.
- `data/repositories/receipt_repository_impl.dart`
  Purpose: repository implementation that maps receipt DTOs into receipt entities and wires providers.

#### Domain

- `domain/repositories/receipt_repository.dart`
  Purpose: repository interface for fetching receipt list and receipt detail state.

### `mobile/lib/features/outbound/`, `ocr/`, `scan/`

- `outbound/data/contracts/shipment_contract.dart`
  Purpose: shipment contract used for outbound slice integration.
- `ocr/data/contracts/ocr_record_contract.dart`
  Purpose: OCR record contract used for OCR slice integration.
- `scan/data/contracts/scan_session_contract.dart`
  Purpose: scan session contract used for scanning workflow integration.

### `mobile/lib/shared/`

#### Contracts

- `shared/contracts/shared_contracts.dart`
  Purpose: shared enums/value objects used by multiple feature contracts.

#### Theme

- `theme/app_colors.dart`
  Purpose: central app color tokens.
- `theme/app_spacing.dart`
  Purpose: spacing tokens and shared radius/padding constants.
- `theme/app_typography.dart`
  Purpose: typography scale and text style tokens.
- `theme/app_theme.dart`
  Purpose: assembled Material theme using shared colors/spacing/typography.

#### Shared widgets

- `widgets/app_loading_view.dart`
  Purpose: reusable loading state UI.
- `widgets/app_error_state.dart`
  Purpose: reusable error state UI with retry hook.
- `widgets/app_empty_state.dart`
  Purpose: reusable empty state UI with optional retry.
- `widgets/app_forbidden_state.dart`
  Purpose: reusable forbidden/access denied state UI.

### Generated contract files

- `*.freezed.dart`
  Purpose: generated immutable model helpers, equality, copy, unions, and serialization glue from `freezed`.
- `*.g.dart`
  Purpose: generated JSON serialization code from `json_serializable`.

These files are source-of-truth outputs from code generation and should not be edited manually.

### Flutter platform folders

- `mobile/android/`
  Purpose: Android runner project and native configuration.
- `mobile/ios/`
  Purpose: iOS runner project and native configuration.
- `mobile/linux/`
  Purpose: Linux desktop runner project.
- `mobile/macos/`
  Purpose: macOS desktop runner project.
- `mobile/web/`
  Purpose: web host page, icons, and manifest.
- `mobile/windows/`
  Purpose: Windows desktop runner project.

Most files in these folders are standard Flutter platform boilerplate unless a task explicitly changes them.

### Assets and fixtures

- `mobile/assets/fixtures/auth/sample_accounts.json`
  Purpose: fixture accounts for login flow and auth tests.
- `mobile/assets/fixtures/inbound/receipt_list.json`
  Purpose: seeded receipt queue data for inbound list filtering and counters.
- `mobile/assets/fixtures/inbound/receipt_detail_receipt-001.json`
  Purpose: concrete inbound detail fixture for receipt detail and footer action state.
- `mobile/assets/fixtures/tasks/task_queue.json`
  Purpose: seeded task queue data for the tasks slice.
- `mobile/assets/fixtures/inbound/`
  Purpose: inbound fixture folder for receipt list/detail datasets.
- `mobile/assets/fixtures/scan/`
  Purpose: reserved fixture folder for scan data.
- `mobile/asset/fixtures/auth.sample_account.json`
  Purpose: legacy flat compatibility fixture path kept from earlier setup.
- `mobile/asset/fixtures/auth/sample_accounts.json`
  Purpose: legacy nested compatibility fixture path for older auth asset callers.

### `mobile/test/`

#### App-level tests

- `test/app/router/app_redirect_guard_test.dart`
  Purpose: verifies auth redirect and permission fallback behavior.
- `test/app/router/route_constants_and_role_matrix_test.dart`
  Purpose: verifies route constants, deep-link builders, role matrix, and role guard rules.
- `test/app/shell/presentation/app_shell_page_test.dart`
  Purpose: verifies shell chrome, active tab behavior, and scan FAB visibility.

#### Contract tests

- `test/contracts/feature_contract_serialization_test.dart`
  Purpose: verifies feature contract JSON serialization/deserialization.
- `test/contracts/shared_and_task_contract_test.dart`
  Purpose: verifies shared and task contract serialization.

#### Auth feature tests

- `test/features/auth/application/auth_controller_test.dart`
  Purpose: verifies auth controller flows and state transitions.
- `test/features/auth/data/auth_fixture_assets_test.dart`
  Purpose: verifies auth fixtures are loadable from Flutter assets.
- `test/features/auth/data/auth_repository_impl_test.dart`
  Purpose: verifies fixture-backed auth repository behavior.
- `test/features/auth/presentation/login_page_test.dart`
  Purpose: verifies login UI interactions and validation.

#### Inbound feature tests

- `test/features/inbound/application/receipt_list_controller_test.dart`
  Purpose: verifies inbound receipt filtering, status chips, and list ordering logic.
- `test/features/inbound/application/receipt_detail_controller_test.dart`
  Purpose: verifies receipt detail loading and footer action derivation.

#### Tasks feature tests

- `test/features/tasks/application/task_queue_controller_test.dart`
  Purpose: verifies task loading, sorting, filtering, and shell badge derivation.
- `test/features/tasks/presentation/task_queue_page_test.dart`
  Purpose: verifies task queue rendering, filters, empty state, and CTA deep links.

#### Shared and smoke tests

- `test/shared/shared_feedback_widgets_test.dart`
  Purpose: verifies shared loading/error/empty feedback widgets.
- `test/smoke/app_boot_test.dart`
  Purpose: ensures the full app boots from the root widget.

### `Plans/` documentation workspace

- `Plans/README.md`
  Purpose: explains how planning artifacts are organized.
- `Plans/ke-hoach-chuyen-doi-webapp-sang-flutter.md`
  Purpose: higher-level migration/transition plan from web app to Flutter.

#### `Plans/mobile-implementation/`

- `01-app-shell-navigation-role-matrix.md`
  Purpose: implementation notes for shell navigation and RBAC.
- `02-task-flow-scan-ocr-inbound-outbound.md`
  Purpose: workflow mapping for operational feature slices.
- `03-flutter-folder-structure-route-state-map.md`
  Purpose: target architecture and state/routing map for the Flutter app.
- `contracts/*.dart`
  Purpose: planning/reference copies of contracts before or alongside Flutter import.
- `contracts/README.md`
  Purpose: explains the role of the planning-side contract bundle.

#### `Plans/mobile-wireframes/`

- `00` to `14` markdown files
  Purpose: screen-by-screen mobile wireframes and interaction notes used as implementation input.

#### `Plans/plans/`

- `2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan.md`
  Purpose: master execution plan for the current vertical slice.
- `2026-03-25-task-01-12-verification-report.md`
  Purpose: rolling verification report tracking completion status through task 14.
- `2026-03-23-flutter-vertical-slice-1-login-shell-tasks-receipt-scan/*.md`
  Purpose: task-by-task implementation checklist from `00` to `20`.

## Notes

- `mobile/asset/fixtures/` currently exists alongside `mobile/assets/fixtures/`.
  The first is legacy/compatibility data from earlier tasks; the second is the
  main Flutter asset path used by the app.
- The `Plans/` folder is the planning/documentation workspace for the mobile
  vertical-slice rollout.
- The Flutter platform folders (`android/`, `ios/`, `linux/`, `macos/`,
  `web/`, `windows/`) are standard app targets and are kept in the tree.
