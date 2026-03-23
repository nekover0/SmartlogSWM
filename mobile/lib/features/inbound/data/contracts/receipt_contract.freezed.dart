// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_contract.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReceiptLineEntity {

 String get id; String get itemCode; String get itemName; String get uomCode; double get expectedQty; double get receivedQty; double get varianceQty;
/// Create a copy of ReceiptLineEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptLineEntityCopyWith<ReceiptLineEntity> get copyWith => _$ReceiptLineEntityCopyWithImpl<ReceiptLineEntity>(this as ReceiptLineEntity, _$identity);

  /// Serializes this ReceiptLineEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptLineEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.uomCode, uomCode) || other.uomCode == uomCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.receivedQty, receivedQty) || other.receivedQty == receivedQty)&&(identical(other.varianceQty, varianceQty) || other.varianceQty == varianceQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemCode,itemName,uomCode,expectedQty,receivedQty,varianceQty);

@override
String toString() {
  return 'ReceiptLineEntity(id: $id, itemCode: $itemCode, itemName: $itemName, uomCode: $uomCode, expectedQty: $expectedQty, receivedQty: $receivedQty, varianceQty: $varianceQty)';
}


}

/// @nodoc
abstract mixin class $ReceiptLineEntityCopyWith<$Res>  {
  factory $ReceiptLineEntityCopyWith(ReceiptLineEntity value, $Res Function(ReceiptLineEntity) _then) = _$ReceiptLineEntityCopyWithImpl;
@useResult
$Res call({
 String id, String itemCode, String itemName, String uomCode, double expectedQty, double receivedQty, double varianceQty
});




}
/// @nodoc
class _$ReceiptLineEntityCopyWithImpl<$Res>
    implements $ReceiptLineEntityCopyWith<$Res> {
  _$ReceiptLineEntityCopyWithImpl(this._self, this._then);

  final ReceiptLineEntity _self;
  final $Res Function(ReceiptLineEntity) _then;

/// Create a copy of ReceiptLineEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemCode = null,Object? itemName = null,Object? uomCode = null,Object? expectedQty = null,Object? receivedQty = null,Object? varianceQty = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,uomCode: null == uomCode ? _self.uomCode : uomCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as double,receivedQty: null == receivedQty ? _self.receivedQty : receivedQty // ignore: cast_nullable_to_non_nullable
as double,varianceQty: null == varianceQty ? _self.varianceQty : varianceQty // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptLineEntity].
extension ReceiptLineEntityPatterns on ReceiptLineEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptLineEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptLineEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptLineEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptLineEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptLineEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptLineEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String itemCode,  String itemName,  String uomCode,  double expectedQty,  double receivedQty,  double varianceQty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptLineEntity() when $default != null:
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.receivedQty,_that.varianceQty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String itemCode,  String itemName,  String uomCode,  double expectedQty,  double receivedQty,  double varianceQty)  $default,) {final _that = this;
switch (_that) {
case _ReceiptLineEntity():
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.receivedQty,_that.varianceQty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String itemCode,  String itemName,  String uomCode,  double expectedQty,  double receivedQty,  double varianceQty)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptLineEntity() when $default != null:
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.receivedQty,_that.varianceQty);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReceiptLineEntity implements ReceiptLineEntity {
  const _ReceiptLineEntity({required this.id, required this.itemCode, required this.itemName, required this.uomCode, required this.expectedQty, required this.receivedQty, required this.varianceQty});
  factory _ReceiptLineEntity.fromJson(Map<String, dynamic> json) => _$ReceiptLineEntityFromJson(json);

@override final  String id;
@override final  String itemCode;
@override final  String itemName;
@override final  String uomCode;
@override final  double expectedQty;
@override final  double receivedQty;
@override final  double varianceQty;

/// Create a copy of ReceiptLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptLineEntityCopyWith<_ReceiptLineEntity> get copyWith => __$ReceiptLineEntityCopyWithImpl<_ReceiptLineEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptLineEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptLineEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.uomCode, uomCode) || other.uomCode == uomCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.receivedQty, receivedQty) || other.receivedQty == receivedQty)&&(identical(other.varianceQty, varianceQty) || other.varianceQty == varianceQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemCode,itemName,uomCode,expectedQty,receivedQty,varianceQty);

@override
String toString() {
  return 'ReceiptLineEntity(id: $id, itemCode: $itemCode, itemName: $itemName, uomCode: $uomCode, expectedQty: $expectedQty, receivedQty: $receivedQty, varianceQty: $varianceQty)';
}


}

