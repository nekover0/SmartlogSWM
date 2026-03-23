// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_record_contract.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OcrExtractedFieldsEntity {

 String? get documentNo; String? get vehiclePlate; String? get ownerCode; String? get ownerName; String? get itemCode; String? get itemName; double? get grossWeightKg; double? get netWeightKg;
/// Create a copy of OcrExtractedFieldsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrExtractedFieldsEntityCopyWith<OcrExtractedFieldsEntity> get copyWith => _$OcrExtractedFieldsEntityCopyWithImpl<OcrExtractedFieldsEntity>(this as OcrExtractedFieldsEntity, _$identity);

  /// Serializes this OcrExtractedFieldsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrExtractedFieldsEntity&&(identical(other.documentNo, documentNo) || other.documentNo == documentNo)&&(identical(other.vehiclePlate, vehiclePlate) || other.vehiclePlate == vehiclePlate)&&(identical(other.ownerCode, ownerCode) || other.ownerCode == ownerCode)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.grossWeightKg, grossWeightKg) || other.grossWeightKg == grossWeightKg)&&(identical(other.netWeightKg, netWeightKg) || other.netWeightKg == netWeightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentNo,vehiclePlate,ownerCode,ownerName,itemCode,itemName,grossWeightKg,netWeightKg);

@override
String toString() {
  return 'OcrExtractedFieldsEntity(documentNo: $documentNo, vehiclePlate: $vehiclePlate, ownerCode: $ownerCode, ownerName: $ownerName, itemCode: $itemCode, itemName: $itemName, grossWeightKg: $grossWeightKg, netWeightKg: $netWeightKg)';
}


}

