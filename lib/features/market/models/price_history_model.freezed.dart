// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PriceHistoryModel _$PriceHistoryModelFromJson(Map<String, dynamic> json) {
  return _PriceHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$PriceHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get farmId => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get variety =>
      throw _privateConstructorUsedError; // Nullable - processed products don't have variety
  double get oldPrice => throw _privateConstructorUsedError;
  double get newPrice => throw _privateConstructorUsedError;
  double? get oldWholesalePrice => throw _privateConstructorUsedError;
  double? get newWholesalePrice => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get changedAt => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this PriceHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceHistoryModelCopyWith<PriceHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceHistoryModelCopyWith<$Res> {
  factory $PriceHistoryModelCopyWith(
          PriceHistoryModel value, $Res Function(PriceHistoryModel) then) =
      _$PriceHistoryModelCopyWithImpl<$Res, PriceHistoryModel>;
  @useResult
  $Res call(
      {String id,
      String farmId,
      String productId,
      String productName,
      String? variety,
      double oldPrice,
      double newPrice,
      double? oldWholesalePrice,
      double? newWholesalePrice,
      @TimestampConverter() DateTime changedAt,
      @NullableTimestampConverter() DateTime? expiresAt});
}

/// @nodoc
class _$PriceHistoryModelCopyWithImpl<$Res, $Val extends PriceHistoryModel>
    implements $PriceHistoryModelCopyWith<$Res> {
  _$PriceHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmId = null,
    Object? productId = null,
    Object? productName = null,
    Object? variety = freezed,
    Object? oldPrice = null,
    Object? newPrice = null,
    Object? oldWholesalePrice = freezed,
    Object? newWholesalePrice = freezed,
    Object? changedAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      farmId: null == farmId
          ? _value.farmId
          : farmId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      variety: freezed == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String?,
      oldPrice: null == oldPrice
          ? _value.oldPrice
          : oldPrice // ignore: cast_nullable_to_non_nullable
              as double,
      newPrice: null == newPrice
          ? _value.newPrice
          : newPrice // ignore: cast_nullable_to_non_nullable
              as double,
      oldWholesalePrice: freezed == oldWholesalePrice
          ? _value.oldWholesalePrice
          : oldWholesalePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      newWholesalePrice: freezed == newWholesalePrice
          ? _value.newWholesalePrice
          : newWholesalePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceHistoryModelImplCopyWith<$Res>
    implements $PriceHistoryModelCopyWith<$Res> {
  factory _$$PriceHistoryModelImplCopyWith(_$PriceHistoryModelImpl value,
          $Res Function(_$PriceHistoryModelImpl) then) =
      __$$PriceHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String farmId,
      String productId,
      String productName,
      String? variety,
      double oldPrice,
      double newPrice,
      double? oldWholesalePrice,
      double? newWholesalePrice,
      @TimestampConverter() DateTime changedAt,
      @NullableTimestampConverter() DateTime? expiresAt});
}

/// @nodoc
class __$$PriceHistoryModelImplCopyWithImpl<$Res>
    extends _$PriceHistoryModelCopyWithImpl<$Res, _$PriceHistoryModelImpl>
    implements _$$PriceHistoryModelImplCopyWith<$Res> {
  __$$PriceHistoryModelImplCopyWithImpl(_$PriceHistoryModelImpl _value,
      $Res Function(_$PriceHistoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmId = null,
    Object? productId = null,
    Object? productName = null,
    Object? variety = freezed,
    Object? oldPrice = null,
    Object? newPrice = null,
    Object? oldWholesalePrice = freezed,
    Object? newWholesalePrice = freezed,
    Object? changedAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_$PriceHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      farmId: null == farmId
          ? _value.farmId
          : farmId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      variety: freezed == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String?,
      oldPrice: null == oldPrice
          ? _value.oldPrice
          : oldPrice // ignore: cast_nullable_to_non_nullable
              as double,
      newPrice: null == newPrice
          ? _value.newPrice
          : newPrice // ignore: cast_nullable_to_non_nullable
              as double,
      oldWholesalePrice: freezed == oldWholesalePrice
          ? _value.oldWholesalePrice
          : oldWholesalePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      newWholesalePrice: freezed == newWholesalePrice
          ? _value.newWholesalePrice
          : newWholesalePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceHistoryModelImpl implements _PriceHistoryModel {
  const _$PriceHistoryModelImpl(
      {required this.id,
      required this.farmId,
      required this.productId,
      required this.productName,
      this.variety,
      required this.oldPrice,
      required this.newPrice,
      this.oldWholesalePrice,
      this.newWholesalePrice,
      @TimestampConverter() required this.changedAt,
      @NullableTimestampConverter() this.expiresAt});

  factory _$PriceHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String farmId;
  @override
  final String productId;
  @override
  final String productName;
  @override
  final String? variety;
// Nullable - processed products don't have variety
  @override
  final double oldPrice;
  @override
  final double newPrice;
  @override
  final double? oldWholesalePrice;
  @override
  final double? newWholesalePrice;
  @override
  @TimestampConverter()
  final DateTime changedAt;
  @override
  @NullableTimestampConverter()
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'PriceHistoryModel(id: $id, farmId: $farmId, productId: $productId, productName: $productName, variety: $variety, oldPrice: $oldPrice, newPrice: $newPrice, oldWholesalePrice: $oldWholesalePrice, newWholesalePrice: $newWholesalePrice, changedAt: $changedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.farmId, farmId) || other.farmId == farmId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variety, variety) || other.variety == variety) &&
            (identical(other.oldPrice, oldPrice) ||
                other.oldPrice == oldPrice) &&
            (identical(other.newPrice, newPrice) ||
                other.newPrice == newPrice) &&
            (identical(other.oldWholesalePrice, oldWholesalePrice) ||
                other.oldWholesalePrice == oldWholesalePrice) &&
            (identical(other.newWholesalePrice, newWholesalePrice) ||
                other.newWholesalePrice == newWholesalePrice) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      farmId,
      productId,
      productName,
      variety,
      oldPrice,
      newPrice,
      oldWholesalePrice,
      newWholesalePrice,
      changedAt,
      expiresAt);

  /// Create a copy of PriceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceHistoryModelImplCopyWith<_$PriceHistoryModelImpl> get copyWith =>
      __$$PriceHistoryModelImplCopyWithImpl<_$PriceHistoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _PriceHistoryModel implements PriceHistoryModel {
  const factory _PriceHistoryModel(
          {required final String id,
          required final String farmId,
          required final String productId,
          required final String productName,
          final String? variety,
          required final double oldPrice,
          required final double newPrice,
          final double? oldWholesalePrice,
          final double? newWholesalePrice,
          @TimestampConverter() required final DateTime changedAt,
          @NullableTimestampConverter() final DateTime? expiresAt}) =
      _$PriceHistoryModelImpl;

  factory _PriceHistoryModel.fromJson(Map<String, dynamic> json) =
      _$PriceHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get farmId;
  @override
  String get productId;
  @override
  String get productName;
  @override
  String? get variety; // Nullable - processed products don't have variety
  @override
  double get oldPrice;
  @override
  double get newPrice;
  @override
  double? get oldWholesalePrice;
  @override
  double? get newWholesalePrice;
  @override
  @TimestampConverter()
  DateTime get changedAt;
  @override
  @NullableTimestampConverter()
  DateTime? get expiresAt;

  /// Create a copy of PriceHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceHistoryModelImplCopyWith<_$PriceHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
