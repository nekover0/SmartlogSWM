import 'package:flutter/material.dart';

class SmartlogApp extends StatelessWidget {
  const SmartlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smartlog WMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF103B73)),
        useMaterial3: true,
      ),
      home: const _SmartlogBootPlaceholderPage(),
    );
  }
}

class _SmartlogBootPlaceholderPage extends StatelessWidget {
  const _SmartlogBootPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Smartlog mobile bootstrap'),
      ),
    );
  }
}
