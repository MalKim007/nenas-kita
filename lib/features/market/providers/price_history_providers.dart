import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/features/market/models/price_history_model.dart';
import 'package:nenas_kita/features/market/models/price_comparison_model.dart';
import 'package:nenas_kita/features/market/repositories/price_history_repository.dart';

part 'price_history_providers.g.dart';

// ============ REPOSITORY ============

/// Price history repository provider
@Riverpod(keepAlive: true)
PriceHistoryRepository priceHistoryRepository(PriceHistoryRepositoryRef ref) {
  return PriceHistoryRepository();
}

// ============ RECENT HISTORY ============

/// Recent price history (all products)
@riverpod
Stream<List<PriceHistoryModel>> recentPriceHistory(
  RecentPriceHistoryRef ref, {
  int limit = 50,
}) {
  return ref.watch(priceHistoryRepositoryProvider).watchRecent(limit: limit);
}

// ============ HISTORY BY PRODUCT ============

/// Price history for a specific product
@riverpod
Stream<List<PriceHistoryModel>> priceHistoryByProduct(
  PriceHistoryByProductRef ref,
  String farmId,
  String productId, {
  int limit = 50,
}) {
  return ref.watch(priceHistoryRepositoryProvider).watchByProduct(
    farmId,
    productId,
    limit: limit,
  );
}

// ============ HISTORY BY VARIETY ============

/// Price history by variety
@riverpod
Stream<List<PriceHistoryModel>> priceHistoryByVariety(
  PriceHistoryByVarietyRef ref,
  String variety, {
  int limit = 100,
}) {
  return ref.watch(priceHistoryRepositoryProvider).watchByVariety(
    variety,
    limit: limit,
  );
}

// ============ ANALYTICS ============

/// Average price for a variety
@riverpod
Future<double?> averagePriceByVariety(
  AveragePriceByVarietyRef ref,
  String variety, {
  int days = 30,
}) async {
  return ref.watch(priceHistoryRepositoryProvider).getAveragePrice(
    variety,
    days: days,
  );
}

/// Price range (min/max/avg) for a variety
@riverpod
Future<Map<String, double>?> priceRangeByVariety(
  PriceRangeByVarietyRef ref,
  String variety, {
  int days = 30,
}) async {
  return ref.watch(priceHistoryRepositoryProvider).getPriceRange(
    variety,
    days: days,
  );
}

/// Price trend for a variety (percentage change)
@riverpod
Future<double?> priceTrendByVariety(
  PriceTrendByVarietyRef ref,
  String variety, {
  int days = 7,
}) async {
  return ref.watch(priceHistoryRepositoryProvider).getPriceTrend(
    variety,
    days: days,
  );
}

/// Daily average prices for charts
@riverpod
Future<List<Map<String, dynamic>>> dailyPriceAverages(
  DailyPriceAveragesRef ref,
  String variety, {
  int days = 30,
}) async {
  return ref.watch(priceHistoryRepositoryProvider).getDailyAverages(
    variety,
    days: days,
  );
}

// ============ STATS ============

/// Total price updates count
@riverpod
Future<int> totalPriceUpdatesCount(TotalPriceUpdatesCountRef ref) async {
  return ref.watch(priceHistoryRepositoryProvider).getTotalCount();
}

/// Price updates count for last N days
@riverpod
Future<int> priceUpdatesCountForDays(
  PriceUpdatesCountForDaysRef ref,
  int days,
) async {
  return ref.watch(priceHistoryRepositoryProvider).getCountForDays(days);
}

// ============ PRODUCT-SPECIFIC ANALYTICS (B7) ============

/// Price history for a specific product filtered by days
/// Used for price history chart with time range toggle (7/30/90 days)
@riverpod
Stream<List<PriceHistoryModel>> productPriceHistoryForDays(
  ProductPriceHistoryForDaysRef ref,
  String farmId,
  String productId,
  int days,
) {
  final cutoffDate = DateTime.now().subtract(Duration(days: days));

  return ref
      .watch(priceHistoryRepositoryProvider)
      .watchByProduct(farmId, productId, limit: 100)
      .map((history) => history
          .where((h) => h.changedAt.isAfter(cutoffDate))
          .toList());
}

/// Price history with fallback to variety-level data when product history is empty.
/// Helps display a trend even if priceHistory docs were not stored per product.
final productPriceHistoryWithFallbackProvider =
    StreamProvider.autoDispose
        .family<List<PriceHistoryModel>, ({String farmId, String productId, String? variety, int days})>(
  (ref, args) {
    final repo = ref.watch(priceHistoryRepositoryProvider);
    final cutoffDate = DateTime.now().subtract(Duration(days: args.days));

    List<PriceHistoryModel> filterByDate(List<PriceHistoryModel> input) {
      return input
          .where((h) =>
              h.changedAt.isAfter(cutoffDate) ||
              h.changedAt.isAtSameMomentAs(cutoffDate))
          .toList();
    }

    final productStream =
        repo.watchByProduct(args.farmId, args.productId, limit: 100);

    return productStream.asyncExpand((productHistory) async* {
      final filteredProduct = filterByDate(productHistory);
      if (filteredProduct.isNotEmpty) {
        yield filteredProduct;
        return;
      }

      if (args.variety != null && args.variety!.isNotEmpty) {
        final varietyStream =
            repo.watchByVariety(args.variety!, limit: 100).map(filterByDate);
        yield* varietyStream;
        return;
      }

      yield const <PriceHistoryModel>[];
    });
  },
);

/// Calculate historical average price for a specific product
/// Returns null if no history available
@riverpod
Future<double?> productHistoricalAverage(
  ProductHistoricalAverageRef ref,
  String farmId,
  String productId, {
  int days = 30,
}) async {
  final history = await ref
      .watch(priceHistoryRepositoryProvider)
      .getByProduct(farmId, productId, limit: 100);

  if (history.isEmpty) return null;

  final cutoffDate = DateTime.now().subtract(Duration(days: days));
  final relevantHistory = history
      .where((h) => h.changedAt.isAfter(cutoffDate))
      .toList();

  if (relevantHistory.isEmpty) return null;

  final sum = relevantHistory.fold<double>(0, (acc, h) => acc + h.newPrice);
  return sum / relevantHistory.length;
}

/// Get price statistics (min, max, avg) for a specific product
@riverpod
Future<PriceStats> productPriceStats(
  ProductPriceStatsRef ref,
  String farmId,
  String productId,
  int days,
) async {
  final history = await ref
      .watch(priceHistoryRepositoryProvider)
      .getByProduct(farmId, productId, limit: 100);

  if (history.isEmpty) return PriceStats.empty();

  final cutoffDate = DateTime.now().subtract(Duration(days: days));
  final relevantHistory = history
      .where((h) => h.changedAt.isAfter(cutoffDate))
      .toList();

  if (relevantHistory.isEmpty) return PriceStats.empty();

  final prices = relevantHistory.map((h) => h.newPrice).toList();
  return PriceStats.fromPrices(prices);
}

/// Compare current price against historical average
/// Returns comparison with "X% below/above avg" data
@riverpod
Future<PriceComparison?> productPriceComparison(
  ProductPriceComparisonRef ref,
  String farmId,
  String productId,
  double currentPrice,
) async {
  final stats = await ref.watch(
    productPriceStatsProvider(farmId, productId, 30).future,
  );

  if (!stats.hasData) return null;

  return PriceComparison.fromStats(
    currentPrice: currentPrice,
    stats: stats,
  );
}
