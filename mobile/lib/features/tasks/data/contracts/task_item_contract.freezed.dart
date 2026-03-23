// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_item_contract.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskItemEntity {

 String get id; TaskItemType get type; TaskItemStatus get status; Severity get severity; String get title; String? get description; String get sourceModule; String? get sourceEntityType; String? get sourceEntityId; String? get sourceEntityNo; String? get routeName; Map<String, String>? get routeParams; int? get ageMinutes; DateTime? get dueAt; DateTime get createdAt; ActionCapability get primaryAction; List<ActionCapability> get secondaryActions; SyncState get syncState;
/// Create a copy of TaskItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskItemEntityCopyWith<TaskItemEntity> get copyWith => _$TaskItemEntityCopyWithImpl<TaskItemEntity>(this as TaskItemEntity, _$identity);

  /// Serializes this TaskItemEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.sourceEntityType, sourceEntityType) || other.sourceEntityType == sourceEntityType)&&(identical(other.sourceEntityId, sourceEntityId) || other.sourceEntityId == sourceEntityId)&&(identical(other.sourceEntityNo, sourceEntityNo) || other.sourceEntityNo == sourceEntityNo)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other.routeParams, routeParams)&&(identical(other.ageMinutes, ageMinutes) || other.ageMinutes == ageMinutes)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.primaryAction, primaryAction) || other.primaryAction == primaryAction)&&const DeepCollectionEquality().equals(other.secondaryActions, secondaryActions)&&(identical(other.syncState, syncState) || other.syncState == syncState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,severity,title,description,sourceModule,sourceEntityType,sourceEntityId,sourceEntityNo,routeName,const DeepCollectionEquality().hash(routeParams),ageMinutes,dueAt,createdAt,primaryAction,const DeepCollectionEquality().hash(secondaryActions),syncState);

@override
String toString() {
  return 'TaskItemEntity(id: $id, type: $type, status: $status, severity: $severity, title: $title, description: $description, sourceModule: $sourceModule, sourceEntityType: $sourceEntityType, sourceEntityId: $sourceEntityId, sourceEntityNo: $sourceEntityNo, routeName: $routeName, routeParams: $routeParams, ageMinutes: $ageMinutes, dueAt: $dueAt, createdAt: $createdAt, primaryAction: $primaryAction, secondaryActions: $secondaryActions, syncState: $syncState)';
}


}

