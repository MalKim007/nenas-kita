// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceHistoryModelImpl _$$PriceHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PriceHistoryModelImpl(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      variety: json['variety'] as String?,
      oldPrice: (json['oldPrice'] as num).toDouble(),
      newPrice: (json['newPrice'] as num).toDouble(),
      oldWholesalePrice: (json['oldWholesalePrice'] as num?)?.toDouble(),
      newWholesalePrice: (json['newWholesalePrice'] as num?)?.toDouble(),
      changedAt: const TimestampConverter().fromJson(json['changedAt']),
      expiresAt: const NullableTimestampConverter()
          .fromJson(json['expiresAt'] as Timestamp?),
    );

Map<String, dynamic> _$$PriceHistoryModelImplToJson(
        _$PriceHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmId': instance.farmId,
      'productId': instance.productId,
      'productName': instance.productName,
      'variety': instance.variety,
      'oldPrice': instance.oldPrice,
      'newPrice': instance.newPrice,
      'oldWholesalePrice': instance.oldWholesalePrice,
      'newWholesalePrice': instance.newWholesalePrice,
      'changedAt': const TimestampConverter().toJson(instance.changedAt),
      'expiresAt':
          const NullableTimestampConverter().toJson(instance.expiresAt),
    };
