// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment_contract.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShipmentLineEntity {

 String get id; String get itemCode; String get itemName; String get uomCode; double get expectedQty; double get shippedQty; bool get shortPick; LocationSummary? get sourceLocation;
/// Create a copy of ShipmentLineEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShipmentLineEntityCopyWith<ShipmentLineEntity> get copyWith => _$ShipmentLineEntityCopyWithImpl<ShipmentLineEntity>(this as ShipmentLineEntity, _$identity);

  /// Serializes this ShipmentLineEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShipmentLineEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.uomCode, uomCode) || other.uomCode == uomCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.shippedQty, shippedQty) || other.shippedQty == shippedQty)&&(identical(other.shortPick, shortPick) || other.shortPick == shortPick)&&(identical(other.sourceLocation, sourceLocation) || other.sourceLocation == sourceLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemCode,itemName,uomCode,expectedQty,shippedQty,shortPick,sourceLocation);

@override
String toString() {
  return 'ShipmentLineEntity(id: $id, itemCode: $itemCode, itemName: $itemName, uomCode: $uomCode, expectedQty: $expectedQty, shippedQty: $shippedQty, shortPick: $shortPick, sourceLocation: $sourceLocation)';
}


}

/// @nodoc
abstract mixin class $ShipmentLineEntityCopyWith<$Res>  {
  factory $ShipmentLineEntityCopyWith(ShipmentLineEntity value, $Res Function(ShipmentLineEntity) _then) = _$ShipmentLineEntityCopyWithImpl;
@useResult
$Res call({
 String id, String itemCode, String itemName, String uomCode, double expectedQty, double shippedQty, bool shortPick, LocationSummary? sourceLocation
});


$LocationSummaryCopyWith<$Res>? get sourceLocation;

}
/// @nodoc
class _$ShipmentLineEntityCopyWithImpl<$Res>
    implements $ShipmentLineEntityCopyWith<$Res> {
  _$ShipmentLineEntityCopyWithImpl(this._self, this._then);

  final ShipmentLineEntity _self;
  final $Res Function(ShipmentLineEntity) _then;

/// Create a copy of ShipmentLineEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemCode = null,Object? itemName = null,Object? uomCode = null,Object? expectedQty = null,Object? shippedQty = null,Object? shortPick = null,Object? sourceLocation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,uomCode: null == uomCode ? _self.uomCode : uomCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as double,shippedQty: null == shippedQty ? _self.shippedQty : shippedQty // ignore: cast_nullable_to_non_nullable
as double,shortPick: null == shortPick ? _self.shortPick : shortPick // ignore: cast_nullable_to_non_nullable
as bool,sourceLocation: freezed == sourceLocation ? _self.sourceLocation : sourceLocation // ignore: cast_nullable_to_non_nullable
as LocationSummary?,
  ));
}
/// Create a copy of ShipmentLineEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationSummaryCopyWith<$Res>? get sourceLocation {
    if (_self.sourceLocation == null) {
    return null;
  }

  return $LocationSummaryCopyWith<$Res>(_self.sourceLocation!, (value) {
    return _then(_self.copyWith(sourceLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShipmentLineEntity].
extension ShipmentLineEntityPatterns on ShipmentLineEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShipmentLineEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShipmentLineEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShipmentLineEntity value)  $default,){
final _that = this;
switch (_that) {
case _ShipmentLineEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShipmentLineEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ShipmentLineEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String itemCode,  String itemName,  String uomCode,  double expectedQty,  double shippedQty,  bool shortPick,  LocationSummary? sourceLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShipmentLineEntity() when $default != null:
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.shippedQty,_that.shortPick,_that.sourceLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String itemCode,  String itemName,  String uomCode,  double expectedQty,  double shippedQty,  bool shortPick,  LocationSummary? sourceLocation)  $default,) {final _that = this;
switch (_that) {
case _ShipmentLineEntity():
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.shippedQty,_that.shortPick,_that.sourceLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String itemCode,  String itemName,  String uomCode,  double expectedQty,  double shippedQty,  bool shortPick,  LocationSummary? sourceLocation)?  $default,) {final _that = this;
switch (_that) {
case _ShipmentLineEntity() when $default != null:
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.shippedQty,_that.shortPick,_that.sourceLocation);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ShipmentLineEntity implements ShipmentLineEntity {
  const _ShipmentLineEntity({required this.id, required this.itemCode, required this.itemName, required this.uomCode, required this.expectedQty, required this.shippedQty, required this.shortPick, this.sourceLocation});
  factory _ShipmentLineEntity.fromJson(Map<String, dynamic> json) => _$ShipmentLineEntityFromJson(json);

@override final  String id;
@override final  String itemCode;
@override final  String itemName;
@override final  String uomCode;
@override final  double expectedQty;
@override final  double shippedQty;
@override final  bool shortPick;
@override final  LocationSummary? sourceLocation;

/// Create a copy of ShipmentLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShipmentLineEntityCopyWith<_ShipmentLineEntity> get copyWith => __$ShipmentLineEntityCopyWithImpl<_ShipmentLineEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShipmentLineEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShipmentLineEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.uomCode, uomCode) || other.uomCode == uomCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.shippedQty, shippedQty) || other.shippedQty == shippedQty)&&(identical(other.shortPick, shortPick) || other.shortPick == shortPick)&&(identical(other.sourceLocation, sourceLocation) || other.sourceLocation == sourceLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemCode,itemName,uomCode,expectedQty,shippedQty,shortPick,sourceLocation);

@override
String toString() {
  return 'ShipmentLineEntity(id: $id, itemCode: $itemCode, itemName: $itemName, uomCode: $uomCode, expectedQty: $expectedQty, shippedQty: $shippedQty, shortPick: $shortPick, sourceLocation: $sourceLocation)';
}


}

/// @nodoc
abstract mixin class _$ShipmentLineEntityCopyWith<$Res> implements $ShipmentLineEntityCopyWith<$Res> {
  factory _$ShipmentLineEntityCopyWith(_ShipmentLineEntity value, $Res Function(_ShipmentLineEntity) _then) = __$ShipmentLineEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String itemCode, String itemName, String uomCode, double expectedQty, double shippedQty, bool shortPick, LocationSummary? sourceLocation
});


@override $LocationSummaryCopyWith<$Res>? get sourceLocation;

}
/// @nodoc
class __$ShipmentLineEntityCopyWithImpl<$Res>
    implements _$ShipmentLineEntityCopyWith<$Res> {
  __$ShipmentLineEntityCopyWithImpl(this._self, this._then);

  final _ShipmentLineEntity _self;
  final $Res Function(_ShipmentLineEntity) _then;

/// Create a copy of ShipmentLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemCode = null,Object? itemName = null,Object? uomCode = null,Object? expectedQty = null,Object? shippedQty = null,Object? shortPick = null,Object? sourceLocation = freezed,}) {
  return _then(_ShipmentLineEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,uomCode: null == uomCode ? _self.uomCode : uomCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as double,shippedQty: null == shippedQty ? _self.shippedQty : shippedQty // ignore: cast_nullable_to_non_nullable
as double,shortPick: null == shortPick ? _self.shortPick : shortPick // ignore: cast_nullable_to_non_nullable
as bool,sourceLocation: freezed == sourceLocation ? _self.sourceLocation : sourceLocation // ignore: cast_nullable_to_non_nullable
as LocationSummary?,
  ));
}

