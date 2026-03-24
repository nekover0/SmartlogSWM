import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';

abstract interface class ReceiptRepository {
  Future<List<ReceiptEntity>> getReceipts();

  Future<ReceiptEntity> getReceiptById(String receiptId);
}
