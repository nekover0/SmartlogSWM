import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/datasources/receipt_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/datasources/receipt_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('ReceiptRepositoryImpl', () {
    test('uses API datasource for receipt list when API succeeds', () async {
      final apiDataSource = _FakeReceiptApiDataSource(
        listResponse: <ReceiptDto>[
          _buildReceiptDto(id: 'api-rcp-001', receiptNo: 'RCP-001'),
        ],
      );
      final fixtureDataSource = _FakeReceiptFixtureDataSource(
        listResponse: <ReceiptDto>[
          _buildReceiptDto(id: 'fixture-rcp-001', receiptNo: 'RCP-FIX-001'),
        ],
      );
      final repository = ReceiptRepositoryImpl(
        apiDataSource: apiDataSource,
        fixtureDataSource: fixtureDataSource,
      );

      final receipts = await repository.getReceipts();

      expect(receipts, hasLength(1));
      expect(receipts.single.id, 'api-rcp-001');
      expect(apiDataSource.listCallCount, 1);
      expect(fixtureDataSource.listCallCount, 0);
    });

    test(
      'falls back to fixture datasource when receipt list API fails',
      () async {
        final apiDataSource = _FakeReceiptApiDataSource(
          listError: StateError('backend unavailable'),
        );
        final fixtureDataSource = _FakeReceiptFixtureDataSource(
          listResponse: <ReceiptDto>[
            _buildReceiptDto(id: 'fixture-rcp-002', receiptNo: 'RCP-FIX-002'),
          ],
        );
        final repository = ReceiptRepositoryImpl(
          apiDataSource: apiDataSource,
          fixtureDataSource: fixtureDataSource,
        );

        final receipts = await repository.getReceipts();

        expect(receipts, hasLength(1));
        expect(receipts.single.id, 'fixture-rcp-002');
        expect(apiDataSource.listCallCount, 1);
        expect(fixtureDataSource.listCallCount, 1);
      },
    );

    test('uses API datasource for receipt detail when API succeeds', () async {
      final apiDataSource = _FakeReceiptApiDataSource(
        detailResponse: _buildReceiptDto(
          id: 'api-rcp-003',
          receiptNo: 'RCP-003',
        ),
      );
      final fixtureDataSource = _FakeReceiptFixtureDataSource(
        detailResponse: _buildReceiptDto(
          id: 'fixture-rcp-003',
          receiptNo: 'RCP-FIX-003',
        ),
      );
      final repository = ReceiptRepositoryImpl(
        apiDataSource: apiDataSource,
        fixtureDataSource: fixtureDataSource,
      );

      final receipt = await repository.getReceiptById('api-rcp-003');

      expect(receipt.id, 'api-rcp-003');
      expect(apiDataSource.detailCallCount, 1);
      expect(fixtureDataSource.detailCallCount, 0);
    });

    test(
      'falls back to fixture datasource when receipt detail API fails',
      () async {
        final apiDataSource = _FakeReceiptApiDataSource(
          detailError: StateError('detail unavailable'),
        );
        final fixtureDataSource = _FakeReceiptFixtureDataSource(
          detailResponse: _buildReceiptDto(
            id: 'fixture-rcp-004',
            receiptNo: 'RCP-FIX-004',
          ),
        );
        final repository = ReceiptRepositoryImpl(
          apiDataSource: apiDataSource,
          fixtureDataSource: fixtureDataSource,
        );

        final receipt = await repository.getReceiptById('api-rcp-004');

        expect(receipt.id, 'fixture-rcp-004');
        expect(apiDataSource.detailCallCount, 1);
        expect(fixtureDataSource.detailCallCount, 1);
      },
    );
  });
}

ReceiptDto _buildReceiptDto({required String id, required String receiptNo}) {
  final now = DateTime.utc(2026, 4, 4, 0, 0, 0);
  return ReceiptDto(
    id: id,
    receiptNo: receiptNo,
    status: ReceiptStatus.confirmed,
    owner: const OwnerSummary(id: 'owner-1', code: 'OWN-1', name: 'Owner 1'),
    warehouse: const WarehouseSummary(
      id: 'wh-1',
      code: 'WH1',
      name: 'Warehouse 1',
    ),
    vehicle: const VehicleInfo(plateNumber: '51A-12345'),
    expectedWeightKg: 1000,
    receivedWeightKg: 990,
    varianceWeightKg: -10,
    syncState: SyncState.synced,
    createdAt: now,
    updatedAt: now,
  );
}

class _FakeReceiptApiDataSource extends ReceiptApiDataSource {
  _FakeReceiptApiDataSource({
    this.listResponse,
    this.listError,
    this.detailResponse,
    this.detailError,
  }) : super(httpClient: _NoopAppHttpClient());

  final List<ReceiptDto>? listResponse;
  final Object? listError;
  final ReceiptDto? detailResponse;
  final Object? detailError;

  int listCallCount = 0;
  int detailCallCount = 0;

  @override
  Future<List<ReceiptDto>> getReceiptList() async {
    listCallCount += 1;
    if (listError != null) {
      throw listError!;
    }

    return listResponse ??
        <ReceiptDto>[
          _buildReceiptDto(id: 'api-default', receiptNo: 'RCP-DEFAULT'),
        ];
  }

  @override
  Future<ReceiptDto> getReceiptDetail(String receiptId) async {
    detailCallCount += 1;
    if (detailError != null) {
      throw detailError!;
    }

    return detailResponse ??
        _buildReceiptDto(id: receiptId, receiptNo: 'RCP-DETAIL-DEFAULT');
  }
}

class _FakeReceiptFixtureDataSource extends ReceiptFixtureDataSource {
  _FakeReceiptFixtureDataSource({
    this.listResponse,
    this.listError,
    this.detailResponse,
    this.detailError,
  }) : super(assetBundle: rootBundle);

  final List<ReceiptDto>? listResponse;
  final Object? listError;
  final ReceiptDto? detailResponse;
  final Object? detailError;

  int listCallCount = 0;
  int detailCallCount = 0;

  @override
  Future<List<ReceiptDto>> getReceiptList() async {
    listCallCount += 1;
    if (listError != null) {
      throw listError!;
    }

    return listResponse ??
        <ReceiptDto>[
          _buildReceiptDto(id: 'fixture-default', receiptNo: 'RCP-FIX-DEFAULT'),
        ];
  }

  @override
  Future<ReceiptDto> getReceiptDetail(String receiptId) async {
    detailCallCount += 1;
    if (detailError != null) {
      throw detailError!;
    }

    return detailResponse ??
        _buildReceiptDto(id: receiptId, receiptNo: 'RCP-FIX-DETAIL-DEFAULT');
  }
}

class _NoopAppHttpClient implements AppHttpClient {
  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }
}
