import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/datasources/receipt_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';

final receiptRepositoryProvider = Provider<ReceiptRepository>((
  Ref<Object?> ref,
) {
  return ReceiptRepositoryImpl(
    apiDataSource: ref.watch(receiptApiDataSourceProvider),
  );
});

class ReceiptRepositoryImpl implements ReceiptRepository {
  ReceiptRepositoryImpl({required ReceiptApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  final ReceiptApiDataSource _apiDataSource;

  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    final receipts = await _apiDataSource.getReceiptList();
    return receipts
        .map((receipt) => receipt.toEntity())
        .toList(growable: false);
  }

  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    final receipt = await _apiDataSource.getReceiptDetail(receiptId);
    return receipt.toEntity();
  }
}
