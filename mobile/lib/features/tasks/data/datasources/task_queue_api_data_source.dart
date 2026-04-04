import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';

final taskQueueApiDataSourceProvider = Provider<TaskQueueApiDataSource>((
  Ref<Object?> ref,
) {
  return TaskQueueApiDataSource(httpClient: ref.watch(appHttpClientProvider));
});

class TaskQueueApiDataSource {
  TaskQueueApiDataSource({required AppHttpClient httpClient})
    : _httpClient = httpClient;

  static const String _taskQueuePath = '/api/v1/mobile/works/my';

  final AppHttpClient _httpClient;

  Future<List<TaskItemDto>> getTaskQueue() async {
    final payload = await _httpClient.getList(_taskQueuePath);

    return payload
        .map((entry) => _unwrapTaskPayload(entry))
        .map((entry) => TaskItemDto.fromJson(_normalizeTaskJson(entry)))
        .toList(growable: false);
  }

  Map<String, dynamic> _unwrapTaskPayload(Object? value, {int depth = 0}) {
    final map = _toMap(value);
    if (_looksLikeTaskPayload(map) || depth >= 4) {
      return map;
    }

    for (final key in const <String>['data', 'item', 'work', 'task']) {
      final nested = map[key];
      if (nested is! Map) {
        continue;
      }

      final unwrapped = _unwrapTaskPayload(nested, depth: depth + 1);
      if (_looksLikeTaskPayload(unwrapped) || map.length == 1) {
        return unwrapped;
      }
    }

    return map;
  }

  bool _looksLikeTaskPayload(Map<String, dynamic> payload) {
    return payload.containsKey('id') ||
        payload.containsKey('workId') ||
        payload.containsKey('title') ||
        payload.containsKey('workType') ||
        payload.containsKey('type') ||
        payload.containsKey('status') ||
        payload.containsKey('sourceModule') ||
        payload.containsKey('source_module');
  }

  Map<String, dynamic> _normalizeTaskJson(Map<String, dynamic> json) {
    final now = DateTime.now().toUtc();

    final taskType = _normalizeTaskType(
      _stringFromKeys(json, const <String>['type', 'taskType', 'workType']),
    );
    final taskStatus = _normalizeTaskStatus(
      _stringFromKeys(json, const <String>['status', 'workStatus']),
    );
    final severity = _normalizeSeverity(
      rawSeverity: _stringFromKeys(json, const <String>['severity']),
      priorityNo: _numberFromKeys(json, const <String>['priorityNo']),
    );

    final sourceModule = _normalizeSourceModule(
      _stringFromKeys(json, const <String>['source_module', 'sourceModule']),
      taskType,
    );
    final sourceEntityId = _stringFromKeys(json, const <String>[
      'source_entity_id',
      'sourceEntityId',
      'sourceRefId',
      'workHeaderId',
      'id',
    ]);
    final sourceEntityNo = _stringFromKeys(json, const <String>[
      'source_entity_no',
      'sourceEntityNo',
      'workId',
      'shipmentNumber',
      'receiptNumber',
      'documentNo',
    ]);

    final createdAt =
        _dateIsoFromKeys(json, const <String>['created_at', 'createdAt']) ??
        now.toIso8601String();
    final routeName =
        _stringFromKeys(json, const <String>['route_name', 'routeName']) ??
        _defaultRouteName(taskType, sourceEntityId: sourceEntityId);
    final routeParams = _normalizeRouteParams(
      _mapFromKeys(json, const <String>['route_params', 'routeParams']),
      routeName: routeName,
      sourceEntityId: sourceEntityId,
    );

    return <String, dynamic>{
      'id':
          _stringFromKeys(json, const <String>['id', 'workId']) ??
          'task-${now.microsecondsSinceEpoch}',
      'type': taskType,
      'status': taskStatus,
      'severity': severity,
      'title':
          _stringFromKeys(json, const <String>['title', 'workTitle']) ??
          _defaultTitle(
            sourceEntityNo: sourceEntityNo,
            sourceModule: sourceModule,
          ),
      'description': _stringFromKeys(json, const <String>[
        'description',
        'note',
        'message',
      ]),
      'source_module': sourceModule,
      'source_entity_type':
          _stringFromKeys(json, const <String>[
            'source_entity_type',
            'sourceEntityType',
            'sourceType',
          ]) ??
          _defaultEntityType(taskType),
      'source_entity_id': sourceEntityId,
      'source_entity_no': sourceEntityNo,
      'route_name': routeName,
      'route_params': routeParams,
      'age_minutes':
          _intFromKeys(json, const <String>['age_minutes', 'ageMinutes']) ??
          _computeAgeMinutes(createdAt),
      'due_at': _dateIsoFromKeys(json, const <String>['due_at', 'dueAt']),
      'created_at': createdAt,
      'primary_action': _normalizeActionJson(
        _mapFromKeys(json, const <String>['primary_action', 'primaryAction']),
        taskType: taskType,
        routeName: routeName,
        routeParams: routeParams,
      ),
      'secondary_actions': _normalizeSecondaryActions(
        _listFromKeys(json, const <String>[
          'secondary_actions',
          'secondaryActions',
        ]),
        taskType: taskType,
      ),
      'sync_state': _normalizeSyncState(
        _stringFromKeys(json, const <String>['sync_state', 'syncState']),
      ),
    };
  }

