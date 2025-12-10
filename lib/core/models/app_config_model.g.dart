// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppConfigModelImpl _$$AppConfigModelImplFromJson(Map<String, dynamic> json) =>
    _$AppConfigModelImpl(
      varieties: (json['varieties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['Morris', 'Josapine', 'MD2', 'Sarawak', 'Yankee'],
      districts: (json['districts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['Melaka Tengah', 'Alor Gajah', 'Jasin'],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['fresh', 'processed'],
      minAppVersion: json['minAppVersion'] as String? ?? '1.0.0',
    );

Map<String, dynamic> _$$AppConfigModelImplToJson(
        _$AppConfigModelImpl instance) =>
    <String, dynamic>{
      'varieties': instance.varieties,
      'districts': instance.districts,
      'categories': instance.categories,
      'minAppVersion': instance.minAppVersion,
    };
