import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('Task contracts', () {
    final Map<String, dynamic> taskJson = <String, dynamic>{
      'id': 'task-001',
      'type': 'receipt',
      'status': 'open',
      'severity': 'critical',
      'title': 'Inbound shipment delayed',
      'description': 'Dock 04 is waiting for weigh-in.',
      'source_module': 'inbound',
      'source_entity_type': 'receipt',
      'source_entity_id': 'receipt-123',
      'source_entity_no': 'INF-2023-9082',
      'route_name': 'receipt_detail',
      'route_params': <String, String>{'receiptId': 'receipt-123'},
      'age_minutes': 24,
      'due_at': '2026-03-23T09:30:00.000Z',
      'created_at': '2026-03-23T09:06:00.000Z',
      'primary_action': <String, dynamic>{
        'type': 'start_weighing',
        'label': 'Bắt đầu cân',
        'route_name': 'receipt_detail',
        'route_params': <String, String>{'receiptId': 'receipt-123'},
        'enabled': true,
      },
      'secondary_actions': <Map<String, dynamic>>[
        <String, dynamic>{
          'type': 'acknowledge',
          'label': 'Đã hiểu',
          'enabled': true,
        },
      ],
      'sync_state': 'pending',
    };

    test('TaskItemDto deserializes agreed enum values', () {
      final dto = TaskItemDto.fromJson(taskJson);

      expect(dto.type, TaskItemType.receipt);
      expect(dto.status, TaskItemStatus.open);
      expect(dto.primaryAction.type, TaskActionType.startWeighing);
      expect(dto.syncState, SyncState.pending);
      expect(dto.secondaryActions.single.type, TaskActionType.acknowledge);
    });

    test('TaskItemDto serializes back to snake_case payloads', () {
      final dto = TaskItemDto.fromJson(taskJson);
      final encoded = dto.toJson();

      expect(encoded['type'], 'receipt');
      expect(encoded['status'], 'open');
      expect(encoded['severity'], 'critical');
      expect(
        encoded['primary_action'],
        isA<Map<String, dynamic>>().having(
          (value) => value['type'],
          'type',
          'start_weighing',
        ),
      );
      expect(encoded['sync_state'], 'pending');
    });

    test('TaskItemDto maps into TaskItemEntity without naming drift', () {
      final dto = TaskItemDto.fromJson(taskJson);
      final entity = dto.toEntity();

      expect(entity.id, 'task-001');
      expect(entity.type, TaskItemType.receipt);
      expect(entity.status, TaskItemStatus.open);
      expect(entity.primaryAction.type, TaskActionType.startWeighing);
      expect(entity.routeParams?['receiptId'], 'receipt-123');
      expect(entity.syncState, SyncState.pending);
    });
  });
}
