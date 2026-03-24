import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';

final receiptDetailControllerProvider =
    AsyncNotifierProviderFamily<ReceiptDetailController, ReceiptEntity, String>(
      ReceiptDetailController.new,
    );

class ReceiptDetailController
    extends FamilyAsyncNotifier<ReceiptEntity, String> {
  ReceiptRepository get _repository => ref.read(receiptRepositoryProvider);

  @override
  Future<ReceiptEntity> build(String receiptId) {
    return _repository.getReceiptById(receiptId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading<ReceiptEntity>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => _repository.getReceiptById(arg));
  }
}