/// Create a copy of ShipmentLineEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationSummaryCopyWith<$Res>? get sourceLocation {
    if (_self.sourceLocation == null) {
    return null;
  }

  return $LocationSummaryCopyWith<$Res>(_self.sourceLocation!, (value) {
    return _then(_self.copyWith(sourceLocation: value));
  });
}
}


/// @nodoc
mixin _$ShipmentEntity {

 String get id; String get shipmentNo; ShipmentStatus get status; OwnerSummary get owner; WarehouseSummary get warehouse; VehicleInfo get vehicle; String? get salesOrderNo; String? get billOfLadingNo; double get expectedWeightKg; double get shippedWeightKg; double? get varianceWeightKg; SyncState get syncState; List<ActionCapability> get availableActions; List<ShipmentLineEntity> get lines; String? get note; String? get errorMessage; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShipmentEntityCopyWith<ShipmentEntity> get copyWith => _$ShipmentEntityCopyWithImpl<ShipmentEntity>(this as ShipmentEntity, _$identity);

  /// Serializes this ShipmentEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShipmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.shipmentNo, shipmentNo) || other.shipmentNo == shipmentNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.salesOrderNo, salesOrderNo) || other.salesOrderNo == salesOrderNo)&&(identical(other.billOfLadingNo, billOfLadingNo) || other.billOfLadingNo == billOfLadingNo)&&(identical(other.expectedWeightKg, expectedWeightKg) || other.expectedWeightKg == expectedWeightKg)&&(identical(other.shippedWeightKg, shippedWeightKg) || other.shippedWeightKg == shippedWeightKg)&&(identical(other.varianceWeightKg, varianceWeightKg) || other.varianceWeightKg == varianceWeightKg)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&const DeepCollectionEquality().equals(other.availableActions, availableActions)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shipmentNo,status,owner,warehouse,vehicle,salesOrderNo,billOfLadingNo,expectedWeightKg,shippedWeightKg,varianceWeightKg,syncState,const DeepCollectionEquality().hash(availableActions),const DeepCollectionEquality().hash(lines),note,errorMessage,createdAt,updatedAt);

@override
String toString() {
  return 'ShipmentEntity(id: $id, shipmentNo: $shipmentNo, status: $status, owner: $owner, warehouse: $warehouse, vehicle: $vehicle, salesOrderNo: $salesOrderNo, billOfLadingNo: $billOfLadingNo, expectedWeightKg: $expectedWeightKg, shippedWeightKg: $shippedWeightKg, varianceWeightKg: $varianceWeightKg, syncState: $syncState, availableActions: $availableActions, lines: $lines, note: $note, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ShipmentEntityCopyWith<$Res>  {
  factory $ShipmentEntityCopyWith(ShipmentEntity value, $Res Function(ShipmentEntity) _then) = _$ShipmentEntityCopyWithImpl;
@useResult
$Res call({
 String id, String shipmentNo, ShipmentStatus status, OwnerSummary owner, WarehouseSummary warehouse, VehicleInfo vehicle, String? salesOrderNo, String? billOfLadingNo, double expectedWeightKg, double shippedWeightKg, double? varianceWeightKg, SyncState syncState, List<ActionCapability> availableActions, List<ShipmentLineEntity> lines, String? note, String? errorMessage, DateTime createdAt, DateTime updatedAt
});


$OwnerSummaryCopyWith<$Res> get owner;$WarehouseSummaryCopyWith<$Res> get warehouse;$VehicleInfoCopyWith<$Res> get vehicle;

}
/// @nodoc
class _$ShipmentEntityCopyWithImpl<$Res>
    implements $ShipmentEntityCopyWith<$Res> {
  _$ShipmentEntityCopyWithImpl(this._self, this._then);

  final ShipmentEntity _self;
  final $Res Function(ShipmentEntity) _then;

/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shipmentNo = null,Object? status = null,Object? owner = null,Object? warehouse = null,Object? vehicle = null,Object? salesOrderNo = freezed,Object? billOfLadingNo = freezed,Object? expectedWeightKg = null,Object? shippedWeightKg = null,Object? varianceWeightKg = freezed,Object? syncState = null,Object? availableActions = null,Object? lines = null,Object? note = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shipmentNo: null == shipmentNo ? _self.shipmentNo : shipmentNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShipmentStatus,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerSummary,warehouse: null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as WarehouseSummary,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as VehicleInfo,salesOrderNo: freezed == salesOrderNo ? _self.salesOrderNo : salesOrderNo // ignore: cast_nullable_to_non_nullable
as String?,billOfLadingNo: freezed == billOfLadingNo ? _self.billOfLadingNo : billOfLadingNo // ignore: cast_nullable_to_non_nullable
as String?,expectedWeightKg: null == expectedWeightKg ? _self.expectedWeightKg : expectedWeightKg // ignore: cast_nullable_to_non_nullable
as double,shippedWeightKg: null == shippedWeightKg ? _self.shippedWeightKg : shippedWeightKg // ignore: cast_nullable_to_non_nullable
as double,varianceWeightKg: freezed == varianceWeightKg ? _self.varianceWeightKg : varianceWeightKg // ignore: cast_nullable_to_non_nullable
as double?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,availableActions: null == availableActions ? _self.availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<ShipmentLineEntity>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<$Res> get owner {
  
  return $OwnerSummaryCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res> get warehouse {
  
  return $WarehouseSummaryCopyWith<$Res>(_self.warehouse, (value) {
    return _then(_self.copyWith(warehouse: value));
  });
}/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<$Res> get vehicle {
  
  return $VehicleInfoCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShipmentEntity].
extension ShipmentEntityPatterns on ShipmentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShipmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShipmentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShipmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _ShipmentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShipmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ShipmentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String shipmentNo,  ShipmentStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle,  String? salesOrderNo,  String? billOfLadingNo,  double expectedWeightKg,  double shippedWeightKg,  double? varianceWeightKg,  SyncState syncState,  List<ActionCapability> availableActions,  List<ShipmentLineEntity> lines,  String? note,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShipmentEntity() when $default != null:
return $default(_that.id,_that.shipmentNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.salesOrderNo,_that.billOfLadingNo,_that.expectedWeightKg,_that.shippedWeightKg,_that.varianceWeightKg,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String shipmentNo,  ShipmentStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle,  String? salesOrderNo,  String? billOfLadingNo,  double expectedWeightKg,  double shippedWeightKg,  double? varianceWeightKg,  SyncState syncState,  List<ActionCapability> availableActions,  List<ShipmentLineEntity> lines,  String? note,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ShipmentEntity():
return $default(_that.id,_that.shipmentNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.salesOrderNo,_that.billOfLadingNo,_that.expectedWeightKg,_that.shippedWeightKg,_that.varianceWeightKg,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String shipmentNo,  ShipmentStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle,  String? salesOrderNo,  String? billOfLadingNo,  double expectedWeightKg,  double shippedWeightKg,  double? varianceWeightKg,  SyncState syncState,  List<ActionCapability> availableActions,  List<ShipmentLineEntity> lines,  String? note,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ShipmentEntity() when $default != null:
return $default(_that.id,_that.shipmentNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.salesOrderNo,_that.billOfLadingNo,_that.expectedWeightKg,_that.shippedWeightKg,_that.varianceWeightKg,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ShipmentEntity implements ShipmentEntity {
  const _ShipmentEntity({required this.id, required this.shipmentNo, required this.status, required this.owner, required this.warehouse, required this.vehicle, this.salesOrderNo, this.billOfLadingNo, required this.expectedWeightKg, required this.shippedWeightKg, this.varianceWeightKg, required this.syncState, final  List<ActionCapability> availableActions = const <ActionCapability>[], final  List<ShipmentLineEntity> lines = const <ShipmentLineEntity>[], this.note, this.errorMessage, required this.createdAt, required this.updatedAt}): _availableActions = availableActions,_lines = lines;
  factory _ShipmentEntity.fromJson(Map<String, dynamic> json) => _$ShipmentEntityFromJson(json);

@override final  String id;
@override final  String shipmentNo;
@override final  ShipmentStatus status;
@override final  OwnerSummary owner;
@override final  WarehouseSummary warehouse;
@override final  VehicleInfo vehicle;
@override final  String? salesOrderNo;
@override final  String? billOfLadingNo;
@override final  double expectedWeightKg;
@override final  double shippedWeightKg;
@override final  double? varianceWeightKg;
@override final  SyncState syncState;
 final  List<ActionCapability> _availableActions;
@override@JsonKey() List<ActionCapability> get availableActions {
  if (_availableActions is EqualUnmodifiableListView) return _availableActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableActions);
}

 final  List<ShipmentLineEntity> _lines;
@override@JsonKey() List<ShipmentLineEntity> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  String? note;
@override final  String? errorMessage;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShipmentEntityCopyWith<_ShipmentEntity> get copyWith => __$ShipmentEntityCopyWithImpl<_ShipmentEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShipmentEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShipmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.shipmentNo, shipmentNo) || other.shipmentNo == shipmentNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.salesOrderNo, salesOrderNo) || other.salesOrderNo == salesOrderNo)&&(identical(other.billOfLadingNo, billOfLadingNo) || other.billOfLadingNo == billOfLadingNo)&&(identical(other.expectedWeightKg, expectedWeightKg) || other.expectedWeightKg == expectedWeightKg)&&(identical(other.shippedWeightKg, shippedWeightKg) || other.shippedWeightKg == shippedWeightKg)&&(identical(other.varianceWeightKg, varianceWeightKg) || other.varianceWeightKg == varianceWeightKg)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&const DeepCollectionEquality().equals(other._availableActions, _availableActions)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shipmentNo,status,owner,warehouse,vehicle,salesOrderNo,billOfLadingNo,expectedWeightKg,shippedWeightKg,varianceWeightKg,syncState,const DeepCollectionEquality().hash(_availableActions),const DeepCollectionEquality().hash(_lines),note,errorMessage,createdAt,updatedAt);

@override
String toString() {
  return 'ShipmentEntity(id: $id, shipmentNo: $shipmentNo, status: $status, owner: $owner, warehouse: $warehouse, vehicle: $vehicle, salesOrderNo: $salesOrderNo, billOfLadingNo: $billOfLadingNo, expectedWeightKg: $expectedWeightKg, shippedWeightKg: $shippedWeightKg, varianceWeightKg: $varianceWeightKg, syncState: $syncState, availableActions: $availableActions, lines: $lines, note: $note, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ShipmentEntityCopyWith<$Res> implements $ShipmentEntityCopyWith<$Res> {
  factory _$ShipmentEntityCopyWith(_ShipmentEntity value, $Res Function(_ShipmentEntity) _then) = __$ShipmentEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String shipmentNo, ShipmentStatus status, OwnerSummary owner, WarehouseSummary warehouse, VehicleInfo vehicle, String? salesOrderNo, String? billOfLadingNo, double expectedWeightKg, double shippedWeightKg, double? varianceWeightKg, SyncState syncState, List<ActionCapability> availableActions, List<ShipmentLineEntity> lines, String? note, String? errorMessage, DateTime createdAt, DateTime updatedAt
});


@override $OwnerSummaryCopyWith<$Res> get owner;@override $WarehouseSummaryCopyWith<$Res> get warehouse;@override $VehicleInfoCopyWith<$Res> get vehicle;

}
/// @nodoc
class __$ShipmentEntityCopyWithImpl<$Res>
    implements _$ShipmentEntityCopyWith<$Res> {
  __$ShipmentEntityCopyWithImpl(this._self, this._then);

  final _ShipmentEntity _self;
  final $Res Function(_ShipmentEntity) _then;

/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shipmentNo = null,Object? status = null,Object? owner = null,Object? warehouse = null,Object? vehicle = null,Object? salesOrderNo = freezed,Object? billOfLadingNo = freezed,Object? expectedWeightKg = null,Object? shippedWeightKg = null,Object? varianceWeightKg = freezed,Object? syncState = null,Object? availableActions = null,Object? lines = null,Object? note = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ShipmentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shipmentNo: null == shipmentNo ? _self.shipmentNo : shipmentNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShipmentStatus,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerSummary,warehouse: null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as WarehouseSummary,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as VehicleInfo,salesOrderNo: freezed == salesOrderNo ? _self.salesOrderNo : salesOrderNo // ignore: cast_nullable_to_non_nullable
as String?,billOfLadingNo: freezed == billOfLadingNo ? _self.billOfLadingNo : billOfLadingNo // ignore: cast_nullable_to_non_nullable
as String?,expectedWeightKg: null == expectedWeightKg ? _self.expectedWeightKg : expectedWeightKg // ignore: cast_nullable_to_non_nullable
as double,shippedWeightKg: null == shippedWeightKg ? _self.shippedWeightKg : shippedWeightKg // ignore: cast_nullable_to_non_nullable
as double,varianceWeightKg: freezed == varianceWeightKg ? _self.varianceWeightKg : varianceWeightKg // ignore: cast_nullable_to_non_nullable
as double?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,availableActions: null == availableActions ? _self._availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<ShipmentLineEntity>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<$Res> get owner {
  
  return $OwnerSummaryCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of ShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res> get warehouse {
  
  return $WarehouseSummaryCopyWith<$Res>(_self.warehouse, (value) {
    return _then(_self.copyWith(warehouse: value));
  });
}/// Create a copy of ShipmentEntity
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
mixin _$ShipmentLineDto {

 String get id;@JsonKey(name: 'item_code') String get itemCode;@JsonKey(name: 'item_name') String get itemName;@JsonKey(name: 'uom_code') String get uomCode;@JsonKey(name: 'expected_qty') double get expectedQty;@JsonKey(name: 'shipped_qty') double get shippedQty;@JsonKey(name: 'short_pick') bool get shortPick;@JsonKey(name: 'source_location') LocationSummary? get sourceLocation;
/// Create a copy of ShipmentLineDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShipmentLineDtoCopyWith<ShipmentLineDto> get copyWith => _$ShipmentLineDtoCopyWithImpl<ShipmentLineDto>(this as ShipmentLineDto, _$identity);

  /// Serializes this ShipmentLineDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShipmentLineDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.uomCode, uomCode) || other.uomCode == uomCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.shippedQty, shippedQty) || other.shippedQty == shippedQty)&&(identical(other.shortPick, shortPick) || other.shortPick == shortPick)&&(identical(other.sourceLocation, sourceLocation) || other.sourceLocation == sourceLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemCode,itemName,uomCode,expectedQty,shippedQty,shortPick,sourceLocation);

@override
String toString() {
  return 'ShipmentLineDto(id: $id, itemCode: $itemCode, itemName: $itemName, uomCode: $uomCode, expectedQty: $expectedQty, shippedQty: $shippedQty, shortPick: $shortPick, sourceLocation: $sourceLocation)';
}


}

/// @nodoc
abstract mixin class $ShipmentLineDtoCopyWith<$Res>  {
  factory $ShipmentLineDtoCopyWith(ShipmentLineDto value, $Res Function(ShipmentLineDto) _then) = _$ShipmentLineDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'item_code') String itemCode,@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'uom_code') String uomCode,@JsonKey(name: 'expected_qty') double expectedQty,@JsonKey(name: 'shipped_qty') double shippedQty,@JsonKey(name: 'short_pick') bool shortPick,@JsonKey(name: 'source_location') LocationSummary? sourceLocation
});