/// @nodoc
abstract mixin class _$ReceiptLineEntityCopyWith<$Res> implements $ReceiptLineEntityCopyWith<$Res> {
  factory _$ReceiptLineEntityCopyWith(_ReceiptLineEntity value, $Res Function(_ReceiptLineEntity) _then) = __$ReceiptLineEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String itemCode, String itemName, String uomCode, double expectedQty, double receivedQty, double varianceQty
});




}
/// @nodoc
class __$ReceiptLineEntityCopyWithImpl<$Res>
    implements _$ReceiptLineEntityCopyWith<$Res> {
  __$ReceiptLineEntityCopyWithImpl(this._self, this._then);

  final _ReceiptLineEntity _self;
  final $Res Function(_ReceiptLineEntity) _then;

/// Create a copy of ReceiptLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemCode = null,Object? itemName = null,Object? uomCode = null,Object? expectedQty = null,Object? receivedQty = null,Object? varianceQty = null,}) {
  return _then(_ReceiptLineEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,uomCode: null == uomCode ? _self.uomCode : uomCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as double,receivedQty: null == receivedQty ? _self.receivedQty : receivedQty // ignore: cast_nullable_to_non_nullable
as double,varianceQty: null == varianceQty ? _self.varianceQty : varianceQty // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ReceiptEntity {

 String get id; String get receiptNo; ReceiptStatus get status; OwnerSummary get owner; WarehouseSummary get warehouse; VehicleInfo get vehicle; String? get purchaseOrderNo; String? get billOfLadingNo; String? get vesselName; double get expectedWeightKg; double get receivedWeightKg; double? get portWeightKg; double get varianceWeightKg; String? get sourceOcrRecordId; SyncState get syncState; List<ActionCapability> get availableActions; List<ReceiptLineEntity> get lines; String? get note; String? get errorMessage; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptEntityCopyWith<ReceiptEntity> get copyWith => _$ReceiptEntityCopyWithImpl<ReceiptEntity>(this as ReceiptEntity, _$identity);

  /// Serializes this ReceiptEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.purchaseOrderNo, purchaseOrderNo) || other.purchaseOrderNo == purchaseOrderNo)&&(identical(other.billOfLadingNo, billOfLadingNo) || other.billOfLadingNo == billOfLadingNo)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.expectedWeightKg, expectedWeightKg) || other.expectedWeightKg == expectedWeightKg)&&(identical(other.receivedWeightKg, receivedWeightKg) || other.receivedWeightKg == receivedWeightKg)&&(identical(other.portWeightKg, portWeightKg) || other.portWeightKg == portWeightKg)&&(identical(other.varianceWeightKg, varianceWeightKg) || other.varianceWeightKg == varianceWeightKg)&&(identical(other.sourceOcrRecordId, sourceOcrRecordId) || other.sourceOcrRecordId == sourceOcrRecordId)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&const DeepCollectionEquality().equals(other.availableActions, availableActions)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,receiptNo,status,owner,warehouse,vehicle,purchaseOrderNo,billOfLadingNo,vesselName,expectedWeightKg,receivedWeightKg,portWeightKg,varianceWeightKg,sourceOcrRecordId,syncState,const DeepCollectionEquality().hash(availableActions),const DeepCollectionEquality().hash(lines),note,errorMessage,createdAt,updatedAt]);

@override
String toString() {
  return 'ReceiptEntity(id: $id, receiptNo: $receiptNo, status: $status, owner: $owner, warehouse: $warehouse, vehicle: $vehicle, purchaseOrderNo: $purchaseOrderNo, billOfLadingNo: $billOfLadingNo, vesselName: $vesselName, expectedWeightKg: $expectedWeightKg, receivedWeightKg: $receivedWeightKg, portWeightKg: $portWeightKg, varianceWeightKg: $varianceWeightKg, sourceOcrRecordId: $sourceOcrRecordId, syncState: $syncState, availableActions: $availableActions, lines: $lines, note: $note, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReceiptEntityCopyWith<$Res>  {
  factory $ReceiptEntityCopyWith(ReceiptEntity value, $Res Function(ReceiptEntity) _then) = _$ReceiptEntityCopyWithImpl;
@useResult
$Res call({
 String id, String receiptNo, ReceiptStatus status, OwnerSummary owner, WarehouseSummary warehouse, VehicleInfo vehicle, String? purchaseOrderNo, String? billOfLadingNo, String? vesselName, double expectedWeightKg, double receivedWeightKg, double? portWeightKg, double varianceWeightKg, String? sourceOcrRecordId, SyncState syncState, List<ActionCapability> availableActions, List<ReceiptLineEntity> lines, String? note, String? errorMessage, DateTime createdAt, DateTime updatedAt
});


$OwnerSummaryCopyWith<$Res> get owner;$WarehouseSummaryCopyWith<$Res> get warehouse;$VehicleInfoCopyWith<$Res> get vehicle;

}
/// @nodoc
class _$ReceiptEntityCopyWithImpl<$Res>
    implements $ReceiptEntityCopyWith<$Res> {
  _$ReceiptEntityCopyWithImpl(this._self, this._then);

  final ReceiptEntity _self;
  final $Res Function(ReceiptEntity) _then;

/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? receiptNo = null,Object? status = null,Object? owner = null,Object? warehouse = null,Object? vehicle = null,Object? purchaseOrderNo = freezed,Object? billOfLadingNo = freezed,Object? vesselName = freezed,Object? expectedWeightKg = null,Object? receivedWeightKg = null,Object? portWeightKg = freezed,Object? varianceWeightKg = null,Object? sourceOcrRecordId = freezed,Object? syncState = null,Object? availableActions = null,Object? lines = null,Object? note = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNo: null == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReceiptStatus,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerSummary,warehouse: null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as WarehouseSummary,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as VehicleInfo,purchaseOrderNo: freezed == purchaseOrderNo ? _self.purchaseOrderNo : purchaseOrderNo // ignore: cast_nullable_to_non_nullable
as String?,billOfLadingNo: freezed == billOfLadingNo ? _self.billOfLadingNo : billOfLadingNo // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,expectedWeightKg: null == expectedWeightKg ? _self.expectedWeightKg : expectedWeightKg // ignore: cast_nullable_to_non_nullable
as double,receivedWeightKg: null == receivedWeightKg ? _self.receivedWeightKg : receivedWeightKg // ignore: cast_nullable_to_non_nullable
as double,portWeightKg: freezed == portWeightKg ? _self.portWeightKg : portWeightKg // ignore: cast_nullable_to_non_nullable
as double?,varianceWeightKg: null == varianceWeightKg ? _self.varianceWeightKg : varianceWeightKg // ignore: cast_nullable_to_non_nullable
as double,sourceOcrRecordId: freezed == sourceOcrRecordId ? _self.sourceOcrRecordId : sourceOcrRecordId // ignore: cast_nullable_to_non_nullable
as String?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,availableActions: null == availableActions ? _self.availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<ReceiptLineEntity>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<$Res> get owner {
  
  return $OwnerSummaryCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res> get warehouse {
  
  return $WarehouseSummaryCopyWith<$Res>(_self.warehouse, (value) {
    return _then(_self.copyWith(warehouse: value));
  });
}/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<$Res> get vehicle {
  
  return $VehicleInfoCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptEntity].
extension ReceiptEntityPatterns on ReceiptEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String receiptNo,  ReceiptStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle,  String? purchaseOrderNo,  String? billOfLadingNo,  String? vesselName,  double expectedWeightKg,  double receivedWeightKg,  double? portWeightKg,  double varianceWeightKg,  String? sourceOcrRecordId,  SyncState syncState,  List<ActionCapability> availableActions,  List<ReceiptLineEntity> lines,  String? note,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptEntity() when $default != null:
return $default(_that.id,_that.receiptNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.purchaseOrderNo,_that.billOfLadingNo,_that.vesselName,_that.expectedWeightKg,_that.receivedWeightKg,_that.portWeightKg,_that.varianceWeightKg,_that.sourceOcrRecordId,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String receiptNo,  ReceiptStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle,  String? purchaseOrderNo,  String? billOfLadingNo,  String? vesselName,  double expectedWeightKg,  double receivedWeightKg,  double? portWeightKg,  double varianceWeightKg,  String? sourceOcrRecordId,  SyncState syncState,  List<ActionCapability> availableActions,  List<ReceiptLineEntity> lines,  String? note,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReceiptEntity():
return $default(_that.id,_that.receiptNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.purchaseOrderNo,_that.billOfLadingNo,_that.vesselName,_that.expectedWeightKg,_that.receivedWeightKg,_that.portWeightKg,_that.varianceWeightKg,_that.sourceOcrRecordId,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String receiptNo,  ReceiptStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle,  String? purchaseOrderNo,  String? billOfLadingNo,  String? vesselName,  double expectedWeightKg,  double receivedWeightKg,  double? portWeightKg,  double varianceWeightKg,  String? sourceOcrRecordId,  SyncState syncState,  List<ActionCapability> availableActions,  List<ReceiptLineEntity> lines,  String? note,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptEntity() when $default != null:
return $default(_that.id,_that.receiptNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.purchaseOrderNo,_that.billOfLadingNo,_that.vesselName,_that.expectedWeightKg,_that.receivedWeightKg,_that.portWeightKg,_that.varianceWeightKg,_that.sourceOcrRecordId,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReceiptEntity implements ReceiptEntity {
  const _ReceiptEntity({required this.id, required this.receiptNo, required this.status, required this.owner, required this.warehouse, required this.vehicle, this.purchaseOrderNo, this.billOfLadingNo, this.vesselName, required this.expectedWeightKg, required this.receivedWeightKg, this.portWeightKg, required this.varianceWeightKg, this.sourceOcrRecordId, required this.syncState, final  List<ActionCapability> availableActions = const <ActionCapability>[], final  List<ReceiptLineEntity> lines = const <ReceiptLineEntity>[], this.note, this.errorMessage, required this.createdAt, required this.updatedAt}): _availableActions = availableActions,_lines = lines;
  factory _ReceiptEntity.fromJson(Map<String, dynamic> json) => _$ReceiptEntityFromJson(json);

@override final  String id;
@override final  String receiptNo;
@override final  ReceiptStatus status;
@override final  OwnerSummary owner;
@override final  WarehouseSummary warehouse;
@override final  VehicleInfo vehicle;
@override final  String? purchaseOrderNo;
@override final  String? billOfLadingNo;
@override final  String? vesselName;
@override final  double expectedWeightKg;
@override final  double receivedWeightKg;
@override final  double? portWeightKg;
@override final  double varianceWeightKg;
@override final  String? sourceOcrRecordId;
@override final  SyncState syncState;
 final  List<ActionCapability> _availableActions;
@override@JsonKey() List<ActionCapability> get availableActions {
  if (_availableActions is EqualUnmodifiableListView) return _availableActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableActions);
}

 final  List<ReceiptLineEntity> _lines;
@override@JsonKey() List<ReceiptLineEntity> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  String? note;
@override final  String? errorMessage;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptEntityCopyWith<_ReceiptEntity> get copyWith => __$ReceiptEntityCopyWithImpl<_ReceiptEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.purchaseOrderNo, purchaseOrderNo) || other.purchaseOrderNo == purchaseOrderNo)&&(identical(other.billOfLadingNo, billOfLadingNo) || other.billOfLadingNo == billOfLadingNo)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.expectedWeightKg, expectedWeightKg) || other.expectedWeightKg == expectedWeightKg)&&(identical(other.receivedWeightKg, receivedWeightKg) || other.receivedWeightKg == receivedWeightKg)&&(identical(other.portWeightKg, portWeightKg) || other.portWeightKg == portWeightKg)&&(identical(other.varianceWeightKg, varianceWeightKg) || other.varianceWeightKg == varianceWeightKg)&&(identical(other.sourceOcrRecordId, sourceOcrRecordId) || other.sourceOcrRecordId == sourceOcrRecordId)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&const DeepCollectionEquality().equals(other._availableActions, _availableActions)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,receiptNo,status,owner,warehouse,vehicle,purchaseOrderNo,billOfLadingNo,vesselName,expectedWeightKg,receivedWeightKg,portWeightKg,varianceWeightKg,sourceOcrRecordId,syncState,const DeepCollectionEquality().hash(_availableActions),const DeepCollectionEquality().hash(_lines),note,errorMessage,createdAt,updatedAt]);

@override
String toString() {
  return 'ReceiptEntity(id: $id, receiptNo: $receiptNo, status: $status, owner: $owner, warehouse: $warehouse, vehicle: $vehicle, purchaseOrderNo: $purchaseOrderNo, billOfLadingNo: $billOfLadingNo, vesselName: $vesselName, expectedWeightKg: $expectedWeightKg, receivedWeightKg: $receivedWeightKg, portWeightKg: $portWeightKg, varianceWeightKg: $varianceWeightKg, sourceOcrRecordId: $sourceOcrRecordId, syncState: $syncState, availableActions: $availableActions, lines: $lines, note: $note, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReceiptEntityCopyWith<$Res> implements $ReceiptEntityCopyWith<$Res> {
  factory _$ReceiptEntityCopyWith(_ReceiptEntity value, $Res Function(_ReceiptEntity) _then) = __$ReceiptEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String receiptNo, ReceiptStatus status, OwnerSummary owner, WarehouseSummary warehouse, VehicleInfo vehicle, String? purchaseOrderNo, String? billOfLadingNo, String? vesselName, double expectedWeightKg, double receivedWeightKg, double? portWeightKg, double varianceWeightKg, String? sourceOcrRecordId, SyncState syncState, List<ActionCapability> availableActions, List<ReceiptLineEntity> lines, String? note, String? errorMessage, DateTime createdAt, DateTime updatedAt
});


