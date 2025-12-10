// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_discovery_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FarmDiscoveryFilter {
  District? get district => throw _privateConstructorUsedError;
  bool get verifiedOnly => throw _privateConstructorUsedError;
  bool get hasDelivery => throw _privateConstructorUsedError;
  FarmSortOption get sortBy => throw _privateConstructorUsedError;

  /// Create a copy of FarmDiscoveryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmDiscoveryFilterCopyWith<FarmDiscoveryFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmDiscoveryFilterCopyWith<$Res> {
  factory $FarmDiscoveryFilterCopyWith(
          FarmDiscoveryFilter value, $Res Function(FarmDiscoveryFilter) then) =
      _$FarmDiscoveryFilterCopyWithImpl<$Res, FarmDiscoveryFilter>;
  @useResult
  $Res call(
      {District? district,
      bool verifiedOnly,
      bool hasDelivery,
      FarmSortOption sortBy});
}

/// @nodoc
class _$FarmDiscoveryFilterCopyWithImpl<$Res, $Val extends FarmDiscoveryFilter>
    implements $FarmDiscoveryFilterCopyWith<$Res> {
  _$FarmDiscoveryFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmDiscoveryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? district = freezed,
    Object? verifiedOnly = null,
    Object? hasDelivery = null,
    Object? sortBy = null,
  }) {
    return _then(_value.copyWith(
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as District?,
      verifiedOnly: null == verifiedOnly
          ? _value.verifiedOnly
          : verifiedOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDelivery: null == hasDelivery
          ? _value.hasDelivery
          : hasDelivery // ignore: cast_nullable_to_non_nullable
              as bool,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as FarmSortOption,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FarmDiscoveryFilterImplCopyWith<$Res>
    implements $FarmDiscoveryFilterCopyWith<$Res> {
  factory _$$FarmDiscoveryFilterImplCopyWith(_$FarmDiscoveryFilterImpl value,
          $Res Function(_$FarmDiscoveryFilterImpl) then) =
      __$$FarmDiscoveryFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {District? district,
      bool verifiedOnly,
      bool hasDelivery,
      FarmSortOption sortBy});
}

/// @nodoc
class __$$FarmDiscoveryFilterImplCopyWithImpl<$Res>
    extends _$FarmDiscoveryFilterCopyWithImpl<$Res, _$FarmDiscoveryFilterImpl>
    implements _$$FarmDiscoveryFilterImplCopyWith<$Res> {
  __$$FarmDiscoveryFilterImplCopyWithImpl(_$FarmDiscoveryFilterImpl _value,
      $Res Function(_$FarmDiscoveryFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of FarmDiscoveryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? district = freezed,
    Object? verifiedOnly = null,
    Object? hasDelivery = null,
    Object? sortBy = null,
  }) {
    return _then(_$FarmDiscoveryFilterImpl(
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as District?,
      verifiedOnly: null == verifiedOnly
          ? _value.verifiedOnly
          : verifiedOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDelivery: null == hasDelivery
          ? _value.hasDelivery
          : hasDelivery // ignore: cast_nullable_to_non_nullable
              as bool,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as FarmSortOption,
    ));
  }
}

/// @nodoc

class _$FarmDiscoveryFilterImpl implements _FarmDiscoveryFilter {
  const _$FarmDiscoveryFilterImpl(
      {this.district = null,
      this.verifiedOnly = false,
      this.hasDelivery = false,
      this.sortBy = FarmSortOption.distance});

  @override
  @JsonKey()
  final District? district;
  @override
  @JsonKey()
  final bool verifiedOnly;
  @override
  @JsonKey()
  final bool hasDelivery;
  @override
  @JsonKey()
  final FarmSortOption sortBy;

  @override
  String toString() {
    return 'FarmDiscoveryFilter(district: $district, verifiedOnly: $verifiedOnly, hasDelivery: $hasDelivery, sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmDiscoveryFilterImpl &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.verifiedOnly, verifiedOnly) ||
                other.verifiedOnly == verifiedOnly) &&
            (identical(other.hasDelivery, hasDelivery) ||
                other.hasDelivery == hasDelivery) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, district, verifiedOnly, hasDelivery, sortBy);

  /// Create a copy of FarmDiscoveryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmDiscoveryFilterImplCopyWith<_$FarmDiscoveryFilterImpl> get copyWith =>
      __$$FarmDiscoveryFilterImplCopyWithImpl<_$FarmDiscoveryFilterImpl>(
          this, _$identity);
}

abstract class _FarmDiscoveryFilter implements FarmDiscoveryFilter {
  const factory _FarmDiscoveryFilter(
      {final District? district,
      final bool verifiedOnly,
      final bool hasDelivery,
      final FarmSortOption sortBy}) = _$FarmDiscoveryFilterImpl;

  @override
  District? get district;
  @override
  bool get verifiedOnly;
  @override
  bool get hasDelivery;
  @override
  FarmSortOption get sortBy;

  /// Create a copy of FarmDiscoveryFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmDiscoveryFilterImplCopyWith<_$FarmDiscoveryFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FarmDiscoveryState {
  String get searchQuery => throw _privateConstructorUsedError;
  FarmDiscoveryFilter get filter => throw _privateConstructorUsedError;

  /// Create a copy of FarmDiscoveryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmDiscoveryStateCopyWith<FarmDiscoveryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmDiscoveryStateCopyWith<$Res> {
  factory $FarmDiscoveryStateCopyWith(
          FarmDiscoveryState value, $Res Function(FarmDiscoveryState) then) =
      _$FarmDiscoveryStateCopyWithImpl<$Res, FarmDiscoveryState>;
  @useResult
  $Res call({String searchQuery, FarmDiscoveryFilter filter});

  $FarmDiscoveryFilterCopyWith<$Res> get filter;
}

/// @nodoc
class _$FarmDiscoveryStateCopyWithImpl<$Res, $Val extends FarmDiscoveryState>
    implements $FarmDiscoveryStateCopyWith<$Res> {
  _$FarmDiscoveryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmDiscoveryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? filter = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as FarmDiscoveryFilter,
    ) as $Val);
  }

  /// Create a copy of FarmDiscoveryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FarmDiscoveryFilterCopyWith<$Res> get filter {
    return $FarmDiscoveryFilterCopyWith<$Res>(_value.filter, (value) {
      return _then(_value.copyWith(filter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FarmDiscoveryStateImplCopyWith<$Res>
    implements $FarmDiscoveryStateCopyWith<$Res> {
  factory _$$FarmDiscoveryStateImplCopyWith(_$FarmDiscoveryStateImpl value,
          $Res Function(_$FarmDiscoveryStateImpl) then) =
      __$$FarmDiscoveryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String searchQuery, FarmDiscoveryFilter filter});

  @override
  $FarmDiscoveryFilterCopyWith<$Res> get filter;
}

/// @nodoc
class __$$FarmDiscoveryStateImplCopyWithImpl<$Res>
    extends _$FarmDiscoveryStateCopyWithImpl<$Res, _$FarmDiscoveryStateImpl>
    implements _$$FarmDiscoveryStateImplCopyWith<$Res> {
  __$$FarmDiscoveryStateImplCopyWithImpl(_$FarmDiscoveryStateImpl _value,
      $Res Function(_$FarmDiscoveryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FarmDiscoveryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? filter = null,
  }) {
    return _then(_$FarmDiscoveryStateImpl(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as FarmDiscoveryFilter,
    ));
  }
}

/// @nodoc

class _$FarmDiscoveryStateImpl implements _FarmDiscoveryState {
  const _$FarmDiscoveryStateImpl(
      {this.searchQuery = '', this.filter = const FarmDiscoveryFilter()});

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final FarmDiscoveryFilter filter;

  @override
  String toString() {
    return 'FarmDiscoveryState(searchQuery: $searchQuery, filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmDiscoveryStateImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchQuery, filter);

  /// Create a copy of FarmDiscoveryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmDiscoveryStateImplCopyWith<_$FarmDiscoveryStateImpl> get copyWith =>
      __$$FarmDiscoveryStateImplCopyWithImpl<_$FarmDiscoveryStateImpl>(
          this, _$identity);
}

abstract class _FarmDiscoveryState implements FarmDiscoveryState {
  const factory _FarmDiscoveryState(
      {final String searchQuery,
      final FarmDiscoveryFilter filter}) = _$FarmDiscoveryStateImpl;

  @override
  String get searchQuery;
  @override
  FarmDiscoveryFilter get filter;

  /// Create a copy of FarmDiscoveryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmDiscoveryStateImplCopyWith<_$FarmDiscoveryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