/// @nodoc
abstract mixin class $TaskItemEntityCopyWith<$Res>  {
  factory $TaskItemEntityCopyWith(TaskItemEntity value, $Res Function(TaskItemEntity) _then) = _$TaskItemEntityCopyWithImpl;
@useResult
$Res call({
 String id, TaskItemType type, TaskItemStatus status, Severity severity, String title, String? description, String sourceModule, String? sourceEntityType, String? sourceEntityId, String? sourceEntityNo, String? routeName, Map<String, String>? routeParams, int? ageMinutes, DateTime? dueAt, DateTime createdAt, ActionCapability primaryAction, List<ActionCapability> secondaryActions, SyncState syncState
});


$ActionCapabilityCopyWith<$Res> get primaryAction;

}
/// @nodoc
class _$TaskItemEntityCopyWithImpl<$Res>
    implements $TaskItemEntityCopyWith<$Res> {
  _$TaskItemEntityCopyWithImpl(this._self, this._then);

  final TaskItemEntity _self;
  final $Res Function(TaskItemEntity) _then;

/// Create a copy of TaskItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? status = null,Object? severity = null,Object? title = null,Object? description = freezed,Object? sourceModule = null,Object? sourceEntityType = freezed,Object? sourceEntityId = freezed,Object? sourceEntityNo = freezed,Object? routeName = freezed,Object? routeParams = freezed,Object? ageMinutes = freezed,Object? dueAt = freezed,Object? createdAt = null,Object? primaryAction = null,Object? secondaryActions = null,Object? syncState = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskItemType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskItemStatus,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,sourceEntityType: freezed == sourceEntityType ? _self.sourceEntityType : sourceEntityType // ignore: cast_nullable_to_non_nullable
as String?,sourceEntityId: freezed == sourceEntityId ? _self.sourceEntityId : sourceEntityId // ignore: cast_nullable_to_non_nullable
as String?,sourceEntityNo: freezed == sourceEntityNo ? _self.sourceEntityNo : sourceEntityNo // ignore: cast_nullable_to_non_nullable
as String?,routeName: freezed == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String?,routeParams: freezed == routeParams ? _self.routeParams : routeParams // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,ageMinutes: freezed == ageMinutes ? _self.ageMinutes : ageMinutes // ignore: cast_nullable_to_non_nullable
as int?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,primaryAction: null == primaryAction ? _self.primaryAction : primaryAction // ignore: cast_nullable_to_non_nullable
as ActionCapability,secondaryActions: null == secondaryActions ? _self.secondaryActions : secondaryActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,
  ));
}
/// Create a copy of TaskItemEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionCapabilityCopyWith<$Res> get primaryAction {
  
  return $ActionCapabilityCopyWith<$Res>(_self.primaryAction, (value) {
    return _then(_self.copyWith(primaryAction: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskItemEntity].
extension TaskItemEntityPatterns on TaskItemEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskItemEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _TaskItemEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TaskItemEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TaskItemType type,  TaskItemStatus status,  Severity severity,  String title,  String? description,  String sourceModule,  String? sourceEntityType,  String? sourceEntityId,  String? sourceEntityNo,  String? routeName,  Map<String, String>? routeParams,  int? ageMinutes,  DateTime? dueAt,  DateTime createdAt,  ActionCapability primaryAction,  List<ActionCapability> secondaryActions,  SyncState syncState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskItemEntity() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.severity,_that.title,_that.description,_that.sourceModule,_that.sourceEntityType,_that.sourceEntityId,_that.sourceEntityNo,_that.routeName,_that.routeParams,_that.ageMinutes,_that.dueAt,_that.createdAt,_that.primaryAction,_that.secondaryActions,_that.syncState);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TaskItemType type,  TaskItemStatus status,  Severity severity,  String title,  String? description,  String sourceModule,  String? sourceEntityType,  String? sourceEntityId,  String? sourceEntityNo,  String? routeName,  Map<String, String>? routeParams,  int? ageMinutes,  DateTime? dueAt,  DateTime createdAt,  ActionCapability primaryAction,  List<ActionCapability> secondaryActions,  SyncState syncState)  $default,) {final _that = this;
switch (_that) {
case _TaskItemEntity():
return $default(_that.id,_that.type,_that.status,_that.severity,_that.title,_that.description,_that.sourceModule,_that.sourceEntityType,_that.sourceEntityId,_that.sourceEntityNo,_that.routeName,_that.routeParams,_that.ageMinutes,_that.dueAt,_that.createdAt,_that.primaryAction,_that.secondaryActions,_that.syncState);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TaskItemType type,  TaskItemStatus status,  Severity severity,  String title,  String? description,  String sourceModule,  String? sourceEntityType,  String? sourceEntityId,  String? sourceEntityNo,  String? routeName,  Map<String, String>? routeParams,  int? ageMinutes,  DateTime? dueAt,  DateTime createdAt,  ActionCapability primaryAction,  List<ActionCapability> secondaryActions,  SyncState syncState)?  $default,) {final _that = this;
switch (_that) {
case _TaskItemEntity() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.severity,_that.title,_that.description,_that.sourceModule,_that.sourceEntityType,_that.sourceEntityId,_that.sourceEntityNo,_that.routeName,_that.routeParams,_that.ageMinutes,_that.dueAt,_that.createdAt,_that.primaryAction,_that.secondaryActions,_that.syncState);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TaskItemEntity implements TaskItemEntity {
  const _TaskItemEntity({required this.id, required this.type, required this.status, required this.severity, required this.title, this.description, required this.sourceModule, this.sourceEntityType, this.sourceEntityId, this.sourceEntityNo, this.routeName, final  Map<String, String>? routeParams, this.ageMinutes, this.dueAt, required this.createdAt, required this.primaryAction, final  List<ActionCapability> secondaryActions = const <ActionCapability>[], required this.syncState}): _routeParams = routeParams,_secondaryActions = secondaryActions;
  factory _TaskItemEntity.fromJson(Map<String, dynamic> json) => _$TaskItemEntityFromJson(json);

@override final  String id;
@override final  TaskItemType type;
@override final  TaskItemStatus status;
@override final  Severity severity;
@override final  String title;
@override final  String? description;
@override final  String sourceModule;
@override final  String? sourceEntityType;
@override final  String? sourceEntityId;
@override final  String? sourceEntityNo;
@override final  String? routeName;
 final  Map<String, String>? _routeParams;
@override Map<String, String>? get routeParams {
  final value = _routeParams;
  if (value == null) return null;
  if (_routeParams is EqualUnmodifiableMapView) return _routeParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  int? ageMinutes;
@override final  DateTime? dueAt;
@override final  DateTime createdAt;
@override final  ActionCapability primaryAction;
 final  List<ActionCapability> _secondaryActions;
@override@JsonKey() List<ActionCapability> get secondaryActions {
  if (_secondaryActions is EqualUnmodifiableListView) return _secondaryActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secondaryActions);
}

@override final  SyncState syncState;

/// Create a copy of TaskItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskItemEntityCopyWith<_TaskItemEntity> get copyWith => __$TaskItemEntityCopyWithImpl<_TaskItemEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskItemEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.sourceEntityType, sourceEntityType) || other.sourceEntityType == sourceEntityType)&&(identical(other.sourceEntityId, sourceEntityId) || other.sourceEntityId == sourceEntityId)&&(identical(other.sourceEntityNo, sourceEntityNo) || other.sourceEntityNo == sourceEntityNo)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other._routeParams, _routeParams)&&(identical(other.ageMinutes, ageMinutes) || other.ageMinutes == ageMinutes)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.primaryAction, primaryAction) || other.primaryAction == primaryAction)&&const DeepCollectionEquality().equals(other._secondaryActions, _secondaryActions)&&(identical(other.syncState, syncState) || other.syncState == syncState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,severity,title,description,sourceModule,sourceEntityType,sourceEntityId,sourceEntityNo,routeName,const DeepCollectionEquality().hash(_routeParams),ageMinutes,dueAt,createdAt,primaryAction,const DeepCollectionEquality().hash(_secondaryActions),syncState);

@override
String toString() {
  return 'TaskItemEntity(id: $id, type: $type, status: $status, severity: $severity, title: $title, description: $description, sourceModule: $sourceModule, sourceEntityType: $sourceEntityType, sourceEntityId: $sourceEntityId, sourceEntityNo: $sourceEntityNo, routeName: $routeName, routeParams: $routeParams, ageMinutes: $ageMinutes, dueAt: $dueAt, createdAt: $createdAt, primaryAction: $primaryAction, secondaryActions: $secondaryActions, syncState: $syncState)';
}


}

/// @nodoc
abstract mixin class _$TaskItemEntityCopyWith<$Res> implements $TaskItemEntityCopyWith<$Res> {
  factory _$TaskItemEntityCopyWith(_TaskItemEntity value, $Res Function(_TaskItemEntity) _then) = __$TaskItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, TaskItemType type, TaskItemStatus status, Severity severity, String title, String? description, String sourceModule, String? sourceEntityType, String? sourceEntityId, String? sourceEntityNo, String? routeName, Map<String, String>? routeParams, int? ageMinutes, DateTime? dueAt, DateTime createdAt, ActionCapability primaryAction, List<ActionCapability> secondaryActions, SyncState syncState
});