@override $OwnerSummaryCopyWith<$Res> get owner;@override $WarehouseSummaryCopyWith<$Res> get warehouse;@override $VehicleInfoCopyWith<$Res> get vehicle;

}
/// @nodoc
class __$ReceiptEntityCopyWithImpl<$Res>
    implements _$ReceiptEntityCopyWith<$Res> {
  __$ReceiptEntityCopyWithImpl(this._self, this._then);

  final _ReceiptEntity _self;
  final $Res Function(_ReceiptEntity) _then;

/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? receiptNo = null,Object? status = null,Object? owner = null,Object? warehouse = null,Object? vehicle = null,Object? purchaseOrderNo = freezed,Object? billOfLadingNo = freezed,Object? vesselName = freezed,Object? expectedWeightKg = null,Object? receivedWeightKg = null,Object? portWeightKg = freezed,Object? varianceWeightKg = null,Object? sourceOcrRecordId = freezed,Object? syncState = null,Object? availableActions = null,Object? lines = null,Object? note = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ReceiptEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNo: null == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReceiptStatus,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerSummary,warehouse: null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as WarehouseSummary,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as VehicleInfo,purchaseOrderNo: freezed == purchaseOrderNo ? _self.purchaseOrderNo : purchaseOrderNo // ignore: cast_nullable_to_non_nullable
as String?,billOfLadingNo: freezed == billOfLadingNo ? _self.billOfLadingNo : billOfLadingNo // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,expectedWeightKg: null == expectedWeightKg ? _self.expectedWeightKg : expectedWeightKg // ignore: cast_nullable_to_non_nullable
as double,receivedWeightKg: null == receivedWeightKg ? _self.receivedWeightKg : receivedWeightKg // ignore: cast_nullable_to_non_nullable
as double,portWeightKg: freezed == portWeightKg ? _self.portWeightKg : portWeightKg // ignore: cast_nullable_to_non_nullable
as double?,varianceWeightKg: null == varianceWeightKg ? _self.varianceWeightKg : varianceWeightKg // ignore: cast_nullable_to_non_nullable
as double,sourceOcrRecordId: freezed == sourceOcrRecordId ? _self.sourceOcrRecordId : sourceOcrRecordId // ignore: cast_nullable_to_non_nullable
as String?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,availableActions: null == availableActions ? _self._availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<ReceiptLineEntity>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<$Res> get owner {
  
  return $OwnerSummaryCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res> get warehouse {
  
  return $WarehouseSummaryCopyWith<$Res>(_self.warehouse, (value) {
    return _then(_self.copyWith(warehouse: value));
  });
}/// Create a copy of ReceiptEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<$Res> get vehicle {
  
  return $VehicleInfoCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// @nodoc
mixin _$ReceiptLineDto {

 String get id;@JsonKey(name: 'item_code') String get itemCode;@JsonKey(name: 'item_name') String get itemName;@JsonKey(name: 'uom_code') String get uomCode;@JsonKey(name: 'expected_qty') double get expectedQty;@JsonKey(name: 'received_qty') double get receivedQty;@JsonKey(name: 'variance_qty') double get varianceQty;
/// Create a copy of ReceiptLineDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptLineDtoCopyWith<ReceiptLineDto> get copyWith => _$ReceiptLineDtoCopyWithImpl<ReceiptLineDto>(this as ReceiptLineDto, _$identity);

  /// Serializes this ReceiptLineDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptLineDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.uomCode, uomCode) || other.uomCode == uomCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.receivedQty, receivedQty) || other.receivedQty == receivedQty)&&(identical(other.varianceQty, varianceQty) || other.varianceQty == varianceQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemCode,itemName,uomCode,expectedQty,receivedQty,varianceQty);

@override
String toString() {
  return 'ReceiptLineDto(id: $id, itemCode: $itemCode, itemName: $itemName, uomCode: $uomCode, expectedQty: $expectedQty, receivedQty: $receivedQty, varianceQty: $varianceQty)';
}


}

/// @nodoc
abstract mixin class $ReceiptLineDtoCopyWith<$Res>  {
  factory $ReceiptLineDtoCopyWith(ReceiptLineDto value, $Res Function(ReceiptLineDto) _then) = _$ReceiptLineDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'item_code') String itemCode,@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'uom_code') String uomCode,@JsonKey(name: 'expected_qty') double expectedQty,@JsonKey(name: 'received_qty') double receivedQty,@JsonKey(name: 'variance_qty') double varianceQty
});




}
/// @nodoc
class _$ReceiptLineDtoCopyWithImpl<$Res>
    implements $ReceiptLineDtoCopyWith<$Res> {
  _$ReceiptLineDtoCopyWithImpl(this._self, this._then);

  final ReceiptLineDto _self;
  final $Res Function(ReceiptLineDto) _then;

/// Create a copy of ReceiptLineDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemCode = null,Object? itemName = null,Object? uomCode = null,Object? expectedQty = null,Object? receivedQty = null,Object? varianceQty = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,uomCode: null == uomCode ? _self.uomCode : uomCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as double,receivedQty: null == receivedQty ? _self.receivedQty : receivedQty // ignore: cast_nullable_to_non_nullable
as double,varianceQty: null == varianceQty ? _self.varianceQty : varianceQty // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptLineDto].
extension ReceiptLineDtoPatterns on ReceiptLineDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptLineDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptLineDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptLineDto value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptLineDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptLineDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptLineDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'uom_code')  String uomCode, @JsonKey(name: 'expected_qty')  double expectedQty, @JsonKey(name: 'received_qty')  double receivedQty, @JsonKey(name: 'variance_qty')  double varianceQty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptLineDto() when $default != null:
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.receivedQty,_that.varianceQty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'uom_code')  String uomCode, @JsonKey(name: 'expected_qty')  double expectedQty, @JsonKey(name: 'received_qty')  double receivedQty, @JsonKey(name: 'variance_qty')  double varianceQty)  $default,) {final _that = this;
switch (_that) {
case _ReceiptLineDto():
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.receivedQty,_that.varianceQty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'uom_code')  String uomCode, @JsonKey(name: 'expected_qty')  double expectedQty, @JsonKey(name: 'received_qty')  double receivedQty, @JsonKey(name: 'variance_qty')  double varianceQty)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptLineDto() when $default != null:
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.receivedQty,_that.varianceQty);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReceiptLineDto implements ReceiptLineDto {
  const _ReceiptLineDto({required this.id, @JsonKey(name: 'item_code') required this.itemCode, @JsonKey(name: 'item_name') required this.itemName, @JsonKey(name: 'uom_code') required this.uomCode, @JsonKey(name: 'expected_qty') required this.expectedQty, @JsonKey(name: 'received_qty') required this.receivedQty, @JsonKey(name: 'variance_qty') required this.varianceQty});
  factory _ReceiptLineDto.fromJson(Map<String, dynamic> json) => _$ReceiptLineDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'item_code') final  String itemCode;
