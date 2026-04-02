import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Centralized runtime configuration for app-wide environment values.
class AppEnvironment {
  const AppEnvironment({required this.apiBaseUrl});

  final String apiBaseUrl;

  static const String _defaultApiBaseUrl = 'https://swm.ap.ngrok.io';

  /// Optional compile-time override.
  ///
  /// Keeping this allows emergency override in CI/CD pipelines.
  static const String _apiBaseUrlFromDefine = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const AppEnvironment fallback = AppEnvironment(
    apiBaseUrl: _defaultApiBaseUrl,
  );
}

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment.fallback;
});

final apiBaseUrlProvider = Provider<String>((ref) {
  return ref.watch(appEnvironmentProvider).apiBaseUrl;
});

Future<AppEnvironment> loadAppEnvironment({AssetBundle? assetBundle}) async {
  if (AppEnvironment._apiBaseUrlFromDefine.isNotEmpty) {
    return const AppEnvironment(
      apiBaseUrl: AppEnvironment._apiBaseUrlFromDefine,
    );
  }

  final bundle = assetBundle ?? rootBundle;

  try {
    final jsonText = await bundle.loadString('assets/config/app_environment.json');
    final payload = jsonDecode(jsonText) as Map<String, dynamic>;
    final apiBaseUrl = (payload['apiBaseUrl'] as String?)?.trim() ?? '';

    if (apiBaseUrl.isNotEmpty) {
      return AppEnvironment(apiBaseUrl: apiBaseUrl);
    }
  } catch (_) {
    // Use fallback when config file is missing or malformed.
  }

  return AppEnvironment.fallback;
}