@override $ActionCapabilityCopyWith<$Res> get primaryAction;

}
/// @nodoc
class __$TaskItemEntityCopyWithImpl<$Res>
    implements _$TaskItemEntityCopyWith<$Res> {
  __$TaskItemEntityCopyWithImpl(this._self, this._then);

  final _TaskItemEntity _self;
  final $Res Function(_TaskItemEntity) _then;

/// Create a copy of TaskItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? status = null,Object? severity = null,Object? title = null,Object? description = freezed,Object? sourceModule = null,Object? sourceEntityType = freezed,Object? sourceEntityId = freezed,Object? sourceEntityNo = freezed,Object? routeName = freezed,Object? routeParams = freezed,Object? ageMinutes = freezed,Object? dueAt = freezed,Object? createdAt = null,Object? primaryAction = null,Object? secondaryActions = null,Object? syncState = null,}) {
  return _then(_TaskItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskItemType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskItemStatus,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,sourceEntityType: freezed == sourceEntityType ? _self.sourceEntityType : sourceEntityType // ignore: cast_nullable_to_non_nullable
as String?,sourceEntityId: freezed == sourceEntityId ? _self.sourceEntityId : sourceEntityId // ignore: cast_nullable_to_non_nullable
as String?,sourceEntityNo: freezed == sourceEntityNo ? _self.sourceEntityNo : sourceEntityNo // ignore: cast_nullable_to_non_nullable
as String?,routeName: freezed == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String?,routeParams: freezed == routeParams ? _self._routeParams : routeParams // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,ageMinutes: freezed == ageMinutes ? _self.ageMinutes : ageMinutes // ignore: cast_nullable_to_non_nullable
as int?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,primaryAction: null == primaryAction ? _self.primaryAction : primaryAction // ignore: cast_nullable_to_non_nullable
as ActionCapability,secondaryActions: null == secondaryActions ? _self._secondaryActions : secondaryActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,
  ));
}