@override@JsonKey(name: 'item_name') final  String itemName;
@override@JsonKey(name: 'uom_code') final  String uomCode;
@override@JsonKey(name: 'expected_qty') final  double expectedQty;
@override@JsonKey(name: 'received_qty') final  double receivedQty;
@override@JsonKey(name: 'variance_qty') final  double varianceQty;

/// Create a copy of ReceiptLineDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptLineDtoCopyWith<_ReceiptLineDto> get copyWith => __$ReceiptLineDtoCopyWithImpl<_ReceiptLineDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptLineDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptLineDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.uomCode, uomCode) || other.uomCode == uomCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.receivedQty, receivedQty) || other.receivedQty == receivedQty)&&(identical(other.varianceQty, varianceQty) || other.varianceQty == varianceQty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemCode,itemName,uomCode,expectedQty,receivedQty,varianceQty);

@override
String toString() {
  return 'ReceiptLineDto(id: $id, itemCode: $itemCode, itemName: $itemName, uomCode: $uomCode, expectedQty: $expectedQty, receivedQty: $receivedQty, varianceQty: $varianceQty)';
}


}

/// @nodoc
abstract mixin class _$ReceiptLineDtoCopyWith<$Res> implements $ReceiptLineDtoCopyWith<$Res> {
  factory _$ReceiptLineDtoCopyWith(_ReceiptLineDto value, $Res Function(_ReceiptLineDto) _then) = __$ReceiptLineDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'item_code') String itemCode,@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'uom_code') String uomCode,@JsonKey(name: 'expected_qty') double expectedQty,@JsonKey(name: 'received_qty') double receivedQty,@JsonKey(name: 'variance_qty') double varianceQty
});




}
/// @nodoc
class __$ReceiptLineDtoCopyWithImpl<$Res>
    implements _$ReceiptLineDtoCopyWith<$Res> {
  __$ReceiptLineDtoCopyWithImpl(this._self, this._then);

  final _ReceiptLineDto _self;
  final $Res Function(_ReceiptLineDto) _then;

/// Create a copy of ReceiptLineDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemCode = null,Object? itemName = null,Object? uomCode = null,Object? expectedQty = null,Object? receivedQty = null,Object? varianceQty = null,}) {
  return _then(_ReceiptLineDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,uomCode: null == uomCode ? _self.uomCode : uomCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as double,receivedQty: null == receivedQty ? _self.receivedQty : receivedQty // ignore: cast_nullable_to_non_nullable
as double,varianceQty: null == varianceQty ? _self.varianceQty : varianceQty // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ReceiptDto {

 String get id;@JsonKey(name: 'receipt_no') String get receiptNo; ReceiptStatus get status; OwnerSummary get owner; WarehouseSummary get warehouse; VehicleInfo get vehicle;@JsonKey(name: 'purchase_order_no') String? get purchaseOrderNo;@JsonKey(name: 'bill_of_lading_no') String? get billOfLadingNo;@JsonKey(name: 'vessel_name') String? get vesselName;@JsonKey(name: 'expected_weight_kg') double get expectedWeightKg;@JsonKey(name: 'received_weight_kg') double get receivedWeightKg;@JsonKey(name: 'port_weight_kg') double? get portWeightKg;@JsonKey(name: 'variance_weight_kg') double get varianceWeightKg;@JsonKey(name: 'source_ocr_record_id') String? get sourceOcrRecordId;@JsonKey(name: 'sync_state') SyncState get syncState;@JsonKey(name: 'available_actions') List<ActionCapability> get availableActions; List<ReceiptLineDto> get lines; String? get note;@JsonKey(name: 'error_message') String? get errorMessage;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptDtoCopyWith<ReceiptDto> get copyWith => _$ReceiptDtoCopyWithImpl<ReceiptDto>(this as ReceiptDto, _$identity);

  /// Serializes this ReceiptDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.purchaseOrderNo, purchaseOrderNo) || other.purchaseOrderNo == purchaseOrderNo)&&(identical(other.billOfLadingNo, billOfLadingNo) || other.billOfLadingNo == billOfLadingNo)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.expectedWeightKg, expectedWeightKg) || other.expectedWeightKg == expectedWeightKg)&&(identical(other.receivedWeightKg, receivedWeightKg) || other.receivedWeightKg == receivedWeightKg)&&(identical(other.portWeightKg, portWeightKg) || other.portWeightKg == portWeightKg)&&(identical(other.varianceWeightKg, varianceWeightKg) || other.varianceWeightKg == varianceWeightKg)&&(identical(other.sourceOcrRecordId, sourceOcrRecordId) || other.sourceOcrRecordId == sourceOcrRecordId)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&const DeepCollectionEquality().equals(other.availableActions, availableActions)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,receiptNo,status,owner,warehouse,vehicle,purchaseOrderNo,billOfLadingNo,vesselName,expectedWeightKg,receivedWeightKg,portWeightKg,varianceWeightKg,sourceOcrRecordId,syncState,const DeepCollectionEquality().hash(availableActions),const DeepCollectionEquality().hash(lines),note,errorMessage,createdAt,updatedAt]);

@override
String toString() {
  return 'ReceiptDto(id: $id, receiptNo: $receiptNo, status: $status, owner: $owner, warehouse: $warehouse, vehicle: $vehicle, purchaseOrderNo: $purchaseOrderNo, billOfLadingNo: $billOfLadingNo, vesselName: $vesselName, expectedWeightKg: $expectedWeightKg, receivedWeightKg: $receivedWeightKg, portWeightKg: $portWeightKg, varianceWeightKg: $varianceWeightKg, sourceOcrRecordId: $sourceOcrRecordId, syncState: $syncState, availableActions: $availableActions, lines: $lines, note: $note, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReceiptDtoCopyWith<$Res>  {
  factory $ReceiptDtoCopyWith(ReceiptDto value, $Res Function(ReceiptDto) _then) = _$ReceiptDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'receipt_no') String receiptNo, ReceiptStatus status, OwnerSummary owner, WarehouseSummary warehouse, VehicleInfo vehicle,@JsonKey(name: 'purchase_order_no') String? purchaseOrderNo,@JsonKey(name: 'bill_of_lading_no') String? billOfLadingNo,@JsonKey(name: 'vessel_name') String? vesselName,@JsonKey(name: 'expected_weight_kg') double expectedWeightKg,@JsonKey(name: 'received_weight_kg') double receivedWeightKg,@JsonKey(name: 'port_weight_kg') double? portWeightKg,@JsonKey(name: 'variance_weight_kg') double varianceWeightKg,@JsonKey(name: 'source_ocr_record_id') String? sourceOcrRecordId,@JsonKey(name: 'sync_state') SyncState syncState,@JsonKey(name: 'available_actions') List<ActionCapability> availableActions, List<ReceiptLineDto> lines, String? note,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});


