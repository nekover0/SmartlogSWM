import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

class SmartlogApp extends ConsumerWidget {
  const SmartlogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Smartlog WMS',
      theme: AppTheme.light(),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