/// Create a copy of TaskItemEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionCapabilityCopyWith<$Res> get primaryAction {
  
  return $ActionCapabilityCopyWith<$Res>(_self.primaryAction, (value) {
    return _then(_self.copyWith(primaryAction: value));
  });
}
}


/// @nodoc
mixin _$TaskItemDto {

 String get id; TaskItemType get type; TaskItemStatus get status; Severity get severity; String get title; String? get description;@JsonKey(name: 'source_module') String get sourceModule;@JsonKey(name: 'source_entity_type') String? get sourceEntityType;@JsonKey(name: 'source_entity_id') String? get sourceEntityId;@JsonKey(name: 'source_entity_no') String? get sourceEntityNo;@JsonKey(name: 'route_name') String? get routeName;@JsonKey(name: 'route_params') Map<String, String>? get routeParams;@JsonKey(name: 'age_minutes') int? get ageMinutes;@JsonKey(name: 'due_at') DateTime? get dueAt;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'primary_action') ActionCapability get primaryAction;@JsonKey(name: 'secondary_actions') List<ActionCapability> get secondaryActions;@JsonKey(name: 'sync_state') SyncState get syncState;
/// Create a copy of TaskItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskItemDtoCopyWith<TaskItemDto> get copyWith => _$TaskItemDtoCopyWithImpl<TaskItemDto>(this as TaskItemDto, _$identity);

  /// Serializes this TaskItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.sourceEntityType, sourceEntityType) || other.sourceEntityType == sourceEntityType)&&(identical(other.sourceEntityId, sourceEntityId) || other.sourceEntityId == sourceEntityId)&&(identical(other.sourceEntityNo, sourceEntityNo) || other.sourceEntityNo == sourceEntityNo)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other.routeParams, routeParams)&&(identical(other.ageMinutes, ageMinutes) || other.ageMinutes == ageMinutes)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.primaryAction, primaryAction) || other.primaryAction == primaryAction)&&const DeepCollectionEquality().equals(other.secondaryActions, secondaryActions)&&(identical(other.syncState, syncState) || other.syncState == syncState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,severity,title,description,sourceModule,sourceEntityType,sourceEntityId,sourceEntityNo,routeName,const DeepCollectionEquality().hash(routeParams),ageMinutes,dueAt,createdAt,primaryAction,const DeepCollectionEquality().hash(secondaryActions),syncState);

@override
String toString() {
  return 'TaskItemDto(id: $id, type: $type, status: $status, severity: $severity, title: $title, description: $description, sourceModule: $sourceModule, sourceEntityType: $sourceEntityType, sourceEntityId: $sourceEntityId, sourceEntityNo: $sourceEntityNo, routeName: $routeName, routeParams: $routeParams, ageMinutes: $ageMinutes, dueAt: $dueAt, createdAt: $createdAt, primaryAction: $primaryAction, secondaryActions: $secondaryActions, syncState: $syncState)';
}


}

/// @nodoc
abstract mixin class $TaskItemDtoCopyWith<$Res>  {
  factory $TaskItemDtoCopyWith(TaskItemDto value, $Res Function(TaskItemDto) _then) = _$TaskItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, TaskItemType type, TaskItemStatus status, Severity severity, String title, String? description,@JsonKey(name: 'source_module') String sourceModule,@JsonKey(name: 'source_entity_type') String? sourceEntityType,@JsonKey(name: 'source_entity_id') String? sourceEntityId,@JsonKey(name: 'source_entity_no') String? sourceEntityNo,@JsonKey(name: 'route_name') String? routeName,@JsonKey(name: 'route_params') Map<String, String>? routeParams,@JsonKey(name: 'age_minutes') int? ageMinutes,@JsonKey(name: 'due_at') DateTime? dueAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'primary_action') ActionCapability primaryAction,@JsonKey(name: 'secondary_actions') List<ActionCapability> secondaryActions,@JsonKey(name: 'sync_state') SyncState syncState
});