  Map<String, dynamic> _normalizeActionJson(
    Map<String, dynamic>? action, {
    required String taskType,
    required String? routeName,
    required Map<String, String>? routeParams,
  }) {
    final normalizedAction = action ?? const <String, dynamic>{};

    final actionRouteName =
        _stringFromKeys(normalizedAction, const <String>['routeName']) ??
        routeName;
    final actionRouteParams = _normalizeRouteParams(
      _mapFromKeys(normalizedAction, const <String>['routeParams']),
      routeName: actionRouteName,
      sourceEntityId: _stringFromKeys(
        routeParams ?? const <String, String>{},
        const <String>['receiptId', 'shipmentId', 'inventoryId'],
      ),
      preferredParams: routeParams,
    );

    return <String, dynamic>{
      'type': _normalizeActionType(
        _stringFromKeys(normalizedAction, const <String>['type']) ??
            _defaultActionType(taskType),
      ),
      'label':
          _stringFromKeys(normalizedAction, const <String>['label']) ??
          _defaultActionLabel(taskType),
      'routeName': actionRouteName,
      'routeParams': actionRouteParams,
      'enabled':
          _boolFromKeys(normalizedAction, const <String>['enabled']) ?? true,
    };
  }

  List<Map<String, dynamic>> _normalizeSecondaryActions(
    List<dynamic> actions, {
    required String taskType,
  }) {
    return actions
        .map(_toMap)
        .map(
          (action) => _normalizeActionJson(
            action,
            taskType: taskType,
            routeName: _stringFromKeys(action, const <String>['routeName']),
            routeParams: _normalizeRouteParams(
              _mapFromKeys(action, const <String>['routeParams']),
              routeName: _stringFromKeys(action, const <String>['routeName']),
              sourceEntityId: null,
            ),
          ),
        )
        .toList(growable: false);
  }

  String _normalizeTaskType(String? rawType) {
    final normalized = _normalizeToken(rawType);
    return switch (normalized) {
      'receipt' || 'inbound' || 'putaway' => 'receipt',
      'shipment' || 'outbound' || 'pick' || 'salesorder' => 'shipment',
      'ocr' => 'ocr',
      'inventory' || 'move' || 'transfer' || 'cyclecount' => 'inventory',
      'aisuggestion' => 'ai_suggestion',
      _ => 'system_alert',
    };
  }

  String _normalizeTaskStatus(String? rawStatus) {
    final normalized = _normalizeToken(rawStatus);
    return switch (normalized) {
      'completed' ||
      'done' ||
      'closed' ||
      'cancelled' ||
      'canceled' => 'completed',
      'acknowledged' ||
      'inprogress' ||
      'claimed' ||
      'assigned' ||
      'started' => 'acknowledged',
      'snoozed' || 'deferred' => 'snoozed',
      _ => 'open',
    };
  }

  String _normalizeSeverity({String? rawSeverity, double? priorityNo}) {
    final normalized = _normalizeToken(rawSeverity);
    if (normalized.isNotEmpty) {
      return switch (normalized) {
        'critical' => 'critical',
        'high' => 'high',
        'medium' => 'medium',
        _ => 'low',
      };
    }

    final priority = priorityNo ?? 50;
    if (priority <= 10) {
      return 'critical';
    }
    if (priority <= 30) {
      return 'high';
    }
    if (priority <= 70) {
      return 'medium';
    }

    return 'low';
  }

  String _normalizeSourceModule(String? rawSource, String taskType) {
    final source = rawSource?.trim();
    if (source != null && source.isNotEmpty) {
      return source;
    }

    return switch (taskType) {
      'receipt' => 'inbound',
      'shipment' => 'outbound',
      'ocr' => 'ocr',
      'inventory' => 'inventory',
      _ => 'system',
    };
  }

  String _defaultEntityType(String taskType) {
    return switch (taskType) {
      'receipt' => 'receipt',
      'shipment' => 'shipment',
      'ocr' => 'ocr_record',
      'inventory' => 'inventory',
      _ => 'work',
    };
  }

  String _defaultTitle({String? sourceEntityNo, required String sourceModule}) {
    final sourceNo = sourceEntityNo?.trim();
    if (sourceNo != null && sourceNo.isNotEmpty) {
      return 'Work $sourceNo';
    }

    return 'Công việc từ $sourceModule';
  }

