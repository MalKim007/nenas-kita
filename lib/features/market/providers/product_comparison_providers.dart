import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/market/models/product_with_farm.dart';
import 'package:nenas_kita/features/market/models/price_comparison_model.dart';
import 'package:nenas_kita/features/market/providers/farm_discovery_providers.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

part 'product_comparison_providers.g.dart';

// ============================================================================
// All Farms Map (Pre-fetch for O(1) lookups)
// ============================================================================

/// Pre-fetches all active farms as a Map for efficient O(1) lookups.
/// Cached and shared across product comparison queries.
@riverpod
Future<Map<String, FarmModel>> allFarmsMap(AllFarmsMapRef ref) async {
  final farms = await ref.watch(allFarmsProvider.future);
  return {for (var farm in farms) farm.id: farm};
}

// ============================================================================
// Product Search Across Farms
// ============================================================================

/// Searches products across all farms with optional category filter.
/// Returns `List<ProductWithFarm>` with farm data and distance calculated.
///
/// - [query]: Search term (min 2 chars, case-insensitive)
/// - [category]: Optional category filter (null = all categories)
@riverpod
Future<List<ProductWithFarm>> searchProductsAcrossFarms(
  SearchProductsAcrossFarmsRef ref,
  String query, {
  ProductCategory? category,
}) async {
  // Guard: only query Firestore when authenticated to avoid permission errors on cold start
  final isAuthed = ref.watch(isAuthenticatedProvider);
  if (!isAuthed) return [];

  // Require minimum 2 characters
  if (query.length < 2) return [];

  // Step 1: Get all products (including out of stock)
  final products = await ref.watch(allProductsProvider.future);

  // Step 2: Pre-fetch all farms as map for O(1) lookup
  final farmsMap = await ref.watch(allFarmsMapProvider.future);

  // Step 3: Get user location for distance calculation
  final userPosition = await ref.watch(cachedUserLocationProvider.future);
  final locationService = ref.read(locationServiceProvider);

  // Step 4: Filter and transform products
  final queryLower = query.toLowerCase();
  final results = <ProductWithFarm>[];

  for (final product in products) {
    // Filter by name (case-insensitive contains)
    if (!product.name.toLowerCase().contains(queryLower)) {
      continue;
    }

    // Filter by category if specified
    if (category != null && product.category != category) {
      continue;
    }

    // Get farm data
    final farm = farmsMap[product.farmId];
    if (farm == null) continue; // Skip if farm not found (shouldn't happen)

    // Calculate distance
    double? distanceKm;
    if (userPosition != null && farm.location != null) {
      try {
        distanceKm = locationService.calculateDistanceFromGeoPoints(
          GeoPoint(userPosition.latitude, userPosition.longitude),
          farm.location!,
        );
      } catch (e) {
        // Distance calculation failed, leave as null
        distanceKm = null;
      }
    }

    results.add(ProductWithFarm(
      product: product,
      farm: farm,
      distanceKm: distanceKm,
    ));
  }

  // Limit results to 50 for performance
  if (results.length > 50) {
    return results.sublist(0, 50);
  }

  return results;
}

/// Searches products with category filter only (no text query).
/// Useful for browsing all products in a category.
@riverpod
Future<List<ProductWithFarm>> productsByComparisonCategory(
  ProductsByComparisonCategoryRef ref,
  ProductCategory? category,
) async {
  // Guard: only query Firestore when authenticated to avoid permission errors on cold start
  final isAuthed = ref.watch(isAuthenticatedProvider);
  if (!isAuthed) return [];

  // Step 1: Get all products
  final products = await ref.watch(allProductsProvider.future);

  // Step 2: Pre-fetch all farms as map for O(1) lookup
  final farmsMap = await ref.watch(allFarmsMapProvider.future);

  // Step 3: Get user location for distance calculation
  final userPosition = await ref.watch(cachedUserLocationProvider.future);
  final locationService = ref.read(locationServiceProvider);

  // Step 4: Filter and transform products
  final results = <ProductWithFarm>[];

  for (final product in products) {
    // Filter by category if specified
    if (category != null && product.category != category) {
      continue;
    }

    // Get farm data
    final farm = farmsMap[product.farmId];
    if (farm == null) continue;

    // Calculate distance
    double? distanceKm;
    if (userPosition != null && farm.location != null) {
      try {
        distanceKm = locationService.calculateDistanceFromGeoPoints(
          GeoPoint(userPosition.latitude, userPosition.longitude),
          farm.location!,
        );
      } catch (e) {
        distanceKm = null;
      }
    }

    results.add(ProductWithFarm(
      product: product,
      farm: farm,
      distanceKm: distanceKm,
    ));
  }

  // Limit results to 50 for performance
  if (results.length > 50) {
    return results.sublist(0, 50);
  }

  return results;
}

