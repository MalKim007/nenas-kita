// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_comparison_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceComparisonImpl _$$PriceComparisonImplFromJson(
        Map<String, dynamic> json) =>
    _$PriceComparisonImpl(
      currentPrice: (json['currentPrice'] as num).toDouble(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
      percentDiff: (json['percentDiff'] as num).toDouble(),
      isGoodDeal: json['isGoodDeal'] as bool,
    );

Map<String, dynamic> _$$PriceComparisonImplToJson(
        _$PriceComparisonImpl instance) =>
    <String, dynamic>{
      'currentPrice': instance.currentPrice,
      'averagePrice': instance.averagePrice,
      'percentDiff': instance.percentDiff,
      'isGoodDeal': instance.isGoodDeal,
    };

_$PriceStatsImpl _$$PriceStatsImplFromJson(Map<String, dynamic> json) =>
    _$PriceStatsImpl(
      average: (json['average'] as num).toDouble(),
      minimum: (json['minimum'] as num).toDouble(),
      maximum: (json['maximum'] as num).toDouble(),
      dataPoints: (json['dataPoints'] as num).toInt(),
    );

Map<String, dynamic> _$$PriceStatsImplToJson(_$PriceStatsImpl instance) =>
    <String, dynamic>{
      'average': instance.average,
      'minimum': instance.minimum,
      'maximum': instance.maximum,
      'dataPoints': instance.dataPoints,
    };