$LocationSummaryCopyWith<$Res>? get sourceLocation;

}
/// @nodoc
class _$ShipmentLineDtoCopyWithImpl<$Res>
    implements $ShipmentLineDtoCopyWith<$Res> {
  _$ShipmentLineDtoCopyWithImpl(this._self, this._then);

  final ShipmentLineDto _self;
  final $Res Function(ShipmentLineDto) _then;

/// Create a copy of ShipmentLineDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemCode = null,Object? itemName = null,Object? uomCode = null,Object? expectedQty = null,Object? shippedQty = null,Object? shortPick = null,Object? sourceLocation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,uomCode: null == uomCode ? _self.uomCode : uomCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as double,shippedQty: null == shippedQty ? _self.shippedQty : shippedQty // ignore: cast_nullable_to_non_nullable
as double,shortPick: null == shortPick ? _self.shortPick : shortPick // ignore: cast_nullable_to_non_nullable
as bool,sourceLocation: freezed == sourceLocation ? _self.sourceLocation : sourceLocation // ignore: cast_nullable_to_non_nullable
as LocationSummary?,
  ));
}
/// Create a copy of ShipmentLineDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationSummaryCopyWith<$Res>? get sourceLocation {
    if (_self.sourceLocation == null) {
    return null;
  }

  return $LocationSummaryCopyWith<$Res>(_self.sourceLocation!, (value) {
    return _then(_self.copyWith(sourceLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShipmentLineDto].
extension ShipmentLineDtoPatterns on ShipmentLineDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShipmentLineDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShipmentLineDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShipmentLineDto value)  $default,){
final _that = this;
switch (_that) {
case _ShipmentLineDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShipmentLineDto value)?  $default,){
final _that = this;
switch (_that) {
case _ShipmentLineDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'uom_code')  String uomCode, @JsonKey(name: 'expected_qty')  double expectedQty, @JsonKey(name: 'shipped_qty')  double shippedQty, @JsonKey(name: 'short_pick')  bool shortPick, @JsonKey(name: 'source_location')  LocationSummary? sourceLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShipmentLineDto() when $default != null:
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.shippedQty,_that.shortPick,_that.sourceLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'uom_code')  String uomCode, @JsonKey(name: 'expected_qty')  double expectedQty, @JsonKey(name: 'shipped_qty')  double shippedQty, @JsonKey(name: 'short_pick')  bool shortPick, @JsonKey(name: 'source_location')  LocationSummary? sourceLocation)  $default,) {final _that = this;
switch (_that) {
case _ShipmentLineDto():
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.shippedQty,_that.shortPick,_that.sourceLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'uom_code')  String uomCode, @JsonKey(name: 'expected_qty')  double expectedQty, @JsonKey(name: 'shipped_qty')  double shippedQty, @JsonKey(name: 'short_pick')  bool shortPick, @JsonKey(name: 'source_location')  LocationSummary? sourceLocation)?  $default,) {final _that = this;
switch (_that) {
case _ShipmentLineDto() when $default != null:
return $default(_that.id,_that.itemCode,_that.itemName,_that.uomCode,_that.expectedQty,_that.shippedQty,_that.shortPick,_that.sourceLocation);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ShipmentLineDto implements ShipmentLineDto {
  const _ShipmentLineDto({required this.id, @JsonKey(name: 'item_code') required this.itemCode, @JsonKey(name: 'item_name') required this.itemName, @JsonKey(name: 'uom_code') required this.uomCode, @JsonKey(name: 'expected_qty') required this.expectedQty, @JsonKey(name: 'shipped_qty') required this.shippedQty, @JsonKey(name: 'short_pick') this.shortPick = false, @JsonKey(name: 'source_location') this.sourceLocation});
  factory _ShipmentLineDto.fromJson(Map<String, dynamic> json) => _$ShipmentLineDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'item_code') final  String itemCode;
@override@JsonKey(name: 'item_name') final  String itemName;
@override@JsonKey(name: 'uom_code') final  String uomCode;
@override@JsonKey(name: 'expected_qty') final  double expectedQty;
@override@JsonKey(name: 'shipped_qty') final  double shippedQty;
@override@JsonKey(name: 'short_pick') final  bool shortPick;
@override@JsonKey(name: 'source_location') final  LocationSummary? sourceLocation;

/// Create a copy of ShipmentLineDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShipmentLineDtoCopyWith<_ShipmentLineDto> get copyWith => __$ShipmentLineDtoCopyWithImpl<_ShipmentLineDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShipmentLineDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShipmentLineDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.uomCode, uomCode) || other.uomCode == uomCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.shippedQty, shippedQty) || other.shippedQty == shippedQty)&&(identical(other.shortPick, shortPick) || other.shortPick == shortPick)&&(identical(other.sourceLocation, sourceLocation) || other.sourceLocation == sourceLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemCode,itemName,uomCode,expectedQty,shippedQty,shortPick,sourceLocation);

@override
String toString() {
  return 'ShipmentLineDto(id: $id, itemCode: $itemCode, itemName: $itemName, uomCode: $uomCode, expectedQty: $expectedQty, shippedQty: $shippedQty, shortPick: $shortPick, sourceLocation: $sourceLocation)';
}


}

/// @nodoc
abstract mixin class _$ShipmentLineDtoCopyWith<$Res> implements $ShipmentLineDtoCopyWith<$Res> {
  factory _$ShipmentLineDtoCopyWith(_ShipmentLineDto value, $Res Function(_ShipmentLineDto) _then) = __$ShipmentLineDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'item_code') String itemCode,@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'uom_code') String uomCode,@JsonKey(name: 'expected_qty') double expectedQty,@JsonKey(name: 'shipped_qty') double shippedQty,@JsonKey(name: 'short_pick') bool shortPick,@JsonKey(name: 'source_location') LocationSummary? sourceLocation
});


