import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

part 'task_item_contract.freezed.dart';
part 'task_item_contract.g.dart';

@freezed
abstract class TaskItemEntity with _$TaskItemEntity {
  @JsonSerializable(explicitToJson: true)
  const factory TaskItemEntity({
    required String id,
    required TaskItemType type,
    required TaskItemStatus status,
    required Severity severity,
    required String title,
    String? description,
    required String sourceModule,
    String? sourceEntityType,
    String? sourceEntityId,
    String? sourceEntityNo,
    String? routeName,
    Map<String, String>? routeParams,
    int? ageMinutes,
    DateTime? dueAt,
    required DateTime createdAt,
    required ActionCapability primaryAction,
    @Default(<ActionCapability>[]) List<ActionCapability> secondaryActions,
    required SyncState syncState,
  }) = _TaskItemEntity;

  factory TaskItemEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskItemEntityFromJson(json);
}

@freezed
abstract class TaskItemDto with _$TaskItemDto {
  @JsonSerializable(explicitToJson: true)
  const factory TaskItemDto({
    required String id,
    required TaskItemType type,
    required TaskItemStatus status,
    required Severity severity,
    required String title,
    String? description,
    @JsonKey(name: 'source_module') required String sourceModule,
    @JsonKey(name: 'source_entity_type') String? sourceEntityType,
    @JsonKey(name: 'source_entity_id') String? sourceEntityId,
    @JsonKey(name: 'source_entity_no') String? sourceEntityNo,
    @JsonKey(name: 'route_name') String? routeName,
    @JsonKey(name: 'route_params') Map<String, String>? routeParams,
    @JsonKey(name: 'age_minutes') int? ageMinutes,
    @JsonKey(name: 'due_at') DateTime? dueAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'primary_action') required ActionCapability primaryAction,
    @JsonKey(name: 'secondary_actions')
    @Default(<ActionCapability>[])
    List<ActionCapability> secondaryActions,
    @JsonKey(name: 'sync_state') required SyncState syncState,
  }) = _TaskItemDto;

  factory TaskItemDto.fromJson(Map<String, dynamic> json) =>
      _$TaskItemDtoFromJson(json);
}

extension TaskItemDtoMapper on TaskItemDto {
  TaskItemEntity toEntity() {
    return TaskItemEntity(
      id: id,
      type: type,
      status: status,
      severity: severity,
      title: title,
      description: description,
      sourceModule: sourceModule,
      sourceEntityType: sourceEntityType,
      sourceEntityId: sourceEntityId,
      sourceEntityNo: sourceEntityNo,
      routeName: routeName,
      routeParams: routeParams,
      ageMinutes: ageMinutes,
      dueAt: dueAt,
      createdAt: createdAt,
      primaryAction: primaryAction,
      secondaryActions: secondaryActions,
      syncState: syncState,
    );
  }
}
