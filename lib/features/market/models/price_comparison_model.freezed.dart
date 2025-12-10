// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_comparison_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PriceComparison _$PriceComparisonFromJson(Map<String, dynamic> json) {
  return _PriceComparison.fromJson(json);
}

/// @nodoc
mixin _$PriceComparison {
  /// Current product price (RM)
  double get currentPrice => throw _privateConstructorUsedError;

  /// Average market price (RM)
  double get averagePrice => throw _privateConstructorUsedError;

  /// Percentage difference from average
  /// Positive = above average, Negative = below average
  double get percentDiff => throw _privateConstructorUsedError;

  /// Whether this is considered a good deal (below average)
  bool get isGoodDeal => throw _privateConstructorUsedError;

  /// Serializes this PriceComparison to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceComparisonCopyWith<PriceComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceComparisonCopyWith<$Res> {
  factory $PriceComparisonCopyWith(
          PriceComparison value, $Res Function(PriceComparison) then) =
      _$PriceComparisonCopyWithImpl<$Res, PriceComparison>;
  @useResult
  $Res call(
      {double currentPrice,
      double averagePrice,
      double percentDiff,
      bool isGoodDeal});
}

/// @nodoc
class _$PriceComparisonCopyWithImpl<$Res, $Val extends PriceComparison>
    implements $PriceComparisonCopyWith<$Res> {
  _$PriceComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPrice = null,
    Object? averagePrice = null,
    Object? percentDiff = null,
    Object? isGoodDeal = null,
  }) {
    return _then(_value.copyWith(
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrice: null == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double,
      percentDiff: null == percentDiff
          ? _value.percentDiff
          : percentDiff // ignore: cast_nullable_to_non_nullable
              as double,
      isGoodDeal: null == isGoodDeal
          ? _value.isGoodDeal
          : isGoodDeal // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceComparisonImplCopyWith<$Res>
    implements $PriceComparisonCopyWith<$Res> {
  factory _$$PriceComparisonImplCopyWith(_$PriceComparisonImpl value,
          $Res Function(_$PriceComparisonImpl) then) =
      __$$PriceComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentPrice,
      double averagePrice,
      double percentDiff,
      bool isGoodDeal});
}

/// @nodoc
class __$$PriceComparisonImplCopyWithImpl<$Res>
    extends _$PriceComparisonCopyWithImpl<$Res, _$PriceComparisonImpl>
    implements _$$PriceComparisonImplCopyWith<$Res> {
  __$$PriceComparisonImplCopyWithImpl(
      _$PriceComparisonImpl _value, $Res Function(_$PriceComparisonImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPrice = null,
    Object? averagePrice = null,
    Object? percentDiff = null,
    Object? isGoodDeal = null,
  }) {
    return _then(_$PriceComparisonImpl(
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrice: null == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double,
      percentDiff: null == percentDiff
          ? _value.percentDiff
          : percentDiff // ignore: cast_nullable_to_non_nullable
              as double,
      isGoodDeal: null == isGoodDeal
          ? _value.isGoodDeal
          : isGoodDeal // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceComparisonImpl implements _PriceComparison {
  const _$PriceComparisonImpl(
      {required this.currentPrice,
      required this.averagePrice,
      required this.percentDiff,
      required this.isGoodDeal});

  factory _$PriceComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceComparisonImplFromJson(json);

  /// Current product price (RM)
  @override
  final double currentPrice;

  /// Average market price (RM)
  @override
  final double averagePrice;

  /// Percentage difference from average
  /// Positive = above average, Negative = below average
  @override
  final double percentDiff;

  /// Whether this is considered a good deal (below average)
  @override
  final bool isGoodDeal;

  @override
  String toString() {
    return 'PriceComparison(currentPrice: $currentPrice, averagePrice: $averagePrice, percentDiff: $percentDiff, isGoodDeal: $isGoodDeal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceComparisonImpl &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.averagePrice, averagePrice) ||
                other.averagePrice == averagePrice) &&
            (identical(other.percentDiff, percentDiff) ||
                other.percentDiff == percentDiff) &&
            (identical(other.isGoodDeal, isGoodDeal) ||
                other.isGoodDeal == isGoodDeal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, currentPrice, averagePrice, percentDiff, isGoodDeal);

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceComparisonImplCopyWith<_$PriceComparisonImpl> get copyWith =>
      __$$PriceComparisonImplCopyWithImpl<_$PriceComparisonImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceComparisonImplToJson(
      this,
    );
  }
}

abstract class _PriceComparison implements PriceComparison {
  const factory _PriceComparison(
      {required final double currentPrice,
      required final double averagePrice,
      required final double percentDiff,
      required final bool isGoodDeal}) = _$PriceComparisonImpl;

  factory _PriceComparison.fromJson(Map<String, dynamic> json) =
      _$PriceComparisonImpl.fromJson;

  /// Current product price (RM)
  @override
  double get currentPrice;

  /// Average market price (RM)
  @override
  double get averagePrice;

  /// Percentage difference from average
  /// Positive = above average, Negative = below average
  @override
  double get percentDiff;

  /// Whether this is considered a good deal (below average)
  @override
  bool get isGoodDeal;

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceComparisonImplCopyWith<_$PriceComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceStats _$PriceStatsFromJson(Map<String, dynamic> json) {
  return _PriceStats.fromJson(json);
}

/// @nodoc
mixin _$PriceStats {
  /// Average price across all data points (RM)
  double get average => throw _privateConstructorUsedError;

  /// Minimum price found (RM)
  double get minimum => throw _privateConstructorUsedError;

  /// Maximum price found (RM)
  double get maximum => throw _privateConstructorUsedError;

  /// Number of data points used for calculation
  int get dataPoints => throw _privateConstructorUsedError;

  /// Serializes this PriceStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceStatsCopyWith<PriceStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceStatsCopyWith<$Res> {
  factory $PriceStatsCopyWith(
          PriceStats value, $Res Function(PriceStats) then) =
      _$PriceStatsCopyWithImpl<$Res, PriceStats>;
  @useResult
  $Res call({double average, double minimum, double maximum, int dataPoints});
}

/// @nodoc
class _$PriceStatsCopyWithImpl<$Res, $Val extends PriceStats>
    implements $PriceStatsCopyWith<$Res> {
  _$PriceStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? average = null,
    Object? minimum = null,
    Object? maximum = null,
    Object? dataPoints = null,
  }) {
    return _then(_value.copyWith(
      average: null == average
          ? _value.average
          : average // ignore: cast_nullable_to_non_nullable
              as double,
      minimum: null == minimum
          ? _value.minimum
          : minimum // ignore: cast_nullable_to_non_nullable
              as double,
      maximum: null == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as double,
      dataPoints: null == dataPoints
          ? _value.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceStatsImplCopyWith<$Res>
    implements $PriceStatsCopyWith<$Res> {
  factory _$$PriceStatsImplCopyWith(
          _$PriceStatsImpl value, $Res Function(_$PriceStatsImpl) then) =
      __$$PriceStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double average, double minimum, double maximum, int dataPoints});
}

/// @nodoc
class __$$PriceStatsImplCopyWithImpl<$Res>
    extends _$PriceStatsCopyWithImpl<$Res, _$PriceStatsImpl>
    implements _$$PriceStatsImplCopyWith<$Res> {
  __$$PriceStatsImplCopyWithImpl(
      _$PriceStatsImpl _value, $Res Function(_$PriceStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? average = null,
    Object? minimum = null,
    Object? maximum = null,
    Object? dataPoints = null,
  }) {
    return _then(_$PriceStatsImpl(
      average: null == average
          ? _value.average
          : average // ignore: cast_nullable_to_non_nullable
              as double,
      minimum: null == minimum
          ? _value.minimum
          : minimum // ignore: cast_nullable_to_non_nullable
              as double,
      maximum: null == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as double,
      dataPoints: null == dataPoints
          ? _value.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceStatsImpl implements _PriceStats {
  const _$PriceStatsImpl(
      {required this.average,
      required this.minimum,
      required this.maximum,
      required this.dataPoints});

  factory _$PriceStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceStatsImplFromJson(json);

  /// Average price across all data points (RM)
  @override
  final double average;

  /// Minimum price found (RM)
  @override
  final double minimum;

  /// Maximum price found (RM)
  @override
  final double maximum;

  /// Number of data points used for calculation
  @override
  final int dataPoints;

  @override
  String toString() {
    return 'PriceStats(average: $average, minimum: $minimum, maximum: $maximum, dataPoints: $dataPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceStatsImpl &&
            (identical(other.average, average) || other.average == average) &&
            (identical(other.minimum, minimum) || other.minimum == minimum) &&
            (identical(other.maximum, maximum) || other.maximum == maximum) &&
            (identical(other.dataPoints, dataPoints) ||
                other.dataPoints == dataPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, average, minimum, maximum, dataPoints);

  /// Create a copy of PriceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceStatsImplCopyWith<_$PriceStatsImpl> get copyWith =>
      __$$PriceStatsImplCopyWithImpl<_$PriceStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceStatsImplToJson(
      this,
    );
  }
}

abstract class _PriceStats implements PriceStats {
  const factory _PriceStats(
      {required final double average,
      required final double minimum,
      required final double maximum,
      required final int dataPoints}) = _$PriceStatsImpl;

  factory _PriceStats.fromJson(Map<String, dynamic> json) =
      _$PriceStatsImpl.fromJson;

  /// Average price across all data points (RM)
  @override
  double get average;

  /// Minimum price found (RM)
  @override
  double get minimum;

  /// Maximum price found (RM)
  @override
  double get maximum;

  /// Number of data points used for calculation
  @override
  int get dataPoints;

  /// Create a copy of PriceStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceStatsImplCopyWith<_$PriceStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
