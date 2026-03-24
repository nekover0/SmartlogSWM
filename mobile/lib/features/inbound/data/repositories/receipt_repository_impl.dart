import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
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
    fixtureDataSource: ref.watch(receiptFixtureDataSourceProvider),
  );
});

class ReceiptRepositoryImpl implements ReceiptRepository {
  ReceiptRepositoryImpl({required ReceiptFixtureDataSource fixtureDataSource})
    : _fixtureDataSource = fixtureDataSource;

  final ReceiptFixtureDataSource _fixtureDataSource;

  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    final receipts = await _fixtureDataSource.getReceiptList();
    return receipts
        .map((receipt) => receipt.toEntity())
        .toList(growable: false);
  }

  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    final receipt = await _fixtureDataSource.getReceiptDetail(receiptId);
    return receipt.toEntity();
  }
}