$ActionCapabilityCopyWith<$Res> get primaryAction;

}
/// @nodoc
class _$TaskItemDtoCopyWithImpl<$Res>
    implements $TaskItemDtoCopyWith<$Res> {
  _$TaskItemDtoCopyWithImpl(this._self, this._then);

  final TaskItemDto _self;
  final $Res Function(TaskItemDto) _then;

/// Create a copy of TaskItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? status = null,Object? severity = null,Object? title = null,Object? description = freezed,Object? sourceModule = null,Object? sourceEntityType = freezed,Object? sourceEntityId = freezed,Object? sourceEntityNo = freezed,Object? routeName = freezed,Object? routeParams = freezed,Object? ageMinutes = freezed,Object? dueAt = freezed,Object? createdAt = null,Object? primaryAction = null,Object? secondaryActions = null,Object? syncState = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskItemType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskItemStatus,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,sourceEntityType: freezed == sourceEntityType ? _self.sourceEntityType : sourceEntityType // ignore: cast_nullable_to_non_nullable
as String?,sourceEntityId: freezed == sourceEntityId ? _self.sourceEntityId : sourceEntityId // ignore: cast_nullable_to_non_nullable
as String?,sourceEntityNo: freezed == sourceEntityNo ? _self.sourceEntityNo : sourceEntityNo // ignore: cast_nullable_to_non_nullable
as String?,routeName: freezed == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String?,routeParams: freezed == routeParams ? _self.routeParams : routeParams // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,ageMinutes: freezed == ageMinutes ? _self.ageMinutes : ageMinutes // ignore: cast_nullable_to_non_nullable
as int?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,primaryAction: null == primaryAction ? _self.primaryAction : primaryAction // ignore: cast_nullable_to_non_nullable
as ActionCapability,secondaryActions: null == secondaryActions ? _self.secondaryActions : secondaryActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,
  ));
}
/// Create a copy of TaskItemDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionCapabilityCopyWith<$Res> get primaryAction {
  
  return $ActionCapabilityCopyWith<$Res>(_self.primaryAction, (value) {
    return _then(_self.copyWith(primaryAction: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskItemDto].
extension TaskItemDtoPatterns on TaskItemDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskItemDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskItemDto value)  $default,){
final _that = this;
switch (_that) {
case _TaskItemDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _TaskItemDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TaskItemType type,  TaskItemStatus status,  Severity severity,  String title,  String? description, @JsonKey(name: 'source_module')  String sourceModule, @JsonKey(name: 'source_entity_type')  String? sourceEntityType, @JsonKey(name: 'source_entity_id')  String? sourceEntityId, @JsonKey(name: 'source_entity_no')  String? sourceEntityNo, @JsonKey(name: 'route_name')  String? routeName, @JsonKey(name: 'route_params')  Map<String, String>? routeParams, @JsonKey(name: 'age_minutes')  int? ageMinutes, @JsonKey(name: 'due_at')  DateTime? dueAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'primary_action')  ActionCapability primaryAction, @JsonKey(name: 'secondary_actions')  List<ActionCapability> secondaryActions, @JsonKey(name: 'sync_state')  SyncState syncState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskItemDto() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.severity,_that.title,_that.description,_that.sourceModule,_that.sourceEntityType,_that.sourceEntityId,_that.sourceEntityNo,_that.routeName,_that.routeParams,_that.ageMinutes,_that.dueAt,_that.createdAt,_that.primaryAction,_that.secondaryActions,_that.syncState);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TaskItemType type,  TaskItemStatus status,  Severity severity,  String title,  String? description, @JsonKey(name: 'source_module')  String sourceModule, @JsonKey(name: 'source_entity_type')  String? sourceEntityType, @JsonKey(name: 'source_entity_id')  String? sourceEntityId, @JsonKey(name: 'source_entity_no')  String? sourceEntityNo, @JsonKey(name: 'route_name')  String? routeName, @JsonKey(name: 'route_params')  Map<String, String>? routeParams, @JsonKey(name: 'age_minutes')  int? ageMinutes, @JsonKey(name: 'due_at')  DateTime? dueAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'primary_action')  ActionCapability primaryAction, @JsonKey(name: 'secondary_actions')  List<ActionCapability> secondaryActions, @JsonKey(name: 'sync_state')  SyncState syncState)  $default,) {final _that = this;
switch (_that) {
case _TaskItemDto():
return $default(_that.id,_that.type,_that.status,_that.severity,_that.title,_that.description,_that.sourceModule,_that.sourceEntityType,_that.sourceEntityId,_that.sourceEntityNo,_that.routeName,_that.routeParams,_that.ageMinutes,_that.dueAt,_that.createdAt,_that.primaryAction,_that.secondaryActions,_that.syncState);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TaskItemType type,  TaskItemStatus status,  Severity severity,  String title,  String? description, @JsonKey(name: 'source_module')  String sourceModule, @JsonKey(name: 'source_entity_type')  String? sourceEntityType, @JsonKey(name: 'source_entity_id')  String? sourceEntityId, @JsonKey(name: 'source_entity_no')  String? sourceEntityNo, @JsonKey(name: 'route_name')  String? routeName, @JsonKey(name: 'route_params')  Map<String, String>? routeParams, @JsonKey(name: 'age_minutes')  int? ageMinutes, @JsonKey(name: 'due_at')  DateTime? dueAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'primary_action')  ActionCapability primaryAction, @JsonKey(name: 'secondary_actions')  List<ActionCapability> secondaryActions, @JsonKey(name: 'sync_state')  SyncState syncState)?  $default,) {final _that = this;
switch (_that) {
case _TaskItemDto() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.severity,_that.title,_that.description,_that.sourceModule,_that.sourceEntityType,_that.sourceEntityId,_that.sourceEntityNo,_that.routeName,_that.routeParams,_that.ageMinutes,_that.dueAt,_that.createdAt,_that.primaryAction,_that.secondaryActions,_that.syncState);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TaskItemDto implements TaskItemDto {
  const _TaskItemDto({required this.id, required this.type, required this.status, required this.severity, required this.title, this.description, @JsonKey(name: 'source_module') required this.sourceModule, @JsonKey(name: 'source_entity_type') this.sourceEntityType, @JsonKey(name: 'source_entity_id') this.sourceEntityId, @JsonKey(name: 'source_entity_no') this.sourceEntityNo, @JsonKey(name: 'route_name') this.routeName, @JsonKey(name: 'route_params') final  Map<String, String>? routeParams, @JsonKey(name: 'age_minutes') this.ageMinutes, @JsonKey(name: 'due_at') this.dueAt, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'primary_action') required this.primaryAction, @JsonKey(name: 'secondary_actions') final  List<ActionCapability> secondaryActions = const <ActionCapability>[], @JsonKey(name: 'sync_state') required this.syncState}): _routeParams = routeParams,_secondaryActions = secondaryActions;
  factory _TaskItemDto.fromJson(Map<String, dynamic> json) => _$TaskItemDtoFromJson(json);

@override final  String id;
@override final  TaskItemType type;
@override final  TaskItemStatus status;
@override final  Severity severity;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'source_module') final  String sourceModule;
@override@JsonKey(name: 'source_entity_type') final  String? sourceEntityType;
@override@JsonKey(name: 'source_entity_id') final  String? sourceEntityId;
@override@JsonKey(name: 'source_entity_no') final  String? sourceEntityNo;
@override@JsonKey(name: 'route_name') final  String? routeName;
 final  Map<String, String>? _routeParams;