/// @nodoc
abstract mixin class $OcrExtractedFieldsEntityCopyWith<$Res>  {
  factory $OcrExtractedFieldsEntityCopyWith(OcrExtractedFieldsEntity value, $Res Function(OcrExtractedFieldsEntity) _then) = _$OcrExtractedFieldsEntityCopyWithImpl;
@useResult
$Res call({
 String? documentNo, String? vehiclePlate, String? ownerCode, String? ownerName, String? itemCode, String? itemName, double? grossWeightKg, double? netWeightKg
});




}
/// @nodoc
class _$OcrExtractedFieldsEntityCopyWithImpl<$Res>
    implements $OcrExtractedFieldsEntityCopyWith<$Res> {
  _$OcrExtractedFieldsEntityCopyWithImpl(this._self, this._then);

  final OcrExtractedFieldsEntity _self;
  final $Res Function(OcrExtractedFieldsEntity) _then;

/// Create a copy of OcrExtractedFieldsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentNo = freezed,Object? vehiclePlate = freezed,Object? ownerCode = freezed,Object? ownerName = freezed,Object? itemCode = freezed,Object? itemName = freezed,Object? grossWeightKg = freezed,Object? netWeightKg = freezed,}) {
  return _then(_self.copyWith(
documentNo: freezed == documentNo ? _self.documentNo : documentNo // ignore: cast_nullable_to_non_nullable
as String?,vehiclePlate: freezed == vehiclePlate ? _self.vehiclePlate : vehiclePlate // ignore: cast_nullable_to_non_nullable
as String?,ownerCode: freezed == ownerCode ? _self.ownerCode : ownerCode // ignore: cast_nullable_to_non_nullable
as String?,ownerName: freezed == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String?,itemCode: freezed == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String?,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,grossWeightKg: freezed == grossWeightKg ? _self.grossWeightKg : grossWeightKg // ignore: cast_nullable_to_non_nullable
as double?,netWeightKg: freezed == netWeightKg ? _self.netWeightKg : netWeightKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [OcrExtractedFieldsEntity].
extension OcrExtractedFieldsEntityPatterns on OcrExtractedFieldsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrExtractedFieldsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrExtractedFieldsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrExtractedFieldsEntity value)  $default,){
final _that = this;
switch (_that) {
case _OcrExtractedFieldsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrExtractedFieldsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OcrExtractedFieldsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? documentNo,  String? vehiclePlate,  String? ownerCode,  String? ownerName,  String? itemCode,  String? itemName,  double? grossWeightKg,  double? netWeightKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrExtractedFieldsEntity() when $default != null:
return $default(_that.documentNo,_that.vehiclePlate,_that.ownerCode,_that.ownerName,_that.itemCode,_that.itemName,_that.grossWeightKg,_that.netWeightKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? documentNo,  String? vehiclePlate,  String? ownerCode,  String? ownerName,  String? itemCode,  String? itemName,  double? grossWeightKg,  double? netWeightKg)  $default,) {final _that = this;
switch (_that) {
case _OcrExtractedFieldsEntity():
return $default(_that.documentNo,_that.vehiclePlate,_that.ownerCode,_that.ownerName,_that.itemCode,_that.itemName,_that.grossWeightKg,_that.netWeightKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? documentNo,  String? vehiclePlate,  String? ownerCode,  String? ownerName,  String? itemCode,  String? itemName,  double? grossWeightKg,  double? netWeightKg)?  $default,) {final _that = this;
switch (_that) {
case _OcrExtractedFieldsEntity() when $default != null:
return $default(_that.documentNo,_that.vehiclePlate,_that.ownerCode,_that.ownerName,_that.itemCode,_that.itemName,_that.grossWeightKg,_that.netWeightKg);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OcrExtractedFieldsEntity implements OcrExtractedFieldsEntity {
  const _OcrExtractedFieldsEntity({this.documentNo, this.vehiclePlate, this.ownerCode, this.ownerName, this.itemCode, this.itemName, this.grossWeightKg, this.netWeightKg});
  factory _OcrExtractedFieldsEntity.fromJson(Map<String, dynamic> json) => _$OcrExtractedFieldsEntityFromJson(json);

@override final  String? documentNo;
@override final  String? vehiclePlate;
@override final  String? ownerCode;
@override final  String? ownerName;
@override final  String? itemCode;
@override final  String? itemName;
@override final  double? grossWeightKg;
@override final  double? netWeightKg;

/// Create a copy of OcrExtractedFieldsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrExtractedFieldsEntityCopyWith<_OcrExtractedFieldsEntity> get copyWith => __$OcrExtractedFieldsEntityCopyWithImpl<_OcrExtractedFieldsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrExtractedFieldsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrExtractedFieldsEntity&&(identical(other.documentNo, documentNo) || other.documentNo == documentNo)&&(identical(other.vehiclePlate, vehiclePlate) || other.vehiclePlate == vehiclePlate)&&(identical(other.ownerCode, ownerCode) || other.ownerCode == ownerCode)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.grossWeightKg, grossWeightKg) || other.grossWeightKg == grossWeightKg)&&(identical(other.netWeightKg, netWeightKg) || other.netWeightKg == netWeightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentNo,vehiclePlate,ownerCode,ownerName,itemCode,itemName,grossWeightKg,netWeightKg);

@override
String toString() {
  return 'OcrExtractedFieldsEntity(documentNo: $documentNo, vehiclePlate: $vehiclePlate, ownerCode: $ownerCode, ownerName: $ownerName, itemCode: $itemCode, itemName: $itemName, grossWeightKg: $grossWeightKg, netWeightKg: $netWeightKg)';
}


}

/// @nodoc
abstract mixin class _$OcrExtractedFieldsEntityCopyWith<$Res> implements $OcrExtractedFieldsEntityCopyWith<$Res> {
  factory _$OcrExtractedFieldsEntityCopyWith(_OcrExtractedFieldsEntity value, $Res Function(_OcrExtractedFieldsEntity) _then) = __$OcrExtractedFieldsEntityCopyWithImpl;
@override @useResult
$Res call({
 String? documentNo, String? vehiclePlate, String? ownerCode, String? ownerName, String? itemCode, String? itemName, double? grossWeightKg, double? netWeightKg
});




}
/// @nodoc
class __$OcrExtractedFieldsEntityCopyWithImpl<$Res>
    implements _$OcrExtractedFieldsEntityCopyWith<$Res> {
  __$OcrExtractedFieldsEntityCopyWithImpl(this._self, this._then);

  final _OcrExtractedFieldsEntity _self;
  final $Res Function(_OcrExtractedFieldsEntity) _then;

/// Create a copy of OcrExtractedFieldsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentNo = freezed,Object? vehiclePlate = freezed,Object? ownerCode = freezed,Object? ownerName = freezed,Object? itemCode = freezed,Object? itemName = freezed,Object? grossWeightKg = freezed,Object? netWeightKg = freezed,}) {
  return _then(_OcrExtractedFieldsEntity(
documentNo: freezed == documentNo ? _self.documentNo : documentNo // ignore: cast_nullable_to_non_nullable
as String?,vehiclePlate: freezed == vehiclePlate ? _self.vehiclePlate : vehiclePlate // ignore: cast_nullable_to_non_nullable
as String?,ownerCode: freezed == ownerCode ? _self.ownerCode : ownerCode // ignore: cast_nullable_to_non_nullable
as String?,ownerName: freezed == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String?,itemCode: freezed == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String?,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,grossWeightKg: freezed == grossWeightKg ? _self.grossWeightKg : grossWeightKg // ignore: cast_nullable_to_non_nullable
as double?,netWeightKg: freezed == netWeightKg ? _self.netWeightKg : netWeightKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$OcrRecordEntity {

 String get id; DocumentDirection get direction; OcrRecordStatus get status; double get confidenceScore; ConfidenceLevel get confidenceLevel; OcrExtractedFieldsEntity get extractedFields; List<FieldReviewFlag> get reviewFlags; String get sourceImageUrl; LinkedTargetType get linkedTargetType; String? get linkedTargetId; String? get linkedTargetNo; String? get errorMessage; DateTime get capturedAt; DateTime? get processedAt; DateTime? get linkedAt; SyncState get syncState;
/// Create a copy of OcrRecordEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrRecordEntityCopyWith<OcrRecordEntity> get copyWith => _$OcrRecordEntityCopyWithImpl<OcrRecordEntity>(this as OcrRecordEntity, _$identity);

  /// Serializes this OcrRecordEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrRecordEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&(identical(other.confidenceLevel, confidenceLevel) || other.confidenceLevel == confidenceLevel)&&(identical(other.extractedFields, extractedFields) || other.extractedFields == extractedFields)&&const DeepCollectionEquality().equals(other.reviewFlags, reviewFlags)&&(identical(other.sourceImageUrl, sourceImageUrl) || other.sourceImageUrl == sourceImageUrl)&&(identical(other.linkedTargetType, linkedTargetType) || other.linkedTargetType == linkedTargetType)&&(identical(other.linkedTargetId, linkedTargetId) || other.linkedTargetId == linkedTargetId)&&(identical(other.linkedTargetNo, linkedTargetNo) || other.linkedTargetNo == linkedTargetNo)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,direction,status,confidenceScore,confidenceLevel,extractedFields,const DeepCollectionEquality().hash(reviewFlags),sourceImageUrl,linkedTargetType,linkedTargetId,linkedTargetNo,errorMessage,capturedAt,processedAt,linkedAt,syncState);

@override
String toString() {
  return 'OcrRecordEntity(id: $id, direction: $direction, status: $status, confidenceScore: $confidenceScore, confidenceLevel: $confidenceLevel, extractedFields: $extractedFields, reviewFlags: $reviewFlags, sourceImageUrl: $sourceImageUrl, linkedTargetType: $linkedTargetType, linkedTargetId: $linkedTargetId, linkedTargetNo: $linkedTargetNo, errorMessage: $errorMessage, capturedAt: $capturedAt, processedAt: $processedAt, linkedAt: $linkedAt, syncState: $syncState)';
}


}

/// @nodoc
abstract mixin class $OcrRecordEntityCopyWith<$Res>  {
  factory $OcrRecordEntityCopyWith(OcrRecordEntity value, $Res Function(OcrRecordEntity) _then) = _$OcrRecordEntityCopyWithImpl;
@useResult
$Res call({
 String id, DocumentDirection direction, OcrRecordStatus status, double confidenceScore, ConfidenceLevel confidenceLevel, OcrExtractedFieldsEntity extractedFields, List<FieldReviewFlag> reviewFlags, String sourceImageUrl, LinkedTargetType linkedTargetType, String? linkedTargetId, String? linkedTargetNo, String? errorMessage, DateTime capturedAt, DateTime? processedAt, DateTime? linkedAt, SyncState syncState
});


$OcrExtractedFieldsEntityCopyWith<$Res> get extractedFields;

}
/// @nodoc
class _$OcrRecordEntityCopyWithImpl<$Res>
    implements $OcrRecordEntityCopyWith<$Res> {
  _$OcrRecordEntityCopyWithImpl(this._self, this._then);

  final OcrRecordEntity _self;
  final $Res Function(OcrRecordEntity) _then;

/// Create a copy of OcrRecordEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? direction = null,Object? status = null,Object? confidenceScore = null,Object? confidenceLevel = null,Object? extractedFields = null,Object? reviewFlags = null,Object? sourceImageUrl = null,Object? linkedTargetType = null,Object? linkedTargetId = freezed,Object? linkedTargetNo = freezed,Object? errorMessage = freezed,Object? capturedAt = null,Object? processedAt = freezed,Object? linkedAt = freezed,Object? syncState = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as DocumentDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OcrRecordStatus,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,extractedFields: null == extractedFields ? _self.extractedFields : extractedFields // ignore: cast_nullable_to_non_nullable
as OcrExtractedFieldsEntity,reviewFlags: null == reviewFlags ? _self.reviewFlags : reviewFlags // ignore: cast_nullable_to_non_nullable
as List<FieldReviewFlag>,sourceImageUrl: null == sourceImageUrl ? _self.sourceImageUrl : sourceImageUrl // ignore: cast_nullable_to_non_nullable
as String,linkedTargetType: null == linkedTargetType ? _self.linkedTargetType : linkedTargetType // ignore: cast_nullable_to_non_nullable
as LinkedTargetType,linkedTargetId: freezed == linkedTargetId ? _self.linkedTargetId : linkedTargetId // ignore: cast_nullable_to_non_nullable
as String?,linkedTargetNo: freezed == linkedTargetNo ? _self.linkedTargetNo : linkedTargetNo // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedAt: freezed == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,
  ));
}
/// Create a copy of OcrRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OcrExtractedFieldsEntityCopyWith<$Res> get extractedFields {
  
  return $OcrExtractedFieldsEntityCopyWith<$Res>(_self.extractedFields, (value) {
    return _then(_self.copyWith(extractedFields: value));
  });
}
}


/// Adds pattern-matching-related methods to [OcrRecordEntity].
extension OcrRecordEntityPatterns on OcrRecordEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrRecordEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrRecordEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrRecordEntity value)  $default,){
final _that = this;
switch (_that) {
case _OcrRecordEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrRecordEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OcrRecordEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DocumentDirection direction,  OcrRecordStatus status,  double confidenceScore,  ConfidenceLevel confidenceLevel,  OcrExtractedFieldsEntity extractedFields,  List<FieldReviewFlag> reviewFlags,  String sourceImageUrl,  LinkedTargetType linkedTargetType,  String? linkedTargetId,  String? linkedTargetNo,  String? errorMessage,  DateTime capturedAt,  DateTime? processedAt,  DateTime? linkedAt,  SyncState syncState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrRecordEntity() when $default != null:
return $default(_that.id,_that.direction,_that.status,_that.confidenceScore,_that.confidenceLevel,_that.extractedFields,_that.reviewFlags,_that.sourceImageUrl,_that.linkedTargetType,_that.linkedTargetId,_that.linkedTargetNo,_that.errorMessage,_that.capturedAt,_that.processedAt,_that.linkedAt,_that.syncState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DocumentDirection direction,  OcrRecordStatus status,  double confidenceScore,  ConfidenceLevel confidenceLevel,  OcrExtractedFieldsEntity extractedFields,  List<FieldReviewFlag> reviewFlags,  String sourceImageUrl,  LinkedTargetType linkedTargetType,  String? linkedTargetId,  String? linkedTargetNo,  String? errorMessage,  DateTime capturedAt,  DateTime? processedAt,  DateTime? linkedAt,  SyncState syncState)  $default,) {final _that = this;
switch (_that) {
case _OcrRecordEntity():
return $default(_that.id,_that.direction,_that.status,_that.confidenceScore,_that.confidenceLevel,_that.extractedFields,_that.reviewFlags,_that.sourceImageUrl,_that.linkedTargetType,_that.linkedTargetId,_that.linkedTargetNo,_that.errorMessage,_that.capturedAt,_that.processedAt,_that.linkedAt,_that.syncState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DocumentDirection direction,  OcrRecordStatus status,  double confidenceScore,  ConfidenceLevel confidenceLevel,  OcrExtractedFieldsEntity extractedFields,  List<FieldReviewFlag> reviewFlags,  String sourceImageUrl,  LinkedTargetType linkedTargetType,  String? linkedTargetId,  String? linkedTargetNo,  String? errorMessage,  DateTime capturedAt,  DateTime? processedAt,  DateTime? linkedAt,  SyncState syncState)?  $default,) {final _that = this;
switch (_that) {
case _OcrRecordEntity() when $default != null:
return $default(_that.id,_that.direction,_that.status,_that.confidenceScore,_that.confidenceLevel,_that.extractedFields,_that.reviewFlags,_that.sourceImageUrl,_that.linkedTargetType,_that.linkedTargetId,_that.linkedTargetNo,_that.errorMessage,_that.capturedAt,_that.processedAt,_that.linkedAt,_that.syncState);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OcrRecordEntity implements OcrRecordEntity {
  const _OcrRecordEntity({required this.id, required this.direction, required this.status, required this.confidenceScore, required this.confidenceLevel, required this.extractedFields, final  List<FieldReviewFlag> reviewFlags = const <FieldReviewFlag>[], required this.sourceImageUrl, required this.linkedTargetType, this.linkedTargetId, this.linkedTargetNo, this.errorMessage, required this.capturedAt, this.processedAt, this.linkedAt, required this.syncState}): _reviewFlags = reviewFlags;
  factory _OcrRecordEntity.fromJson(Map<String, dynamic> json) => _$OcrRecordEntityFromJson(json);

@override final  String id;
@override final  DocumentDirection direction;
@override final  OcrRecordStatus status;
@override final  double confidenceScore;
@override final  ConfidenceLevel confidenceLevel;
@override final  OcrExtractedFieldsEntity extractedFields;
 final  List<FieldReviewFlag> _reviewFlags;
@override@JsonKey() List<FieldReviewFlag> get reviewFlags {
  if (_reviewFlags is EqualUnmodifiableListView) return _reviewFlags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviewFlags);
}

@override final  String sourceImageUrl;
@override final  LinkedTargetType linkedTargetType;
@override final  String? linkedTargetId;
@override final  String? linkedTargetNo;
@override final  String? errorMessage;
@override final  DateTime capturedAt;
@override final  DateTime? processedAt;
@override final  DateTime? linkedAt;
@override final  SyncState syncState;

/// Create a copy of OcrRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrRecordEntityCopyWith<_OcrRecordEntity> get copyWith => __$OcrRecordEntityCopyWithImpl<_OcrRecordEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrRecordEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrRecordEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&(identical(other.confidenceLevel, confidenceLevel) || other.confidenceLevel == confidenceLevel)&&(identical(other.extractedFields, extractedFields) || other.extractedFields == extractedFields)&&const DeepCollectionEquality().equals(other._reviewFlags, _reviewFlags)&&(identical(other.sourceImageUrl, sourceImageUrl) || other.sourceImageUrl == sourceImageUrl)&&(identical(other.linkedTargetType, linkedTargetType) || other.linkedTargetType == linkedTargetType)&&(identical(other.linkedTargetId, linkedTargetId) || other.linkedTargetId == linkedTargetId)&&(identical(other.linkedTargetNo, linkedTargetNo) || other.linkedTargetNo == linkedTargetNo)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,direction,status,confidenceScore,confidenceLevel,extractedFields,const DeepCollectionEquality().hash(_reviewFlags),sourceImageUrl,linkedTargetType,linkedTargetId,linkedTargetNo,errorMessage,capturedAt,processedAt,linkedAt,syncState);

@override
String toString() {
  return 'OcrRecordEntity(id: $id, direction: $direction, status: $status, confidenceScore: $confidenceScore, confidenceLevel: $confidenceLevel, extractedFields: $extractedFields, reviewFlags: $reviewFlags, sourceImageUrl: $sourceImageUrl, linkedTargetType: $linkedTargetType, linkedTargetId: $linkedTargetId, linkedTargetNo: $linkedTargetNo, errorMessage: $errorMessage, capturedAt: $capturedAt, processedAt: $processedAt, linkedAt: $linkedAt, syncState: $syncState)';
}


}

/// @nodoc
abstract mixin class _$OcrRecordEntityCopyWith<$Res> implements $OcrRecordEntityCopyWith<$Res> {
  factory _$OcrRecordEntityCopyWith(_OcrRecordEntity value, $Res Function(_OcrRecordEntity) _then) = __$OcrRecordEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, DocumentDirection direction, OcrRecordStatus status, double confidenceScore, ConfidenceLevel confidenceLevel, OcrExtractedFieldsEntity extractedFields, List<FieldReviewFlag> reviewFlags, String sourceImageUrl, LinkedTargetType linkedTargetType, String? linkedTargetId, String? linkedTargetNo, String? errorMessage, DateTime capturedAt, DateTime? processedAt, DateTime? linkedAt, SyncState syncState
});


@override $OcrExtractedFieldsEntityCopyWith<$Res> get extractedFields;

}
/// @nodoc
class __$OcrRecordEntityCopyWithImpl<$Res>
    implements _$OcrRecordEntityCopyWith<$Res> {
  __$OcrRecordEntityCopyWithImpl(this._self, this._then);

  final _OcrRecordEntity _self;
  final $Res Function(_OcrRecordEntity) _then;

/// Create a copy of OcrRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? direction = null,Object? status = null,Object? confidenceScore = null,Object? confidenceLevel = null,Object? extractedFields = null,Object? reviewFlags = null,Object? sourceImageUrl = null,Object? linkedTargetType = null,Object? linkedTargetId = freezed,Object? linkedTargetNo = freezed,Object? errorMessage = freezed,Object? capturedAt = null,Object? processedAt = freezed,Object? linkedAt = freezed,Object? syncState = null,}) {
  return _then(_OcrRecordEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as DocumentDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OcrRecordStatus,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,extractedFields: null == extractedFields ? _self.extractedFields : extractedFields // ignore: cast_nullable_to_non_nullable
as OcrExtractedFieldsEntity,reviewFlags: null == reviewFlags ? _self._reviewFlags : reviewFlags // ignore: cast_nullable_to_non_nullable
as List<FieldReviewFlag>,sourceImageUrl: null == sourceImageUrl ? _self.sourceImageUrl : sourceImageUrl // ignore: cast_nullable_to_non_nullable
as String,linkedTargetType: null == linkedTargetType ? _self.linkedTargetType : linkedTargetType // ignore: cast_nullable_to_non_nullable
as LinkedTargetType,linkedTargetId: freezed == linkedTargetId ? _self.linkedTargetId : linkedTargetId // ignore: cast_nullable_to_non_nullable
as String?,linkedTargetNo: freezed == linkedTargetNo ? _self.linkedTargetNo : linkedTargetNo // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedAt: freezed == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,
  ));
}

/// Create a copy of OcrRecordEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OcrExtractedFieldsEntityCopyWith<$Res> get extractedFields {
  
  return $OcrExtractedFieldsEntityCopyWith<$Res>(_self.extractedFields, (value) {
    return _then(_self.copyWith(extractedFields: value));
  });
}
}