  String _defaultActionType(String taskType) {
    return switch (taskType) {
      'receipt' => 'start_weighing',
      'shipment' => 'start_picking',
      'ocr' => 'review_ocr',
      'inventory' => 'view_inventory',
      _ => 'acknowledge',
    };
  }

  String _defaultActionLabel(String taskType) {
    return switch (taskType) {
      'receipt' => 'Mở phiếu nhập',
      'shipment' => 'Mở phiếu xuất',
      'ocr' => 'Review OCR',
      'inventory' => 'Mở tồn kho',
      _ => 'Xem chi tiết',
    };
  }

  String _normalizeActionType(String rawType) {
    final normalized = _normalizeToken(rawType);
    return switch (normalized) {
      'open' => 'open',
      'approve' => 'approve',
      'dismiss' => 'dismiss',
      'acknowledge' => 'acknowledge',
      'startweighing' => 'start_weighing',
      'startpicking' => 'start_picking',
      'reviewocr' => 'review_ocr',
      'viewinventory' => 'view_inventory',
      _ => 'custom',
    };
  }

  String _normalizeSyncState(String? rawState) {
    return switch (_normalizeToken(rawState)) {
      'pending' => 'pending',
      'failed' => 'failed',
      _ => 'synced',
    };
  }

  String _defaultRouteName(String taskType, {String? sourceEntityId}) {
    return switch (taskType) {
      'receipt' => sourceEntityId == null ? 'receipt_list' : 'receipt_detail',
      'shipment' =>
        sourceEntityId == null ? 'shipment_list' : 'shipment_detail',
      'ocr' => 'ocr_inbox',
      'inventory' => 'inventory_list',
      _ => 'home',
    };
  }

  Map<String, String>? _normalizeRouteParams(
    Map<String, dynamic>? rawParams, {
    required String? routeName,
    required String? sourceEntityId,
    Map<String, String>? preferredParams,
  }) {
    final normalized = <String, String>{};

    if (preferredParams != null) {
      normalized.addAll(preferredParams);
    }

    if (rawParams != null) {
      rawParams.forEach((String key, Object? value) {
        if (value == null) {
          return;
        }
        final text = value.toString().trim();
        if (text.isEmpty) {
          return;
        }
        normalized[key] = text;
      });
    }

    final normalizedRouteName = routeName?.trim();
    if (sourceEntityId != null && sourceEntityId.trim().isNotEmpty) {
      if (normalizedRouteName == 'receipt_detail') {
        normalized.putIfAbsent('receiptId', () => sourceEntityId.trim());
      } else if (normalizedRouteName == 'shipment_detail') {
        normalized.putIfAbsent('shipmentId', () => sourceEntityId.trim());
      } else if (normalizedRouteName == 'inventory_detail') {
        normalized.putIfAbsent('inventoryId', () => sourceEntityId.trim());
      }
    }

    return normalized.isEmpty ? null : normalized;
  }

  int? _computeAgeMinutes(String createdAtIso) {
    final createdAt = DateTime.tryParse(createdAtIso)?.toUtc();
    if (createdAt == null) {
      return null;
    }

    final diff = DateTime.now().toUtc().difference(createdAt);
    return diff.isNegative ? 0 : diff.inMinutes;
  }

  Map<String, dynamic> _toMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (Object? key, Object? nestedValue) =>
            MapEntry(key?.toString() ?? '', nestedValue),
      );
    }

    throw const FormatException('Task payload must be an object.');
  }

  Map<String, dynamic>? _mapFromKeys(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = map[key];
      if (value is Map<String, dynamic>) {
        return value;
      }
      if (value is Map) {
        return value.map(
          (Object? nestedKey, Object? nestedValue) =>
              MapEntry(nestedKey?.toString() ?? '', nestedValue),
        );
      }
    }

    return null;
  }

  List<dynamic> _listFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is List<dynamic>) {
        return value;
      }
      if (value is List) {
        return List<dynamic>.from(value);
      }
    }

    return const <dynamic>[];
  }

  String? _stringFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) {
        continue;
      }

      if (value is String) {
        final normalized = value.trim();
        if (normalized.isNotEmpty) {
          return normalized;
        }

        continue;
      }

      return value.toString();
    }

    return null;
  }

  double? _numberFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        final parsed = double.tryParse(value.trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }

    return null;
  }

  int? _intFromKeys(Map<String, dynamic> map, List<String> keys) {
    final value = _numberFromKeys(map, keys);
    return value?.round();
  }

  bool? _boolFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true') {
          return true;
        }
        if (normalized == 'false') {
          return false;
        }
      }
    }

    return null;
  }

  String? _dateIsoFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is DateTime) {
        return value.toUtc().toIso8601String();
      }
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed.toUtc().toIso8601String();
        }
      }
    }

    return null;
  }

  String _normalizeToken(String? value) {
    if (value == null) {
      return '';
    }

    return value.trim().toLowerCase().replaceAll(RegExp(r'[_\-\s]+'), '');
  }
}
