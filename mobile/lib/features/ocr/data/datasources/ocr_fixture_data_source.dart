import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';

class OcrFixtureDataSource {
  OcrFixtureDataSource({
    AssetBundle? assetBundle,
    this.fixturePath = _defaultFixturePath,
  }) : _assetBundle = assetBundle ?? rootBundle;

  static const String _defaultFixturePath =
      'assets/fixtures/ocr/ocr_records.json';

  final AssetBundle _assetBundle;
  final String fixturePath;

  List<OcrRecordDto>? _cachedRecords;

  Future<List<OcrRecordDto>> getRecords() async {
    if (_cachedRecords != null) {
      return _cachedRecords!;
    }

    final rawJson = await _assetBundle.loadString(fixturePath);
    final payload = jsonDecode(rawJson) as Map<String, dynamic>;
    final recordsJson = payload['records'] as List<dynamic>;

    _cachedRecords = recordsJson
        .map((entry) => OcrRecordDto.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);

    return _cachedRecords!;
  }
}
