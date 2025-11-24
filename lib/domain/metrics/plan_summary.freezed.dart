// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlanSummaryData _$PlanSummaryDataFromJson(Map<String, dynamic> json) {
  return _PlanSummaryData.fromJson(json);
}

/// @nodoc
mixin _$PlanSummaryData {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;

  /// Serializes this PlanSummaryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanSummaryDataCopyWith<PlanSummaryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanSummaryDataCopyWith<$Res> {
  factory $PlanSummaryDataCopyWith(
          PlanSummaryData value, $Res Function(PlanSummaryData) then) =
      _$PlanSummaryDataCopyWithImpl<$Res, PlanSummaryData>;
  @useResult
  $Res call({int id, String title, String summary});
}

/// @nodoc
class _$PlanSummaryDataCopyWithImpl<$Res, $Val extends PlanSummaryData>
    implements $PlanSummaryDataCopyWith<$Res> {
  _$PlanSummaryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? summary = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanSummaryDataImplCopyWith<$Res>
    implements $PlanSummaryDataCopyWith<$Res> {
  factory _$$PlanSummaryDataImplCopyWith(_$PlanSummaryDataImpl value,
          $Res Function(_$PlanSummaryDataImpl) then) =
      __$$PlanSummaryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, String summary});
}

/// @nodoc
class __$$PlanSummaryDataImplCopyWithImpl<$Res>
    extends _$PlanSummaryDataCopyWithImpl<$Res, _$PlanSummaryDataImpl>
    implements _$$PlanSummaryDataImplCopyWith<$Res> {
  __$$PlanSummaryDataImplCopyWithImpl(
      _$PlanSummaryDataImpl _value, $Res Function(_$PlanSummaryDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlanSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? summary = null,
  }) {
    return _then(_$PlanSummaryDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanSummaryDataImpl implements _PlanSummaryData {
  const _$PlanSummaryDataImpl(
      {required this.id, required this.title, required this.summary});

  factory _$PlanSummaryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanSummaryDataImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String summary;

  @override
  String toString() {
    return 'PlanSummaryData(id: $id, title: $title, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanSummaryDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, summary);

  /// Create a copy of PlanSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanSummaryDataImplCopyWith<_$PlanSummaryDataImpl> get copyWith =>
      __$$PlanSummaryDataImplCopyWithImpl<_$PlanSummaryDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanSummaryDataImplToJson(
      this,
    );
  }
}

abstract class _PlanSummaryData implements PlanSummaryData {
  const factory _PlanSummaryData(
      {required final int id,
      required final String title,
      required final String summary}) = _$PlanSummaryDataImpl;

  factory _PlanSummaryData.fromJson(Map<String, dynamic> json) =
      _$PlanSummaryDataImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get summary;

  /// Create a copy of PlanSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanSummaryDataImplCopyWith<_$PlanSummaryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlanSummaryResponse _$PlanSummaryResponseFromJson(Map<String, dynamic> json) {
  return _PlanSummaryResponse.fromJson(json);
}

/// @nodoc
mixin _$PlanSummaryResponse {
  bool get success => throw _privateConstructorUsedError;
  PlanSummaryData? get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this PlanSummaryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanSummaryResponseCopyWith<PlanSummaryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanSummaryResponseCopyWith<$Res> {
  factory $PlanSummaryResponseCopyWith(
          PlanSummaryResponse value, $Res Function(PlanSummaryResponse) then) =
      _$PlanSummaryResponseCopyWithImpl<$Res, PlanSummaryResponse>;
  @useResult
  $Res call({bool success, PlanSummaryData? data, String? message});

  $PlanSummaryDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$PlanSummaryResponseCopyWithImpl<$Res, $Val extends PlanSummaryResponse>
    implements $PlanSummaryResponseCopyWith<$Res> {
  _$PlanSummaryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PlanSummaryData?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of PlanSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlanSummaryDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $PlanSummaryDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlanSummaryResponseImplCopyWith<$Res>
    implements $PlanSummaryResponseCopyWith<$Res> {
  factory _$$PlanSummaryResponseImplCopyWith(_$PlanSummaryResponseImpl value,
          $Res Function(_$PlanSummaryResponseImpl) then) =
      __$$PlanSummaryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, PlanSummaryData? data, String? message});

  @override
  $PlanSummaryDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$PlanSummaryResponseImplCopyWithImpl<$Res>
    extends _$PlanSummaryResponseCopyWithImpl<$Res, _$PlanSummaryResponseImpl>
    implements _$$PlanSummaryResponseImplCopyWith<$Res> {
  __$$PlanSummaryResponseImplCopyWithImpl(_$PlanSummaryResponseImpl _value,
      $Res Function(_$PlanSummaryResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlanSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? message = freezed,
  }) {
    return _then(_$PlanSummaryResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PlanSummaryData?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanSummaryResponseImpl implements _PlanSummaryResponse {
  const _$PlanSummaryResponseImpl(
      {required this.success, this.data, this.message});

  factory _$PlanSummaryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanSummaryResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final PlanSummaryData? data;
  @override
  final String? message;

  @override
  String toString() {
    return 'PlanSummaryResponse(success: $success, data: $data, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanSummaryResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data, message);

  /// Create a copy of PlanSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanSummaryResponseImplCopyWith<_$PlanSummaryResponseImpl> get copyWith =>
      __$$PlanSummaryResponseImplCopyWithImpl<_$PlanSummaryResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanSummaryResponseImplToJson(
      this,
    );
  }
}

abstract class _PlanSummaryResponse implements PlanSummaryResponse {
  const factory _PlanSummaryResponse(
      {required final bool success,
      final PlanSummaryData? data,
      final String? message}) = _$PlanSummaryResponseImpl;

  factory _PlanSummaryResponse.fromJson(Map<String, dynamic> json) =
      _$PlanSummaryResponseImpl.fromJson;

  @override
  bool get success;
  @override
  PlanSummaryData? get data;
  @override
  String? get message;

  /// Create a copy of PlanSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanSummaryResponseImplCopyWith<_$PlanSummaryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
