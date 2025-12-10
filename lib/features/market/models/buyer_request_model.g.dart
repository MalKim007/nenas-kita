// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuyerRequestModelImpl _$$BuyerRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BuyerRequestModelImpl(
      id: json['id'] as String,
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String,
      buyerPhone: json['buyerPhone'] as String?,
      category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
      variety: json['variety'] as String?,
      quantityKg: (json['quantityKg'] as num).toDouble(),
      deliveryDistrict: json['deliveryDistrict'] as String?,
      neededByDate: const NullableTimestampConverter()
          .fromJson(json['neededByDate'] as Timestamp?),
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      fulfilledByFarmId: json['fulfilledByFarmId'] as String?,
      fulfilledByFarmName: json['fulfilledByFarmName'] as String?,
      fulfilledAt: const NullableTimestampConverter()
          .fromJson(json['fulfilledAt'] as Timestamp?),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$BuyerRequestModelImplToJson(
        _$BuyerRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'buyerId': instance.buyerId,
      'buyerName': instance.buyerName,
      'buyerPhone': instance.buyerPhone,
      'category': _$ProductCategoryEnumMap[instance.category]!,
      'variety': instance.variety,
      'quantityKg': instance.quantityKg,
      'deliveryDistrict': instance.deliveryDistrict,
      'neededByDate':
          const NullableTimestampConverter().toJson(instance.neededByDate),
      'status': _$RequestStatusEnumMap[instance.status]!,
      'fulfilledByFarmId': instance.fulfilledByFarmId,
      'fulfilledByFarmName': instance.fulfilledByFarmName,
      'fulfilledAt':
          const NullableTimestampConverter().toJson(instance.fulfilledAt),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$ProductCategoryEnumMap = {
  ProductCategory.fresh: 'fresh',
  ProductCategory.processed: 'processed',
};

const _$RequestStatusEnumMap = {
  RequestStatus.open: 'open',
  RequestStatus.fulfilled: 'fulfilled',
  RequestStatus.closed: 'closed',
};
