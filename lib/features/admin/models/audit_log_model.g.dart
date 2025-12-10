// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogModelImpl _$$AuditLogModelImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogModelImpl(
      id: json['id'] as String,
      adminId: json['adminId'] as String,
      adminName: json['adminName'] as String,
      farmId: json['farmId'] as String?,
      farmName: json['farmName'] as String?,
      action: $enumDecode(_$AuditActionEnumMap, json['action']),
      notes: json['notes'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      timestamp: const TimestampConverter().fromJson(json['timestamp']),
    );

Map<String, dynamic> _$$AuditLogModelImplToJson(_$AuditLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adminId': instance.adminId,
      'adminName': instance.adminName,
      'farmId': instance.farmId,
      'farmName': instance.farmName,
      'action': _$AuditActionEnumMap[instance.action]!,
      'notes': instance.notes,
      'attachments': instance.attachments,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };

const _$AuditActionEnumMap = {
  AuditAction.inspection: 'inspection',
  AuditAction.approved: 'approved',
  AuditAction.rejected: 'rejected',
  AuditAction.pending: 'pending',
};
