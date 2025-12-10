// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harvest_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HarvestPlanModel _$HarvestPlanModelFromJson(Map<String, dynamic> json) {
  return _HarvestPlanModel.fromJson(json);
}

/// @nodoc
mixin _$HarvestPlanModel {
  String get id => throw _privateConstructorUsedError;
  String get farmId => throw _privateConstructorUsedError;
  String get farmName => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get variety => throw _privateConstructorUsedError;
  double get quantityKg => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get plantingDate => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get expectedHarvestDate => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get actualHarvestDate => throw _privateConstructorUsedError;
  HarvestStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get reminderSent => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HarvestPlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HarvestPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HarvestPlanModelCopyWith<HarvestPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HarvestPlanModelCopyWith<$Res> {
  factory $HarvestPlanModelCopyWith(
          HarvestPlanModel value, $Res Function(HarvestPlanModel) then) =
      _$HarvestPlanModelCopyWithImpl<$Res, HarvestPlanModel>;
  @useResult
  $Res call(
      {String id,
      String farmId,
      String farmName,
      String ownerId,
      String variety,
      double quantityKg,
      @NullableTimestampConverter() DateTime? plantingDate,
      @TimestampConverter() DateTime expectedHarvestDate,
      @NullableTimestampConverter() DateTime? actualHarvestDate,
      HarvestStatus status,
      String? notes,
      bool reminderSent,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$HarvestPlanModelCopyWithImpl<$Res, $Val extends HarvestPlanModel>
    implements $HarvestPlanModelCopyWith<$Res> {
  _$HarvestPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HarvestPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmId = null,
    Object? farmName = null,
    Object? ownerId = null,
    Object? variety = null,
    Object? quantityKg = null,
    Object? plantingDate = freezed,
    Object? expectedHarvestDate = null,
    Object? actualHarvestDate = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? reminderSent = null,
    Object? createdAt = null,
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
      farmName: null == farmName
          ? _value.farmName
          : farmName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      variety: null == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String,
      quantityKg: null == quantityKg
          ? _value.quantityKg
          : quantityKg // ignore: cast_nullable_to_non_nullable
              as double,
      plantingDate: freezed == plantingDate
          ? _value.plantingDate
          : plantingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedHarvestDate: null == expectedHarvestDate
          ? _value.expectedHarvestDate
          : expectedHarvestDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualHarvestDate: freezed == actualHarvestDate
          ? _value.actualHarvestDate
          : actualHarvestDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HarvestStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderSent: null == reminderSent
          ? _value.reminderSent
          : reminderSent // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HarvestPlanModelImplCopyWith<$Res>
    implements $HarvestPlanModelCopyWith<$Res> {
  factory _$$HarvestPlanModelImplCopyWith(_$HarvestPlanModelImpl value,
          $Res Function(_$HarvestPlanModelImpl) then) =
      __$$HarvestPlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String farmId,
      String farmName,
      String ownerId,
      String variety,
      double quantityKg,
      @NullableTimestampConverter() DateTime? plantingDate,
      @TimestampConverter() DateTime expectedHarvestDate,
      @NullableTimestampConverter() DateTime? actualHarvestDate,
      HarvestStatus status,
      String? notes,
      bool reminderSent,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$$HarvestPlanModelImplCopyWithImpl<$Res>
    extends _$HarvestPlanModelCopyWithImpl<$Res, _$HarvestPlanModelImpl>
    implements _$$HarvestPlanModelImplCopyWith<$Res> {
  __$$HarvestPlanModelImplCopyWithImpl(_$HarvestPlanModelImpl _value,
      $Res Function(_$HarvestPlanModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HarvestPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmId = null,
    Object? farmName = null,
    Object? ownerId = null,
    Object? variety = null,
    Object? quantityKg = null,
    Object? plantingDate = freezed,
    Object? expectedHarvestDate = null,
    Object? actualHarvestDate = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? reminderSent = null,
    Object? createdAt = null,
  }) {
    return _then(_$HarvestPlanModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      farmId: null == farmId
          ? _value.farmId
          : farmId // ignore: cast_nullable_to_non_nullable
              as String,
      farmName: null == farmName
          ? _value.farmName
          : farmName // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      variety: null == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String,
      quantityKg: null == quantityKg
          ? _value.quantityKg
          : quantityKg // ignore: cast_nullable_to_non_nullable
              as double,
      plantingDate: freezed == plantingDate
          ? _value.plantingDate
          : plantingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedHarvestDate: null == expectedHarvestDate
          ? _value.expectedHarvestDate
          : expectedHarvestDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualHarvestDate: freezed == actualHarvestDate
          ? _value.actualHarvestDate
          : actualHarvestDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HarvestStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderSent: null == reminderSent
          ? _value.reminderSent
          : reminderSent // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HarvestPlanModelImpl implements _HarvestPlanModel {
  const _$HarvestPlanModelImpl(
      {required this.id,
      required this.farmId,
      required this.farmName,
      required this.ownerId,
      required this.variety,
      required this.quantityKg,
      @NullableTimestampConverter() this.plantingDate,
      @TimestampConverter() required this.expectedHarvestDate,
      @NullableTimestampConverter() this.actualHarvestDate,
      required this.status,
      this.notes,
      this.reminderSent = false,
      @TimestampConverter() required this.createdAt});

  factory _$HarvestPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HarvestPlanModelImplFromJson(json);

  @override
  final String id;
  @override
  final String farmId;
  @override
  final String farmName;
  @override
  final String ownerId;
  @override
  final String variety;
  @override
  final double quantityKg;
  @override
  @NullableTimestampConverter()
  final DateTime? plantingDate;
  @override
  @TimestampConverter()
  final DateTime expectedHarvestDate;
  @override
  @NullableTimestampConverter()
  final DateTime? actualHarvestDate;
  @override
  final HarvestStatus status;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool reminderSent;
  @override
  @TimestampConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'HarvestPlanModel(id: $id, farmId: $farmId, farmName: $farmName, ownerId: $ownerId, variety: $variety, quantityKg: $quantityKg, plantingDate: $plantingDate, expectedHarvestDate: $expectedHarvestDate, actualHarvestDate: $actualHarvestDate, status: $status, notes: $notes, reminderSent: $reminderSent, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HarvestPlanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.farmId, farmId) || other.farmId == farmId) &&
            (identical(other.farmName, farmName) ||
                other.farmName == farmName) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.variety, variety) || other.variety == variety) &&
            (identical(other.quantityKg, quantityKg) ||
                other.quantityKg == quantityKg) &&
            (identical(other.plantingDate, plantingDate) ||
                other.plantingDate == plantingDate) &&
            (identical(other.expectedHarvestDate, expectedHarvestDate) ||
                other.expectedHarvestDate == expectedHarvestDate) &&
            (identical(other.actualHarvestDate, actualHarvestDate) ||
                other.actualHarvestDate == actualHarvestDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.reminderSent, reminderSent) ||
                other.reminderSent == reminderSent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      farmId,
      farmName,
      ownerId,
      variety,
      quantityKg,
      plantingDate,
      expectedHarvestDate,
      actualHarvestDate,
      status,
      notes,
      reminderSent,
      createdAt);

  /// Create a copy of HarvestPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HarvestPlanModelImplCopyWith<_$HarvestPlanModelImpl> get copyWith =>
      __$$HarvestPlanModelImplCopyWithImpl<_$HarvestPlanModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HarvestPlanModelImplToJson(
      this,
    );
  }
}

abstract class _HarvestPlanModel implements HarvestPlanModel {
  const factory _HarvestPlanModel(
          {required final String id,
          required final String farmId,
          required final String farmName,
          required final String ownerId,
          required final String variety,
          required final double quantityKg,
          @NullableTimestampConverter() final DateTime? plantingDate,
          @TimestampConverter() required final DateTime expectedHarvestDate,
          @NullableTimestampConverter() final DateTime? actualHarvestDate,
          required final HarvestStatus status,
          final String? notes,
          final bool reminderSent,
          @TimestampConverter() required final DateTime createdAt}) =
      _$HarvestPlanModelImpl;

  factory _HarvestPlanModel.fromJson(Map<String, dynamic> json) =
      _$HarvestPlanModelImpl.fromJson;

  @override
  String get id;
  @override
  String get farmId;
  @override
  String get farmName;
  @override
  String get ownerId;
  @override
  String get variety;
  @override
  double get quantityKg;
  @override
  @NullableTimestampConverter()
  DateTime? get plantingDate;
  @override
  @TimestampConverter()
  DateTime get expectedHarvestDate;
  @override
  @NullableTimestampConverter()
  DateTime? get actualHarvestDate;
  @override
  HarvestStatus get status;
  @override
  String? get notes;
  @override
  bool get reminderSent;
  @override
  @TimestampConverter()
  DateTime get createdAt;

  /// Create a copy of HarvestPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HarvestPlanModelImplCopyWith<_$HarvestPlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
