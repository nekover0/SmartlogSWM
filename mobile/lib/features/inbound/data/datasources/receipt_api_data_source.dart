import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';

final receiptApiDataSourceProvider = Provider<ReceiptApiDataSource>((
  Ref<Object?> ref,
) {
  return ReceiptApiDataSource(httpClient: ref.watch(appHttpClientProvider));
});

class ReceiptApiDataSource {
  ReceiptApiDataSource({required AppHttpClient httpClient})
    : _httpClient = httpClient;

  static const String _receiptsPath = '/api/v1/inbound/receipts';

  final AppHttpClient _httpClient;

  Future<List<ReceiptDto>> getReceiptList() async {
    final payload = await _httpClient.getList(_receiptsPath);

    return payload
        .map(
          (entry) => ReceiptDto.fromJson(_normalizeReceiptJson(_toMap(entry))),
        )
        .toList(growable: false);
  }

  Future<ReceiptDto> getReceiptDetail(String receiptId) async {
    final payload = await _httpClient.getMap('$_receiptsPath/$receiptId');
    final receiptPayload = payload['receipt'] ?? payload;

    return ReceiptDto.fromJson(_normalizeReceiptJson(_toMap(receiptPayload)));
  }

  Map<String, dynamic> _toMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (Object? key, Object? nestedValue) =>
            MapEntry(key?.toString() ?? '', nestedValue),
      );
    }

    throw const FormatException('Receipt payload must be an object.');
  }

  Map<String, dynamic> _normalizeReceiptJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    final status = normalized['status'];
    if (status is String) {
      normalized['status'] = switch (status) {
        'weighing_1' => 'weighing1',
        'weighing_2' => 'weighing2',
        _ => status,
      };
    }

    return normalized;
  }
}
