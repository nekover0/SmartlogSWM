// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_contracts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerSummary {

 String get id; String get code; String get name;
/// Create a copy of OwnerSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerSummaryCopyWith<OwnerSummary> get copyWith => _$OwnerSummaryCopyWithImpl<OwnerSummary>(this as OwnerSummary, _$identity);

  /// Serializes this OwnerSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name);

@override
String toString() {
  return 'OwnerSummary(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class $OwnerSummaryCopyWith<$Res>  {
  factory $OwnerSummaryCopyWith(OwnerSummary value, $Res Function(OwnerSummary) _then) = _$OwnerSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class _$OwnerSummaryCopyWithImpl<$Res>
    implements $OwnerSummaryCopyWith<$Res> {
  _$OwnerSummaryCopyWithImpl(this._self, this._then);

  final OwnerSummary _self;
  final $Res Function(OwnerSummary) _then;

/// Create a copy of OwnerSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnerSummary].
extension OwnerSummaryPatterns on OwnerSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerSummary value)  $default,){
final _that = this;
switch (_that) {
case _OwnerSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerSummary value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerSummary() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name)  $default,) {final _that = this;
switch (_that) {
case _OwnerSummary():
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _OwnerSummary() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerSummary implements OwnerSummary {
  const _OwnerSummary({required this.id, required this.code, required this.name});
  factory _OwnerSummary.fromJson(Map<String, dynamic> json) => _$OwnerSummaryFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;

/// Create a copy of OwnerSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerSummaryCopyWith<_OwnerSummary> get copyWith => __$OwnerSummaryCopyWithImpl<_OwnerSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name);

@override
String toString() {
  return 'OwnerSummary(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$OwnerSummaryCopyWith<$Res> implements $OwnerSummaryCopyWith<$Res> {
  factory _$OwnerSummaryCopyWith(_OwnerSummary value, $Res Function(_OwnerSummary) _then) = __$OwnerSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class __$OwnerSummaryCopyWithImpl<$Res>
    implements _$OwnerSummaryCopyWith<$Res> {
  __$OwnerSummaryCopyWithImpl(this._self, this._then);

  final _OwnerSummary _self;
  final $Res Function(_OwnerSummary) _then;

/// Create a copy of OwnerSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_OwnerSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WarehouseSummary {

 String get id; String get code; String get name;
/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WarehouseSummaryCopyWith<WarehouseSummary> get copyWith => _$WarehouseSummaryCopyWithImpl<WarehouseSummary>(this as WarehouseSummary, _$identity);

  /// Serializes this WarehouseSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarehouseSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name);

@override
String toString() {
  return 'WarehouseSummary(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class $WarehouseSummaryCopyWith<$Res>  {
  factory $WarehouseSummaryCopyWith(WarehouseSummary value, $Res Function(WarehouseSummary) _then) = _$WarehouseSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class _$WarehouseSummaryCopyWithImpl<$Res>
    implements $WarehouseSummaryCopyWith<$Res> {
  _$WarehouseSummaryCopyWithImpl(this._self, this._then);

  final WarehouseSummary _self;
  final $Res Function(WarehouseSummary) _then;

/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WarehouseSummary].
extension WarehouseSummaryPatterns on WarehouseSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WarehouseSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WarehouseSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WarehouseSummary value)  $default,){
final _that = this;
switch (_that) {
case _WarehouseSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WarehouseSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WarehouseSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WarehouseSummary() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name)  $default,) {final _that = this;
switch (_that) {
case _WarehouseSummary():
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _WarehouseSummary() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WarehouseSummary implements WarehouseSummary {
  const _WarehouseSummary({required this.id, required this.code, required this.name});
  factory _WarehouseSummary.fromJson(Map<String, dynamic> json) => _$WarehouseSummaryFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;

/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WarehouseSummaryCopyWith<_WarehouseSummary> get copyWith => __$WarehouseSummaryCopyWithImpl<_WarehouseSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WarehouseSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WarehouseSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name);

@override
String toString() {
  return 'WarehouseSummary(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$WarehouseSummaryCopyWith<$Res> implements $WarehouseSummaryCopyWith<$Res> {
  factory _$WarehouseSummaryCopyWith(_WarehouseSummary value, $Res Function(_WarehouseSummary) _then) = __$WarehouseSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class __$WarehouseSummaryCopyWithImpl<$Res>
    implements _$WarehouseSummaryCopyWith<$Res> {
  __$WarehouseSummaryCopyWithImpl(this._self, this._then);

  final _WarehouseSummary _self;
  final $Res Function(_WarehouseSummary) _then;

/// Create a copy of WarehouseSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_WarehouseSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LocationSummary {

 String get id; String get code; String get name;
/// Create a copy of LocationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationSummaryCopyWith<LocationSummary> get copyWith => _$LocationSummaryCopyWithImpl<LocationSummary>(this as LocationSummary, _$identity);

  /// Serializes this LocationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name);

@override
String toString() {
  return 'LocationSummary(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class $LocationSummaryCopyWith<$Res>  {
  factory $LocationSummaryCopyWith(LocationSummary value, $Res Function(LocationSummary) _then) = _$LocationSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class _$LocationSummaryCopyWithImpl<$Res>
    implements $LocationSummaryCopyWith<$Res> {
  _$LocationSummaryCopyWithImpl(this._self, this._then);

  final LocationSummary _self;
  final $Res Function(LocationSummary) _then;

/// Create a copy of LocationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationSummary].
extension LocationSummaryPatterns on LocationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationSummary value)  $default,){
final _that = this;
switch (_that) {
case _LocationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LocationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationSummary() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name)  $default,) {final _that = this;
switch (_that) {
case _LocationSummary():
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _LocationSummary() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationSummary implements LocationSummary {
  const _LocationSummary({required this.id, required this.code, required this.name});
  factory _LocationSummary.fromJson(Map<String, dynamic> json) => _$LocationSummaryFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;

/// Create a copy of LocationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationSummaryCopyWith<_LocationSummary> get copyWith => __$LocationSummaryCopyWithImpl<_LocationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name);

@override
String toString() {
  return 'LocationSummary(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$LocationSummaryCopyWith<$Res> implements $LocationSummaryCopyWith<$Res> {
  factory _$LocationSummaryCopyWith(_LocationSummary value, $Res Function(_LocationSummary) _then) = __$LocationSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class __$LocationSummaryCopyWithImpl<$Res>
    implements _$LocationSummaryCopyWith<$Res> {
  __$LocationSummaryCopyWithImpl(this._self, this._then);

  final _LocationSummary _self;
  final $Res Function(_LocationSummary) _then;

/// Create a copy of LocationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_LocationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$VehicleInfo {

 String? get plateNumber; String? get vesselName; String? get driverName;
/// Create a copy of VehicleInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleInfoCopyWith<VehicleInfo> get copyWith => _$VehicleInfoCopyWithImpl<VehicleInfo>(this as VehicleInfo, _$identity);

  /// Serializes this VehicleInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleInfo&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.driverName, driverName) || other.driverName == driverName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plateNumber,vesselName,driverName);

@override
String toString() {
  return 'VehicleInfo(plateNumber: $plateNumber, vesselName: $vesselName, driverName: $driverName)';
}


}

/// @nodoc
abstract mixin class $VehicleInfoCopyWith<$Res>  {
  factory $VehicleInfoCopyWith(VehicleInfo value, $Res Function(VehicleInfo) _then) = _$VehicleInfoCopyWithImpl;
@useResult
$Res call({
 String? plateNumber, String? vesselName, String? driverName
});




}
/// @nodoc
class _$VehicleInfoCopyWithImpl<$Res>
    implements $VehicleInfoCopyWith<$Res> {
  _$VehicleInfoCopyWithImpl(this._self, this._then);

  final VehicleInfo _self;
  final $Res Function(VehicleInfo) _then;

/// Create a copy of VehicleInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plateNumber = freezed,Object? vesselName = freezed,Object? driverName = freezed,}) {
  return _then(_self.copyWith(
plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleInfo].
extension VehicleInfoPatterns on VehicleInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleInfo value)  $default,){
final _that = this;
switch (_that) {
case _VehicleInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleInfo value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? plateNumber,  String? vesselName,  String? driverName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleInfo() when $default != null:
return $default(_that.plateNumber,_that.vesselName,_that.driverName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? plateNumber,  String? vesselName,  String? driverName)  $default,) {final _that = this;
switch (_that) {
case _VehicleInfo():
return $default(_that.plateNumber,_that.vesselName,_that.driverName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? plateNumber,  String? vesselName,  String? driverName)?  $default,) {final _that = this;
switch (_that) {
case _VehicleInfo() when $default != null:
return $default(_that.plateNumber,_that.vesselName,_that.driverName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleInfo implements VehicleInfo {
  const _VehicleInfo({this.plateNumber, this.vesselName, this.driverName});
  factory _VehicleInfo.fromJson(Map<String, dynamic> json) => _$VehicleInfoFromJson(json);

@override final  String? plateNumber;
@override final  String? vesselName;
@override final  String? driverName;

/// Create a copy of VehicleInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleInfoCopyWith<_VehicleInfo> get copyWith => __$VehicleInfoCopyWithImpl<_VehicleInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleInfo&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.driverName, driverName) || other.driverName == driverName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plateNumber,vesselName,driverName);

@override
String toString() {
  return 'VehicleInfo(plateNumber: $plateNumber, vesselName: $vesselName, driverName: $driverName)';
}


}

/// @nodoc
abstract mixin class _$VehicleInfoCopyWith<$Res> implements $VehicleInfoCopyWith<$Res> {
  factory _$VehicleInfoCopyWith(_VehicleInfo value, $Res Function(_VehicleInfo) _then) = __$VehicleInfoCopyWithImpl;
@override @useResult
$Res call({
 String? plateNumber, String? vesselName, String? driverName
});




}
/// @nodoc
class __$VehicleInfoCopyWithImpl<$Res>
    implements _$VehicleInfoCopyWith<$Res> {
  __$VehicleInfoCopyWithImpl(this._self, this._then);

  final _VehicleInfo _self;
  final $Res Function(_VehicleInfo) _then;

/// Create a copy of VehicleInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plateNumber = freezed,Object? vesselName = freezed,Object? driverName = freezed,}) {
  return _then(_VehicleInfo(
plateNumber: freezed == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ActionCapability {

 TaskActionType get type; String get label; String? get routeName; Map<String, String>? get routeParams; bool get enabled;
/// Create a copy of ActionCapability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionCapabilityCopyWith<ActionCapability> get copyWith => _$ActionCapabilityCopyWithImpl<ActionCapability>(this as ActionCapability, _$identity);

  /// Serializes this ActionCapability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionCapability&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other.routeParams, routeParams)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,label,routeName,const DeepCollectionEquality().hash(routeParams),enabled);

@override
String toString() {
  return 'ActionCapability(type: $type, label: $label, routeName: $routeName, routeParams: $routeParams, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $ActionCapabilityCopyWith<$Res>  {
  factory $ActionCapabilityCopyWith(ActionCapability value, $Res Function(ActionCapability) _then) = _$ActionCapabilityCopyWithImpl;
@useResult
$Res call({
 TaskActionType type, String label, String? routeName, Map<String, String>? routeParams, bool enabled
});




}
/// @nodoc
class _$ActionCapabilityCopyWithImpl<$Res>
    implements $ActionCapabilityCopyWith<$Res> {
  _$ActionCapabilityCopyWithImpl(this._self, this._then);

  final ActionCapability _self;
  final $Res Function(ActionCapability) _then;

/// Create a copy of ActionCapability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? label = null,Object? routeName = freezed,Object? routeParams = freezed,Object? enabled = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskActionType,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,routeName: freezed == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String?,routeParams: freezed == routeParams ? _self.routeParams : routeParams // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionCapability].
extension ActionCapabilityPatterns on ActionCapability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionCapability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionCapability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionCapability value)  $default,){
final _that = this;
switch (_that) {
case _ActionCapability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionCapability value)?  $default,){
final _that = this;
switch (_that) {
case _ActionCapability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskActionType type,  String label,  String? routeName,  Map<String, String>? routeParams,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionCapability() when $default != null:
return $default(_that.type,_that.label,_that.routeName,_that.routeParams,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskActionType type,  String label,  String? routeName,  Map<String, String>? routeParams,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _ActionCapability():
return $default(_that.type,_that.label,_that.routeName,_that.routeParams,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskActionType type,  String label,  String? routeName,  Map<String, String>? routeParams,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _ActionCapability() when $default != null:
return $default(_that.type,_that.label,_that.routeName,_that.routeParams,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionCapability implements ActionCapability {
  const _ActionCapability({required this.type, required this.label, this.routeName, final  Map<String, String>? routeParams, this.enabled = true}): _routeParams = routeParams;
  factory _ActionCapability.fromJson(Map<String, dynamic> json) => _$ActionCapabilityFromJson(json);

@override final  TaskActionType type;
@override final  String label;
@override final  String? routeName;
 final  Map<String, String>? _routeParams;
@override Map<String, String>? get routeParams {
  final value = _routeParams;
  if (value == null) return null;
  if (_routeParams is EqualUnmodifiableMapView) return _routeParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  bool enabled;

/// Create a copy of ActionCapability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionCapabilityCopyWith<_ActionCapability> get copyWith => __$ActionCapabilityCopyWithImpl<_ActionCapability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionCapabilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionCapability&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other._routeParams, _routeParams)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,label,routeName,const DeepCollectionEquality().hash(_routeParams),enabled);

@override
String toString() {
  return 'ActionCapability(type: $type, label: $label, routeName: $routeName, routeParams: $routeParams, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$ActionCapabilityCopyWith<$Res> implements $ActionCapabilityCopyWith<$Res> {
  factory _$ActionCapabilityCopyWith(_ActionCapability value, $Res Function(_ActionCapability) _then) = __$ActionCapabilityCopyWithImpl;
@override @useResult
$Res call({
 TaskActionType type, String label, String? routeName, Map<String, String>? routeParams, bool enabled
});




}
/// @nodoc
class __$ActionCapabilityCopyWithImpl<$Res>
    implements _$ActionCapabilityCopyWith<$Res> {
  __$ActionCapabilityCopyWithImpl(this._self, this._then);

  final _ActionCapability _self;
  final $Res Function(_ActionCapability) _then;

/// Create a copy of ActionCapability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? label = null,Object? routeName = freezed,Object? routeParams = freezed,Object? enabled = null,}) {
  return _then(_ActionCapability(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskActionType,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,routeName: freezed == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String?,routeParams: freezed == routeParams ? _self._routeParams : routeParams // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$FieldReviewFlag {

 String get fieldName; String? get rawValue; double get confidenceScore; ConfidenceLevel get level; bool get requiredReview;
/// Create a copy of FieldReviewFlag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldReviewFlagCopyWith<FieldReviewFlag> get copyWith => _$FieldReviewFlagCopyWithImpl<FieldReviewFlag>(this as FieldReviewFlag, _$identity);

  /// Serializes this FieldReviewFlag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldReviewFlag&&(identical(other.fieldName, fieldName) || other.fieldName == fieldName)&&(identical(other.rawValue, rawValue) || other.rawValue == rawValue)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&(identical(other.level, level) || other.level == level)&&(identical(other.requiredReview, requiredReview) || other.requiredReview == requiredReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldName,rawValue,confidenceScore,level,requiredReview);

@override
String toString() {
  return 'FieldReviewFlag(fieldName: $fieldName, rawValue: $rawValue, confidenceScore: $confidenceScore, level: $level, requiredReview: $requiredReview)';
}


}

/// @nodoc
abstract mixin class $FieldReviewFlagCopyWith<$Res>  {
  factory $FieldReviewFlagCopyWith(FieldReviewFlag value, $Res Function(FieldReviewFlag) _then) = _$FieldReviewFlagCopyWithImpl;
@useResult
$Res call({
 String fieldName, String? rawValue, double confidenceScore, ConfidenceLevel level, bool requiredReview
});




}
/// @nodoc
class _$FieldReviewFlagCopyWithImpl<$Res>
    implements $FieldReviewFlagCopyWith<$Res> {
  _$FieldReviewFlagCopyWithImpl(this._self, this._then);

  final FieldReviewFlag _self;
  final $Res Function(FieldReviewFlag) _then;

/// Create a copy of FieldReviewFlag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldName = null,Object? rawValue = freezed,Object? confidenceScore = null,Object? level = null,Object? requiredReview = null,}) {
  return _then(_self.copyWith(
fieldName: null == fieldName ? _self.fieldName : fieldName // ignore: cast_nullable_to_non_nullable
as String,rawValue: freezed == rawValue ? _self.rawValue : rawValue // ignore: cast_nullable_to_non_nullable
as String?,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,requiredReview: null == requiredReview ? _self.requiredReview : requiredReview // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldReviewFlag].
extension FieldReviewFlagPatterns on FieldReviewFlag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldReviewFlag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldReviewFlag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldReviewFlag value)  $default,){
final _that = this;
switch (_that) {
case _FieldReviewFlag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldReviewFlag value)?  $default,){
final _that = this;
switch (_that) {
case _FieldReviewFlag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fieldName,  String? rawValue,  double confidenceScore,  ConfidenceLevel level,  bool requiredReview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldReviewFlag() when $default != null:
return $default(_that.fieldName,_that.rawValue,_that.confidenceScore,_that.level,_that.requiredReview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fieldName,  String? rawValue,  double confidenceScore,  ConfidenceLevel level,  bool requiredReview)  $default,) {final _that = this;
switch (_that) {
case _FieldReviewFlag():
return $default(_that.fieldName,_that.rawValue,_that.confidenceScore,_that.level,_that.requiredReview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fieldName,  String? rawValue,  double confidenceScore,  ConfidenceLevel level,  bool requiredReview)?  $default,) {final _that = this;
switch (_that) {
case _FieldReviewFlag() when $default != null:
return $default(_that.fieldName,_that.rawValue,_that.confidenceScore,_that.level,_that.requiredReview);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldReviewFlag implements FieldReviewFlag {
  const _FieldReviewFlag({required this.fieldName, this.rawValue, required this.confidenceScore, required this.level, this.requiredReview = false});
  factory _FieldReviewFlag.fromJson(Map<String, dynamic> json) => _$FieldReviewFlagFromJson(json);

@override final  String fieldName;
@override final  String? rawValue;
@override final  double confidenceScore;
@override final  ConfidenceLevel level;
@override@JsonKey() final  bool requiredReview;

/// Create a copy of FieldReviewFlag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldReviewFlagCopyWith<_FieldReviewFlag> get copyWith => __$FieldReviewFlagCopyWithImpl<_FieldReviewFlag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldReviewFlagToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldReviewFlag&&(identical(other.fieldName, fieldName) || other.fieldName == fieldName)&&(identical(other.rawValue, rawValue) || other.rawValue == rawValue)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&(identical(other.level, level) || other.level == level)&&(identical(other.requiredReview, requiredReview) || other.requiredReview == requiredReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldName,rawValue,confidenceScore,level,requiredReview);

@override
String toString() {
  return 'FieldReviewFlag(fieldName: $fieldName, rawValue: $rawValue, confidenceScore: $confidenceScore, level: $level, requiredReview: $requiredReview)';
}


}

/// @nodoc
abstract mixin class _$FieldReviewFlagCopyWith<$Res> implements $FieldReviewFlagCopyWith<$Res> {
  factory _$FieldReviewFlagCopyWith(_FieldReviewFlag value, $Res Function(_FieldReviewFlag) _then) = __$FieldReviewFlagCopyWithImpl;
@override @useResult
$Res call({
 String fieldName, String? rawValue, double confidenceScore, ConfidenceLevel level, bool requiredReview
});




}
/// @nodoc
class __$FieldReviewFlagCopyWithImpl<$Res>
    implements _$FieldReviewFlagCopyWith<$Res> {
  __$FieldReviewFlagCopyWithImpl(this._self, this._then);

  final _FieldReviewFlag _self;
  final $Res Function(_FieldReviewFlag) _then;

/// Create a copy of FieldReviewFlag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldName = null,Object? rawValue = freezed,Object? confidenceScore = null,Object? level = null,Object? requiredReview = null,}) {
  return _then(_FieldReviewFlag(
fieldName: null == fieldName ? _self.fieldName : fieldName // ignore: cast_nullable_to_non_nullable
as String,rawValue: freezed == rawValue ? _self.rawValue : rawValue // ignore: cast_nullable_to_non_nullable
as String?,confidenceScore: null == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,requiredReview: null == requiredReview ? _self.requiredReview : requiredReview // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
