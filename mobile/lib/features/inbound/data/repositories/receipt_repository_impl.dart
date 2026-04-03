import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/datasources/receipt_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/datasources/receipt_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';

final receiptFixtureDataSourceProvider = Provider<ReceiptFixtureDataSource>((
  Ref<Object?> ref,
) {
  return ReceiptFixtureDataSource();
});

final receiptRepositoryProvider = Provider<ReceiptRepository>((
  Ref<Object?> ref,
) {
  return ReceiptRepositoryImpl(
    apiDataSource: ref.watch(receiptApiDataSourceProvider),
    fixtureDataSource: ref.watch(receiptFixtureDataSourceProvider),
  );
});

class ReceiptRepositoryImpl implements ReceiptRepository {
  ReceiptRepositoryImpl({
    required ReceiptApiDataSource apiDataSource,
    required ReceiptFixtureDataSource fixtureDataSource,
  }) : _apiDataSource = apiDataSource,
       _fixtureDataSource = fixtureDataSource;

  final ReceiptApiDataSource _apiDataSource;
  final ReceiptFixtureDataSource _fixtureDataSource;

  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    try {
      final receipts = await _apiDataSource.getReceiptList();
      return receipts
          .map((receipt) => receipt.toEntity())
          .toList(growable: false);
    } catch (_) {
      final receipts = await _fixtureDataSource.getReceiptList();
      return receipts
          .map((receipt) => receipt.toEntity())
          .toList(growable: false);
    }
  }

  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    try {
      final receipt = await _apiDataSource.getReceiptDetail(receiptId);
      return receipt.toEntity();
    } catch (_) {
      final receipt = await _fixtureDataSource.getReceiptDetail(receiptId);
      return receipt.toEntity();
    }
  }
}