@override $LocationSummaryCopyWith<$Res>? get sourceLocation;

}
/// @nodoc
class __$ShipmentLineDtoCopyWithImpl<$Res>
    implements _$ShipmentLineDtoCopyWith<$Res> {
  __$ShipmentLineDtoCopyWithImpl(this._self, this._then);

  final _ShipmentLineDto _self;
  final $Res Function(_ShipmentLineDto) _then;

/// Create a copy of ShipmentLineDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemCode = null,Object? itemName = null,Object? uomCode = null,Object? expectedQty = null,Object? shippedQty = null,Object? shortPick = null,Object? sourceLocation = freezed,}) {
  return _then(_ShipmentLineDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,uomCode: null == uomCode ? _self.uomCode : uomCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as double,shippedQty: null == shippedQty ? _self.shippedQty : shippedQty // ignore: cast_nullable_to_non_nullable
as double,shortPick: null == shortPick ? _self.shortPick : shortPick // ignore: cast_nullable_to_non_nullable
as bool,sourceLocation: freezed == sourceLocation ? _self.sourceLocation : sourceLocation // ignore: cast_nullable_to_non_nullable
as LocationSummary?,
  ));
}

/// Create a copy of ShipmentLineDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationSummaryCopyWith<$Res>? get sourceLocation {
    if (_self.sourceLocation == null) {
    return null;
  }

  return $LocationSummaryCopyWith<$Res>(_self.sourceLocation!, (value) {
    return _then(_self.copyWith(sourceLocation: value));
  });
}
}


