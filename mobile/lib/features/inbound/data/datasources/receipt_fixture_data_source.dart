import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';

class ReceiptFixtureNotFoundException implements Exception {
  const ReceiptFixtureNotFoundException(this.receiptId);

  final String receiptId;

  @override
  String toString() => 'Receipt fixture not found for "$receiptId".';
}

class ReceiptFixtureDataSource {
  ReceiptFixtureDataSource({
    AssetBundle? assetBundle,
    this.listFixturePath = _defaultListFixturePath,
    Map<String, String>? detailFixturePaths,
  }) : _assetBundle = assetBundle ?? rootBundle,
       detailFixturePaths = detailFixturePaths ?? _defaultDetailFixturePaths;

  static const String _defaultListFixturePath =
      'assets/fixtures/inbound/receipt_list.json';

  static const Map<String, String> _defaultDetailFixturePaths =
      <String, String>{
        'rcp-20260323-001':
            'assets/fixtures/inbound/receipt_detail_receipt-001.json',
      };

  final AssetBundle _assetBundle;
  final String listFixturePath;
  final Map<String, String> detailFixturePaths;

  List<ReceiptDto>? _cachedReceipts;
  final Map<String, ReceiptDto> _cachedReceiptDetails = <String, ReceiptDto>{};

  Future<List<ReceiptDto>> getReceiptList() async {
    if (_cachedReceipts != null) {
      return _cachedReceipts!;
    }

    final rawJson = await _assetBundle.loadString(listFixturePath);
    final payload = jsonDecode(rawJson) as Map<String, dynamic>;
    final receiptsJson = payload['receipts'] as List<dynamic>;

    _cachedReceipts = receiptsJson
        .map((entry) => ReceiptDto.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);

    return _cachedReceipts!;
  }

  Future<ReceiptDto> getReceiptDetail(String receiptId) async {
    final cachedDetail = _cachedReceiptDetails[receiptId];
    if (cachedDetail != null) {
      return cachedDetail;
    }

    final detailFixturePath = detailFixturePaths[receiptId];
    if (detailFixturePath != null) {
      final detail = await _loadDetailFromPath(detailFixturePath);
      _cachedReceiptDetails[receiptId] = detail;
      return detail;
    }

    final listReceipt = await _findReceiptInList(receiptId);
    if (listReceipt != null) {
      return listReceipt;
    }

    throw ReceiptFixtureNotFoundException(receiptId);
  }

  Future<ReceiptDto?> _findReceiptInList(String receiptId) async {
    final receipts = await getReceiptList();
    return receipts.cast<ReceiptDto?>().firstWhere(
      (receipt) => receipt?.id == receiptId,
      orElse: () => null,
    );
  }

  Future<ReceiptDto> _loadDetailFromPath(String fixturePath) async {
    final rawJson = await _assetBundle.loadString(fixturePath);
    final payload = jsonDecode(rawJson) as Map<String, dynamic>;
    final receiptJson = payload['receipt'] as Map<String, dynamic>;
    return ReceiptDto.fromJson(receiptJson);
  }
}
