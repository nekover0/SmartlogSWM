import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/datasources/ocr_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/ocr/domain/repositories/ocr_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final ocrFixtureDataSourceProvider = Provider<OcrFixtureDataSource>((
  Ref<Object?> ref,
) {
  return OcrFixtureDataSource();
});

final ocrRepositoryProvider = Provider<OcrRepository>((Ref<Object?> ref) {
  return OcrRepositoryImpl(
    fixtureDataSource: ref.watch(ocrFixtureDataSourceProvider),
  );
});

class OcrRepositoryImpl implements OcrRepository {
  OcrRepositoryImpl({required OcrFixtureDataSource fixtureDataSource})
    : _fixtureDataSource = fixtureDataSource;

  final OcrFixtureDataSource _fixtureDataSource;
  List<OcrRecordEntity>? _cache;

  Future<List<OcrRecordEntity>> _loadCache() async {
    final cached = _cache;
    if (cached != null) {
      return cached;
    }

    final dtos = await _fixtureDataSource.getRecords();
    _cache = dtos.map((dto) => dto.toEntity()).toList(growable: true);
    return _cache!;
  }

  @override
  Future<List<OcrRecordEntity>> getRecords() async {
    final records = await _loadCache();
    final copied = records.toList(growable: false)
      ..sort((left, right) => right.capturedAt.compareTo(left.capturedAt));
    return copied;
  }

  @override
  Future<OcrRecordEntity> getRecordById(String recordId) async {
    final records = await _loadCache();
    final record = records.cast<OcrRecordEntity?>().firstWhere(
      (entry) => entry?.id == recordId,
      orElse: () => null,
    );

    if (record == null) {
      throw StateError('OCR record not found: $recordId');
    }

    return record;
  }

  @override
  Future<OcrRecordEntity> captureRecord({
    required DocumentDirection direction,
    required bool fromGallery,
  }) async {
    final records = await _loadCache();
    final timestamp = DateTime.now();
    final recordId = 'ocr-${timestamp.millisecondsSinceEpoch}';

    final newRecord = OcrRecordEntity(
      id: recordId,
      direction: direction,
      status: OcrRecordStatus.processing,
      confidenceScore: 0.72,
      confidenceLevel: ConfidenceLevel.medium,
      extractedFields: const OcrExtractedFieldsEntity(),
      reviewFlags: const <FieldReviewFlag>[],
      sourceImageUrl: fromGallery
          ? 'gallery://ocr/$recordId.jpg'
          : 'camera://ocr/$recordId.jpg',
      linkedTargetType: LinkedTargetType.none,
      capturedAt: timestamp,
      processedAt: null,
      linkedAt: null,
      syncState: SyncState.pending,
    );

    records.insert(0, newRecord);
    return newRecord;
  }

  @override
  Future<OcrRecordEntity> completeProcessing(String recordId) async {
    final record = await getRecordById(recordId);

    final now = DateTime.now();
    final enrichedRecord = record.copyWith(
      status: OcrRecordStatus.reviewRequired,
      confidenceScore: 0.78,
      confidenceLevel: ConfidenceLevel.medium,
      extractedFields: OcrExtractedFieldsEntity(
        documentNo:
            record.extractedFields.documentNo ??
            (record.direction == DocumentDirection.inbound
                ? 'RCP-${now.millisecondsSinceEpoch % 100000}'
                : 'SHP-${now.millisecondsSinceEpoch % 100000}'),
        vehiclePlate: record.extractedFields.vehiclePlate ?? '51D-123.45',
        ownerCode: record.extractedFields.ownerCode ?? 'OWN-01',
        ownerName: record.extractedFields.ownerName ?? 'VinFast Logistics',
        itemCode: record.extractedFields.itemCode ?? 'SKU-COIL-01',
        itemName: record.extractedFields.itemName ?? 'Steel Coil 5T',
        grossWeightKg: record.extractedFields.grossWeightKg ?? 12450,
        netWeightKg: record.extractedFields.netWeightKg ?? 11820,
      ),
      reviewFlags: const <FieldReviewFlag>[
        FieldReviewFlag(
          fieldName: 'vehiclePlate',
          rawValue: '51D-123.4?',
          confidenceScore: 0.62,
          level: ConfidenceLevel.low,
          requiredReview: true,
        ),
      ],
      processedAt: now,
      syncState: SyncState.pending,
    );

    _upsert(enrichedRecord);
    return enrichedRecord;
  }

  @override
  Future<OcrRecordEntity> saveReview({
    required String recordId,
    required OcrExtractedFieldsEntity extractedFields,
    required List<FieldReviewFlag> reviewFlags,
    required OcrRecordStatus status,
  }) async {
    final record = await getRecordById(recordId);

    final nextRecord = record.copyWith(
      extractedFields: extractedFields,
      reviewFlags: reviewFlags,
      status: status,
      processedAt: DateTime.now(),
      syncState: SyncState.pending,
    );

    _upsert(nextRecord);
    return nextRecord;
  }

  @override
  Future<OcrRecordEntity> linkRecord({
    required String recordId,
    required LinkedTargetType targetType,
    required String targetId,
    required String targetNo,
  }) async {
    final record = await getRecordById(recordId);

    final nextRecord = record.copyWith(
      status: OcrRecordStatus.linked,
      linkedTargetType: targetType,
      linkedTargetId: targetId,
      linkedTargetNo: targetNo,
      linkedAt: DateTime.now(),
      syncState: SyncState.pending,
    );

    _upsert(nextRecord);
    return nextRecord;
  }

  @override
  Future<OcrRecordEntity> rejectRecord({
    required String recordId,
    String? reason,
  }) async {
    final record = await getRecordById(recordId);

    final nextRecord = record.copyWith(
      status: OcrRecordStatus.rejected,
      errorMessage: reason,
      processedAt: DateTime.now(),
      syncState: SyncState.pending,
    );

    _upsert(nextRecord);
    return nextRecord;
  }

  void _upsert(OcrRecordEntity nextRecord) {
    final records = _cache;
    if (records == null) {
      return;
    }

    final recordIndex = records.indexWhere(
      (entry) => entry.id == nextRecord.id,
    );
    if (recordIndex == -1) {
      records.insert(0, nextRecord);
      return;
    }

    records[recordIndex] = nextRecord;
  }
}