/// @nodoc
mixin _$ShipmentDto {

 String get id;@JsonKey(name: 'shipment_no') String get shipmentNo; ShipmentStatus get status; OwnerSummary get owner; WarehouseSummary get warehouse; VehicleInfo get vehicle;@JsonKey(name: 'sales_order_no') String? get salesOrderNo;@JsonKey(name: 'bill_of_lading_no') String? get billOfLadingNo;@JsonKey(name: 'expected_weight_kg') double get expectedWeightKg;@JsonKey(name: 'shipped_weight_kg') double get shippedWeightKg;@JsonKey(name: 'variance_weight_kg') double? get varianceWeightKg;@JsonKey(name: 'sync_state') SyncState get syncState;@JsonKey(name: 'available_actions') List<ActionCapability> get availableActions; List<ShipmentLineDto> get lines; String? get note;@JsonKey(name: 'error_message') String? get errorMessage;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShipmentDtoCopyWith<ShipmentDto> get copyWith => _$ShipmentDtoCopyWithImpl<ShipmentDto>(this as ShipmentDto, _$identity);

  /// Serializes this ShipmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShipmentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.shipmentNo, shipmentNo) || other.shipmentNo == shipmentNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.salesOrderNo, salesOrderNo) || other.salesOrderNo == salesOrderNo)&&(identical(other.billOfLadingNo, billOfLadingNo) || other.billOfLadingNo == billOfLadingNo)&&(identical(other.expectedWeightKg, expectedWeightKg) || other.expectedWeightKg == expectedWeightKg)&&(identical(other.shippedWeightKg, shippedWeightKg) || other.shippedWeightKg == shippedWeightKg)&&(identical(other.varianceWeightKg, varianceWeightKg) || other.varianceWeightKg == varianceWeightKg)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&const DeepCollectionEquality().equals(other.availableActions, availableActions)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shipmentNo,status,owner,warehouse,vehicle,salesOrderNo,billOfLadingNo,expectedWeightKg,shippedWeightKg,varianceWeightKg,syncState,const DeepCollectionEquality().hash(availableActions),const DeepCollectionEquality().hash(lines),note,errorMessage,createdAt,updatedAt);

@override
String toString() {
  return 'ShipmentDto(id: $id, shipmentNo: $shipmentNo, status: $status, owner: $owner, warehouse: $warehouse, vehicle: $vehicle, salesOrderNo: $salesOrderNo, billOfLadingNo: $billOfLadingNo, expectedWeightKg: $expectedWeightKg, shippedWeightKg: $shippedWeightKg, varianceWeightKg: $varianceWeightKg, syncState: $syncState, availableActions: $availableActions, lines: $lines, note: $note, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ShipmentDtoCopyWith<$Res>  {
  factory $ShipmentDtoCopyWith(ShipmentDto value, $Res Function(ShipmentDto) _then) = _$ShipmentDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'shipment_no') String shipmentNo, ShipmentStatus status, OwnerSummary owner, WarehouseSummary warehouse, VehicleInfo vehicle,@JsonKey(name: 'sales_order_no') String? salesOrderNo,@JsonKey(name: 'bill_of_lading_no') String? billOfLadingNo,@JsonKey(name: 'expected_weight_kg') double expectedWeightKg,@JsonKey(name: 'shipped_weight_kg') double shippedWeightKg,@JsonKey(name: 'variance_weight_kg') double? varianceWeightKg,@JsonKey(name: 'sync_state') SyncState syncState,@JsonKey(name: 'available_actions') List<ActionCapability> availableActions, List<ShipmentLineDto> lines, String? note,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});


