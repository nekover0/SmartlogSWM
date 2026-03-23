import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('Feature contract serialization', () {
    test('ReceiptDto round-trips nested actions and lines', () {
      final json = <String, dynamic>{
        'id': 'receipt-001',
        'receipt_no': 'RCP-001',
        'status': 'waiting_for_weighing',
        'owner': <String, dynamic>{
          'id': 'owner-01',
          'code': 'OWN01',
          'name': 'Owner One',
        },
        'warehouse': <String, dynamic>{
          'id': 'wh-01',
          'code': 'WH01',
          'name': 'Main Warehouse',
        },
        'vehicle': <String, dynamic>{
          'plate_number': '51A-12345',
          'driver_name': 'Nguyen Van A',
        },
        'purchase_order_no': 'PO-7788',
        'bill_of_lading_no': 'BOL-99',
        'vessel_name': 'Smartlog Vessel',
        'expected_weight_kg': 1200.5,
        'received_weight_kg': 1195.0,
        'port_weight_kg': 1198.0,
        'variance_weight_kg': -5.5,
        'source_ocr_record_id': 'ocr-002',
        'sync_state': 'pending',
        'available_actions': <Map<String, dynamic>>[
          <String, dynamic>{
            'type': 'start_weighing',
            'label': 'Start weighing',
            'route_name': 'receipt_detail',
            'route_params': <String, String>{'receiptId': 'receipt-001'},
            'enabled': true,
          },
        ],
        'lines': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'line-1',
            'item_code': 'ITEM-01',
            'item_name': 'Rice',
            'uom_code': 'BAG',
            'expected_qty': 10.0,
            'received_qty': 9.0,
            'variance_qty': -1.0,
          },
        ],
        'note': 'Arrived early',
        'error_message': null,
        'created_at': '2026-03-23T01:00:00.000Z',
        'updated_at': '2026-03-23T01:10:00.000Z',
      };

      final dto = ReceiptDto.fromJson(json);
      final encoded = dto.toJson();

      expect(dto.status, ReceiptStatus.waitingForWeighing);
      expect(dto.availableActions.single.type, TaskActionType.startWeighing);
      expect(dto.lines.single.itemCode, 'ITEM-01');
      expect(
        (encoded['available_actions'] as List<dynamic>).single,
        isA<Map<String, dynamic>>().having(
          (value) => value['type'],
          'type',
          'start_weighing',
        ),
      );
      expect(
        (encoded['lines'] as List<dynamic>).single,
        isA<Map<String, dynamic>>().having(
          (value) => value['item_code'],
          'item_code',
          'ITEM-01',
        ),
      );
      expect(encoded['status'], 'waiting_for_weighing');
    });

    test('ScanSessionDraftDto round-trips snake_case keys', () {
      final json = <String, dynamic>{
        'id': 'scan-001',
        'mode': 'receive',
        'state': 'form_ready',
        'camera_granted': true,
        'lookup_code': 'BC-9988',
        'resolved_item_code': 'ITEM-02',
        'resolved_location_code': 'A-01',
        'reference_id': 'receipt-001',
        'warehouse_id': 'wh-01',
        'quantity': 20.0,
        'counted_quantity': 19.0,
        'source_location_code': 'DOCK-01',
        'destination_location_code': 'A-01',
        'reason_code': 'NORMAL',
        'error_message': null,
        'sync_state': 'synced',
        'started_at': '2026-03-23T02:00:00.000Z',
        'updated_at': '2026-03-23T02:03:00.000Z',
        'submitted_at': '2026-03-23T02:04:00.000Z',
      };

      final dto = ScanSessionDraftDto.fromJson(json);
      final encoded = dto.toJson();

      expect(dto.mode, ScanMode.receive);
      expect(dto.state, ScanSessionState.formReady);
      expect(dto.syncState, SyncState.synced);
      expect(encoded['camera_granted'], true);
      expect(encoded['resolved_item_code'], 'ITEM-02');
      expect(encoded['destination_location_code'], 'A-01');
      expect(encoded['state'], 'form_ready');
    });

    test('ShipmentDto round-trips nested location and actions', () {
      final json = <String, dynamic>{
        'id': 'shipment-001',
        'shipment_no': 'SHP-001',
        'status': 'loading',
        'owner': <String, dynamic>{
          'id': 'owner-01',
          'code': 'OWN01',
          'name': 'Owner One',
        },
        'warehouse': <String, dynamic>{
          'id': 'wh-01',
          'code': 'WH01',
          'name': 'Main Warehouse',
        },
        'vehicle': <String, dynamic>{
          'plate_number': '51C-67890',
          'driver_name': 'Tran Van B',
        },
        'sales_order_no': 'SO-1122',
        'bill_of_lading_no': 'BOL-100',
        'expected_weight_kg': 900.0,
        'shipped_weight_kg': 875.5,
        'variance_weight_kg': -24.5,
        'sync_state': 'pending',
        'available_actions': <Map<String, dynamic>>[
          <String, dynamic>{
            'type': 'start_picking',
            'label': 'Start picking',
            'enabled': true,
          },
        ],
        'lines': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'ship-line-1',
            'item_code': 'ITEM-03',
            'item_name': 'Corn',
            'uom_code': 'BAG',
            'expected_qty': 50.0,
            'shipped_qty': 48.0,
            'short_pick': true,
            'source_location': <String, dynamic>{
              'id': 'loc-01',
              'code': 'B-02',
              'name': 'Rack B-02',
            },
          },
        ],
        'note': 'Partial shipment',
        'error_message': null,
        'created_at': '2026-03-23T03:00:00.000Z',
        'updated_at': '2026-03-23T03:15:00.000Z',
      };

      final dto = ShipmentDto.fromJson(json);
      final encoded = dto.toJson();

      expect(dto.status, ShipmentStatus.loading);
      expect(dto.availableActions.single.type, TaskActionType.startPicking);
      expect(dto.lines.single.shortPick, isTrue);
      expect(dto.lines.single.sourceLocation?.code, 'B-02');
      expect(
        (encoded['lines'] as List<dynamic>).single,
        isA<Map<String, dynamic>>().having(
          (value) => value['source_location']['code'],
          'source_location.code',
          'B-02',
        ),
      );
      expect(encoded['status'], 'loading');
    });

    test('OcrRecordDto round-trips extracted fields and review flags', () {
      final json = <String, dynamic>{
        'id': 'ocr-001',
        'direction': 'inbound',
        'status': 'review_required',
        'confidence_score': 0.82,
        'confidence_level': 'medium',
        'extracted_fields': <String, dynamic>{
          'document_no': 'DOC-001',
          'vehicle_plate': '51A-12345',
          'owner_code': 'OWN01',
          'owner_name': 'Owner One',
          'item_code': 'ITEM-01',
          'item_name': 'Rice',
          'gross_weight_kg': 1300.0,
          'net_weight_kg': 1200.0,
        },
        'review_flags': <Map<String, dynamic>>[
          <String, dynamic>{
            'fieldName': 'gross_weight_kg',
            'rawValue': '1300',
            'confidenceScore': 0.61,
            'level': 'medium',
            'requiredReview': true,
          },
        ],
        'source_image_url': 'https://example.com/ocr-001.jpg',
        'linked_target_type': 'receipt',
        'linked_target_id': 'receipt-001',
        'linked_target_no': 'RCP-001',
        'error_message': null,
        'captured_at': '2026-03-23T04:00:00.000Z',
        'processed_at': '2026-03-23T04:01:00.000Z',
        'linked_at': null,
        'sync_state': 'failed',
      };

      final dto = OcrRecordDto.fromJson(json);
      final encoded = dto.toJson();

      expect(dto.direction, DocumentDirection.inbound);
      expect(dto.status, OcrRecordStatus.reviewRequired);
      expect(dto.confidenceLevel, ConfidenceLevel.medium);
      expect(dto.reviewFlags.single.requiredReview, isTrue);
      expect(
        encoded['extracted_fields'],
        isA<Map<String, dynamic>>().having(
          (value) => value['document_no'],
          'document_no',
          'DOC-001',
        ),
      );
      expect(
        (encoded['review_flags'] as List<dynamic>).single,
        isA<Map<String, dynamic>>().having(
          (value) => value['requiredReview'],
          'requiredReview',
          true,
        ),
      );
      expect(encoded['status'], 'review_required');
    });
  });
}
