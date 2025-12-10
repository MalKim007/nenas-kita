// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FarmModelImpl _$$FarmModelImplFromJson(Map<String, dynamic> json) =>
    _$FarmModelImpl(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      ownerPhone: json['ownerPhone'] as String?,
      farmName: json['farmName'] as String,
      description: json['description'] as String?,
      location: const NullableGeoPointConverter()
          .fromJson(json['location'] as GeoPoint?),
      address: json['address'] as String?,
      district: json['district'] as String,
      licenseNumber: json['licenseNumber'] as String?,
      licenseExpiry: const NullableTimestampConverter()
          .fromJson(json['licenseExpiry'] as Timestamp?),
      farmSizeHectares: (json['farmSizeHectares'] as num?)?.toDouble(),
      varieties: (json['varieties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      deliveryAvailable: json['deliveryAvailable'] as bool? ?? false,
      verifiedByLPNM: json['verifiedByLPNM'] as bool? ?? false,
      verifiedAt: const NullableTimestampConverter()
          .fromJson(json['verifiedAt'] as Timestamp?),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter()
          .fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$FarmModelImplToJson(_$FarmModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'ownerPhone': instance.ownerPhone,
      'farmName': instance.farmName,
      'description': instance.description,
      'location': const NullableGeoPointConverter().toJson(instance.location),
      'address': instance.address,
      'district': instance.district,
      'licenseNumber': instance.licenseNumber,
      'licenseExpiry':
          const NullableTimestampConverter().toJson(instance.licenseExpiry),
      'farmSizeHectares': instance.farmSizeHectares,
      'varieties': instance.varieties,
      'socialLinks': instance.socialLinks,
      'deliveryAvailable': instance.deliveryAvailable,
      'verifiedByLPNM': instance.verifiedByLPNM,
      'verifiedAt':
          const NullableTimestampConverter().toJson(instance.verifiedAt),
      'isActive': instance.isActive,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const NullableTimestampConverter().toJson(instance.updatedAt),
    };
