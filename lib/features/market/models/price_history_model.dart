import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/core/utils/firestore_converters.dart';

part 'price_history_model.freezed.dart';
part 'price_history_model.g.dart';

@freezed
class PriceHistoryModel with _$PriceHistoryModel {
  const factory PriceHistoryModel({
    required String id,
    required String farmId,
    required String productId,
    required String productName,
    String? variety, // Nullable - processed products don't have variety
    required double oldPrice,
    required double newPrice,
    double? oldWholesalePrice,
    double? newWholesalePrice,
    @TimestampConverter() required DateTime changedAt,
    @NullableTimestampConverter() DateTime? expiresAt,
  }) = _PriceHistoryModel;

  factory PriceHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$PriceHistoryModelFromJson(json);

  factory PriceHistoryModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PriceHistoryModel.fromJson({...data, 'id': doc.id});
  }
}

extension PriceHistoryModelExtension on PriceHistoryModel {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  /// Calculate price change percentage
  double get priceChangePercent =>
      oldPrice > 0 ? ((newPrice - oldPrice) / oldPrice) * 100 : 0;

  /// Check if price increased
  bool get isPriceIncrease => newPrice > oldPrice;

  /// Check if price decreased
  bool get isPriceDecrease => newPrice < oldPrice;

  /// Get price difference
  double get priceDifference => newPrice - oldPrice;

  /// Get formatted price change string
  String get formattedChange {
    final diff = priceDifference;
    final sign = diff >= 0 ? '+' : '';
    return '$sign${diff.toStringAsFixed(2)} (${priceChangePercent.toStringAsFixed(1)}%)';
  }
}
