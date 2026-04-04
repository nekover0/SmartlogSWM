import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/datasources/ocr_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/ocr/domain/repositories/ocr_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final ocrRepositoryProvider = Provider<OcrRepository>((Ref<Object?> ref) {
  return OcrRepositoryImpl(apiDataSource: ref.watch(ocrApiDataSourceProvider));
});

class OcrRepositoryImpl implements OcrRepository {
  OcrRepositoryImpl({required OcrApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  final OcrApiDataSource _apiDataSource;

  @override
  Future<List<OcrRecordEntity>> getRecords() async {
    final records = await _apiDataSource.getRecords();
    final entities =
        records.map((record) => record.toEntity()).toList(growable: false)
          ..sort((left, right) => right.capturedAt.compareTo(left.capturedAt));
    return entities;
  }

  @override
  Future<OcrRecordEntity> getRecordById(String recordId) async {
    final record = await _apiDataSource.getRecordById(recordId);
    return record.toEntity();
  }

  @override
  Future<OcrRecordEntity> captureRecord({
    required DocumentDirection direction,
    required bool fromGallery,
  }) async {
    final uploaded = await _apiDataSource.upload(
      direction: direction,
      fromGallery: fromGallery,
    );
    return uploaded.toEntity();
  }

  @override
  Future<OcrRecordEntity> completeProcessing(String recordId) async {
    final record = await getRecordById(recordId);
    final updated = await _apiDataSource.confirm(
      recordId: recordId,
      extractedFields: record.extractedFields,
      reviewFlags: record.reviewFlags,
      remarks: 'Confirmed from mobile processing flow',
    );
    return updated.toEntity();
  }

  @override
  Future<OcrRecordEntity> saveReview({
    required String recordId,
    required OcrExtractedFieldsEntity extractedFields,
    required List<FieldReviewFlag> reviewFlags,
    required OcrRecordStatus status,
  }) async {
    final updated = await _apiDataSource.confirm(
      recordId: recordId,
      extractedFields: extractedFields,
      reviewFlags: reviewFlags,
      remarks: 'Review status: ${status.name}',
    );
    return updated.toEntity();
  }

  @override
  Future<OcrRecordEntity> linkRecord({
    required String recordId,
    required LinkedTargetType targetType,
    required String targetId,
    required String targetNo,
  }) async {
    final linked = await _apiDataSource.link(
      recordId: recordId,
      targetType: targetType,
      targetId: targetId,
      targetNo: targetNo,
    );
    return linked.toEntity();
  }

  @override
  Future<OcrRecordEntity> rejectRecord({
    required String recordId,
    String? reason,
  }) async {
    final rejected = await _apiDataSource.reject(
      recordId: recordId,
      reason: reason,
    );
    return rejected.toEntity();
  }
}
