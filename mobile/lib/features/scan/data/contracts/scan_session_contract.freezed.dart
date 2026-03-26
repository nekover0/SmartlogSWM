// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_session_contract.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanSessionEntity {

 String get id; ScanMode get mode; ScanSessionState get state; bool get cameraGranted; String? get lookupCode; String? get resolvedItemCode; String? get resolvedLocationCode; String? get referenceId; String? get warehouseId; double? get quantity; double? get countedQuantity; String? get sourceLocationCode; String? get destinationLocationCode; String? get reasonCode; String? get errorMessage; SyncState get syncState; DateTime get startedAt; DateTime get updatedAt; DateTime? get submittedAt;
/// Create a copy of ScanSessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanSessionEntityCopyWith<ScanSessionEntity> get copyWith => _$ScanSessionEntityCopyWithImpl<ScanSessionEntity>(this as ScanSessionEntity, _$identity);

  /// Serializes this ScanSessionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanSessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.state, state) || other.state == state)&&(identical(other.cameraGranted, cameraGranted) || other.cameraGranted == cameraGranted)&&(identical(other.lookupCode, lookupCode) || other.lookupCode == lookupCode)&&(identical(other.resolvedItemCode, resolvedItemCode) || other.resolvedItemCode == resolvedItemCode)&&(identical(other.resolvedLocationCode, resolvedLocationCode) || other.resolvedLocationCode == resolvedLocationCode)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.countedQuantity, countedQuantity) || other.countedQuantity == countedQuantity)&&(identical(other.sourceLocationCode, sourceLocationCode) || other.sourceLocationCode == sourceLocationCode)&&(identical(other.destinationLocationCode, destinationLocationCode) || other.destinationLocationCode == destinationLocationCode)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,mode,state,cameraGranted,lookupCode,resolvedItemCode,resolvedLocationCode,referenceId,warehouseId,quantity,countedQuantity,sourceLocationCode,destinationLocationCode,reasonCode,errorMessage,syncState,startedAt,updatedAt,submittedAt]);

@override
String toString() {
  return 'ScanSessionEntity(id: $id, mode: $mode, state: $state, cameraGranted: $cameraGranted, lookupCode: $lookupCode, resolvedItemCode: $resolvedItemCode, resolvedLocationCode: $resolvedLocationCode, referenceId: $referenceId, warehouseId: $warehouseId, quantity: $quantity, countedQuantity: $countedQuantity, sourceLocationCode: $sourceLocationCode, destinationLocationCode: $destinationLocationCode, reasonCode: $reasonCode, errorMessage: $errorMessage, syncState: $syncState, startedAt: $startedAt, updatedAt: $updatedAt, submittedAt: $submittedAt)';
}


}

