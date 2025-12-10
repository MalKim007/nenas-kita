// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      avatarUrl: json['avatarUrl'] as String?,
      district: json['district'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter()
          .fromJson(json['updatedAt'] as Timestamp?),
      isVerified: json['isVerified'] as bool? ?? false,
      fcmToken: json['fcmToken'] as String?,
      firebaseUid: json['firebaseUid'] as String?,
      hasPassword: json['hasPassword'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'avatarUrl': instance.avatarUrl,
      'district': instance.district,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const NullableTimestampConverter().toJson(instance.updatedAt),
      'isVerified': instance.isVerified,
      'fcmToken': instance.fcmToken,
      'firebaseUid': instance.firebaseUid,
      'hasPassword': instance.hasPassword,
    };

const _$UserRoleEnumMap = {
  UserRole.farmer: 'farmer',
  UserRole.buyer: 'buyer',
  UserRole.wholesaler: 'wholesaler',
  UserRole.admin: 'admin',
  UserRole.superadmin: 'superadmin',
};
