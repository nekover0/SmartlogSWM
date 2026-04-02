import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/app.dart';
import 'package:smartlog_swm_mobile/core/config/app_environment.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';

Future<ProviderContainer> createBootstrapContainer() async {
  final appEnvironment = await loadAppEnvironment();

  final container = ProviderContainer(
    overrides: [
      appEnvironmentProvider.overrideWithValue(appEnvironment),
    ],
  );

  container.read(authControllerProvider);

  return container;
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = await createBootstrapContainer();

  runApp(UncontrolledProviderScope(container: container, child: SmartlogApp()));
}