/// @nodoc
mixin _$OcrExtractedFieldsDto {

@JsonKey(name: 'document_no') String? get documentNo;@JsonKey(name: 'vehicle_plate') String? get vehiclePlate;@JsonKey(name: 'owner_code') String? get ownerCode;@JsonKey(name: 'owner_name') String? get ownerName;@JsonKey(name: 'item_code') String? get itemCode;@JsonKey(name: 'item_name') String? get itemName;@JsonKey(name: 'gross_weight_kg') double? get grossWeightKg;@JsonKey(name: 'net_weight_kg') double? get netWeightKg;
/// Create a copy of OcrExtractedFieldsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrExtractedFieldsDtoCopyWith<OcrExtractedFieldsDto> get copyWith => _$OcrExtractedFieldsDtoCopyWithImpl<OcrExtractedFieldsDto>(this as OcrExtractedFieldsDto, _$identity);

  /// Serializes this OcrExtractedFieldsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrExtractedFieldsDto&&(identical(other.documentNo, documentNo) || other.documentNo == documentNo)&&(identical(other.vehiclePlate, vehiclePlate) || other.vehiclePlate == vehiclePlate)&&(identical(other.ownerCode, ownerCode) || other.ownerCode == ownerCode)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.grossWeightKg, grossWeightKg) || other.grossWeightKg == grossWeightKg)&&(identical(other.netWeightKg, netWeightKg) || other.netWeightKg == netWeightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentNo,vehiclePlate,ownerCode,ownerName,itemCode,itemName,grossWeightKg,netWeightKg);

@override
String toString() {
  return 'OcrExtractedFieldsDto(documentNo: $documentNo, vehiclePlate: $vehiclePlate, ownerCode: $ownerCode, ownerName: $ownerName, itemCode: $itemCode, itemName: $itemName, grossWeightKg: $grossWeightKg, netWeightKg: $netWeightKg)';
}


}

