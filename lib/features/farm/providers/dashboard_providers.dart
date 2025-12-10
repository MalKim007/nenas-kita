import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/market/providers/price_history_providers.dart';

part 'dashboard_providers.g.dart';

// ============ DASHBOARD PROVIDERS ============

/// Get the latest (most recent) harvest plan for current user
/// Returns null if user has no harvest plans
@riverpod
Future<HarvestPlanModel?> latestHarvestPlan(LatestHarvestPlanRef ref) async {
  final plans = await ref.watch(myHarvestPlansProvider.future);

  if (plans.isEmpty) return null;

  // Sort by createdAt descending (most recent first)
  final sortedPlans = List<HarvestPlanModel>.from(plans)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return sortedPlans.first;
}

/// Calculate average price across all products for a specific farm
/// Returns 0.0 if farm has no products
@riverpod
Future<double> myAverageProductPrice(
  MyAverageProductPriceRef ref,
  String farmId,
) async {
  final products = await ref.watch(productsByFarmProvider(farmId).future);

  if (products.isEmpty) return 0.0;

  // Calculate sum of all product prices
  final totalPrice = products.fold<double>(
    0.0,
    (sum, product) => sum + product.price,
  );

  // Return average
  return totalPrice / products.length;
}

/// Get market average price for a specific variety
/// Returns null if no price data available for the variety
/// Uses 30-day window by default
@riverpod
Future<double?> marketAveragePrice(
  MarketAveragePriceRef ref,
  String variety,
) async {
  return ref.watch(averagePriceByVarietyProvider(variety, days: 30).future);
}
