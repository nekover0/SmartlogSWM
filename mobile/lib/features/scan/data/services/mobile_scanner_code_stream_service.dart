import 'dart:async';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/services/scan_code_stream_service.dart';

class MobileScannerCodeStreamService implements ScanCodeStreamService {
  MobileScannerCodeStreamService({MobileScannerController? controller})
    : _controller =
          controller ??
          MobileScannerController(autoStart: false, facing: CameraFacing.back);

  final MobileScannerController _controller;
  Stream<ScanCodeCapture>? _stream;

  @override
  Stream<ScanCodeCapture> start() {
    _stream ??= _controller.barcodes.expand(_toCaptures).asBroadcastStream();
    unawaited(_controller.start());
    return _stream!;
  }

  @override
  Future<void> pause() {
    return _controller.stop();
  }

  @override
  Future<void> resume() {
    return _controller.start();
  }

  @override
  Future<void> stop() {
    return _controller.stop();
  }

  Iterable<ScanCodeCapture> _toCaptures(BarcodeCapture capture) sync* {
    final detectedAt = DateTime.now().toUtc();

    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue?.trim();
      if (rawValue == null || rawValue.isEmpty) {
        continue;
      }

      yield ScanCodeCapture(code: rawValue, detectedAt: detectedAt);
    }
  }
}
