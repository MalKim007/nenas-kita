// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'buyer_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BuyerRequestModel _$BuyerRequestModelFromJson(Map<String, dynamic> json) {
  return _BuyerRequestModel.fromJson(json);
}

/// @nodoc
mixin _$BuyerRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get buyerId => throw _privateConstructorUsedError;
  String get buyerName => throw _privateConstructorUsedError;
  String? get buyerPhone => throw _privateConstructorUsedError;
  ProductCategory get category => throw _privateConstructorUsedError;
  String? get variety => throw _privateConstructorUsedError;
  double get quantityKg => throw _privateConstructorUsedError;
  String? get deliveryDistrict => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get neededByDate => throw _privateConstructorUsedError;
  RequestStatus get status => throw _privateConstructorUsedError;
  String? get fulfilledByFarmId => throw _privateConstructorUsedError;
  String? get fulfilledByFarmName => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get fulfilledAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BuyerRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuyerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuyerRequestModelCopyWith<BuyerRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuyerRequestModelCopyWith<$Res> {
  factory $BuyerRequestModelCopyWith(
          BuyerRequestModel value, $Res Function(BuyerRequestModel) then) =
      _$BuyerRequestModelCopyWithImpl<$Res, BuyerRequestModel>;
  @useResult
  $Res call(
      {String id,
      String buyerId,
      String buyerName,
      String? buyerPhone,
      ProductCategory category,
      String? variety,
      double quantityKg,
      String? deliveryDistrict,
      @NullableTimestampConverter() DateTime? neededByDate,
      RequestStatus status,
      String? fulfilledByFarmId,
      String? fulfilledByFarmName,
      @NullableTimestampConverter() DateTime? fulfilledAt,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$BuyerRequestModelCopyWithImpl<$Res, $Val extends BuyerRequestModel>
    implements $BuyerRequestModelCopyWith<$Res> {
  _$BuyerRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuyerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? buyerId = null,
    Object? buyerName = null,
    Object? buyerPhone = freezed,
    Object? category = null,
    Object? variety = freezed,
    Object? quantityKg = null,
    Object? deliveryDistrict = freezed,
    Object? neededByDate = freezed,
    Object? status = null,
    Object? fulfilledByFarmId = freezed,
    Object? fulfilledByFarmName = freezed,
    Object? fulfilledAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerName: null == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String,
      buyerPhone: freezed == buyerPhone
          ? _value.buyerPhone
          : buyerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory,
      variety: freezed == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityKg: null == quantityKg
          ? _value.quantityKg
          : quantityKg // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryDistrict: freezed == deliveryDistrict
          ? _value.deliveryDistrict
          : deliveryDistrict // ignore: cast_nullable_to_non_nullable
              as String?,
      neededByDate: freezed == neededByDate
          ? _value.neededByDate
          : neededByDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus,
      fulfilledByFarmId: freezed == fulfilledByFarmId
          ? _value.fulfilledByFarmId
          : fulfilledByFarmId // ignore: cast_nullable_to_non_nullable
              as String?,
      fulfilledByFarmName: freezed == fulfilledByFarmName
          ? _value.fulfilledByFarmName
          : fulfilledByFarmName // ignore: cast_nullable_to_non_nullable
              as String?,
      fulfilledAt: freezed == fulfilledAt
          ? _value.fulfilledAt
          : fulfilledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuyerRequestModelImplCopyWith<$Res>
    implements $BuyerRequestModelCopyWith<$Res> {
  factory _$$BuyerRequestModelImplCopyWith(_$BuyerRequestModelImpl value,
          $Res Function(_$BuyerRequestModelImpl) then) =
      __$$BuyerRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String buyerId,
      String buyerName,
      String? buyerPhone,
      ProductCategory category,
      String? variety,
      double quantityKg,
      String? deliveryDistrict,
      @NullableTimestampConverter() DateTime? neededByDate,
      RequestStatus status,
      String? fulfilledByFarmId,
      String? fulfilledByFarmName,
      @NullableTimestampConverter() DateTime? fulfilledAt,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$$BuyerRequestModelImplCopyWithImpl<$Res>
    extends _$BuyerRequestModelCopyWithImpl<$Res, _$BuyerRequestModelImpl>
    implements _$$BuyerRequestModelImplCopyWith<$Res> {
  __$$BuyerRequestModelImplCopyWithImpl(_$BuyerRequestModelImpl _value,
      $Res Function(_$BuyerRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BuyerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? buyerId = null,
    Object? buyerName = null,
    Object? buyerPhone = freezed,
    Object? category = null,
    Object? variety = freezed,
    Object? quantityKg = null,
    Object? deliveryDistrict = freezed,
    Object? neededByDate = freezed,
    Object? status = null,
    Object? fulfilledByFarmId = freezed,
    Object? fulfilledByFarmName = freezed,
    Object? fulfilledAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$BuyerRequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerName: null == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String,
      buyerPhone: freezed == buyerPhone
          ? _value.buyerPhone
          : buyerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory,
      variety: freezed == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityKg: null == quantityKg
          ? _value.quantityKg
          : quantityKg // ignore: cast_nullable_to_non_nullable
              as double,
      deliveryDistrict: freezed == deliveryDistrict
          ? _value.deliveryDistrict
          : deliveryDistrict // ignore: cast_nullable_to_non_nullable
              as String?,
      neededByDate: freezed == neededByDate
          ? _value.neededByDate
          : neededByDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus,
      fulfilledByFarmId: freezed == fulfilledByFarmId
          ? _value.fulfilledByFarmId
          : fulfilledByFarmId // ignore: cast_nullable_to_non_nullable
              as String?,
      fulfilledByFarmName: freezed == fulfilledByFarmName
          ? _value.fulfilledByFarmName
          : fulfilledByFarmName // ignore: cast_nullable_to_non_nullable
              as String?,
      fulfilledAt: freezed == fulfilledAt
          ? _value.fulfilledAt
          : fulfilledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuyerRequestModelImpl implements _BuyerRequestModel {
  const _$BuyerRequestModelImpl(
      {required this.id,
      required this.buyerId,
      required this.buyerName,
      this.buyerPhone,
      required this.category,
      this.variety,
      required this.quantityKg,
      this.deliveryDistrict,
      @NullableTimestampConverter() this.neededByDate,
      required this.status,
      this.fulfilledByFarmId,
      this.fulfilledByFarmName,
      @NullableTimestampConverter() this.fulfilledAt,
      @TimestampConverter() required this.createdAt});

  factory _$BuyerRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuyerRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String buyerId;
  @override
  final String buyerName;
  @override
  final String? buyerPhone;
  @override
  final ProductCategory category;
  @override
  final String? variety;
  @override
  final double quantityKg;
  @override
  final String? deliveryDistrict;
  @override
  @NullableTimestampConverter()
  final DateTime? neededByDate;
  @override
  final RequestStatus status;
  @override
  final String? fulfilledByFarmId;
  @override
  final String? fulfilledByFarmName;
  @override
  @NullableTimestampConverter()
  final DateTime? fulfilledAt;
  @override
  @TimestampConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'BuyerRequestModel(id: $id, buyerId: $buyerId, buyerName: $buyerName, buyerPhone: $buyerPhone, category: $category, variety: $variety, quantityKg: $quantityKg, deliveryDistrict: $deliveryDistrict, neededByDate: $neededByDate, status: $status, fulfilledByFarmId: $fulfilledByFarmId, fulfilledByFarmName: $fulfilledByFarmName, fulfilledAt: $fulfilledAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuyerRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.buyerName, buyerName) ||
                other.buyerName == buyerName) &&
            (identical(other.buyerPhone, buyerPhone) ||
                other.buyerPhone == buyerPhone) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.variety, variety) || other.variety == variety) &&
            (identical(other.quantityKg, quantityKg) ||
                other.quantityKg == quantityKg) &&
            (identical(other.deliveryDistrict, deliveryDistrict) ||
                other.deliveryDistrict == deliveryDistrict) &&
            (identical(other.neededByDate, neededByDate) ||
                other.neededByDate == neededByDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fulfilledByFarmId, fulfilledByFarmId) ||
                other.fulfilledByFarmId == fulfilledByFarmId) &&
            (identical(other.fulfilledByFarmName, fulfilledByFarmName) ||
                other.fulfilledByFarmName == fulfilledByFarmName) &&
            (identical(other.fulfilledAt, fulfilledAt) ||
                other.fulfilledAt == fulfilledAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      buyerId,
      buyerName,
      buyerPhone,
      category,
      variety,
      quantityKg,
      deliveryDistrict,
      neededByDate,
      status,
      fulfilledByFarmId,
      fulfilledByFarmName,
      fulfilledAt,
      createdAt);

  /// Create a copy of BuyerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuyerRequestModelImplCopyWith<_$BuyerRequestModelImpl> get copyWith =>
      __$$BuyerRequestModelImplCopyWithImpl<_$BuyerRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuyerRequestModelImplToJson(
      this,
    );
  }
}

abstract class _BuyerRequestModel implements BuyerRequestModel {
  const factory _BuyerRequestModel(
          {required final String id,
          required final String buyerId,
          required final String buyerName,
          final String? buyerPhone,
          required final ProductCategory category,
          final String? variety,
          required final double quantityKg,
          final String? deliveryDistrict,
          @NullableTimestampConverter() final DateTime? neededByDate,
          required final RequestStatus status,
          final String? fulfilledByFarmId,
          final String? fulfilledByFarmName,
          @NullableTimestampConverter() final DateTime? fulfilledAt,
          @TimestampConverter() required final DateTime createdAt}) =
      _$BuyerRequestModelImpl;

  factory _BuyerRequestModel.fromJson(Map<String, dynamic> json) =
      _$BuyerRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get buyerId;
  @override
  String get buyerName;
  @override
  String? get buyerPhone;
  @override
  ProductCategory get category;
  @override
  String? get variety;
  @override
  double get quantityKg;
  @override
  String? get deliveryDistrict;
  @override
  @NullableTimestampConverter()
  DateTime? get neededByDate;
  @override
  RequestStatus get status;
  @override
  String? get fulfilledByFarmId;
  @override
  String? get fulfilledByFarmName;
  @override
  @NullableTimestampConverter()
  DateTime? get fulfilledAt;
  @override
  @TimestampConverter()
  DateTime get createdAt;

  /// Create a copy of BuyerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuyerRequestModelImplCopyWith<_$BuyerRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