$OwnerSummaryCopyWith<$Res> get owner;$WarehouseSummaryCopyWith<$Res> get warehouse;$VehicleInfoCopyWith<$Res> get vehicle;

}
/// @nodoc
class _$ReceiptDtoCopyWithImpl<$Res>
    implements $ReceiptDtoCopyWith<$Res> {
  _$ReceiptDtoCopyWithImpl(this._self, this._then);

  final ReceiptDto _self;
  final $Res Function(ReceiptDto) _then;

/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? receiptNo = null,Object? status = null,Object? owner = null,Object? warehouse = null,Object? vehicle = null,Object? purchaseOrderNo = freezed,Object? billOfLadingNo = freezed,Object? vesselName = freezed,Object? expectedWeightKg = null,Object? receivedWeightKg = null,Object? portWeightKg = freezed,Object? varianceWeightKg = null,Object? sourceOcrRecordId = freezed,Object? syncState = null,Object? availableActions = null,Object? lines = null,Object? note = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNo: null == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReceiptStatus,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerSummary,warehouse: null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as WarehouseSummary,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as VehicleInfo,purchaseOrderNo: freezed == purchaseOrderNo ? _self.purchaseOrderNo : purchaseOrderNo // ignore: cast_nullable_to_non_nullable
as String?,billOfLadingNo: freezed == billOfLadingNo ? _self.billOfLadingNo : billOfLadingNo // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,expectedWeightKg: null == expectedWeightKg ? _self.expectedWeightKg : expectedWeightKg // ignore: cast_nullable_to_non_nullable
as double,receivedWeightKg: null == receivedWeightKg ? _self.receivedWeightKg : receivedWeightKg // ignore: cast_nullable_to_non_nullable
as double,portWeightKg: freezed == portWeightKg ? _self.portWeightKg : portWeightKg // ignore: cast_nullable_to_non_nullable
as double?,varianceWeightKg: null == varianceWeightKg ? _self.varianceWeightKg : varianceWeightKg // ignore: cast_nullable_to_non_nullable
as double,sourceOcrRecordId: freezed == sourceOcrRecordId ? _self.sourceOcrRecordId : sourceOcrRecordId // ignore: cast_nullable_to_non_nullable
as String?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,availableActions: null == availableActions ? _self.availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<ReceiptLineDto>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<$Res> get owner {
  
  return $OwnerSummaryCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res> get warehouse {
  
  return $WarehouseSummaryCopyWith<$Res>(_self.warehouse, (value) {
    return _then(_self.copyWith(warehouse: value));
  });
}/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<$Res> get vehicle {
  
  return $VehicleInfoCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceiptDto].
extension ReceiptDtoPatterns on ReceiptDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptDto value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'receipt_no')  String receiptNo,  ReceiptStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle, @JsonKey(name: 'purchase_order_no')  String? purchaseOrderNo, @JsonKey(name: 'bill_of_lading_no')  String? billOfLadingNo, @JsonKey(name: 'vessel_name')  String? vesselName, @JsonKey(name: 'expected_weight_kg')  double expectedWeightKg, @JsonKey(name: 'received_weight_kg')  double receivedWeightKg, @JsonKey(name: 'port_weight_kg')  double? portWeightKg, @JsonKey(name: 'variance_weight_kg')  double varianceWeightKg, @JsonKey(name: 'source_ocr_record_id')  String? sourceOcrRecordId, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'available_actions')  List<ActionCapability> availableActions,  List<ReceiptLineDto> lines,  String? note, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptDto() when $default != null:
return $default(_that.id,_that.receiptNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.purchaseOrderNo,_that.billOfLadingNo,_that.vesselName,_that.expectedWeightKg,_that.receivedWeightKg,_that.portWeightKg,_that.varianceWeightKg,_that.sourceOcrRecordId,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'receipt_no')  String receiptNo,  ReceiptStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle, @JsonKey(name: 'purchase_order_no')  String? purchaseOrderNo, @JsonKey(name: 'bill_of_lading_no')  String? billOfLadingNo, @JsonKey(name: 'vessel_name')  String? vesselName, @JsonKey(name: 'expected_weight_kg')  double expectedWeightKg, @JsonKey(name: 'received_weight_kg')  double receivedWeightKg, @JsonKey(name: 'port_weight_kg')  double? portWeightKg, @JsonKey(name: 'variance_weight_kg')  double varianceWeightKg, @JsonKey(name: 'source_ocr_record_id')  String? sourceOcrRecordId, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'available_actions')  List<ActionCapability> availableActions,  List<ReceiptLineDto> lines,  String? note, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReceiptDto():
return $default(_that.id,_that.receiptNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.purchaseOrderNo,_that.billOfLadingNo,_that.vesselName,_that.expectedWeightKg,_that.receivedWeightKg,_that.portWeightKg,_that.varianceWeightKg,_that.sourceOcrRecordId,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'receipt_no')  String receiptNo,  ReceiptStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle, @JsonKey(name: 'purchase_order_no')  String? purchaseOrderNo, @JsonKey(name: 'bill_of_lading_no')  String? billOfLadingNo, @JsonKey(name: 'vessel_name')  String? vesselName, @JsonKey(name: 'expected_weight_kg')  double expectedWeightKg, @JsonKey(name: 'received_weight_kg')  double receivedWeightKg, @JsonKey(name: 'port_weight_kg')  double? portWeightKg, @JsonKey(name: 'variance_weight_kg')  double varianceWeightKg, @JsonKey(name: 'source_ocr_record_id')  String? sourceOcrRecordId, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'available_actions')  List<ActionCapability> availableActions,  List<ReceiptLineDto> lines,  String? note, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptDto() when $default != null:
return $default(_that.id,_that.receiptNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.purchaseOrderNo,_that.billOfLadingNo,_that.vesselName,_that.expectedWeightKg,_that.receivedWeightKg,_that.portWeightKg,_that.varianceWeightKg,_that.sourceOcrRecordId,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReceiptDto implements ReceiptDto {
  const _ReceiptDto({required this.id, @JsonKey(name: 'receipt_no') required this.receiptNo, required this.status, required this.owner, required this.warehouse, required this.vehicle, @JsonKey(name: 'purchase_order_no') this.purchaseOrderNo, @JsonKey(name: 'bill_of_lading_no') this.billOfLadingNo, @JsonKey(name: 'vessel_name') this.vesselName, @JsonKey(name: 'expected_weight_kg') required this.expectedWeightKg, @JsonKey(name: 'received_weight_kg') required this.receivedWeightKg, @JsonKey(name: 'port_weight_kg') this.portWeightKg, @JsonKey(name: 'variance_weight_kg') required this.varianceWeightKg, @JsonKey(name: 'source_ocr_record_id') this.sourceOcrRecordId, @JsonKey(name: 'sync_state') required this.syncState, @JsonKey(name: 'available_actions') final  List<ActionCapability> availableActions = const <ActionCapability>[], final  List<ReceiptLineDto> lines = const <ReceiptLineDto>[], this.note, @JsonKey(name: 'error_message') this.errorMessage, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _availableActions = availableActions,_lines = lines;
  factory _ReceiptDto.fromJson(Map<String, dynamic> json) => _$ReceiptDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'receipt_no') final  String receiptNo;
@override final  ReceiptStatus status;
@override final  OwnerSummary owner;
@override final  WarehouseSummary warehouse;
@override final  VehicleInfo vehicle;
@override@JsonKey(name: 'purchase_order_no') final  String? purchaseOrderNo;
@override@JsonKey(name: 'bill_of_lading_no') final  String? billOfLadingNo;
@override@JsonKey(name: 'vessel_name') final  String? vesselName;
@override@JsonKey(name: 'expected_weight_kg') final  double expectedWeightKg;
@override@JsonKey(name: 'received_weight_kg') final  double receivedWeightKg;
@override@JsonKey(name: 'port_weight_kg') final  double? portWeightKg;
@override@JsonKey(name: 'variance_weight_kg') final  double varianceWeightKg;
@override@JsonKey(name: 'source_ocr_record_id') final  String? sourceOcrRecordId;
@override@JsonKey(name: 'sync_state') final  SyncState syncState;
 final  List<ActionCapability> _availableActions;
@override@JsonKey(name: 'available_actions') List<ActionCapability> get availableActions {
  if (_availableActions is EqualUnmodifiableListView) return _availableActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableActions);
}

 final  List<ReceiptLineDto> _lines;
@override@JsonKey() List<ReceiptLineDto> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  String? note;
@override@JsonKey(name: 'error_message') final  String? errorMessage;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptDtoCopyWith<_ReceiptDto> get copyWith => __$ReceiptDtoCopyWithImpl<_ReceiptDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.receiptNo, receiptNo) || other.receiptNo == receiptNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.purchaseOrderNo, purchaseOrderNo) || other.purchaseOrderNo == purchaseOrderNo)&&(identical(other.billOfLadingNo, billOfLadingNo) || other.billOfLadingNo == billOfLadingNo)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.expectedWeightKg, expectedWeightKg) || other.expectedWeightKg == expectedWeightKg)&&(identical(other.receivedWeightKg, receivedWeightKg) || other.receivedWeightKg == receivedWeightKg)&&(identical(other.portWeightKg, portWeightKg) || other.portWeightKg == portWeightKg)&&(identical(other.varianceWeightKg, varianceWeightKg) || other.varianceWeightKg == varianceWeightKg)&&(identical(other.sourceOcrRecordId, sourceOcrRecordId) || other.sourceOcrRecordId == sourceOcrRecordId)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&const DeepCollectionEquality().equals(other._availableActions, _availableActions)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,receiptNo,status,owner,warehouse,vehicle,purchaseOrderNo,billOfLadingNo,vesselName,expectedWeightKg,receivedWeightKg,portWeightKg,varianceWeightKg,sourceOcrRecordId,syncState,const DeepCollectionEquality().hash(_availableActions),const DeepCollectionEquality().hash(_lines),note,errorMessage,createdAt,updatedAt]);