@override@JsonKey(name: 'route_params') Map<String, String>? get routeParams {
  final value = _routeParams;
  if (value == null) return null;
  if (_routeParams is EqualUnmodifiableMapView) return _routeParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'age_minutes') final  int? ageMinutes;
@override@JsonKey(name: 'due_at') final  DateTime? dueAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'primary_action') final  ActionCapability primaryAction;
 final  List<ActionCapability> _secondaryActions;
@override@JsonKey(name: 'secondary_actions') List<ActionCapability> get secondaryActions {
  if (_secondaryActions is EqualUnmodifiableListView) return _secondaryActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secondaryActions);
}

@override@JsonKey(name: 'sync_state') final  SyncState syncState;

/// Create a copy of TaskItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskItemDtoCopyWith<_TaskItemDto> get copyWith => __$TaskItemDtoCopyWithImpl<_TaskItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.sourceEntityType, sourceEntityType) || other.sourceEntityType == sourceEntityType)&&(identical(other.sourceEntityId, sourceEntityId) || other.sourceEntityId == sourceEntityId)&&(identical(other.sourceEntityNo, sourceEntityNo) || other.sourceEntityNo == sourceEntityNo)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other._routeParams, _routeParams)&&(identical(other.ageMinutes, ageMinutes) || other.ageMinutes == ageMinutes)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.primaryAction, primaryAction) || other.primaryAction == primaryAction)&&const DeepCollectionEquality().equals(other._secondaryActions, _secondaryActions)&&(identical(other.syncState, syncState) || other.syncState == syncState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,severity,title,description,sourceModule,sourceEntityType,sourceEntityId,sourceEntityNo,routeName,const DeepCollectionEquality().hash(_routeParams),ageMinutes,dueAt,createdAt,primaryAction,const DeepCollectionEquality().hash(_secondaryActions),syncState);