$OwnerSummaryCopyWith<$Res> get owner;$WarehouseSummaryCopyWith<$Res> get warehouse;$VehicleInfoCopyWith<$Res> get vehicle;

}
/// @nodoc
class _$ShipmentDtoCopyWithImpl<$Res>
    implements $ShipmentDtoCopyWith<$Res> {
  _$ShipmentDtoCopyWithImpl(this._self, this._then);

  final ShipmentDto _self;
  final $Res Function(ShipmentDto) _then;

/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shipmentNo = null,Object? status = null,Object? owner = null,Object? warehouse = null,Object? vehicle = null,Object? salesOrderNo = freezed,Object? billOfLadingNo = freezed,Object? expectedWeightKg = null,Object? shippedWeightKg = null,Object? varianceWeightKg = freezed,Object? syncState = null,Object? availableActions = null,Object? lines = null,Object? note = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shipmentNo: null == shipmentNo ? _self.shipmentNo : shipmentNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShipmentStatus,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerSummary,warehouse: null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as WarehouseSummary,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as VehicleInfo,salesOrderNo: freezed == salesOrderNo ? _self.salesOrderNo : salesOrderNo // ignore: cast_nullable_to_non_nullable
as String?,billOfLadingNo: freezed == billOfLadingNo ? _self.billOfLadingNo : billOfLadingNo // ignore: cast_nullable_to_non_nullable
as String?,expectedWeightKg: null == expectedWeightKg ? _self.expectedWeightKg : expectedWeightKg // ignore: cast_nullable_to_non_nullable
as double,shippedWeightKg: null == shippedWeightKg ? _self.shippedWeightKg : shippedWeightKg // ignore: cast_nullable_to_non_nullable
as double,varianceWeightKg: freezed == varianceWeightKg ? _self.varianceWeightKg : varianceWeightKg // ignore: cast_nullable_to_non_nullable
as double?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,availableActions: null == availableActions ? _self.availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<ShipmentLineDto>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<$Res> get owner {
  
  return $OwnerSummaryCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res> get warehouse {
  
  return $WarehouseSummaryCopyWith<$Res>(_self.warehouse, (value) {
    return _then(_self.copyWith(warehouse: value));
  });
}/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<$Res> get vehicle {
  
  return $VehicleInfoCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShipmentDto].
extension ShipmentDtoPatterns on ShipmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShipmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShipmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShipmentDto value)  $default,){
final _that = this;
switch (_that) {
case _ShipmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShipmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _ShipmentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'shipment_no')  String shipmentNo,  ShipmentStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle, @JsonKey(name: 'sales_order_no')  String? salesOrderNo, @JsonKey(name: 'bill_of_lading_no')  String? billOfLadingNo, @JsonKey(name: 'expected_weight_kg')  double expectedWeightKg, @JsonKey(name: 'shipped_weight_kg')  double shippedWeightKg, @JsonKey(name: 'variance_weight_kg')  double? varianceWeightKg, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'available_actions')  List<ActionCapability> availableActions,  List<ShipmentLineDto> lines,  String? note, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShipmentDto() when $default != null:
return $default(_that.id,_that.shipmentNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.salesOrderNo,_that.billOfLadingNo,_that.expectedWeightKg,_that.shippedWeightKg,_that.varianceWeightKg,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'shipment_no')  String shipmentNo,  ShipmentStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle, @JsonKey(name: 'sales_order_no')  String? salesOrderNo, @JsonKey(name: 'bill_of_lading_no')  String? billOfLadingNo, @JsonKey(name: 'expected_weight_kg')  double expectedWeightKg, @JsonKey(name: 'shipped_weight_kg')  double shippedWeightKg, @JsonKey(name: 'variance_weight_kg')  double? varianceWeightKg, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'available_actions')  List<ActionCapability> availableActions,  List<ShipmentLineDto> lines,  String? note, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ShipmentDto():
return $default(_that.id,_that.shipmentNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.salesOrderNo,_that.billOfLadingNo,_that.expectedWeightKg,_that.shippedWeightKg,_that.varianceWeightKg,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'shipment_no')  String shipmentNo,  ShipmentStatus status,  OwnerSummary owner,  WarehouseSummary warehouse,  VehicleInfo vehicle, @JsonKey(name: 'sales_order_no')  String? salesOrderNo, @JsonKey(name: 'bill_of_lading_no')  String? billOfLadingNo, @JsonKey(name: 'expected_weight_kg')  double expectedWeightKg, @JsonKey(name: 'shipped_weight_kg')  double shippedWeightKg, @JsonKey(name: 'variance_weight_kg')  double? varianceWeightKg, @JsonKey(name: 'sync_state')  SyncState syncState, @JsonKey(name: 'available_actions')  List<ActionCapability> availableActions,  List<ShipmentLineDto> lines,  String? note, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ShipmentDto() when $default != null:
return $default(_that.id,_that.shipmentNo,_that.status,_that.owner,_that.warehouse,_that.vehicle,_that.salesOrderNo,_that.billOfLadingNo,_that.expectedWeightKg,_that.shippedWeightKg,_that.varianceWeightKg,_that.syncState,_that.availableActions,_that.lines,_that.note,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ShipmentDto implements ShipmentDto {
  const _ShipmentDto({required this.id, @JsonKey(name: 'shipment_no') required this.shipmentNo, required this.status, required this.owner, required this.warehouse, required this.vehicle, @JsonKey(name: 'sales_order_no') this.salesOrderNo, @JsonKey(name: 'bill_of_lading_no') this.billOfLadingNo, @JsonKey(name: 'expected_weight_kg') required this.expectedWeightKg, @JsonKey(name: 'shipped_weight_kg') required this.shippedWeightKg, @JsonKey(name: 'variance_weight_kg') this.varianceWeightKg, @JsonKey(name: 'sync_state') required this.syncState, @JsonKey(name: 'available_actions') final  List<ActionCapability> availableActions = const <ActionCapability>[], final  List<ShipmentLineDto> lines = const <ShipmentLineDto>[], this.note, @JsonKey(name: 'error_message') this.errorMessage, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _availableActions = availableActions,_lines = lines;
  factory _ShipmentDto.fromJson(Map<String, dynamic> json) => _$ShipmentDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'shipment_no') final  String shipmentNo;
@override final  ShipmentStatus status;
@override final  OwnerSummary owner;
@override final  WarehouseSummary warehouse;
@override final  VehicleInfo vehicle;
@override@JsonKey(name: 'sales_order_no') final  String? salesOrderNo;
@override@JsonKey(name: 'bill_of_lading_no') final  String? billOfLadingNo;
@override@JsonKey(name: 'expected_weight_kg') final  double expectedWeightKg;
@override@JsonKey(name: 'shipped_weight_kg') final  double shippedWeightKg;
@override@JsonKey(name: 'variance_weight_kg') final  double? varianceWeightKg;
@override@JsonKey(name: 'sync_state') final  SyncState syncState;
 final  List<ActionCapability> _availableActions;
@override@JsonKey(name: 'available_actions') List<ActionCapability> get availableActions {
  if (_availableActions is EqualUnmodifiableListView) return _availableActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableActions);
}

 final  List<ShipmentLineDto> _lines;
@override@JsonKey() List<ShipmentLineDto> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  String? note;
@override@JsonKey(name: 'error_message') final  String? errorMessage;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShipmentDtoCopyWith<_ShipmentDto> get copyWith => __$ShipmentDtoCopyWithImpl<_ShipmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShipmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShipmentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.shipmentNo, shipmentNo) || other.shipmentNo == shipmentNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.salesOrderNo, salesOrderNo) || other.salesOrderNo == salesOrderNo)&&(identical(other.billOfLadingNo, billOfLadingNo) || other.billOfLadingNo == billOfLadingNo)&&(identical(other.expectedWeightKg, expectedWeightKg) || other.expectedWeightKg == expectedWeightKg)&&(identical(other.shippedWeightKg, shippedWeightKg) || other.shippedWeightKg == shippedWeightKg)&&(identical(other.varianceWeightKg, varianceWeightKg) || other.varianceWeightKg == varianceWeightKg)&&(identical(other.syncState, syncState) || other.syncState == syncState)&&const DeepCollectionEquality().equals(other._availableActions, _availableActions)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shipmentNo,status,owner,warehouse,vehicle,salesOrderNo,billOfLadingNo,expectedWeightKg,shippedWeightKg,varianceWeightKg,syncState,const DeepCollectionEquality().hash(_availableActions),const DeepCollectionEquality().hash(_lines),note,errorMessage,createdAt,updatedAt);