@override
String toString() {
  return 'ReceiptDto(id: $id, receiptNo: $receiptNo, status: $status, owner: $owner, warehouse: $warehouse, vehicle: $vehicle, purchaseOrderNo: $purchaseOrderNo, billOfLadingNo: $billOfLadingNo, vesselName: $vesselName, expectedWeightKg: $expectedWeightKg, receivedWeightKg: $receivedWeightKg, portWeightKg: $portWeightKg, varianceWeightKg: $varianceWeightKg, sourceOcrRecordId: $sourceOcrRecordId, syncState: $syncState, availableActions: $availableActions, lines: $lines, note: $note, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReceiptDtoCopyWith<$Res> implements $ReceiptDtoCopyWith<$Res> {
  factory _$ReceiptDtoCopyWith(_ReceiptDto value, $Res Function(_ReceiptDto) _then) = __$ReceiptDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'receipt_no') String receiptNo, ReceiptStatus status, OwnerSummary owner, WarehouseSummary warehouse, VehicleInfo vehicle,@JsonKey(name: 'purchase_order_no') String? purchaseOrderNo,@JsonKey(name: 'bill_of_lading_no') String? billOfLadingNo,@JsonKey(name: 'vessel_name') String? vesselName,@JsonKey(name: 'expected_weight_kg') double expectedWeightKg,@JsonKey(name: 'received_weight_kg') double receivedWeightKg,@JsonKey(name: 'port_weight_kg') double? portWeightKg,@JsonKey(name: 'variance_weight_kg') double varianceWeightKg,@JsonKey(name: 'source_ocr_record_id') String? sourceOcrRecordId,@JsonKey(name: 'sync_state') SyncState syncState,@JsonKey(name: 'available_actions') List<ActionCapability> availableActions, List<ReceiptLineDto> lines, String? note,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});