// ============================================================================
// Sorting
// ============================================================================

/// Sorts a list of ProductWithFarm by the specified option.
/// Returns a new sorted list (does not modify original).
List<ProductWithFarm> sortProductComparison(
  List<ProductWithFarm> products,
  ProductSortOption sortBy,
) {
  final sorted = List<ProductWithFarm>.from(products);

  switch (sortBy) {
    case ProductSortOption.priceLowToHigh:
      sorted.sort((a, b) => a.product.price.compareTo(b.product.price));
      break;

    case ProductSortOption.priceHighToLow:
      sorted.sort((a, b) => b.product.price.compareTo(a.product.price));
      break;

    case ProductSortOption.distance:
      sorted.sort((a, b) {
        // Nulls at the end
        if (a.distanceKm == null && b.distanceKm == null) return 0;
        if (a.distanceKm == null) return 1;
        if (b.distanceKm == null) return -1;
        return a.distanceKm!.compareTo(b.distanceKm!);
      });
      break;

    case ProductSortOption.farmName:
      sorted.sort((a, b) => a.farm.farmName
          .toLowerCase()
          .compareTo(b.farm.farmName.toLowerCase()));
      break;
  }

  return sorted;
}

/// Provider version of sortProductComparison for reactive UI.
@riverpod
List<ProductWithFarm> sortedProductComparison(
  SortedProductComparisonRef ref,
  List<ProductWithFarm> products,
  ProductSortOption sortBy,
) {
  return sortProductComparison(products, sortBy);
}

// ============================================================================
// Price Statistics by Variety
// ============================================================================

/// Calculates price statistics for a specific pineapple variety.
/// Returns PriceStats with average, min, max, and data point count.
///
/// Used for price comparison and deal detection.
@riverpod
Future<PriceStats> varietyPriceStats(
  VarietyPriceStatsRef ref,
  PineappleVariety variety,
) async {
  // Guard: only query when authenticated
  final isAuthed = ref.watch(isAuthenticatedProvider);
  if (!isAuthed) return PriceStats.empty();

  // Get all products
  final products = await ref.watch(allProductsProvider.future);

  // Filter by variety and available stock
  final varietyProducts = products.where((p) {
    // Match variety name from product name (case-insensitive contains)
    final productName = p.name.toLowerCase();
    final varietyName = variety.displayName.toLowerCase();

    // Only include available and limited stock products for price stats
    final hasValidStock = p.stockStatus == StockStatus.available ||
        p.stockStatus == StockStatus.limited;

    return productName.contains(varietyName) && hasValidStock;
  }).toList();

  // Extract prices and calculate stats
  final prices = varietyProducts.map((p) => p.price).toList();

  return PriceStats.fromPrices(prices);
}

/// Calculate price statistics for all varieties.
/// Returns a map of variety -> PriceStats.
///
/// Useful for batch price comparison calculations.
@riverpod
Future<Map<PineappleVariety, PriceStats>> allVarietiesPriceStats(
  AllVarietiesPriceStatsRef ref,
) async {
  final stats = <PineappleVariety, PriceStats>{};

  for (final variety in PineappleVariety.values) {
    stats[variety] = await ref.watch(varietyPriceStatsProvider(variety).future);
  }

  return stats;
}
