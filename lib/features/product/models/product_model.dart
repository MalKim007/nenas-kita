import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/utils/firestore_converters.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String farmId,
    required String name,
    required ProductCategory category,
    String? variety, // Nullable - only required for fresh products
    required double price,
    double? wholesalePrice,
    double? wholesaleMinQty,
    required String priceUnit,
    required StockStatus stockStatus,
    String? description,
    @Default([]) List<String> images,
    @TimestampConverter() required DateTime updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  factory ProductModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ProductModel.fromJson({...data, 'id': doc.id});
  }
}

extension ProductModelExtension on ProductModel {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json.remove('farmId'); // farmId is implicit in subcollection path
    return json;
  }

  /// Check if product is available
  bool get isAvailable => stockStatus == StockStatus.available;

  /// Check if product has wholesale pricing
  bool get hasWholesalePrice => wholesalePrice != null && wholesaleMinQty != null;

  /// Get formatted price string
  String get formattedPrice => 'RM ${price.toStringAsFixed(2)} $priceUnit';

  /// Get formatted wholesale price string
  String? get formattedWholesalePrice => wholesalePrice != null
      ? 'RM ${wholesalePrice!.toStringAsFixed(2)} $priceUnit (min ${wholesaleMinQty?.toStringAsFixed(0)} kg)'
      : null;

  /// Get primary image or null
  String? get primaryImage => images.isNotEmpty ? images.first : null;
}