@override $OwnerSummaryCopyWith<$Res> get owner;@override $WarehouseSummaryCopyWith<$Res> get warehouse;@override $VehicleInfoCopyWith<$Res> get vehicle;

}
/// @nodoc
class __$ReceiptDtoCopyWithImpl<$Res>
    implements _$ReceiptDtoCopyWith<$Res> {
  __$ReceiptDtoCopyWithImpl(this._self, this._then);

  final _ReceiptDto _self;
  final $Res Function(_ReceiptDto) _then;

/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? receiptNo = null,Object? status = null,Object? owner = null,Object? warehouse = null,Object? vehicle = null,Object? purchaseOrderNo = freezed,Object? billOfLadingNo = freezed,Object? vesselName = freezed,Object? expectedWeightKg = null,Object? receivedWeightKg = null,Object? portWeightKg = freezed,Object? varianceWeightKg = null,Object? sourceOcrRecordId = freezed,Object? syncState = null,Object? availableActions = null,Object? lines = null,Object? note = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ReceiptDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,receiptNo: null == receiptNo ? _self.receiptNo : receiptNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReceiptStatus,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerSummary,warehouse: null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as WarehouseSummary,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as VehicleInfo,purchaseOrderNo: freezed == purchaseOrderNo ? _self.purchaseOrderNo : purchaseOrderNo // ignore: cast_nullable_to_non_nullable
as String?,billOfLadingNo: freezed == billOfLadingNo ? _self.billOfLadingNo : billOfLadingNo // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,expectedWeightKg: null == expectedWeightKg ? _self.expectedWeightKg : expectedWeightKg // ignore: cast_nullable_to_non_nullable
as double,receivedWeightKg: null == receivedWeightKg ? _self.receivedWeightKg : receivedWeightKg // ignore: cast_nullable_to_non_nullable
as double,portWeightKg: freezed == portWeightKg ? _self.portWeightKg : portWeightKg // ignore: cast_nullable_to_non_nullable
as double?,varianceWeightKg: null == varianceWeightKg ? _self.varianceWeightKg : varianceWeightKg // ignore: cast_nullable_to_non_nullable
as double,sourceOcrRecordId: freezed == sourceOcrRecordId ? _self.sourceOcrRecordId : sourceOcrRecordId // ignore: cast_nullable_to_non_nullable
as String?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,availableActions: null == availableActions ? _self._availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<ReceiptLineDto>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<$Res> get owner {
  
  return $OwnerSummaryCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res> get warehouse {
  
  return $WarehouseSummaryCopyWith<$Res>(_self.warehouse, (value) {
    return _then(_self.copyWith(warehouse: value));
  });
}/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<$Res> get vehicle {
  
  return $VehicleInfoCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}

// dart format on
