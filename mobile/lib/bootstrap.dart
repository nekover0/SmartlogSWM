import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/app.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';

ProviderContainer createBootstrapContainer() {
  final container = ProviderContainer();

  container.read(authControllerProvider);

  return container;
}

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = createBootstrapContainer();

  runApp(UncontrolledProviderScope(container: container, child: SmartlogApp()));
}
