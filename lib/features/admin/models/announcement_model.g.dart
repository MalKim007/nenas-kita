// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnnouncementModelImpl _$$AnnouncementModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AnnouncementModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: $enumDecode(_$AnnouncementTypeEnumMap, json['type']),
      targetRoles: (json['targetRoles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdBy: json['createdBy'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      expiresAt: const NullableTimestampConverter()
          .fromJson(json['expiresAt'] as Timestamp?),
    );

Map<String, dynamic> _$$AnnouncementModelImplToJson(
        _$AnnouncementModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': _$AnnouncementTypeEnumMap[instance.type]!,
      'targetRoles': instance.targetRoles,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'expiresAt':
          const NullableTimestampConverter().toJson(instance.expiresAt),
    };

const _$AnnouncementTypeEnumMap = {
  AnnouncementType.info: 'info',
  AnnouncementType.warning: 'warning',
  AnnouncementType.promo: 'promo',
};