/// @nodoc
abstract mixin class $ScanSessionEntityCopyWith<$Res>  {
  factory $ScanSessionEntityCopyWith(ScanSessionEntity value, $Res Function(ScanSessionEntity) _then) = _$ScanSessionEntityCopyWithImpl;
@useResult
$Res call({
 String id, ScanMode mode, ScanSessionState state, bool cameraGranted, String? lookupCode, String? resolvedItemCode, String? resolvedLocationCode, String? referenceId, String? warehouseId, double? quantity, double? countedQuantity, String? sourceLocationCode, String? destinationLocationCode, String? reasonCode, String? errorMessage, SyncState syncState, DateTime startedAt, DateTime updatedAt, DateTime? submittedAt
});




}
/// @nodoc
class _$ScanSessionEntityCopyWithImpl<$Res>
    implements $ScanSessionEntityCopyWith<$Res> {
  _$ScanSessionEntityCopyWithImpl(this._self, this._then);

  final ScanSessionEntity _self;
  final $Res Function(ScanSessionEntity) _then;

/// Create a copy of ScanSessionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mode = null,Object? state = null,Object? cameraGranted = null,Object? lookupCode = freezed,Object? resolvedItemCode = freezed,Object? resolvedLocationCode = freezed,Object? referenceId = freezed,Object? warehouseId = freezed,Object? quantity = freezed,Object? countedQuantity = freezed,Object? sourceLocationCode = freezed,Object? destinationLocationCode = freezed,Object? reasonCode = freezed,Object? errorMessage = freezed,Object? syncState = null,Object? startedAt = null,Object? updatedAt = null,Object? submittedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ScanMode,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ScanSessionState,cameraGranted: null == cameraGranted ? _self.cameraGranted : cameraGranted // ignore: cast_nullable_to_non_nullable
as bool,lookupCode: freezed == lookupCode ? _self.lookupCode : lookupCode // ignore: cast_nullable_to_non_nullable
as String?,resolvedItemCode: freezed == resolvedItemCode ? _self.resolvedItemCode : resolvedItemCode // ignore: cast_nullable_to_non_nullable
as String?,resolvedLocationCode: freezed == resolvedLocationCode ? _self.resolvedLocationCode : resolvedLocationCode // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,countedQuantity: freezed == countedQuantity ? _self.countedQuantity : countedQuantity // ignore: cast_nullable_to_non_nullable
as double?,sourceLocationCode: freezed == sourceLocationCode ? _self.sourceLocationCode : sourceLocationCode // ignore: cast_nullable_to_non_nullable
as String?,destinationLocationCode: freezed == destinationLocationCode ? _self.destinationLocationCode : destinationLocationCode // ignore: cast_nullable_to_non_nullable
as String?,reasonCode: freezed == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanSessionEntity].
extension ScanSessionEntityPatterns on ScanSessionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanSessionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanSessionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanSessionEntity value)  $default,){
final _that = this;
switch (_that) {
case _ScanSessionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanSessionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ScanSessionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ScanMode mode,  ScanSessionState state,  bool cameraGranted,  String? lookupCode,  String? resolvedItemCode,  String? resolvedLocationCode,  String? referenceId,  String? warehouseId,  double? quantity,  double? countedQuantity,  String? sourceLocationCode,  String? destinationLocationCode,  String? reasonCode,  String? errorMessage,  SyncState syncState,  DateTime startedAt,  DateTime updatedAt,  DateTime? submittedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanSessionEntity() when $default != null:
return $default(_that.id,_that.mode,_that.state,_that.cameraGranted,_that.lookupCode,_that.resolvedItemCode,_that.resolvedLocationCode,_that.referenceId,_that.warehouseId,_that.quantity,_that.countedQuantity,_that.sourceLocationCode,_that.destinationLocationCode,_that.reasonCode,_that.errorMessage,_that.syncState,_that.startedAt,_that.updatedAt,_that.submittedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ScanMode mode,  ScanSessionState state,  bool cameraGranted,  String? lookupCode,  String? resolvedItemCode,  String? resolvedLocationCode,  String? referenceId,  String? warehouseId,  double? quantity,  double? countedQuantity,  String? sourceLocationCode,  String? destinationLocationCode,  String? reasonCode,  String? errorMessage,  SyncState syncState,  DateTime startedAt,  DateTime updatedAt,  DateTime? submittedAt)  $default,) {final _that = this;
switch (_that) {
case _ScanSessionEntity():
return $default(_that.id,_that.mode,_that.state,_that.cameraGranted,_that.lookupCode,_that.resolvedItemCode,_that.resolvedLocationCode,_that.referenceId,_that.warehouseId,_that.quantity,_that.countedQuantity,_that.sourceLocationCode,_that.destinationLocationCode,_that.reasonCode,_that.errorMessage,_that.syncState,_that.startedAt,_that.updatedAt,_that.submittedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ScanMode mode,  ScanSessionState state,  bool cameraGranted,  String? lookupCode,  String? resolvedItemCode,  String? resolvedLocationCode,  String? referenceId,  String? warehouseId,  double? quantity,  double? countedQuantity,  String? sourceLocationCode,  String? destinationLocationCode,  String? reasonCode,  String? errorMessage,  SyncState syncState,  DateTime startedAt,  DateTime updatedAt,  DateTime? submittedAt)?  $default,) {final _that = this;
switch (_that) {
case _ScanSessionEntity() when $default != null:
return $default(_that.id,_that.mode,_that.state,_that.cameraGranted,_that.lookupCode,_that.resolvedItemCode,_that.resolvedLocationCode,_that.referenceId,_that.warehouseId,_that.quantity,_that.countedQuantity,_that.sourceLocationCode,_that.destinationLocationCode,_that.reasonCode,_that.errorMessage,_that.syncState,_that.startedAt,_that.updatedAt,_that.submittedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ScanSessionEntity implements ScanSessionEntity {
  const _ScanSessionEntity({required this.id, required this.mode, required this.state, this.cameraGranted = false, this.lookupCode, this.resolvedItemCode, this.resolvedLocationCode, this.referenceId, this.warehouseId, this.quantity, this.countedQuantity, this.sourceLocationCode, this.destinationLocationCode, this.reasonCode, this.errorMessage, required this.syncState, required this.startedAt, required this.updatedAt, this.submittedAt});
  factory _ScanSessionEntity.fromJson(Map<String, dynamic> json) => _$ScanSessionEntityFromJson(json);

@override final  String id;
@override final  ScanMode mode;
@override final  ScanSessionState state;
@override@JsonKey() final  bool cameraGranted;
@override final  String? lookupCode;
@override final  String? resolvedItemCode;
@override final  String? resolvedLocationCode;
@override final  String? referenceId;
@override final  String? warehouseId;
@override final  double? quantity;
@override final  double? countedQuantity;
@override final  String? sourceLocationCode;
@override final  String? destinationLocationCode;
@override final  String? reasonCode;
@override final  String? errorMessage;
@override final  SyncState syncState;
@override final  DateTime startedAt;
@override final  DateTime updatedAt;
@override final  DateTime? submittedAt;

/// Create a copy of ScanSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanSessionEntityCopyWith<_ScanSessionEntity> get copyWith => __$ScanSessionEntityCopyWithImpl<_ScanSessionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanSessionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanSessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.state, state) || other.state == state)&&(identical(other.cameraGranted, cameraGranted) || other.cameraGranted == cameraGranted)&&(identical(other.lookupCode, lookupCode) || other.lookupCode == lookupCode)&&(identical(other.resolvedItemCode, resolvedItemCode) || other.resolvedItemCode == resolvedItemCode)&&(identical(other.resolvedLocationCode, resolvedLocationCode) || other.resolvedLocationCode == resolvedLocationCode)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.countedQuantity, countedQuantity) || other.countedQuantity == countedQuantity)&&(identical(other.sourceLocationCode, sourceLocationCode) || other.sourceLocationCode == sourceLocationCode)&&(identical(other.destinationLocationCode, destinationLocationCode) || other.destinationLocationCode == destinationLocationCode)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,mode,state,cameraGranted,lookupCode,resolvedItemCode,resolvedLocationCode,referenceId,warehouseId,quantity,countedQuantity,sourceLocationCode,destinationLocationCode,reasonCode,errorMessage,syncState,startedAt,updatedAt,submittedAt]);

@override
String toString() {
  return 'ScanSessionEntity(id: $id, mode: $mode, state: $state, cameraGranted: $cameraGranted, lookupCode: $lookupCode, resolvedItemCode: $resolvedItemCode, resolvedLocationCode: $resolvedLocationCode, referenceId: $referenceId, warehouseId: $warehouseId, quantity: $quantity, countedQuantity: $countedQuantity, sourceLocationCode: $sourceLocationCode, destinationLocationCode: $destinationLocationCode, reasonCode: $reasonCode, errorMessage: $errorMessage, syncState: $syncState, startedAt: $startedAt, updatedAt: $updatedAt, submittedAt: $submittedAt)';
}


}

/// @nodoc
abstract mixin class _$ScanSessionEntityCopyWith<$Res> implements $ScanSessionEntityCopyWith<$Res> {
  factory _$ScanSessionEntityCopyWith(_ScanSessionEntity value, $Res Function(_ScanSessionEntity) _then) = __$ScanSessionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, ScanMode mode, ScanSessionState state, bool cameraGranted, String? lookupCode, String? resolvedItemCode, String? resolvedLocationCode, String? referenceId, String? warehouseId, double? quantity, double? countedQuantity, String? sourceLocationCode, String? destinationLocationCode, String? reasonCode, String? errorMessage, SyncState syncState, DateTime startedAt, DateTime updatedAt, DateTime? submittedAt
});




}
/// @nodoc
class __$ScanSessionEntityCopyWithImpl<$Res>
    implements _$ScanSessionEntityCopyWith<$Res> {
  __$ScanSessionEntityCopyWithImpl(this._self, this._then);

  final _ScanSessionEntity _self;
  final $Res Function(_ScanSessionEntity) _then;

/// Create a copy of ScanSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mode = null,Object? state = null,Object? cameraGranted = null,Object? lookupCode = freezed,Object? resolvedItemCode = freezed,Object? resolvedLocationCode = freezed,Object? referenceId = freezed,Object? warehouseId = freezed,Object? quantity = freezed,Object? countedQuantity = freezed,Object? sourceLocationCode = freezed,Object? destinationLocationCode = freezed,Object? reasonCode = freezed,Object? errorMessage = freezed,Object? syncState = null,Object? startedAt = null,Object? updatedAt = null,Object? submittedAt = freezed,}) {
  return _then(_ScanSessionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ScanMode,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ScanSessionState,cameraGranted: null == cameraGranted ? _self.cameraGranted : cameraGranted // ignore: cast_nullable_to_non_nullable
as bool,lookupCode: freezed == lookupCode ? _self.lookupCode : lookupCode // ignore: cast_nullable_to_non_nullable
as String?,resolvedItemCode: freezed == resolvedItemCode ? _self.resolvedItemCode : resolvedItemCode // ignore: cast_nullable_to_non_nullable
as String?,resolvedLocationCode: freezed == resolvedLocationCode ? _self.resolvedLocationCode : resolvedLocationCode // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,countedQuantity: freezed == countedQuantity ? _self.countedQuantity : countedQuantity // ignore: cast_nullable_to_non_nullable
as double?,sourceLocationCode: freezed == sourceLocationCode ? _self.sourceLocationCode : sourceLocationCode // ignore: cast_nullable_to_non_nullable
as String?,destinationLocationCode: freezed == destinationLocationCode ? _self.destinationLocationCode : destinationLocationCode // ignore: cast_nullable_to_non_nullable
as String?,reasonCode: freezed == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ScanSessionDraftDto {

 String get id; ScanMode get mode; ScanSessionState get state;@JsonKey(name: 'camera_granted') bool get cameraGranted;@JsonKey(name: 'lookup_code') String? get lookupCode;@JsonKey(name: 'resolved_item_code') String? get resolvedItemCode;@JsonKey(name: 'resolved_location_code') String? get resolvedLocationCode;@JsonKey(name: 'reference_id') String? get referenceId;@JsonKey(name: 'warehouse_id') String? get warehouseId; double? get quantity;@JsonKey(name: 'counted_quantity') double? get countedQuantity;@JsonKey(name: 'source_location_code') String? get sourceLocationCode;@JsonKey(name: 'destination_location_code') String? get destinationLocationCode;@JsonKey(name: 'reason_code') String? get reasonCode;@JsonKey(name: 'error_message') String? get errorMessage;@JsonKey(name: 'sync_state') SyncState get syncState;@JsonKey(name: 'started_at') DateTime get startedAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;@JsonKey(name: 'submitted_at') DateTime? get submittedAt;
/// Create a copy of ScanSessionDraftDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanSessionDraftDtoCopyWith<ScanSessionDraftDto> get copyWith => _$ScanSessionDraftDtoCopyWithImpl<ScanSessionDraftDto>(this as ScanSessionDraftDto, _$identity);

  /// Serializes this ScanSessionDraftDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanSessionDraftDto&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.state, state) || other.state == state)&&(identical(other.cameraGranted, cameraGranted) || other.cameraGranted == cameraGranted)&&(identical(other.lookupCode, lookupCode) || other.lookupCode == lookupCode)&&(identical(other.resolvedItemCode, resolvedItemCode) || other.resolvedItemCode == resolvedItemCode)&&(identical(other.resolvedLocationCode, resolvedLocationCode) || other.resolvedLocationCode == resolvedLocationCode)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.countedQuantity, countedQuantity) || other.countedQuantity == countedQuantity)&&(identical(other.sourceLocationCode, sourceLocationCode) || other.sourceLocationCode == sourceLocationCode)&&(identical(other.destinationLocationCode, destinationLocationCode) || other.destinationLocationCode == destinationLocationCode)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,mode,state,cameraGranted,lookupCode,resolvedItemCode,resolvedLocationCode,referenceId,warehouseId,quantity,countedQuantity,sourceLocationCode,destinationLocationCode,reasonCode,errorMessage,syncState,startedAt,updatedAt,submittedAt]);

@override
String toString() {
  return 'ScanSessionDraftDto(id: $id, mode: $mode, state: $state, cameraGranted: $cameraGranted, lookupCode: $lookupCode, resolvedItemCode: $resolvedItemCode, resolvedLocationCode: $resolvedLocationCode, referenceId: $referenceId, warehouseId: $warehouseId, quantity: $quantity, countedQuantity: $countedQuantity, sourceLocationCode: $sourceLocationCode, destinationLocationCode: $destinationLocationCode, reasonCode: $reasonCode, errorMessage: $errorMessage, syncState: $syncState, startedAt: $startedAt, updatedAt: $updatedAt, submittedAt: $submittedAt)';
}


}

/// @nodoc
abstract mixin class $ScanSessionDraftDtoCopyWith<$Res>  {
  factory $ScanSessionDraftDtoCopyWith(ScanSessionDraftDto value, $Res Function(ScanSessionDraftDto) _then) = _$ScanSessionDraftDtoCopyWithImpl;
@useResult
$Res call({
 String id, ScanMode mode, ScanSessionState state,@JsonKey(name: 'camera_granted') bool cameraGranted,@JsonKey(name: 'lookup_code') String? lookupCode,@JsonKey(name: 'resolved_item_code') String? resolvedItemCode,@JsonKey(name: 'resolved_location_code') String? resolvedLocationCode,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'warehouse_id') String? warehouseId, double? quantity,@JsonKey(name: 'counted_quantity') double? countedQuantity,@JsonKey(name: 'source_location_code') String? sourceLocationCode,@JsonKey(name: 'destination_location_code') String? destinationLocationCode,@JsonKey(name: 'reason_code') String? reasonCode,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'sync_state') SyncState syncState,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt
});




}
/// @nodoc
class _$ScanSessionDraftDtoCopyWithImpl<$Res>
    implements $ScanSessionDraftDtoCopyWith<$Res> {
  _$ScanSessionDraftDtoCopyWithImpl(this._self, this._then);

  final ScanSessionDraftDto _self;
  final $Res Function(ScanSessionDraftDto) _then;

/// Create a copy of ScanSessionDraftDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mode = null,Object? state = null,Object? cameraGranted = null,Object? lookupCode = freezed,Object? resolvedItemCode = freezed,Object? resolvedLocationCode = freezed,Object? referenceId = freezed,Object? warehouseId = freezed,Object? quantity = freezed,Object? countedQuantity = freezed,Object? sourceLocationCode = freezed,Object? destinationLocationCode = freezed,Object? reasonCode = freezed,Object? errorMessage = freezed,Object? syncState = null,Object? startedAt = null,Object? updatedAt = null,Object? submittedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ScanMode,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ScanSessionState,cameraGranted: null == cameraGranted ? _self.cameraGranted : cameraGranted // ignore: cast_nullable_to_non_nullable
as bool,lookupCode: freezed == lookupCode ? _self.lookupCode : lookupCode // ignore: cast_nullable_to_non_nullable
as String?,resolvedItemCode: freezed == resolvedItemCode ? _self.resolvedItemCode : resolvedItemCode // ignore: cast_nullable_to_non_nullable
as String?,resolvedLocationCode: freezed == resolvedLocationCode ? _self.resolvedLocationCode : resolvedLocationCode // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,countedQuantity: freezed == countedQuantity ? _self.countedQuantity : countedQuantity // ignore: cast_nullable_to_non_nullable
as double?,sourceLocationCode: freezed == sourceLocationCode ? _self.sourceLocationCode : sourceLocationCode // ignore: cast_nullable_to_non_nullable
as String?,destinationLocationCode: freezed == destinationLocationCode ? _self.destinationLocationCode : destinationLocationCode // ignore: cast_nullable_to_non_nullable
as String?,reasonCode: freezed == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanSessionDraftDto].
extension ScanSessionDraftDtoPatterns on ScanSessionDraftDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanSessionDraftDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanSessionDraftDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanSessionDraftDto value)  $default,){
final _that = this;
switch (_that) {
case _ScanSessionDraftDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanSessionDraftDto value)?  $default,){
final _that = this;
switch (_that) {
case _ScanSessionDraftDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ScanMode mode,  ScanSessionState state, @JsonKey(name: 'camera_granted')  bool cameraGranted, @JsonKey(name: 'lookup_code')  String? lookupCode, @JsonKey(name: 'resolved_item_code')  String? resolvedItemCode, @JsonKey(name: 'resolved_location_code')  String? resolvedLocationCode, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'warehouse_id')  String? warehouseId,  double? quantity, @JsonKey(name: 'counted_quantity')  double? countedQuantity, @JsonKey(name: 'source_location_code')  String? sourceLocationCode, @JsonKey(name: 'destination_location_code')  String? destinationLocationCode, @JsonKey(name: 'reason_code')  String? reasonCode, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanSessionDraftDto() when $default != null:
return $default(_that.id,_that.mode,_that.state,_that.cameraGranted,_that.lookupCode,_that.resolvedItemCode,_that.resolvedLocationCode,_that.referenceId,_that.warehouseId,_that.quantity,_that.countedQuantity,_that.sourceLocationCode,_that.destinationLocationCode,_that.reasonCode,_that.errorMessage,_that.syncState,_that.startedAt,_that.updatedAt,_that.submittedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ScanMode mode,  ScanSessionState state, @JsonKey(name: 'camera_granted')  bool cameraGranted, @JsonKey(name: 'lookup_code')  String? lookupCode, @JsonKey(name: 'resolved_item_code')  String? resolvedItemCode, @JsonKey(name: 'resolved_location_code')  String? resolvedLocationCode, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'warehouse_id')  String? warehouseId,  double? quantity, @JsonKey(name: 'counted_quantity')  double? countedQuantity, @JsonKey(name: 'source_location_code')  String? sourceLocationCode, @JsonKey(name: 'destination_location_code')  String? destinationLocationCode, @JsonKey(name: 'reason_code')  String? reasonCode, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt)  $default,) {final _that = this;
switch (_that) {
case _ScanSessionDraftDto():
return $default(_that.id,_that.mode,_that.state,_that.cameraGranted,_that.lookupCode,_that.resolvedItemCode,_that.resolvedLocationCode,_that.referenceId,_that.warehouseId,_that.quantity,_that.countedQuantity,_that.sourceLocationCode,_that.destinationLocationCode,_that.reasonCode,_that.errorMessage,_that.syncState,_that.startedAt,_that.updatedAt,_that.submittedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ScanMode mode,  ScanSessionState state, @JsonKey(name: 'camera_granted')  bool cameraGranted, @JsonKey(name: 'lookup_code')  String? lookupCode, @JsonKey(name: 'resolved_item_code')  String? resolvedItemCode, @JsonKey(name: 'resolved_location_code')  String? resolvedLocationCode, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'warehouse_id')  String? warehouseId,  double? quantity, @JsonKey(name: 'counted_quantity')  double? countedQuantity, @JsonKey(name: 'source_location_code')  String? sourceLocationCode, @JsonKey(name: 'destination_location_code')  String? destinationLocationCode, @JsonKey(name: 'reason_code')  String? reasonCode, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'started_at')  DateTime startedAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt)?  $default,) {final _that = this;
switch (_that) {
case _ScanSessionDraftDto() when $default != null:
return $default(_that.id,_that.mode,_that.state,_that.cameraGranted,_that.lookupCode,_that.resolvedItemCode,_that.resolvedLocationCode,_that.referenceId,_that.warehouseId,_that.quantity,_that.countedQuantity,_that.sourceLocationCode,_that.destinationLocationCode,_that.reasonCode,_that.errorMessage,_that.syncState,_that.startedAt,_that.updatedAt,_that.submittedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ScanSessionDraftDto implements ScanSessionDraftDto {
  const _ScanSessionDraftDto({required this.id, required this.mode, required this.state, @JsonKey(name: 'camera_granted') this.cameraGranted = false, @JsonKey(name: 'lookup_code') this.lookupCode, @JsonKey(name: 'resolved_item_code') this.resolvedItemCode, @JsonKey(name: 'resolved_location_code') this.resolvedLocationCode, @JsonKey(name: 'reference_id') this.referenceId, @JsonKey(name: 'warehouse_id') this.warehouseId, this.quantity, @JsonKey(name: 'counted_quantity') this.countedQuantity, @JsonKey(name: 'source_location_code') this.sourceLocationCode, @JsonKey(name: 'destination_location_code') this.destinationLocationCode, @JsonKey(name: 'reason_code') this.reasonCode, @JsonKey(name: 'error_message') this.errorMessage, @JsonKey(name: 'sync_state') required this.syncState, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'submitted_at') this.submittedAt});
  factory _ScanSessionDraftDto.fromJson(Map<String, dynamic> json) => _$ScanSessionDraftDtoFromJson(json);

@override final  String id;
@override final  ScanMode mode;
@override final  ScanSessionState state;
@override@JsonKey(name: 'camera_granted') final  bool cameraGranted;
@override@JsonKey(name: 'lookup_code') final  String? lookupCode;
@override@JsonKey(name: 'resolved_item_code') final  String? resolvedItemCode;
@override@JsonKey(name: 'resolved_location_code') final  String? resolvedLocationCode;
@override@JsonKey(name: 'reference_id') final  String? referenceId;
@override@JsonKey(name: 'warehouse_id') final  String? warehouseId;
@override final  double? quantity;
@override@JsonKey(name: 'counted_quantity') final  double? countedQuantity;
@override@JsonKey(name: 'source_location_code') final  String? sourceLocationCode;
@override@JsonKey(name: 'destination_location_code') final  String? destinationLocationCode;
@override@JsonKey(name: 'reason_code') final  String? reasonCode;
@override@JsonKey(name: 'error_message') final  String? errorMessage;
@override@JsonKey(name: 'sync_state') final  SyncState syncState;
@override@JsonKey(name: 'started_at') final  DateTime startedAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override@JsonKey(name: 'submitted_at') final  DateTime? submittedAt;

/// Create a copy of ScanSessionDraftDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanSessionDraftDtoCopyWith<_ScanSessionDraftDto> get copyWith => __$ScanSessionDraftDtoCopyWithImpl<_ScanSessionDraftDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanSessionDraftDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanSessionDraftDto&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.state, state) || other.state == state)&&(identical(other.cameraGranted, cameraGranted) || other.cameraGranted == cameraGranted)&&(identical(other.lookupCode, lookupCode) || other.lookupCode == lookupCode)&&(identical(other.resolvedItemCode, resolvedItemCode) || other.resolvedItemCode == resolvedItemCode)&&(identical(other.resolvedLocationCode, resolvedLocationCode) || other.resolvedLocationCode == resolvedLocationCode)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.countedQuantity, countedQuantity) || other.countedQuantity == countedQuantity)&&(identical(other.sourceLocationCode, sourceLocationCode) || other.sourceLocationCode == sourceLocationCode)&&(identical(other.destinationLocationCode, destinationLocationCode) || other.destinationLocationCode == destinationLocationCode)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,mode,state,cameraGranted,lookupCode,resolvedItemCode,resolvedLocationCode,referenceId,warehouseId,quantity,countedQuantity,sourceLocationCode,destinationLocationCode,reasonCode,errorMessage,syncState,startedAt,updatedAt,submittedAt]);

@override
String toString() {
  return 'ScanSessionDraftDto(id: $id, mode: $mode, state: $state, cameraGranted: $cameraGranted, lookupCode: $lookupCode, resolvedItemCode: $resolvedItemCode, resolvedLocationCode: $resolvedLocationCode, referenceId: $referenceId, warehouseId: $warehouseId, quantity: $quantity, countedQuantity: $countedQuantity, sourceLocationCode: $sourceLocationCode, destinationLocationCode: $destinationLocationCode, reasonCode: $reasonCode, errorMessage: $errorMessage, syncState: $syncState, startedAt: $startedAt, updatedAt: $updatedAt, submittedAt: $submittedAt)';
}


}

/// @nodoc
abstract mixin class _$ScanSessionDraftDtoCopyWith<$Res> implements $ScanSessionDraftDtoCopyWith<$Res> {
  factory _$ScanSessionDraftDtoCopyWith(_ScanSessionDraftDto value, $Res Function(_ScanSessionDraftDto) _then) = __$ScanSessionDraftDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, ScanMode mode, ScanSessionState state,@JsonKey(name: 'camera_granted') bool cameraGranted,@JsonKey(name: 'lookup_code') String? lookupCode,@JsonKey(name: 'resolved_item_code') String? resolvedItemCode,@JsonKey(name: 'resolved_location_code') String? resolvedLocationCode,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'warehouse_id') String? warehouseId, double? quantity,@JsonKey(name: 'counted_quantity') double? countedQuantity,@JsonKey(name: 'source_location_code') String? sourceLocationCode,@JsonKey(name: 'destination_location_code') String? destinationLocationCode,@JsonKey(name: 'reason_code') String? reasonCode,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'sync_state') SyncState syncState,@JsonKey(name: 'started_at') DateTime startedAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt
});




}
/// @nodoc
class __$ScanSessionDraftDtoCopyWithImpl<$Res>
    implements _$ScanSessionDraftDtoCopyWith<$Res> {
  __$ScanSessionDraftDtoCopyWithImpl(this._self, this._then);

  final _ScanSessionDraftDto _self;
  final $Res Function(_ScanSessionDraftDto) _then;

/// Create a copy of ScanSessionDraftDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mode = null,Object? state = null,Object? cameraGranted = null,Object? lookupCode = freezed,Object? resolvedItemCode = freezed,Object? resolvedLocationCode = freezed,Object? referenceId = freezed,Object? warehouseId = freezed,Object? quantity = freezed,Object? countedQuantity = freezed,Object? sourceLocationCode = freezed,Object? destinationLocationCode = freezed,Object? reasonCode = freezed,Object? errorMessage = freezed,Object? syncState = null,Object? startedAt = null,Object? updatedAt = null,Object? submittedAt = freezed,}) {
  return _then(_ScanSessionDraftDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ScanMode,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ScanSessionState,cameraGranted: null == cameraGranted ? _self.cameraGranted : cameraGranted // ignore: cast_nullable_to_non_nullable
as bool,lookupCode: freezed == lookupCode ? _self.lookupCode : lookupCode // ignore: cast_nullable_to_non_nullable
as String?,resolvedItemCode: freezed == resolvedItemCode ? _self.resolvedItemCode : resolvedItemCode // ignore: cast_nullable_to_non_nullable
as String?,resolvedLocationCode: freezed == resolvedLocationCode ? _self.resolvedLocationCode : resolvedLocationCode // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,countedQuantity: freezed == countedQuantity ? _self.countedQuantity : countedQuantity // ignore: cast_nullable_to_non_nullable
as double?,sourceLocationCode: freezed == sourceLocationCode ? _self.sourceLocationCode : sourceLocationCode // ignore: cast_nullable_to_non_nullable
as String?,destinationLocationCode: freezed == destinationLocationCode ? _self.destinationLocationCode : destinationLocationCode // ignore: cast_nullable_to_non_nullable
as String?,reasonCode: freezed == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ScanSubmitRequestDto {

@JsonKey(name: 'session_id') String? get sessionId; ScanMode get mode;@JsonKey(name: 'reference_id') String? get referenceId;@JsonKey(name: 'warehouse_id') String? get warehouseId;@JsonKey(name: 'item_code') String? get itemCode;@JsonKey(name: 'location_code') String? get locationCode;@JsonKey(name: 'source_location_code') String? get sourceLocationCode;@JsonKey(name: 'destination_location_code') String? get destinationLocationCode; double? get quantity;@JsonKey(name: 'counted_quantity') double? get countedQuantity;@JsonKey(name: 'reason_code') String? get reasonCode;@JsonKey(name: 'idempotency_key') String? get idempotencyKey;
/// Create a copy of ScanSubmitRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanSubmitRequestDtoCopyWith<ScanSubmitRequestDto> get copyWith => _$ScanSubmitRequestDtoCopyWithImpl<ScanSubmitRequestDto>(this as ScanSubmitRequestDto, _$identity);

  /// Serializes this ScanSubmitRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanSubmitRequestDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.locationCode, locationCode) || other.locationCode == locationCode)&&(identical(other.sourceLocationCode, sourceLocationCode) || other.sourceLocationCode == sourceLocationCode)&&(identical(other.destinationLocationCode, destinationLocationCode) || other.destinationLocationCode == destinationLocationCode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.countedQuantity, countedQuantity) || other.countedQuantity == countedQuantity)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,mode,referenceId,warehouseId,itemCode,locationCode,sourceLocationCode,destinationLocationCode,quantity,countedQuantity,reasonCode,idempotencyKey);

@override
String toString() {
  return 'ScanSubmitRequestDto(sessionId: $sessionId, mode: $mode, referenceId: $referenceId, warehouseId: $warehouseId, itemCode: $itemCode, locationCode: $locationCode, sourceLocationCode: $sourceLocationCode, destinationLocationCode: $destinationLocationCode, quantity: $quantity, countedQuantity: $countedQuantity, reasonCode: $reasonCode, idempotencyKey: $idempotencyKey)';
}


}

/// @nodoc
abstract mixin class $ScanSubmitRequestDtoCopyWith<$Res>  {
  factory $ScanSubmitRequestDtoCopyWith(ScanSubmitRequestDto value, $Res Function(ScanSubmitRequestDto) _then) = _$ScanSubmitRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String? sessionId, ScanMode mode,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'warehouse_id') String? warehouseId,@JsonKey(name: 'item_code') String? itemCode,@JsonKey(name: 'location_code') String? locationCode,@JsonKey(name: 'source_location_code') String? sourceLocationCode,@JsonKey(name: 'destination_location_code') String? destinationLocationCode, double? quantity,@JsonKey(name: 'counted_quantity') double? countedQuantity,@JsonKey(name: 'reason_code') String? reasonCode,@JsonKey(name: 'idempotency_key') String? idempotencyKey
});




}
/// @nodoc
class _$ScanSubmitRequestDtoCopyWithImpl<$Res>
    implements $ScanSubmitRequestDtoCopyWith<$Res> {
  _$ScanSubmitRequestDtoCopyWithImpl(this._self, this._then);

  final ScanSubmitRequestDto _self;
  final $Res Function(ScanSubmitRequestDto) _then;

/// Create a copy of ScanSubmitRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = freezed,Object? mode = null,Object? referenceId = freezed,Object? warehouseId = freezed,Object? itemCode = freezed,Object? locationCode = freezed,Object? sourceLocationCode = freezed,Object? destinationLocationCode = freezed,Object? quantity = freezed,Object? countedQuantity = freezed,Object? reasonCode = freezed,Object? idempotencyKey = freezed,}) {
  return _then(_self.copyWith(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ScanMode,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String?,itemCode: freezed == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String?,locationCode: freezed == locationCode ? _self.locationCode : locationCode // ignore: cast_nullable_to_non_nullable
as String?,sourceLocationCode: freezed == sourceLocationCode ? _self.sourceLocationCode : sourceLocationCode // ignore: cast_nullable_to_non_nullable
as String?,destinationLocationCode: freezed == destinationLocationCode ? _self.destinationLocationCode : destinationLocationCode // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,countedQuantity: freezed == countedQuantity ? _self.countedQuantity : countedQuantity // ignore: cast_nullable_to_non_nullable
as double?,reasonCode: freezed == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String?,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanSubmitRequestDto].
extension ScanSubmitRequestDtoPatterns on ScanSubmitRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanSubmitRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanSubmitRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanSubmitRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _ScanSubmitRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanSubmitRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _ScanSubmitRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String? sessionId,  ScanMode mode, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'warehouse_id')  String? warehouseId, @JsonKey(name: 'item_code')  String? itemCode, @JsonKey(name: 'location_code')  String? locationCode, @JsonKey(name: 'source_location_code')  String? sourceLocationCode, @JsonKey(name: 'destination_location_code')  String? destinationLocationCode,  double? quantity, @JsonKey(name: 'counted_quantity')  double? countedQuantity, @JsonKey(name: 'reason_code')  String? reasonCode, @JsonKey(name: 'idempotency_key')  String? idempotencyKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanSubmitRequestDto() when $default != null:
return $default(_that.sessionId,_that.mode,_that.referenceId,_that.warehouseId,_that.itemCode,_that.locationCode,_that.sourceLocationCode,_that.destinationLocationCode,_that.quantity,_that.countedQuantity,_that.reasonCode,_that.idempotencyKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String? sessionId,  ScanMode mode, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'warehouse_id')  String? warehouseId, @JsonKey(name: 'item_code')  String? itemCode, @JsonKey(name: 'location_code')  String? locationCode, @JsonKey(name: 'source_location_code')  String? sourceLocationCode, @JsonKey(name: 'destination_location_code')  String? destinationLocationCode,  double? quantity, @JsonKey(name: 'counted_quantity')  double? countedQuantity, @JsonKey(name: 'reason_code')  String? reasonCode, @JsonKey(name: 'idempotency_key')  String? idempotencyKey)  $default,) {final _that = this;
switch (_that) {
case _ScanSubmitRequestDto():
return $default(_that.sessionId,_that.mode,_that.referenceId,_that.warehouseId,_that.itemCode,_that.locationCode,_that.sourceLocationCode,_that.destinationLocationCode,_that.quantity,_that.countedQuantity,_that.reasonCode,_that.idempotencyKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String? sessionId,  ScanMode mode, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'warehouse_id')  String? warehouseId, @JsonKey(name: 'item_code')  String? itemCode, @JsonKey(name: 'location_code')  String? locationCode, @JsonKey(name: 'source_location_code')  String? sourceLocationCode, @JsonKey(name: 'destination_location_code')  String? destinationLocationCode,  double? quantity, @JsonKey(name: 'counted_quantity')  double? countedQuantity, @JsonKey(name: 'reason_code')  String? reasonCode, @JsonKey(name: 'idempotency_key')  String? idempotencyKey)?  $default,) {final _that = this;
switch (_that) {
case _ScanSubmitRequestDto() when $default != null:
return $default(_that.sessionId,_that.mode,_that.referenceId,_that.warehouseId,_that.itemCode,_that.locationCode,_that.sourceLocationCode,_that.destinationLocationCode,_that.quantity,_that.countedQuantity,_that.reasonCode,_that.idempotencyKey);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ScanSubmitRequestDto implements ScanSubmitRequestDto {
  const _ScanSubmitRequestDto({@JsonKey(name: 'session_id') this.sessionId, required this.mode, @JsonKey(name: 'reference_id') this.referenceId, @JsonKey(name: 'warehouse_id') this.warehouseId, @JsonKey(name: 'item_code') this.itemCode, @JsonKey(name: 'location_code') this.locationCode, @JsonKey(name: 'source_location_code') this.sourceLocationCode, @JsonKey(name: 'destination_location_code') this.destinationLocationCode, this.quantity, @JsonKey(name: 'counted_quantity') this.countedQuantity, @JsonKey(name: 'reason_code') this.reasonCode, @JsonKey(name: 'idempotency_key') this.idempotencyKey});
  factory _ScanSubmitRequestDto.fromJson(Map<String, dynamic> json) => _$ScanSubmitRequestDtoFromJson(json);

@override@JsonKey(name: 'session_id') final  String? sessionId;
@override final  ScanMode mode;
@override@JsonKey(name: 'reference_id') final  String? referenceId;
@override@JsonKey(name: 'warehouse_id') final  String? warehouseId;
@override@JsonKey(name: 'item_code') final  String? itemCode;
@override@JsonKey(name: 'location_code') final  String? locationCode;
@override@JsonKey(name: 'source_location_code') final  String? sourceLocationCode;
@override@JsonKey(name: 'destination_location_code') final  String? destinationLocationCode;
@override final  double? quantity;
@override@JsonKey(name: 'counted_quantity') final  double? countedQuantity;
@override@JsonKey(name: 'reason_code') final  String? reasonCode;
@override@JsonKey(name: 'idempotency_key') final  String? idempotencyKey;

/// Create a copy of ScanSubmitRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanSubmitRequestDtoCopyWith<_ScanSubmitRequestDto> get copyWith => __$ScanSubmitRequestDtoCopyWithImpl<_ScanSubmitRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanSubmitRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanSubmitRequestDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.locationCode, locationCode) || other.locationCode == locationCode)&&(identical(other.sourceLocationCode, sourceLocationCode) || other.sourceLocationCode == sourceLocationCode)&&(identical(other.destinationLocationCode, destinationLocationCode) || other.destinationLocationCode == destinationLocationCode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.countedQuantity, countedQuantity) || other.countedQuantity == countedQuantity)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,mode,referenceId,warehouseId,itemCode,locationCode,sourceLocationCode,destinationLocationCode,quantity,countedQuantity,reasonCode,idempotencyKey);

@override
String toString() {
  return 'ScanSubmitRequestDto(sessionId: $sessionId, mode: $mode, referenceId: $referenceId, warehouseId: $warehouseId, itemCode: $itemCode, locationCode: $locationCode, sourceLocationCode: $sourceLocationCode, destinationLocationCode: $destinationLocationCode, quantity: $quantity, countedQuantity: $countedQuantity, reasonCode: $reasonCode, idempotencyKey: $idempotencyKey)';
}


}

/// @nodoc
abstract mixin class _$ScanSubmitRequestDtoCopyWith<$Res> implements $ScanSubmitRequestDtoCopyWith<$Res> {
  factory _$ScanSubmitRequestDtoCopyWith(_ScanSubmitRequestDto value, $Res Function(_ScanSubmitRequestDto) _then) = __$ScanSubmitRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String? sessionId, ScanMode mode,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'warehouse_id') String? warehouseId,@JsonKey(name: 'item_code') String? itemCode,@JsonKey(name: 'location_code') String? locationCode,@JsonKey(name: 'source_location_code') String? sourceLocationCode,@JsonKey(name: 'destination_location_code') String? destinationLocationCode, double? quantity,@JsonKey(name: 'counted_quantity') double? countedQuantity,@JsonKey(name: 'reason_code') String? reasonCode,@JsonKey(name: 'idempotency_key') String? idempotencyKey
});




}
/// @nodoc
class __$ScanSubmitRequestDtoCopyWithImpl<$Res>
    implements _$ScanSubmitRequestDtoCopyWith<$Res> {
  __$ScanSubmitRequestDtoCopyWithImpl(this._self, this._then);

  final _ScanSubmitRequestDto _self;
  final $Res Function(_ScanSubmitRequestDto) _then;

/// Create a copy of ScanSubmitRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? mode = null,Object? referenceId = freezed,Object? warehouseId = freezed,Object? itemCode = freezed,Object? locationCode = freezed,Object? sourceLocationCode = freezed,Object? destinationLocationCode = freezed,Object? quantity = freezed,Object? countedQuantity = freezed,Object? reasonCode = freezed,Object? idempotencyKey = freezed,}) {
  return _then(_ScanSubmitRequestDto(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ScanMode,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String?,itemCode: freezed == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String?,locationCode: freezed == locationCode ? _self.locationCode : locationCode // ignore: cast_nullable_to_non_nullable
as String?,sourceLocationCode: freezed == sourceLocationCode ? _self.sourceLocationCode : sourceLocationCode // ignore: cast_nullable_to_non_nullable
as String?,destinationLocationCode: freezed == destinationLocationCode ? _self.destinationLocationCode : destinationLocationCode // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,countedQuantity: freezed == countedQuantity ? _self.countedQuantity : countedQuantity // ignore: cast_nullable_to_non_nullable
as double?,reasonCode: freezed == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as String?,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
