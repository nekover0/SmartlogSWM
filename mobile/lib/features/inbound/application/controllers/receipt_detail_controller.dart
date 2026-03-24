import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_flow_projection_controller.dart';

final receiptDetailControllerProvider =
    AsyncNotifierProviderFamily<ReceiptDetailController, ReceiptEntity, String>(
      ReceiptDetailController.new,
    );

class ReceiptDetailController
    extends FamilyAsyncNotifier<ReceiptEntity, String> {
  ReceiptRepository get _repository => ref.read(receiptRepositoryProvider);

  @override
  Future<ReceiptEntity> build(String receiptId) async {
    final projectionState = ref.watch(scanFlowProjectionControllerProvider);
    final receipt = await _repository.getReceiptById(receiptId);
    return projectionState.projectReceipt(receipt);
  }

  Future<void> refresh() async {
    final projectionState = ref.read(scanFlowProjectionControllerProvider);
    state = const AsyncLoading<ReceiptEntity>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final receipt = await _repository.getReceiptById(arg);
      return projectionState.projectReceipt(receipt);
    });
  }
}
