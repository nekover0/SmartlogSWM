# Smartlog SWM

Smartlog SWM is a Flutter-based warehouse mobile project focused on role-based task execution, inbound and outbound operations, scan flows, and fixture-driven verification.

The repository currently contains:
- the main Flutter app in `mobile/`
- implementation and UX planning documents in `Plans/`
- GitHub Actions workflows for Android and iOS builds in `.github/workflows/`

## Repository Layout

- `mobile/`: Flutter application source, assets, tests, and platform folders
- `Plans/`: migration notes, feature plans, wireframes, and verification reports
- `.github/workflows/`: CI workflows for mobile builds
- `PROJECT_STRUCTURE.md`: detailed tree and folder responsibilities

## Prerequisites

- Flutter SDK compatible with the project constraints (see `mobile/pubspec.yaml`)
- Dart SDK bundled with the matching Flutter version
- One of the following for local development:
  - VS Code with Flutter extension
  - Android Studio

## Quick Start

```bash
cd mobile
flutter pub get
flutter run
```

The app is fixture-backed for core verification scenarios, so a backend is not required for current vertical-slice testing.

## Common Developer Commands

Run from `mobile/`:

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter test integration_test/vertical_slice_1_happy_path_test.dart
flutter test integration_test/vertical_slice_1_error_path_test.dart
```

## CI Workflows

This repository includes two build workflows:

- Android: `.github/workflows/build-android.yml`
  - Builds a release APK on `ubuntu-latest`
  - Publishes APK as a workflow artifact

- iOS: `.github/workflows/build-ios.yml`
  - Builds iOS app with `--no-codesign` on `macos-latest`
  - Publishes `Runner.app` as a workflow artifact

These workflows can be triggered via `workflow_dispatch`, `push`, and `pull_request` when relevant files change.

## Planning Documents

The `Plans/` folder captures:
- web-to-flutter migration plans
- mobile implementation contracts
- UX wireframes by screen
- verification reports and execution notes

Use these documents as implementation references before introducing new feature slices.
