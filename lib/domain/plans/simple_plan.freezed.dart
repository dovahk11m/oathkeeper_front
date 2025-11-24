// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simple_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SimplePlan _$SimplePlanFromJson(Map<String, dynamic> json) {
  return _SimplePlan.fromJson(json);
}

/// @nodoc
mixin _$SimplePlan {
  int get planId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get planDatetime => throw _privateConstructorUsedError;

  /// Serializes this SimplePlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SimplePlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SimplePlanCopyWith<SimplePlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimplePlanCopyWith<$Res> {
  factory $SimplePlanCopyWith(
          SimplePlan value, $Res Function(SimplePlan) then) =
      _$SimplePlanCopyWithImpl<$Res, SimplePlan>;
  @useResult
  $Res call({int planId, String title, String planDatetime});
}

/// @nodoc
class _$SimplePlanCopyWithImpl<$Res, $Val extends SimplePlan>
    implements $SimplePlanCopyWith<$Res> {
  _$SimplePlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SimplePlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? title = null,
    Object? planDatetime = null,
  }) {
    return _then(_value.copyWith(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      planDatetime: null == planDatetime
          ? _value.planDatetime
          : planDatetime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SimplePlanImplCopyWith<$Res>
    implements $SimplePlanCopyWith<$Res> {
  factory _$$SimplePlanImplCopyWith(
          _$SimplePlanImpl value, $Res Function(_$SimplePlanImpl) then) =
      __$$SimplePlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int planId, String title, String planDatetime});
}

/// @nodoc
class __$$SimplePlanImplCopyWithImpl<$Res>
    extends _$SimplePlanCopyWithImpl<$Res, _$SimplePlanImpl>
    implements _$$SimplePlanImplCopyWith<$Res> {
  __$$SimplePlanImplCopyWithImpl(
      _$SimplePlanImpl _value, $Res Function(_$SimplePlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of SimplePlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? title = null,
    Object? planDatetime = null,
  }) {
    return _then(_$SimplePlanImpl(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      planDatetime: null == planDatetime
          ? _value.planDatetime
          : planDatetime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SimplePlanImpl implements _SimplePlan {
  const _$SimplePlanImpl(
      {required this.planId, required this.title, required this.planDatetime});

  factory _$SimplePlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$SimplePlanImplFromJson(json);

  @override
  final int planId;
  @override
  final String title;
  @override
  final String planDatetime;

  @override
  String toString() {
    return 'SimplePlan(planId: $planId, title: $title, planDatetime: $planDatetime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimplePlanImpl &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.planDatetime, planDatetime) ||
                other.planDatetime == planDatetime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, planId, title, planDatetime);

  /// Create a copy of SimplePlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimplePlanImplCopyWith<_$SimplePlanImpl> get copyWith =>
      __$$SimplePlanImplCopyWithImpl<_$SimplePlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SimplePlanImplToJson(
      this,
    );
  }
}

abstract class _SimplePlan implements SimplePlan {
  const factory _SimplePlan(
      {required final int planId,
      required final String title,
      required final String planDatetime}) = _$SimplePlanImpl;

  factory _SimplePlan.fromJson(Map<String, dynamic> json) =
      _$SimplePlanImpl.fromJson;

  @override
  int get planId;
  @override
  String get title;
  @override
  String get planDatetime;

  /// Create a copy of SimplePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimplePlanImplCopyWith<_$SimplePlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlanListResponse _$PlanListResponseFromJson(Map<String, dynamic> json) {
  return _PlanListResponse.fromJson(json);
}

/// @nodoc
mixin _$PlanListResponse {
  List<SimplePlan> get items => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  bool get isFirst => throw _privateConstructorUsedError;
  bool get isLast => throw _privateConstructorUsedError;

  /// Serializes this PlanListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanListResponseCopyWith<PlanListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanListResponseCopyWith<$Res> {
  factory $PlanListResponseCopyWith(
          PlanListResponse value, $Res Function(PlanListResponse) then) =
      _$PlanListResponseCopyWithImpl<$Res, PlanListResponse>;
  @useResult
  $Res call(
      {List<SimplePlan> items,
      int currentPage,
      int totalPages,
      int totalElements,
      bool isFirst,
      bool isLast});
}

/// @nodoc
class _$PlanListResponseCopyWithImpl<$Res, $Val extends PlanListResponse>
    implements $PlanListResponseCopyWith<$Res> {
  _$PlanListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? totalElements = null,
    Object? isFirst = null,
    Object? isLast = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SimplePlan>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      isFirst: null == isFirst
          ? _value.isFirst
          : isFirst // ignore: cast_nullable_to_non_nullable
              as bool,
      isLast: null == isLast
          ? _value.isLast
          : isLast // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanListResponseImplCopyWith<$Res>
    implements $PlanListResponseCopyWith<$Res> {
  factory _$$PlanListResponseImplCopyWith(_$PlanListResponseImpl value,
          $Res Function(_$PlanListResponseImpl) then) =
      __$$PlanListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SimplePlan> items,
      int currentPage,
      int totalPages,
      int totalElements,
      bool isFirst,
      bool isLast});
}

/// @nodoc
class __$$PlanListResponseImplCopyWithImpl<$Res>
    extends _$PlanListResponseCopyWithImpl<$Res, _$PlanListResponseImpl>
    implements _$$PlanListResponseImplCopyWith<$Res> {
  __$$PlanListResponseImplCopyWithImpl(_$PlanListResponseImpl _value,
      $Res Function(_$PlanListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlanListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? totalElements = null,
    Object? isFirst = null,
    Object? isLast = null,
  }) {
    return _then(_$PlanListResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SimplePlan>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      isFirst: null == isFirst
          ? _value.isFirst
          : isFirst // ignore: cast_nullable_to_non_nullable
              as bool,
      isLast: null == isLast
          ? _value.isLast
          : isLast // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanListResponseImpl implements _PlanListResponse {
  const _$PlanListResponseImpl(
      {required final List<SimplePlan> items,
      required this.currentPage,
      required this.totalPages,
      required this.totalElements,
      required this.isFirst,
      required this.isLast})
      : _items = items;

  factory _$PlanListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanListResponseImplFromJson(json);

  final List<SimplePlan> _items;
  @override
  List<SimplePlan> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int currentPage;
  @override
  final int totalPages;
  @override
  final int totalElements;
  @override
  final bool isFirst;
  @override
  final bool isLast;

  @override
  String toString() {
    return 'PlanListResponse(items: $items, currentPage: $currentPage, totalPages: $totalPages, totalElements: $totalElements, isFirst: $isFirst, isLast: $isLast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanListResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.isFirst, isFirst) || other.isFirst == isFirst) &&
            (identical(other.isLast, isLast) || other.isLast == isLast));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      currentPage,
      totalPages,
      totalElements,
      isFirst,
      isLast);

  /// Create a copy of PlanListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanListResponseImplCopyWith<_$PlanListResponseImpl> get copyWith =>
      __$$PlanListResponseImplCopyWithImpl<_$PlanListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanListResponseImplToJson(
      this,
    );
  }
}

abstract class _PlanListResponse implements PlanListResponse {
  const factory _PlanListResponse(
      {required final List<SimplePlan> items,
      required final int currentPage,
      required final int totalPages,
      required final int totalElements,
      required final bool isFirst,
      required final bool isLast}) = _$PlanListResponseImpl;

  factory _PlanListResponse.fromJson(Map<String, dynamic> json) =
      _$PlanListResponseImpl.fromJson;

  @override
  List<SimplePlan> get items;
  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  int get totalElements;
  @override
  bool get isFirst;
  @override
  bool get isLast;

  /// Create a copy of PlanListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanListResponseImplCopyWith<_$PlanListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