@override
String toString() {
  return 'ShipmentDto(id: $id, shipmentNo: $shipmentNo, status: $status, owner: $owner, warehouse: $warehouse, vehicle: $vehicle, salesOrderNo: $salesOrderNo, billOfLadingNo: $billOfLadingNo, expectedWeightKg: $expectedWeightKg, shippedWeightKg: $shippedWeightKg, varianceWeightKg: $varianceWeightKg, syncState: $syncState, availableActions: $availableActions, lines: $lines, note: $note, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ShipmentDtoCopyWith<$Res> implements $ShipmentDtoCopyWith<$Res> {
  factory _$ShipmentDtoCopyWith(_ShipmentDto value, $Res Function(_ShipmentDto) _then) = __$ShipmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'shipment_no') String shipmentNo, ShipmentStatus status, OwnerSummary owner, WarehouseSummary warehouse, VehicleInfo vehicle,@JsonKey(name: 'sales_order_no') String? salesOrderNo,@JsonKey(name: 'bill_of_lading_no') String? billOfLadingNo,@JsonKey(name: 'expected_weight_kg') double expectedWeightKg,@JsonKey(name: 'shipped_weight_kg') double shippedWeightKg,@JsonKey(name: 'variance_weight_kg') double? varianceWeightKg,@JsonKey(name: 'sync_state') SyncState syncState,@JsonKey(name: 'available_actions') List<ActionCapability> availableActions, List<ShipmentLineDto> lines, String? note,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});


