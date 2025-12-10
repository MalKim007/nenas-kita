// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      name: json['name'] as String,
      category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
      variety: json['variety'] as String?,
      price: (json['price'] as num).toDouble(),
      wholesalePrice: (json['wholesalePrice'] as num?)?.toDouble(),
      wholesaleMinQty: (json['wholesaleMinQty'] as num?)?.toDouble(),
      priceUnit: json['priceUnit'] as String,
      stockStatus: $enumDecode(_$StockStatusEnumMap, json['stockStatus']),
      description: json['description'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmId': instance.farmId,
      'name': instance.name,
      'category': _$ProductCategoryEnumMap[instance.category]!,
      'variety': instance.variety,
      'price': instance.price,
      'wholesalePrice': instance.wholesalePrice,
      'wholesaleMinQty': instance.wholesaleMinQty,
      'priceUnit': instance.priceUnit,
      'stockStatus': _$StockStatusEnumMap[instance.stockStatus]!,
      'description': instance.description,
      'images': instance.images,
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$ProductCategoryEnumMap = {
  ProductCategory.fresh: 'fresh',
  ProductCategory.processed: 'processed',
};

const _$StockStatusEnumMap = {
  StockStatus.available: 'available',
  StockStatus.limited: 'limited',
  StockStatus.out: 'out',
};
