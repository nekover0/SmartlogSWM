import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/inventory/data/datasources/inventory_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('InventoryRepositoryImpl', () {
    test('returns list from api data source', () async {
      final apiDataSource = _FakeInventoryApiDataSource(
        listResponse: <InventoryItemEntity>[
          _buildItem(id: 'inv-001', skuCode: 'SKU-001', itemName: 'Item 001'),
        ],
      );
      final repository = InventoryRepositoryImpl(apiDataSource: apiDataSource);

      final items = await repository.getInventoryItems();

      expect(apiDataSource.listCallCount, 1);
      expect(items, hasLength(1));
      expect(items.single.id, 'inv-001');
      expect(items.single.skuCode, 'SKU-001');
    });

    test('returns detail from api data source', () async {
      final detail = InventoryDetailEntity(
        item: _buildItem(
          id: 'inv-002',
          skuCode: 'SKU-002',
          itemName: 'Item 002',
          availableQty: 20,
          warningThreshold: 10,
        ),
        priority: 'Binh thuong',
        timelineEvents: <InventoryTimelineEventEntity>[
          InventoryTimelineEventEntity(
            type: 'issue',
            label: 'Xuat kho gan nhat',
            occurredAt: DateTime(2026, 4, 4, 12),
            deltaQty: -5,
          ),
        ],
      );

      final apiDataSource = _FakeInventoryApiDataSource(detailResponse: detail);
      final repository = InventoryRepositoryImpl(apiDataSource: apiDataSource);

      final result = await repository.getInventoryDetail('inv-002');

      expect(apiDataSource.detailCallCount, 1);
      expect(result.item.id, 'inv-002');
      expect(result.timelineEvents, hasLength(1));
      expect(result.timelineEvents.single.deltaQty, -5);
    });
  });
}

InventoryItemEntity _buildItem({
  required String id,
  required String skuCode,
  required String itemName,
  double availableQty = 5,
  double warningThreshold = 10,
}) {
  return InventoryItemEntity(
    id: id,
    itemId: id,
    skuCode: skuCode,
    itemName: itemName,
    warehouseCode: 'WH-01',
    warehouseName: 'Warehouse 01',
    locationCode: 'A1',
    ownerCode: 'OWNER-01',
    zoneCode: 'ZONE-A',
    shelfCode: 'SHELF-1',
    batchNo: 'LOT-001',
    physicalQty: availableQty,
    allocatedQty: 0,
    availableQty: availableQty,
    warningThreshold: warningThreshold,
    uomCode: 'PCS',
    inventoryStatusCode: 'AVAILABLE',
    inventoryStatusAllocatable: true,
    syncState: SyncState.synced,
  );
}

class _FakeInventoryApiDataSource extends InventoryApiDataSource {
  _FakeInventoryApiDataSource({this.listResponse, this.detailResponse})
    : super(httpClient: _NoopAppHttpClient());

  final List<InventoryItemEntity>? listResponse;
  final InventoryDetailEntity? detailResponse;

  int listCallCount = 0;
  int detailCallCount = 0;

  @override
  Future<List<InventoryItemEntity>> getInventoryList() async {
    listCallCount += 1;
    return listResponse ?? const <InventoryItemEntity>[];
  }

  @override
  Future<InventoryDetailEntity> getInventoryDetail(String inventoryId) async {
    detailCallCount += 1;
    return detailResponse ??
        InventoryDetailEntity(
          item: _buildItem(
            id: inventoryId,
            skuCode: 'SKU-$inventoryId',
            itemName: 'Item $inventoryId',
          ),
          priority: 'Cao',
          timelineEvents: const <InventoryTimelineEventEntity>[],
        );
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