@override $OwnerSummaryCopyWith<$Res> get owner;@override $WarehouseSummaryCopyWith<$Res> get warehouse;@override $VehicleInfoCopyWith<$Res> get vehicle;

}
/// @nodoc
class __$ShipmentDtoCopyWithImpl<$Res>
    implements _$ShipmentDtoCopyWith<$Res> {
  __$ShipmentDtoCopyWithImpl(this._self, this._then);

  final _ShipmentDto _self;
  final $Res Function(_ShipmentDto) _then;

/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shipmentNo = null,Object? status = null,Object? owner = null,Object? warehouse = null,Object? vehicle = null,Object? salesOrderNo = freezed,Object? billOfLadingNo = freezed,Object? expectedWeightKg = null,Object? shippedWeightKg = null,Object? varianceWeightKg = freezed,Object? syncState = null,Object? availableActions = null,Object? lines = null,Object? note = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ShipmentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shipmentNo: null == shipmentNo ? _self.shipmentNo : shipmentNo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShipmentStatus,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerSummary,warehouse: null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as WarehouseSummary,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as VehicleInfo,salesOrderNo: freezed == salesOrderNo ? _self.salesOrderNo : salesOrderNo // ignore: cast_nullable_to_non_nullable
as String?,billOfLadingNo: freezed == billOfLadingNo ? _self.billOfLadingNo : billOfLadingNo // ignore: cast_nullable_to_non_nullable
as String?,expectedWeightKg: null == expectedWeightKg ? _self.expectedWeightKg : expectedWeightKg // ignore: cast_nullable_to_non_nullable
as double,shippedWeightKg: null == shippedWeightKg ? _self.shippedWeightKg : shippedWeightKg // ignore: cast_nullable_to_non_nullable
as double,varianceWeightKg: freezed == varianceWeightKg ? _self.varianceWeightKg : varianceWeightKg // ignore: cast_nullable_to_non_nullable
as double?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,availableActions: null == availableActions ? _self._availableActions : availableActions // ignore: cast_nullable_to_non_nullable
as List<ActionCapability>,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<ShipmentLineDto>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<$Res> get owner {
  
  return $OwnerSummaryCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of ShipmentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<$Res> get warehouse {
  
  return $WarehouseSummaryCopyWith<$Res>(_self.warehouse, (value) {
    return _then(_self.copyWith(warehouse: value));
  });
}/// Create a copy of ShipmentDto
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
