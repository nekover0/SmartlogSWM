import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

class SmartlogApp extends StatelessWidget {
  const SmartlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smartlog WMS',
      theme: AppTheme.light(),
      home: const _SmartlogBootPlaceholderPage(),
    );
  }
}

class _SmartlogBootPlaceholderPage extends StatelessWidget {
  const _SmartlogBootPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Smartlog mobile bootstrap',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Shared theme and reusable state widgets are ready for the next slices.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
