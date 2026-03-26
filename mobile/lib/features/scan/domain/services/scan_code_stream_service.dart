import 'package:flutter/foundation.dart';

/// Default cooldown window used to suppress repeated detections of the same code.
///
/// This value is intentionally deterministic so unit/widget tests can use the
/// same threshold across fake and platform scanner implementations.
const int kScanCodeDuplicateCooldownMs = 700;

/// Normalizes a scan payload for duplicate-key comparison.
///
/// Both scanner implementations and tests should use this helper to avoid
/// mismatch caused by spacing and letter-case differences.
String normalizeScanCodeForDuplicateCheck(String code) {
  return code.trim().toUpperCase();
}

@immutable
class ScanCodeCapture {
  const ScanCodeCapture({required this.code, required this.detectedAt});

  final String code;
  final DateTime detectedAt;
}

abstract interface class ScanCodeStreamService {
  /// Starts emitting scan captures from the active scanner session.
  ///
  /// Contract:
  /// - Emitted `code` values are expected to be non-empty and trimmed.
  /// - Implementations should cooperate with the shared duplicate strategy
  ///   (`normalizeScanCodeForDuplicateCheck` + `kScanCodeDuplicateCooldownMs`)
  ///   so behavior is consistent in runtime and tests.
  Stream<ScanCodeCapture> start();

  /// Temporarily stops scan emission while preserving scanner session state.
  Future<void> pause();

  /// Resumes scan emission after a previous [pause].
  Future<void> resume();

  /// Fully stops scan emission and releases scanner resources for this session.
  Future<void> stop();
}