@override
String toString() {
  return 'TaskItemDto(id: $id, type: $type, status: $status, severity: $severity, title: $title, description: $description, sourceModule: $sourceModule, sourceEntityType: $sourceEntityType, sourceEntityId: $sourceEntityId, sourceEntityNo: $sourceEntityNo, routeName: $routeName, routeParams: $routeParams, ageMinutes: $ageMinutes, dueAt: $dueAt, createdAt: $createdAt, primaryAction: $primaryAction, secondaryActions: $secondaryActions, syncState: $syncState)';
}


}

/// @nodoc
abstract mixin class _$TaskItemDtoCopyWith<$Res> implements $TaskItemDtoCopyWith<$Res> {
  factory _$TaskItemDtoCopyWith(_TaskItemDto value, $Res Function(_TaskItemDto) _then) = __$TaskItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, TaskItemType type, TaskItemStatus status, Severity severity, String title, String? description,@JsonKey(name: 'source_module') String sourceModule,@JsonKey(name: 'source_entity_type') String? sourceEntityType,@JsonKey(name: 'source_entity_id') String? sourceEntityId,@JsonKey(name: 'source_entity_no') String? sourceEntityNo,@JsonKey(name: 'route_name') String? routeName,@JsonKey(name: 'route_params') Map<String, String>? routeParams,@JsonKey(name: 'age_minutes') int? ageMinutes,@JsonKey(name: 'due_at') DateTime? dueAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'primary_action') ActionCapability primaryAction,@JsonKey(name: 'secondary_actions') List<ActionCapability> secondaryActions,@JsonKey(name: 'sync_state') SyncState syncState
});


@override $ActionCapabilityCopyWith<$Res> get primaryAction;

}
/// @nodoc
class __$TaskItemDtoCopyWithImpl<$Res>
    implements _$TaskItemDtoCopyWith<$Res> {
  __$TaskItemDtoCopyWithImpl(this._self, this._then);

  final _TaskItemDto _self;
  final $Res Function(_TaskItemDto) _then;

/// Create a copy of TaskItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? status = null,Object? severity = null,Object? title = null,Object? description = freezed,Object? sourceModule = null,Object? sourceEntityType = freezed,Object? sourceEntityId = freezed,Object? sourceEntityNo = freezed,Object? routeName = freezed,Object? routeParams = freezed,Object? ageMinutes = freezed,Object? dueAt = freezed,Object? createdAt = null,Object? primaryAction = null,Object? secondaryActions = null,Object? syncState = null,}) {
  return _then(_TaskItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskItemType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskItemStatus,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,sourceEntityType: freezed == sourceEntityType ? _self.sourceEntityType : sourceEntityType // ignore: cast_nullable_to_non_nullable
as String?,sourceEntityId: freezed == sourceEntityId ? _self.sourceEntityId : sourceEntityId // ignore: cast_nullable_to_non_nullable
as String?,sourceEntityNo: freezed == sourceEntityNo ? _self.sourceEntityNo : sourceEntityNo // ignore: cast_nullable_to_non_nullable
as String?,routeName: freezed == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String?,routeParams: freezed == routeParams ? _self._routeParams : routeParams // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,ageMinutes: freezed == ageMinutes ? _self.ageMinutes : ageMinutes // ignore: cast_nullable_to_non_nullable
as int?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,primaryAction: null == primaryAction ? _self.primaryAction : primaryAction // ignore: cast_nullable_to_non_nullable
as ActionCapability,secondaryActions: null == secondaryActions ? _self._secondaryActions : secondaryActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,
  ));
}

/// Create a copy of TaskItemDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionCapabilityCopyWith<$Res> get primaryAction {
  
  return $ActionCapabilityCopyWith<$Res>(_self.primaryAction, (value) {
    return _then(_self.copyWith(primaryAction: value));
  });
}
}

// dart format on
