import 'dart:async';

import 'package:smartlog_swm_mobile/features/scan/domain/services/scan_code_stream_service.dart';

class FakeScanCodeStreamService implements ScanCodeStreamService {
  FakeScanCodeStreamService();

  final StreamController<ScanCodeCapture> _controller =
      StreamController<ScanCodeCapture>.broadcast(sync: true);

  bool _isPaused = false;

  @override
  Stream<ScanCodeCapture> start() {
    return _controller.stream;
  }

  @override
  Future<void> pause() async {
    _isPaused = true;
  }

  @override
  Future<void> resume() async {
    _isPaused = false;
  }

  @override
  Future<void> stop() async {
    if (!_controller.isClosed) {
      await _controller.close();
    }
  }

  void emitCode(String code, {DateTime? detectedAt}) {
    if (_controller.isClosed || _isPaused) {
      return;
    }

    final normalizedCode = code.trim();
    if (normalizedCode.isEmpty) {
      return;
    }

    _controller.add(
      ScanCodeCapture(
        code: normalizedCode,
        detectedAt: detectedAt ?? DateTime.now().toUtc(),
      ),
    );
  }
}