/// @nodoc
abstract mixin class $OcrExtractedFieldsDtoCopyWith<$Res>  {
  factory $OcrExtractedFieldsDtoCopyWith(OcrExtractedFieldsDto value, $Res Function(OcrExtractedFieldsDto) _then) = _$OcrExtractedFieldsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'document_no') String? documentNo,@JsonKey(name: 'vehicle_plate') String? vehiclePlate,@JsonKey(name: 'owner_code') String? ownerCode,@JsonKey(name: 'owner_name') String? ownerName,@JsonKey(name: 'item_code') String? itemCode,@JsonKey(name: 'item_name') String? itemName,@JsonKey(name: 'gross_weight_kg') double? grossWeightKg,@JsonKey(name: 'net_weight_kg') double? netWeightKg
});




}
/// @nodoc
class _$OcrExtractedFieldsDtoCopyWithImpl<$Res>
    implements $OcrExtractedFieldsDtoCopyWith<$Res> {
  _$OcrExtractedFieldsDtoCopyWithImpl(this._self, this._then);

  final OcrExtractedFieldsDto _self;
  final $Res Function(OcrExtractedFieldsDto) _then;

/// Create a copy of OcrExtractedFieldsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentNo = freezed,Object? vehiclePlate = freezed,Object? ownerCode = freezed,Object? ownerName = freezed,Object? itemCode = freezed,Object? itemName = freezed,Object? grossWeightKg = freezed,Object? netWeightKg = freezed,}) {
  return _then(_self.copyWith(
documentNo: freezed == documentNo ? _self.documentNo : documentNo // ignore: cast_nullable_to_non_nullable
as String?,vehiclePlate: freezed == vehiclePlate ? _self.vehiclePlate : vehiclePlate // ignore: cast_nullable_to_non_nullable
as String?,ownerCode: freezed == ownerCode ? _self.ownerCode : ownerCode // ignore: cast_nullable_to_non_nullable
as String?,ownerName: freezed == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String?,itemCode: freezed == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String?,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,grossWeightKg: freezed == grossWeightKg ? _self.grossWeightKg : grossWeightKg // ignore: cast_nullable_to_non_nullable
as double?,netWeightKg: freezed == netWeightKg ? _self.netWeightKg : netWeightKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [OcrExtractedFieldsDto].
extension OcrExtractedFieldsDtoPatterns on OcrExtractedFieldsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrExtractedFieldsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrExtractedFieldsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrExtractedFieldsDto value)  $default,){
final _that = this;
switch (_that) {
case _OcrExtractedFieldsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrExtractedFieldsDto value)?  $default,){
final _that = this;
switch (_that) {
case _OcrExtractedFieldsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'document_no')  String? documentNo, @JsonKey(name: 'vehicle_plate')  String? vehiclePlate, @JsonKey(name: 'owner_code')  String? ownerCode, @JsonKey(name: 'owner_name')  String? ownerName, @JsonKey(name: 'item_code')  String? itemCode, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'gross_weight_kg')  double? grossWeightKg, @JsonKey(name: 'net_weight_kg')  double? netWeightKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrExtractedFieldsDto() when $default != null:
return $default(_that.documentNo,_that.vehiclePlate,_that.ownerCode,_that.ownerName,_that.itemCode,_that.itemName,_that.grossWeightKg,_that.netWeightKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'document_no')  String? documentNo, @JsonKey(name: 'vehicle_plate')  String? vehiclePlate, @JsonKey(name: 'owner_code')  String? ownerCode, @JsonKey(name: 'owner_name')  String? ownerName, @JsonKey(name: 'item_code')  String? itemCode, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'gross_weight_kg')  double? grossWeightKg, @JsonKey(name: 'net_weight_kg')  double? netWeightKg)  $default,) {final _that = this;
switch (_that) {
case _OcrExtractedFieldsDto():
return $default(_that.documentNo,_that.vehiclePlate,_that.ownerCode,_that.ownerName,_that.itemCode,_that.itemName,_that.grossWeightKg,_that.netWeightKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'document_no')  String? documentNo, @JsonKey(name: 'vehicle_plate')  String? vehiclePlate, @JsonKey(name: 'owner_code')  String? ownerCode, @JsonKey(name: 'owner_name')  String? ownerName, @JsonKey(name: 'item_code')  String? itemCode, @JsonKey(name: 'item_name')  String? itemName, @JsonKey(name: 'gross_weight_kg')  double? grossWeightKg, @JsonKey(name: 'net_weight_kg')  double? netWeightKg)?  $default,) {final _that = this;
switch (_that) {
case _OcrExtractedFieldsDto() when $default != null:
return $default(_that.documentNo,_that.vehiclePlate,_that.ownerCode,_that.ownerName,_that.itemCode,_that.itemName,_that.grossWeightKg,_that.netWeightKg);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OcrExtractedFieldsDto implements OcrExtractedFieldsDto {
  const _OcrExtractedFieldsDto({@JsonKey(name: 'document_no') this.documentNo, @JsonKey(name: 'vehicle_plate') this.vehiclePlate, @JsonKey(name: 'owner_code') this.ownerCode, @JsonKey(name: 'owner_name') this.ownerName, @JsonKey(name: 'item_code') this.itemCode, @JsonKey(name: 'item_name') this.itemName, @JsonKey(name: 'gross_weight_kg') this.grossWeightKg, @JsonKey(name: 'net_weight_kg') this.netWeightKg});
  factory _OcrExtractedFieldsDto.fromJson(Map<String, dynamic> json) => _$OcrExtractedFieldsDtoFromJson(json);

@override@JsonKey(name: 'document_no') final  String? documentNo;
@override@JsonKey(name: 'vehicle_plate') final  String? vehiclePlate;
@override@JsonKey(name: 'owner_code') final  String? ownerCode;
@override@JsonKey(name: 'owner_name') final  String? ownerName;
@override@JsonKey(name: 'item_code') final  String? itemCode;
@override@JsonKey(name: 'item_name') final  String? itemName;
@override@JsonKey(name: 'gross_weight_kg') final  double? grossWeightKg;
@override@JsonKey(name: 'net_weight_kg') final  double? netWeightKg;

/// Create a copy of OcrExtractedFieldsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrExtractedFieldsDtoCopyWith<_OcrExtractedFieldsDto> get copyWith => __$OcrExtractedFieldsDtoCopyWithImpl<_OcrExtractedFieldsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrExtractedFieldsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrExtractedFieldsDto&&(identical(other.documentNo, documentNo) || other.documentNo == documentNo)&&(identical(other.vehiclePlate, vehiclePlate) || other.vehiclePlate == vehiclePlate)&&(identical(other.ownerCode, ownerCode) || other.ownerCode == ownerCode)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.grossWeightKg, grossWeightKg) || other.grossWeightKg == grossWeightKg)&&(identical(other.netWeightKg, netWeightKg) || other.netWeightKg == netWeightKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentNo,vehiclePlate,ownerCode,ownerName,itemCode,itemName,grossWeightKg,netWeightKg);

@override
String toString() {
  return 'OcrExtractedFieldsDto(documentNo: $documentNo, vehiclePlate: $vehiclePlate, ownerCode: $ownerCode, ownerName: $ownerName, itemCode: $itemCode, itemName: $itemName, grossWeightKg: $grossWeightKg, netWeightKg: $netWeightKg)';
}


}

/// @nodoc
abstract mixin class _$OcrExtractedFieldsDtoCopyWith<$Res> implements $OcrExtractedFieldsDtoCopyWith<$Res> {
  factory _$OcrExtractedFieldsDtoCopyWith(_OcrExtractedFieldsDto value, $Res Function(_OcrExtractedFieldsDto) _then) = __$OcrExtractedFieldsDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'document_no') String? documentNo,@JsonKey(name: 'vehicle_plate') String? vehiclePlate,@JsonKey(name: 'owner_code') String? ownerCode,@JsonKey(name: 'owner_name') String? ownerName,@JsonKey(name: 'item_code') String? itemCode,@JsonKey(name: 'item_name') String? itemName,@JsonKey(name: 'gross_weight_kg') double? grossWeightKg,@JsonKey(name: 'net_weight_kg') double? netWeightKg
});




}
/// @nodoc
class __$OcrExtractedFieldsDtoCopyWithImpl<$Res>
    implements _$OcrExtractedFieldsDtoCopyWith<$Res> {
  __$OcrExtractedFieldsDtoCopyWithImpl(this._self, this._then);

  final _OcrExtractedFieldsDto _self;
  final $Res Function(_OcrExtractedFieldsDto) _then;

/// Create a copy of OcrExtractedFieldsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentNo = freezed,Object? vehiclePlate = freezed,Object? ownerCode = freezed,Object? ownerName = freezed,Object? itemCode = freezed,Object? itemName = freezed,Object? grossWeightKg = freezed,Object? netWeightKg = freezed,}) {
  return _then(_OcrExtractedFieldsDto(
documentNo: freezed == documentNo ? _self.documentNo : documentNo // ignore: cast_nullable_to_non_nullable
as String?,vehiclePlate: freezed == vehiclePlate ? _self.vehiclePlate : vehiclePlate // ignore: cast_nullable_to_non_nullable
as String?,ownerCode: freezed == ownerCode ? _self.ownerCode : ownerCode // ignore: cast_nullable_to_non_nullable
as String?,ownerName: freezed == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String?,itemCode: freezed == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String?,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,grossWeightKg: freezed == grossWeightKg ? _self.grossWeightKg : grossWeightKg // ignore: cast_nullable_to_non_nullable
as double?,netWeightKg: freezed == netWeightKg ? _self.netWeightKg : netWeightKg // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$OcrRecordDto {

 String get id; DocumentDirection get direction; OcrRecordStatus get status;@JsonKey(name: 'confidence_score') double get confidenceScore;@JsonKey(name: 'confidence_level') ConfidenceLevel get confidenceLevel;@JsonKey(name: 'extracted_fields') OcrExtractedFieldsDto get extractedFields;@JsonKey(name: 'review_flags') List<FieldReviewFlag> get reviewFlags;@JsonKey(name: 'source_image_url') String get sourceImageUrl;@JsonKey(name: 'linked_target_type') LinkedTargetType get linkedTargetType;@JsonKey(name: 'linked_target_id') String? get linkedTargetId;@JsonKey(name: 'linked_target_no') String? get linkedTargetNo;@JsonKey(name: 'error_message') String? get errorMessage;@JsonKey(name: 'captured_at') DateTime get capturedAt;@JsonKey(name: 'processed_at') DateTime? get processedAt;@JsonKey(name: 'linked_at') DateTime? get linkedAt;@JsonKey(name: 'sync_state') SyncState get syncState;
/// Create a copy of OcrRecordDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrRecordDtoCopyWith<OcrRecordDto> get copyWith => _$OcrRecordDtoCopyWithImpl<OcrRecordDto>(this as OcrRecordDto, _$identity);

  /// Serializes this OcrRecordDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrRecordDto&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&(identical(other.confidenceLevel, confidenceLevel) || other.confidenceLevel == confidenceLevel)&&(identical(other.extractedFields, extractedFields) || other.extractedFields == extractedFields)&&const DeepCollectionEquality().equals(other.reviewFlags, reviewFlags)&&(identical(other.sourceImageUrl, sourceImageUrl) || other.sourceImageUrl == sourceImageUrl)&&(identical(other.linkedTargetType, linkedTargetType) || other.linkedTargetType == linkedTargetType)&&(identical(other.linkedTargetId, linkedTargetId) || other.linkedTargetId == linkedTargetId)&&(identical(other.linkedTargetNo, linkedTargetNo) || other.linkedTargetNo == linkedTargetNo)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,direction,status,confidenceScore,confidenceLevel,extractedFields,const DeepCollectionEquality().hash(reviewFlags),sourceImageUrl,linkedTargetType,linkedTargetId,linkedTargetNo,errorMessage,capturedAt,processedAt,linkedAt,syncState);

@override
String toString() {
  return 'OcrRecordDto(id: $id, direction: $direction, status: $status, confidenceScore: $confidenceScore, confidenceLevel: $confidenceLevel, extractedFields: $extractedFields, reviewFlags: $reviewFlags, sourceImageUrl: $sourceImageUrl, linkedTargetType: $linkedTargetType, linkedTargetId: $linkedTargetId, linkedTargetNo: $linkedTargetNo, errorMessage: $errorMessage, capturedAt: $capturedAt, processedAt: $processedAt, linkedAt: $linkedAt, syncState: $syncState)';
}


}

/// @nodoc
abstract mixin class $OcrRecordDtoCopyWith<$Res>  {
  factory $OcrRecordDtoCopyWith(OcrRecordDto value, $Res Function(OcrRecordDto) _then) = _$OcrRecordDtoCopyWithImpl;
@useResult
$Res call({
 String id, DocumentDirection direction, OcrRecordStatus status,@JsonKey(name: 'confidence_score') double confidenceScore,@JsonKey(name: 'confidence_level') ConfidenceLevel confidenceLevel,@JsonKey(name: 'extracted_fields') OcrExtractedFieldsDto extractedFields,@JsonKey(name: 'review_flags') List<FieldReviewFlag> reviewFlags,@JsonKey(name: 'source_image_url') String sourceImageUrl,@JsonKey(name: 'linked_target_type') LinkedTargetType linkedTargetType,@JsonKey(name: 'linked_target_id') String? linkedTargetId,@JsonKey(name: 'linked_target_no') String? linkedTargetNo,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'captured_at') DateTime capturedAt,@JsonKey(name: 'processed_at') DateTime? processedAt,@JsonKey(name: 'linked_at') DateTime? linkedAt,@JsonKey(name: 'sync_state') SyncState syncState
});


$OcrExtractedFieldsDtoCopyWith<$Res> get extractedFields;

}
/// @nodoc
class _$OcrRecordDtoCopyWithImpl<$Res>
    implements $OcrRecordDtoCopyWith<$Res> {
  _$OcrRecordDtoCopyWithImpl(this._self, this._then);

  final OcrRecordDto _self;
  final $Res Function(OcrRecordDto) _then;

/// Create a copy of OcrRecordDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? direction = null,Object? status = null,Object? confidenceScore = null,Object? confidenceLevel = null,Object? extractedFields = null,Object? reviewFlags = null,Object? sourceImageUrl = null,Object? linkedTargetType = null,Object? linkedTargetId = freezed,Object? linkedTargetNo = freezed,Object? errorMessage = freezed,Object? capturedAt = null,Object? processedAt = freezed,Object? linkedAt = freezed,Object? syncState = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as DocumentDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OcrRecordStatus,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,extractedFields: null == extractedFields ? _self.extractedFields : extractedFields // ignore: cast_nullable_to_non_nullable
as OcrExtractedFieldsDto,reviewFlags: null == reviewFlags ? _self.reviewFlags : reviewFlags // ignore: cast_nullable_to_non_nullable
as List<FieldReviewFlag>,sourceImageUrl: null == sourceImageUrl ? _self.sourceImageUrl : sourceImageUrl // ignore: cast_nullable_to_non_nullable
as String,linkedTargetType: null == linkedTargetType ? _self.linkedTargetType : linkedTargetType // ignore: cast_nullable_to_non_nullable
as LinkedTargetType,linkedTargetId: freezed == linkedTargetId ? _self.linkedTargetId : linkedTargetId // ignore: cast_nullable_to_non_nullable
as String?,linkedTargetNo: freezed == linkedTargetNo ? _self.linkedTargetNo : linkedTargetNo // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedAt: freezed == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,
  ));
}
/// Create a copy of OcrRecordDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OcrExtractedFieldsDtoCopyWith<$Res> get extractedFields {
  
  return $OcrExtractedFieldsDtoCopyWith<$Res>(_self.extractedFields, (value) {
    return _then(_self.copyWith(extractedFields: value));
  });
}
}


