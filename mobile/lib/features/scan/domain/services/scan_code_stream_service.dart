import 'package:flutter/foundation.dart';

@immutable
class ScanCodeCapture {
  const ScanCodeCapture({
    required this.code,
    required this.detectedAt,
  });

  final String code;
  final DateTime detectedAt;
}

abstract interface class ScanCodeStreamService {
  Stream<ScanCodeCapture> start();

  Future<void> pause();

  Future<void> resume();

  Future<void> stop();
}
