import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';

part 'product_with_farm.freezed.dart';

/// Composite model combining a product with its associated farm data.
/// Used for cross-farm product comparison features.
@freezed
class ProductWithFarm with _$ProductWithFarm {
  const ProductWithFarm._();

  const factory ProductWithFarm({
    /// The product being compared
    required ProductModel product,

    /// The farm that sells this product
    required FarmModel farm,

    /// Distance from user's current location in kilometers (null if unavailable)
    double? distanceKm,
  }) = _ProductWithFarm;
}

/// Extension methods for ProductWithFarm
extension ProductWithFarmExtension on ProductWithFarm {
  /// Get formatted distance string (e.g., "12.5 km")
  String? get formattedDistance =>
      distanceKm != null ? '${distanceKm!.toStringAsFixed(1)} km' : null;

  /// Check if farm is LPNM verified
  bool get isVerified => farm.verifiedByLPNM;

  /// Check if farm offers delivery
  bool get hasDelivery => farm.deliveryAvailable;

  /// Get the product's primary image URL
  String? get productImage => product.primaryImage;

  /// Get farm hero image URL
  String? get farmImage => farm.socialLinks['heroImage'];

  /// Get display image (product image first, then farm image)
  String? get displayImage => productImage ?? farmImage;

  /// Get formatted retail price
  String get formattedPrice => product.formattedPrice;

  /// Check if wholesale price is available
  bool get hasWholesalePrice => product.hasWholesalePrice;

  /// Get formatted wholesale price (null if not available)
  String? get formattedWholesalePrice => product.formattedWholesalePrice;

  /// Get product name
  String get productName => product.name;

  /// Get farm name
  String get farmName => farm.farmName;

  /// Get district name
  String get district => farm.district;

  /// Get stock status
  String get stockStatusLabel {
    switch (product.stockStatus.name) {
      case 'available':
        return 'Available';
      case 'limited':
        return 'Limited Stock';
      case 'out':
        return 'Out of Stock';
      default:
        return 'Unknown';
    }
  }

  /// Check if product is in stock
  bool get isInStock =>
      product.stockStatus.name == 'available' ||
      product.stockStatus.name == 'limited';
}