/// Adds pattern-matching-related methods to [OcrRecordDto].
extension OcrRecordDtoPatterns on OcrRecordDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrRecordDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrRecordDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrRecordDto value)  $default,){
final _that = this;
switch (_that) {
case _OcrRecordDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrRecordDto value)?  $default,){
final _that = this;
switch (_that) {
case _OcrRecordDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DocumentDirection direction,  OcrRecordStatus status, @JsonKey(name: 'confidence_score')  double confidenceScore, @JsonKey(name: 'confidence_level')  ConfidenceLevel confidenceLevel, @JsonKey(name: 'extracted_fields')  OcrExtractedFieldsDto extractedFields, @JsonKey(name: 'review_flags')  List<FieldReviewFlag> reviewFlags, @JsonKey(name: 'source_image_url')  String sourceImageUrl, @JsonKey(name: 'linked_target_type')  LinkedTargetType linkedTargetType, @JsonKey(name: 'linked_target_id')  String? linkedTargetId, @JsonKey(name: 'linked_target_no')  String? linkedTargetNo, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'captured_at')  DateTime capturedAt, @JsonKey(name: 'processed_at')  DateTime? processedAt, @JsonKey(name: 'linked_at')  DateTime? linkedAt, @JsonKey(name: 'sync_state')  SyncState syncState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrRecordDto() when $default != null:
return $default(_that.id,_that.direction,_that.status,_that.confidenceScore,_that.confidenceLevel,_that.extractedFields,_that.reviewFlags,_that.sourceImageUrl,_that.linkedTargetType,_that.linkedTargetId,_that.linkedTargetNo,_that.errorMessage,_that.capturedAt,_that.processedAt,_that.linkedAt,_that.syncState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DocumentDirection direction,  OcrRecordStatus status, @JsonKey(name: 'confidence_score')  double confidenceScore, @JsonKey(name: 'confidence_level')  ConfidenceLevel confidenceLevel, @JsonKey(name: 'extracted_fields')  OcrExtractedFieldsDto extractedFields, @JsonKey(name: 'review_flags')  List<FieldReviewFlag> reviewFlags, @JsonKey(name: 'source_image_url')  String sourceImageUrl, @JsonKey(name: 'linked_target_type')  LinkedTargetType linkedTargetType, @JsonKey(name: 'linked_target_id')  String? linkedTargetId, @JsonKey(name: 'linked_target_no')  String? linkedTargetNo, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'captured_at')  DateTime capturedAt, @JsonKey(name: 'processed_at')  DateTime? processedAt, @JsonKey(name: 'linked_at')  DateTime? linkedAt, @JsonKey(name: 'sync_state')  SyncState syncState)  $default,) {final _that = this;
switch (_that) {
case _OcrRecordDto():
return $default(_that.id,_that.direction,_that.status,_that.confidenceScore,_that.confidenceLevel,_that.extractedFields,_that.reviewFlags,_that.sourceImageUrl,_that.linkedTargetType,_that.linkedTargetId,_that.linkedTargetNo,_that.errorMessage,_that.capturedAt,_that.processedAt,_that.linkedAt,_that.syncState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DocumentDirection direction,  OcrRecordStatus status, @JsonKey(name: 'confidence_score')  double confidenceScore, @JsonKey(name: 'confidence_level')  ConfidenceLevel confidenceLevel, @JsonKey(name: 'extracted_fields')  OcrExtractedFieldsDto extractedFields, @JsonKey(name: 'review_flags')  List<FieldReviewFlag> reviewFlags, @JsonKey(name: 'source_image_url')  String sourceImageUrl, @JsonKey(name: 'linked_target_type')  LinkedTargetType linkedTargetType, @JsonKey(name: 'linked_target_id')  String? linkedTargetId, @JsonKey(name: 'linked_target_no')  String? linkedTargetNo, @JsonKey(name: 'error_message')  String? errorMessage, @JsonKey(name: 'captured_at')  DateTime capturedAt, @JsonKey(name: 'processed_at')  DateTime? processedAt, @JsonKey(name: 'linked_at')  DateTime? linkedAt, @JsonKey(name: 'sync_state')  SyncState syncState)?  $default,) {final _that = this;
switch (_that) {
case _OcrRecordDto() when $default != null:
return $default(_that.id,_that.direction,_that.status,_that.confidenceScore,_that.confidenceLevel,_that.extractedFields,_that.reviewFlags,_that.sourceImageUrl,_that.linkedTargetType,_that.linkedTargetId,_that.linkedTargetNo,_that.errorMessage,_that.capturedAt,_that.processedAt,_that.linkedAt,_that.syncState);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OcrRecordDto implements OcrRecordDto {
  const _OcrRecordDto({required this.id, required this.direction, required this.status, @JsonKey(name: 'confidence_score') required this.confidenceScore, @JsonKey(name: 'confidence_level') required this.confidenceLevel, @JsonKey(name: 'extracted_fields') required this.extractedFields, @JsonKey(name: 'review_flags') final  List<FieldReviewFlag> reviewFlags = const <FieldReviewFlag>[], @JsonKey(name: 'source_image_url') required this.sourceImageUrl, @JsonKey(name: 'linked_target_type') this.linkedTargetType = LinkedTargetType.none, @JsonKey(name: 'linked_target_id') this.linkedTargetId, @JsonKey(name: 'linked_target_no') this.linkedTargetNo, @JsonKey(name: 'error_message') this.errorMessage, @JsonKey(name: 'captured_at') required this.capturedAt, @JsonKey(name: 'processed_at') this.processedAt, @JsonKey(name: 'linked_at') this.linkedAt, @JsonKey(name: 'sync_state') required this.syncState}): _reviewFlags = reviewFlags;
  factory _OcrRecordDto.fromJson(Map<String, dynamic> json) => _$OcrRecordDtoFromJson(json);

@override final  String id;
@override final  DocumentDirection direction;
@override final  OcrRecordStatus status;
@override@JsonKey(name: 'confidence_score') final  double confidenceScore;
@override@JsonKey(name: 'confidence_level') final  ConfidenceLevel confidenceLevel;
@override@JsonKey(name: 'extracted_fields') final  OcrExtractedFieldsDto extractedFields;
 final  List<FieldReviewFlag> _reviewFlags;
@override@JsonKey(name: 'review_flags') List<FieldReviewFlag> get reviewFlags {
  if (_reviewFlags is EqualUnmodifiableListView) return _reviewFlags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviewFlags);
}

@override@JsonKey(name: 'source_image_url') final  String sourceImageUrl;
@override@JsonKey(name: 'linked_target_type') final  LinkedTargetType linkedTargetType;
@override@JsonKey(name: 'linked_target_id') final  String? linkedTargetId;
@override@JsonKey(name: 'linked_target_no') final  String? linkedTargetNo;
@override@JsonKey(name: 'error_message') final  String? errorMessage;
@override@JsonKey(name: 'captured_at') final  DateTime capturedAt;
@override@JsonKey(name: 'processed_at') final  DateTime? processedAt;
@override@JsonKey(name: 'linked_at') final  DateTime? linkedAt;
@override@JsonKey(name: 'sync_state') final  SyncState syncState;

/// Create a copy of OcrRecordDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrRecordDtoCopyWith<_OcrRecordDto> get copyWith => __$OcrRecordDtoCopyWithImpl<_OcrRecordDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrRecordDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrRecordDto&&(identical(other.id, id) || other.id == id)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&(identical(other.confidenceLevel, confidenceLevel) || other.confidenceLevel == confidenceLevel)&&(identical(other.extractedFields, extractedFields) || other.extractedFields == extractedFields)&&const DeepCollectionEquality().equals(other._reviewFlags, _reviewFlags)&&(identical(other.sourceImageUrl, sourceImageUrl) || other.sourceImageUrl == sourceImageUrl)&&(identical(other.linkedTargetType, linkedTargetType) || other.linkedTargetType == linkedTargetType)&&(identical(other.linkedTargetId, linkedTargetId) || other.linkedTargetId == linkedTargetId)&&(identical(other.linkedTargetNo, linkedTargetNo) || other.linkedTargetNo == linkedTargetNo)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.processedAt, processedAt) || other.processedAt == processedAt)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt)&&(identical(other.syncState, syncState) || other.syncState == syncState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,direction,status,confidenceScore,confidenceLevel,extractedFields,const DeepCollectionEquality().hash(_reviewFlags),sourceImageUrl,linkedTargetType,linkedTargetId,linkedTargetNo,errorMessage,capturedAt,processedAt,linkedAt,syncState);

@override
String toString() {
  return 'OcrRecordDto(id: $id, direction: $direction, status: $status, confidenceScore: $confidenceScore, confidenceLevel: $confidenceLevel, extractedFields: $extractedFields, reviewFlags: $reviewFlags, sourceImageUrl: $sourceImageUrl, linkedTargetType: $linkedTargetType, linkedTargetId: $linkedTargetId, linkedTargetNo: $linkedTargetNo, errorMessage: $errorMessage, capturedAt: $capturedAt, processedAt: $processedAt, linkedAt: $linkedAt, syncState: $syncState)';
}


}

/// @nodoc
abstract mixin class _$OcrRecordDtoCopyWith<$Res> implements $OcrRecordDtoCopyWith<$Res> {
  factory _$OcrRecordDtoCopyWith(_OcrRecordDto value, $Res Function(_OcrRecordDto) _then) = __$OcrRecordDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, DocumentDirection direction, OcrRecordStatus status,@JsonKey(name: 'confidence_score') double confidenceScore,@JsonKey(name: 'confidence_level') ConfidenceLevel confidenceLevel,@JsonKey(name: 'extracted_fields') OcrExtractedFieldsDto extractedFields,@JsonKey(name: 'review_flags') List<FieldReviewFlag> reviewFlags,@JsonKey(name: 'source_image_url') String sourceImageUrl,@JsonKey(name: 'linked_target_type') LinkedTargetType linkedTargetType,@JsonKey(name: 'linked_target_id') String? linkedTargetId,@JsonKey(name: 'linked_target_no') String? linkedTargetNo,@JsonKey(name: 'error_message') String? errorMessage,@JsonKey(name: 'captured_at') DateTime capturedAt,@JsonKey(name: 'processed_at') DateTime? processedAt,@JsonKey(name: 'linked_at') DateTime? linkedAt,@JsonKey(name: 'sync_state') SyncState syncState
});


@override $OcrExtractedFieldsDtoCopyWith<$Res> get extractedFields;

}
/// @nodoc
class __$OcrRecordDtoCopyWithImpl<$Res>
    implements _$OcrRecordDtoCopyWith<$Res> {
  __$OcrRecordDtoCopyWithImpl(this._self, this._then);

  final _OcrRecordDto _self;
  final $Res Function(_OcrRecordDto) _then;

/// Create a copy of OcrRecordDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? direction = null,Object? status = null,Object? confidenceScore = null,Object? confidenceLevel = null,Object? extractedFields = null,Object? reviewFlags = null,Object? sourceImageUrl = null,Object? linkedTargetType = null,Object? linkedTargetId = freezed,Object? linkedTargetNo = freezed,Object? errorMessage = freezed,Object? capturedAt = null,Object? processedAt = freezed,Object? linkedAt = freezed,Object? syncState = null,}) {
  return _then(_OcrRecordDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as DocumentDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OcrRecordStatus,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,extractedFields: null == extractedFields ? _self.extractedFields : extractedFields // ignore: cast_nullable_to_non_nullable
as OcrExtractedFieldsDto,reviewFlags: null == reviewFlags ? _self._reviewFlags : reviewFlags // ignore: cast_nullable_to_non_nullable
as List<FieldReviewFlag>,sourceImageUrl: null == sourceImageUrl ? _self.sourceImageUrl : sourceImageUrl // ignore: cast_nullable_to_non_nullable
as String,linkedTargetType: null == linkedTargetType ? _self.linkedTargetType : linkedTargetType // ignore: cast_nullable_to_non_nullable
as LinkedTargetType,linkedTargetId: freezed == linkedTargetId ? _self.linkedTargetId : linkedTargetId // ignore: cast_nullable_to_non_nullable
as String?,linkedTargetNo: freezed == linkedTargetNo ? _self.linkedTargetNo : linkedTargetNo // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,processedAt: freezed == processedAt ? _self.processedAt : processedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedAt: freezed == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncState: null == syncState ? _self.syncState : syncState // ignore: cast_nullable_to_non_nullable
as SyncState,
  ));
}

/// Create a copy of OcrRecordDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OcrExtractedFieldsDtoCopyWith<$Res> get extractedFields {
  
  return $OcrExtractedFieldsDtoCopyWith<$Res>(_self.extractedFields, (value) {
    return _then(_self.copyWith(extractedFields: value));
  });
}
}

// dart format on
