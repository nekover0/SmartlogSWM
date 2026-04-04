import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/datasources/ocr_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/repositories/ocr_repository_impl.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('OcrRepositoryImpl', () {
    test('maps list/detail from api datasource', () async {
      final apiDataSource = _FakeOcrApiDataSource(
        recordsResponse: <OcrRecordDto>[_buildDto(id: 'ocr-001')],
        detailResponse: _buildDto(id: 'ocr-002'),
      );
      final repository = OcrRepositoryImpl(apiDataSource: apiDataSource);

      final records = await repository.getRecords();
      final detail = await repository.getRecordById('ocr-002');

      expect(apiDataSource.recordsCallCount, 1);
      expect(apiDataSource.detailCallCount, 1);
      expect(records, hasLength(1));
      expect(records.single.id, 'ocr-001');
      expect(detail.id, 'ocr-002');
    });

    test('uses API for capture/confirm/link/reject actions', () async {
      final apiDataSource = _FakeOcrApiDataSource(
        uploadResponse: _buildDto(
          id: 'ocr-uploaded',
          status: OcrRecordStatus.captured,
        ),
        detailResponse: _buildDto(id: 'ocr-003'),
        confirmResponse: _buildDto(
          id: 'ocr-003',
          status: OcrRecordStatus.confirmed,
        ),
        linkResponse: _buildDto(
          id: 'ocr-003',
          status: OcrRecordStatus.linked,
          linkedTargetType: LinkedTargetType.receipt,
          linkedTargetId: 'rcp-001',
          linkedTargetNo: 'RCP-001',
        ),
        rejectResponse: _buildDto(
          id: 'ocr-003',
          status: OcrRecordStatus.rejected,
        ),
      );
      final repository = OcrRepositoryImpl(apiDataSource: apiDataSource);

      final captured = await repository.captureRecord(
        direction: DocumentDirection.inbound,
        fromGallery: false,
      );
      final completed = await repository.completeProcessing('ocr-003');
      final linked = await repository.linkRecord(
        recordId: 'ocr-003',
        targetType: LinkedTargetType.receipt,
        targetId: 'rcp-001',
        targetNo: 'RCP-001',
      );
      final rejected = await repository.rejectRecord(
        recordId: 'ocr-003',
        reason: 'invalid image',
      );

      expect(apiDataSource.uploadCallCount, 1);
      expect(apiDataSource.confirmCallCount, 1);
      expect(apiDataSource.linkCallCount, 1);
      expect(apiDataSource.rejectCallCount, 1);

      expect(captured.id, 'ocr-uploaded');
      expect(completed.status, OcrRecordStatus.confirmed);
      expect(linked.status, OcrRecordStatus.linked);
      expect(rejected.status, OcrRecordStatus.rejected);
    });
  });
}

OcrRecordDto _buildDto({
  required String id,
  OcrRecordStatus status = OcrRecordStatus.reviewRequired,
  LinkedTargetType linkedTargetType = LinkedTargetType.none,
  String? linkedTargetId,
  String? linkedTargetNo,
}) {
  return OcrRecordDto(
    id: id,
    direction: DocumentDirection.inbound,
    status: status,
    confidenceScore: 0.8,
    confidenceLevel: ConfidenceLevel.medium,
    extractedFields: const OcrExtractedFieldsDto(documentNo: 'DOC-001'),
    sourceImageUrl: '/uploads/ocr/$id.jpg',
    linkedTargetType: linkedTargetType,
    linkedTargetId: linkedTargetId,
    linkedTargetNo: linkedTargetNo,
    capturedAt: DateTime.utc(2026, 4, 4, 12, 0),
    processedAt: DateTime.utc(2026, 4, 4, 12, 1),
    syncState: SyncState.pending,
  );
}

class _FakeOcrApiDataSource extends OcrApiDataSource {
  _FakeOcrApiDataSource({
    this.recordsResponse,
    this.detailResponse,
    this.uploadResponse,
    this.confirmResponse,
    this.linkResponse,
    this.rejectResponse,
  }) : super(httpClient: _NoopAppHttpClient());

  final List<OcrRecordDto>? recordsResponse;
  final OcrRecordDto? detailResponse;
  final OcrRecordDto? uploadResponse;
  final OcrRecordDto? confirmResponse;
  final OcrRecordDto? linkResponse;
  final OcrRecordDto? rejectResponse;

  int recordsCallCount = 0;
  int detailCallCount = 0;
  int uploadCallCount = 0;
  int confirmCallCount = 0;
  int linkCallCount = 0;
  int rejectCallCount = 0;

  @override
  Future<List<OcrRecordDto>> getRecords() async {
    recordsCallCount += 1;
    return recordsResponse ?? const <OcrRecordDto>[];
  }

  @override
  Future<OcrRecordDto> getRecordById(String recordId) async {
    detailCallCount += 1;
    return detailResponse ?? _buildDto(id: recordId);
  }

  @override
  Future<OcrRecordDto> upload({
    required DocumentDirection direction,
    required bool fromGallery,
  }) async {
    uploadCallCount += 1;
    return uploadResponse ?? _buildDto(id: 'ocr-upload');
  }

  @override
  Future<OcrRecordDto> confirm({
    required String recordId,
    required OcrExtractedFieldsEntity extractedFields,
    required List<FieldReviewFlag> reviewFlags,
    String? remarks,
  }) async {
    confirmCallCount += 1;
    return confirmResponse ??
        _buildDto(id: recordId, status: OcrRecordStatus.confirmed);
  }

  @override
  Future<OcrRecordDto> link({
    required String recordId,
    required LinkedTargetType targetType,
    required String targetId,
    required String targetNo,
  }) async {
    linkCallCount += 1;
    return linkResponse ??
        _buildDto(
          id: recordId,
          status: OcrRecordStatus.linked,
          linkedTargetType: targetType,
          linkedTargetId: targetId,
          linkedTargetNo: targetNo,
        );
  }

  @override
  Future<OcrRecordDto> reject({
    required String recordId,
    String? reason,
  }) async {
    rejectCallCount += 1;
    return rejectResponse ??
        _buildDto(id: recordId, status: OcrRecordStatus.rejected);
  }
}

class _NoopAppHttpClient implements AppHttpClient {
  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }
}
