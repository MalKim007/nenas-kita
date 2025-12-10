import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_comparison_model.freezed.dart';
part 'price_comparison_model.g.dart';

/// Model for comparing a product's price against market statistics
@freezed
class PriceComparison with _$PriceComparison {
  const factory PriceComparison({
    /// Current product price (RM)
    required double currentPrice,

    /// Average market price (RM)
    required double averagePrice,

    /// Percentage difference from average
    /// Positive = above average, Negative = below average
    required double percentDiff,

    /// Whether this is considered a good deal (below average)
    required bool isGoodDeal,
  }) = _PriceComparison;

  factory PriceComparison.fromJson(Map<String, dynamic> json) =>
      _$PriceComparisonFromJson(json);

  /// Create comparison from current price and market stats
  factory PriceComparison.fromStats({
    required double currentPrice,
    required PriceStats stats,
  }) {
    if (stats.average == 0) {
      return PriceComparison(
        currentPrice: currentPrice,
        averagePrice: 0,
        percentDiff: 0,
        isGoodDeal: false,
      );
    }

    final percentDiff = ((currentPrice - stats.average) / stats.average) * 100;

    return PriceComparison(
      currentPrice: currentPrice,
      averagePrice: stats.average,
      percentDiff: percentDiff,
      isGoodDeal: currentPrice < stats.average,
    );
  }
}

/// Market price statistics for a product category/variety
@freezed
class PriceStats with _$PriceStats {
  const factory PriceStats({
    /// Average price across all data points (RM)
    required double average,

    /// Minimum price found (RM)
    required double minimum,

    /// Maximum price found (RM)
    required double maximum,

    /// Number of data points used for calculation
    required int dataPoints,
  }) = _PriceStats;

  factory PriceStats.fromJson(Map<String, dynamic> json) =>
      _$PriceStatsFromJson(json);

  /// Create empty stats (no data available)
  factory PriceStats.empty() => const PriceStats(
        average: 0,
        minimum: 0,
        maximum: 0,
        dataPoints: 0,
      );

  /// Calculate stats from a list of prices
  factory PriceStats.fromPrices(List<double> prices) {
    if (prices.isEmpty) {
      return PriceStats.empty();
    }

    final sortedPrices = List<double>.from(prices)..sort();
    final average = prices.reduce((a, b) => a + b) / prices.length;

    return PriceStats(
      average: average,
      minimum: sortedPrices.first,
      maximum: sortedPrices.last,
      dataPoints: prices.length,
    );
  }
}

/// Extensions for PriceComparison
extension PriceComparisonExtension on PriceComparison {
  /// Get formatted current price
  String get formattedCurrentPrice => 'RM ${currentPrice.toStringAsFixed(2)}';

  /// Get formatted average price
  String get formattedAveragePrice => 'RM ${averagePrice.toStringAsFixed(2)}';

  /// Get formatted percentage difference with context
  /// Examples: "5% below avg", "3% above avg", "At average"
  String get formattedPercentDiff {
    if (percentDiff.abs() < 0.5) {
      return 'At average';
    }

    final absPercent = percentDiff.abs().toStringAsFixed(1);

    if (percentDiff < 0) {
      return '$absPercent% below avg';
    } else {
      return '$absPercent% above avg';
    }
  }

  /// Get comparison label for UI
  /// Examples: "Good Deal", "Above Average", "Fair Price"
  String get comparisonLabel {
    if (percentDiff.abs() < 0.5) {
      return 'Fair Price';
    }

    if (isGoodDeal) {
      if (percentDiff < -10) {
        return 'Great Deal';
      }
      return 'Good Deal';
    } else {
      if (percentDiff > 10) {
        return 'Premium Price';
      }
      return 'Above Average';
    }
  }

  /// Get price difference amount (negative = cheaper than average)
  double get priceDifference => currentPrice - averagePrice;

  /// Get formatted price difference
  /// Examples: "RM 2.50 cheaper", "RM 1.20 more expensive"
  String get formattedPriceDifference {
    final diff = priceDifference.abs();
    final formatted = 'RM ${diff.toStringAsFixed(2)}';

    if (priceDifference.abs() < 0.01) {
      return 'Same as average';
    }

    if (priceDifference < 0) {
      return '$formatted cheaper';
    } else {
      return '$formatted more expensive';
    }
  }

  /// Check if price is significantly below average (>10% cheaper)
  bool get isSignificantDeal => percentDiff < -10;

  /// Check if price is significantly above average (>10% more expensive)
  bool get isSignificantlyExpensive => percentDiff > 10;
}

/// Extensions for PriceStats
extension PriceStatsExtension on PriceStats {
  /// Get formatted average price
  String get formattedAverage => 'RM ${average.toStringAsFixed(2)}';

  /// Get formatted minimum price
  String get formattedMinimum => 'RM ${minimum.toStringAsFixed(2)}';

  /// Get formatted maximum price
  String get formattedMaximum => 'RM ${maximum.toStringAsFixed(2)}';

  /// Get price range as formatted string
  /// Example: "RM 5.00 - RM 8.50"
  String get formattedRange => '$formattedMinimum - $formattedMaximum';

  /// Check if stats have valid data
  bool get hasData => dataPoints > 0;

  /// Check if stats have enough data for reliable comparison
  /// At least 3 data points recommended
  bool get hasReliableData => dataPoints >= 3;

  /// Get data reliability label
  String get reliabilityLabel {
    if (dataPoints == 0) return 'No data';
    if (dataPoints == 1) return 'Limited data (1 listing)';
    if (dataPoints == 2) return 'Limited data (2 listings)';
    if (dataPoints < 5) return 'Some data ($dataPoints listings)';
    if (dataPoints < 10) return 'Good data ($dataPoints listings)';
    return 'Reliable data ($dataPoints listings)';
  }

  /// Get price spread (difference between max and min)
  double get priceSpread => maximum - minimum;

  /// Get formatted price spread
  String get formattedSpread => 'RM ${priceSpread.toStringAsFixed(2)}';

  /// Calculate coefficient of variation (relative variability)
  /// Higher value = more price variation
  double get coefficientOfVariation {
    if (average == 0) return 0;
    return (priceSpread / 2) / average; // Simplified CV using range/2 as approximation
  }

  /// Check if prices are relatively stable (low variation)
  bool get isPriceStable => hasReliableData && coefficientOfVariation < 0.2;

  /// Check if prices are highly variable
  bool get isPriceVolatile => hasReliableData && coefficientOfVariation > 0.5;
}
