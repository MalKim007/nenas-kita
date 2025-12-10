// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HarvestPlanModelImpl _$$HarvestPlanModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HarvestPlanModelImpl(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      farmName: json['farmName'] as String,
      ownerId: json['ownerId'] as String,
      variety: json['variety'] as String,
      quantityKg: (json['quantityKg'] as num).toDouble(),
      plantingDate: const NullableTimestampConverter()
          .fromJson(json['plantingDate'] as Timestamp?),
      expectedHarvestDate:
          const TimestampConverter().fromJson(json['expectedHarvestDate']),
      actualHarvestDate: const NullableTimestampConverter()
          .fromJson(json['actualHarvestDate'] as Timestamp?),
      status: $enumDecode(_$HarvestStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      reminderSent: json['reminderSent'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$HarvestPlanModelImplToJson(
        _$HarvestPlanModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmId': instance.farmId,
      'farmName': instance.farmName,
      'ownerId': instance.ownerId,
      'variety': instance.variety,
      'quantityKg': instance.quantityKg,
      'plantingDate':
          const NullableTimestampConverter().toJson(instance.plantingDate),
      'expectedHarvestDate':
          const TimestampConverter().toJson(instance.expectedHarvestDate),
      'actualHarvestDate':
          const NullableTimestampConverter().toJson(instance.actualHarvestDate),
      'status': _$HarvestStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'reminderSent': instance.reminderSent,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$HarvestStatusEnumMap = {
  HarvestStatus.planned: 'planned',
  HarvestStatus.growing: 'growing',
  HarvestStatus.ready: 'ready',
  HarvestStatus.harvested: 'harvested',
};
