// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  String get farmId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ProductCategory get category => throw _privateConstructorUsedError;
  String? get variety =>
      throw _privateConstructorUsedError; // Nullable - only required for fresh products
  double get price => throw _privateConstructorUsedError;
  double? get wholesalePrice => throw _privateConstructorUsedError;
  double? get wholesaleMinQty => throw _privateConstructorUsedError;
  String get priceUnit => throw _privateConstructorUsedError;
  StockStatus get stockStatus => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {String id,
      String farmId,
      String name,
      ProductCategory category,
      String? variety,
      double price,
      double? wholesalePrice,
      double? wholesaleMinQty,
      String priceUnit,
      StockStatus stockStatus,
      String? description,
      List<String> images,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmId = null,
    Object? name = null,
    Object? category = null,
    Object? variety = freezed,
    Object? price = null,
    Object? wholesalePrice = freezed,
    Object? wholesaleMinQty = freezed,
    Object? priceUnit = null,
    Object? stockStatus = null,
    Object? description = freezed,
    Object? images = null,
    Object? updatedAt = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory,
      variety: freezed == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      wholesalePrice: freezed == wholesalePrice
          ? _value.wholesalePrice
          : wholesalePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      wholesaleMinQty: freezed == wholesaleMinQty
          ? _value.wholesaleMinQty
          : wholesaleMinQty // ignore: cast_nullable_to_non_nullable
              as double?,
      priceUnit: null == priceUnit
          ? _value.priceUnit
          : priceUnit // ignore: cast_nullable_to_non_nullable
              as String,
      stockStatus: null == stockStatus
          ? _value.stockStatus
          : stockStatus // ignore: cast_nullable_to_non_nullable
              as StockStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String farmId,
      String name,
      ProductCategory category,
      String? variety,
      double price,
      double? wholesalePrice,
      double? wholesaleMinQty,
      String priceUnit,
      StockStatus stockStatus,
      String? description,
      List<String> images,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmId = null,
    Object? name = null,
    Object? category = null,
    Object? variety = freezed,
    Object? price = null,
    Object? wholesalePrice = freezed,
    Object? wholesaleMinQty = freezed,
    Object? priceUnit = null,
    Object? stockStatus = null,
    Object? description = freezed,
    Object? images = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      farmId: null == farmId
          ? _value.farmId
          : farmId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory,
      variety: freezed == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      wholesalePrice: freezed == wholesalePrice
          ? _value.wholesalePrice
          : wholesalePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      wholesaleMinQty: freezed == wholesaleMinQty
          ? _value.wholesaleMinQty
          : wholesaleMinQty // ignore: cast_nullable_to_non_nullable
              as double?,
      priceUnit: null == priceUnit
          ? _value.priceUnit
          : priceUnit // ignore: cast_nullable_to_non_nullable
              as String,
      stockStatus: null == stockStatus
          ? _value.stockStatus
          : stockStatus // ignore: cast_nullable_to_non_nullable
              as StockStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl implements _ProductModel {
  const _$ProductModelImpl(
      {required this.id,
      required this.farmId,
      required this.name,
      required this.category,
      this.variety,
      required this.price,
      this.wholesalePrice,
      this.wholesaleMinQty,
      required this.priceUnit,
      required this.stockStatus,
      this.description,
      final List<String> images = const [],
      @TimestampConverter() required this.updatedAt})
      : _images = images;

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  final String id;
  @override
  final String farmId;
  @override
  final String name;
  @override
  final ProductCategory category;
  @override
  final String? variety;
// Nullable - only required for fresh products
  @override
  final double price;
  @override
  final double? wholesalePrice;
  @override
  final double? wholesaleMinQty;
  @override
  final String priceUnit;
  @override
  final StockStatus stockStatus;
  @override
  final String? description;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProductModel(id: $id, farmId: $farmId, name: $name, category: $category, variety: $variety, price: $price, wholesalePrice: $wholesalePrice, wholesaleMinQty: $wholesaleMinQty, priceUnit: $priceUnit, stockStatus: $stockStatus, description: $description, images: $images, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.farmId, farmId) || other.farmId == farmId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.variety, variety) || other.variety == variety) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.wholesalePrice, wholesalePrice) ||
                other.wholesalePrice == wholesalePrice) &&
            (identical(other.wholesaleMinQty, wholesaleMinQty) ||
                other.wholesaleMinQty == wholesaleMinQty) &&
            (identical(other.priceUnit, priceUnit) ||
                other.priceUnit == priceUnit) &&
            (identical(other.stockStatus, stockStatus) ||
                other.stockStatus == stockStatus) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      farmId,
      name,
      category,
      variety,
      price,
      wholesalePrice,
      wholesaleMinQty,
      priceUnit,
      stockStatus,
      description,
      const DeepCollectionEquality().hash(_images),
      updatedAt);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(
      this,
    );
  }
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel(
          {required final String id,
          required final String farmId,
          required final String name,
          required final ProductCategory category,
          final String? variety,
          required final double price,
          final double? wholesalePrice,
          final double? wholesaleMinQty,
          required final String priceUnit,
          required final StockStatus stockStatus,
          final String? description,
          final List<String> images,
          @TimestampConverter() required final DateTime updatedAt}) =
      _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get farmId;
  @override
  String get name;
  @override
  ProductCategory get category;
  @override
  String? get variety; // Nullable - only required for fresh products
  @override
  double get price;
  @override
  double? get wholesalePrice;
  @override
  double? get wholesaleMinQty;
  @override
  String get priceUnit;
  @override
  StockStatus get stockStatus;
  @override
  String? get description;
  @override
  List<String> get images;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
