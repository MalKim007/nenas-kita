// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FarmModel _$FarmModelFromJson(Map<String, dynamic> json) {
  return _FarmModel.fromJson(json);
}

/// @nodoc
mixin _$FarmModel {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  String? get ownerPhone => throw _privateConstructorUsedError;
  String get farmName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @NullableGeoPointConverter()
  GeoPoint? get location => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;
  String? get licenseNumber => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get licenseExpiry => throw _privateConstructorUsedError;
  double? get farmSizeHectares => throw _privateConstructorUsedError;
  List<String> get varieties => throw _privateConstructorUsedError;
  Map<String, String> get socialLinks => throw _privateConstructorUsedError;
  bool get deliveryAvailable => throw _privateConstructorUsedError;
  bool get verifiedByLPNM => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FarmModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FarmModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmModelCopyWith<FarmModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmModelCopyWith<$Res> {
  factory $FarmModelCopyWith(FarmModel value, $Res Function(FarmModel) then) =
      _$FarmModelCopyWithImpl<$Res, FarmModel>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String ownerName,
      String? ownerPhone,
      String farmName,
      String? description,
      @NullableGeoPointConverter() GeoPoint? location,
      String? address,
      String district,
      String? licenseNumber,
      @NullableTimestampConverter() DateTime? licenseExpiry,
      double? farmSizeHectares,
      List<String> varieties,
      Map<String, String> socialLinks,
      bool deliveryAvailable,
      bool verifiedByLPNM,
      @NullableTimestampConverter() DateTime? verifiedAt,
      bool isActive,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$FarmModelCopyWithImpl<$Res, $Val extends FarmModel>
    implements $FarmModelCopyWith<$Res> {
  _$FarmModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? ownerName = null,
    Object? ownerPhone = freezed,
    Object? farmName = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? address = freezed,
    Object? district = null,
    Object? licenseNumber = freezed,
    Object? licenseExpiry = freezed,
    Object? farmSizeHectares = freezed,
    Object? varieties = null,
    Object? socialLinks = null,
    Object? deliveryAvailable = null,
    Object? verifiedByLPNM = null,
    Object? verifiedAt = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerPhone: freezed == ownerPhone
          ? _value.ownerPhone
          : ownerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      farmName: null == farmName
          ? _value.farmName
          : farmName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: freezed == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseExpiry: freezed == licenseExpiry
          ? _value.licenseExpiry
          : licenseExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      farmSizeHectares: freezed == farmSizeHectares
          ? _value.farmSizeHectares
          : farmSizeHectares // ignore: cast_nullable_to_non_nullable
              as double?,
      varieties: null == varieties
          ? _value.varieties
          : varieties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      socialLinks: null == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      deliveryAvailable: null == deliveryAvailable
          ? _value.deliveryAvailable
          : deliveryAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedByLPNM: null == verifiedByLPNM
          ? _value.verifiedByLPNM
          : verifiedByLPNM // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FarmModelImplCopyWith<$Res>
    implements $FarmModelCopyWith<$Res> {
  factory _$$FarmModelImplCopyWith(
          _$FarmModelImpl value, $Res Function(_$FarmModelImpl) then) =
      __$$FarmModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String ownerName,
      String? ownerPhone,
      String farmName,
      String? description,
      @NullableGeoPointConverter() GeoPoint? location,
      String? address,
      String district,
      String? licenseNumber,
      @NullableTimestampConverter() DateTime? licenseExpiry,
      double? farmSizeHectares,
      List<String> varieties,
      Map<String, String> socialLinks,
      bool deliveryAvailable,
      bool verifiedByLPNM,
      @NullableTimestampConverter() DateTime? verifiedAt,
      bool isActive,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$$FarmModelImplCopyWithImpl<$Res>
    extends _$FarmModelCopyWithImpl<$Res, _$FarmModelImpl>
    implements _$$FarmModelImplCopyWith<$Res> {
  __$$FarmModelImplCopyWithImpl(
      _$FarmModelImpl _value, $Res Function(_$FarmModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FarmModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? ownerName = null,
    Object? ownerPhone = freezed,
    Object? farmName = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? address = freezed,
    Object? district = null,
    Object? licenseNumber = freezed,
    Object? licenseExpiry = freezed,
    Object? farmSizeHectares = freezed,
    Object? varieties = null,
    Object? socialLinks = null,
    Object? deliveryAvailable = null,
    Object? verifiedByLPNM = null,
    Object? verifiedAt = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FarmModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerPhone: freezed == ownerPhone
          ? _value.ownerPhone
          : ownerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      farmName: null == farmName
          ? _value.farmName
          : farmName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: freezed == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseExpiry: freezed == licenseExpiry
          ? _value.licenseExpiry
          : licenseExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      farmSizeHectares: freezed == farmSizeHectares
          ? _value.farmSizeHectares
          : farmSizeHectares // ignore: cast_nullable_to_non_nullable
              as double?,
      varieties: null == varieties
          ? _value._varieties
          : varieties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      socialLinks: null == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      deliveryAvailable: null == deliveryAvailable
          ? _value.deliveryAvailable
          : deliveryAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedByLPNM: null == verifiedByLPNM
          ? _value.verifiedByLPNM
          : verifiedByLPNM // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FarmModelImpl implements _FarmModel {
  const _$FarmModelImpl(
      {required this.id,
      required this.ownerId,
      required this.ownerName,
      this.ownerPhone,
      required this.farmName,
      this.description,
      @NullableGeoPointConverter() this.location,
      this.address,
      required this.district,
      this.licenseNumber,
      @NullableTimestampConverter() this.licenseExpiry,
      this.farmSizeHectares,
      final List<String> varieties = const [],
      final Map<String, String> socialLinks = const {},
      this.deliveryAvailable = false,
      this.verifiedByLPNM = false,
      @NullableTimestampConverter() this.verifiedAt,
      this.isActive = true,
      @TimestampConverter() required this.createdAt,
      @NullableTimestampConverter() this.updatedAt})
      : _varieties = varieties,
        _socialLinks = socialLinks;

  factory _$FarmModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmModelImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String ownerName;
  @override
  final String? ownerPhone;
  @override
  final String farmName;
  @override
  final String? description;
  @override
  @NullableGeoPointConverter()
  final GeoPoint? location;
  @override
  final String? address;
  @override
  final String district;
  @override
  final String? licenseNumber;
  @override
  @NullableTimestampConverter()
  final DateTime? licenseExpiry;
  @override
  final double? farmSizeHectares;
  final List<String> _varieties;
  @override
  @JsonKey()
  List<String> get varieties {
    if (_varieties is EqualUnmodifiableListView) return _varieties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_varieties);
  }

  final Map<String, String> _socialLinks;
  @override
  @JsonKey()
  Map<String, String> get socialLinks {
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_socialLinks);
  }

  @override
  @JsonKey()
  final bool deliveryAvailable;
  @override
  @JsonKey()
  final bool verifiedByLPNM;
  @override
  @NullableTimestampConverter()
  final DateTime? verifiedAt;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @NullableTimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FarmModel(id: $id, ownerId: $ownerId, ownerName: $ownerName, ownerPhone: $ownerPhone, farmName: $farmName, description: $description, location: $location, address: $address, district: $district, licenseNumber: $licenseNumber, licenseExpiry: $licenseExpiry, farmSizeHectares: $farmSizeHectares, varieties: $varieties, socialLinks: $socialLinks, deliveryAvailable: $deliveryAvailable, verifiedByLPNM: $verifiedByLPNM, verifiedAt: $verifiedAt, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerPhone, ownerPhone) ||
                other.ownerPhone == ownerPhone) &&
            (identical(other.farmName, farmName) ||
                other.farmName == farmName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.licenseExpiry, licenseExpiry) ||
                other.licenseExpiry == licenseExpiry) &&
            (identical(other.farmSizeHectares, farmSizeHectares) ||
                other.farmSizeHectares == farmSizeHectares) &&
            const DeepCollectionEquality()
                .equals(other._varieties, _varieties) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            (identical(other.deliveryAvailable, deliveryAvailable) ||
                other.deliveryAvailable == deliveryAvailable) &&
            (identical(other.verifiedByLPNM, verifiedByLPNM) ||
                other.verifiedByLPNM == verifiedByLPNM) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        ownerId,
        ownerName,
        ownerPhone,
        farmName,
        description,
        location,
        address,
        district,
        licenseNumber,
        licenseExpiry,
        farmSizeHectares,
        const DeepCollectionEquality().hash(_varieties),
        const DeepCollectionEquality().hash(_socialLinks),
        deliveryAvailable,
        verifiedByLPNM,
        verifiedAt,
        isActive,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of FarmModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmModelImplCopyWith<_$FarmModelImpl> get copyWith =>
      __$$FarmModelImplCopyWithImpl<_$FarmModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmModelImplToJson(
      this,
    );
  }
}

abstract class _FarmModel implements FarmModel {
  const factory _FarmModel(
          {required final String id,
          required final String ownerId,
          required final String ownerName,
          final String? ownerPhone,
          required final String farmName,
          final String? description,
          @NullableGeoPointConverter() final GeoPoint? location,
          final String? address,
          required final String district,
          final String? licenseNumber,
          @NullableTimestampConverter() final DateTime? licenseExpiry,
          final double? farmSizeHectares,
          final List<String> varieties,
          final Map<String, String> socialLinks,
          final bool deliveryAvailable,
          final bool verifiedByLPNM,
          @NullableTimestampConverter() final DateTime? verifiedAt,
          final bool isActive,
          @TimestampConverter() required final DateTime createdAt,
          @NullableTimestampConverter() final DateTime? updatedAt}) =
      _$FarmModelImpl;

  factory _FarmModel.fromJson(Map<String, dynamic> json) =
      _$FarmModelImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get ownerName;
  @override
  String? get ownerPhone;
  @override
  String get farmName;
  @override
  String? get description;
  @override
  @NullableGeoPointConverter()
  GeoPoint? get location;
  @override
  String? get address;
  @override
  String get district;
  @override
  String? get licenseNumber;
  @override
  @NullableTimestampConverter()
  DateTime? get licenseExpiry;
  @override
  double? get farmSizeHectares;
  @override
  List<String> get varieties;
  @override
  Map<String, String> get socialLinks;
  @override
  bool get deliveryAvailable;
  @override
  bool get verifiedByLPNM;
  @override
  @NullableTimestampConverter()
  DateTime? get verifiedAt;
  @override
  bool get isActive;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @NullableTimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of FarmModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmModelImplCopyWith<_$FarmModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
