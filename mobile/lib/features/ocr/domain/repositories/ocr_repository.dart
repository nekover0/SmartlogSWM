import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

abstract interface class OcrRepository {
  Future<List<OcrRecordEntity>> getRecords();

  Future<OcrRecordEntity> getRecordById(String recordId);

  Future<OcrRecordEntity> captureRecord({
    required DocumentDirection direction,
    required bool fromGallery,
  });

  Future<OcrRecordEntity> completeProcessing(String recordId);

  Future<OcrRecordEntity> saveReview({
    required String recordId,
    required OcrExtractedFieldsEntity extractedFields,
    required List<FieldReviewFlag> reviewFlags,
    required OcrRecordStatus status,
  });

  Future<OcrRecordEntity> linkRecord({
    required String recordId,
    required LinkedTargetType targetType,
    required String targetId,
    required String targetNo,
  });

  Future<OcrRecordEntity> rejectRecord({
    required String recordId,
    String? reason,
  });
}
