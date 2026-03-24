import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';

class TaskQueueFixtureDataSource {
  TaskQueueFixtureDataSource({
    AssetBundle? assetBundle,
    this.fixturePath = _defaultFixturePath,
  }) : _assetBundle = assetBundle ?? rootBundle;

  static const String _defaultFixturePath =
      'assets/fixtures/tasks/task_queue.json';

  final AssetBundle _assetBundle;
  final String fixturePath;

  List<TaskItemDto>? _cachedItems;

  Future<List<TaskItemDto>> getTaskQueue() async {
    if (_cachedItems != null) {
      return _cachedItems!;
    }

    final rawJson = await _assetBundle.loadString(fixturePath);
    final payload = jsonDecode(rawJson) as Map<String, dynamic>;
    final itemsJson = payload['items'] as List<dynamic>;

    _cachedItems = itemsJson
        .map((entry) => TaskItemDto.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);

    return _cachedItems!;
  }
}
