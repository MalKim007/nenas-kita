import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/market/models/price_history_model.dart';

/// Beautiful, production-grade price history line chart
/// Uses fl_chart with amber pineapple-inspired theme
/// Follows NenasKita design system with distinctive styling
class PriceHistoryChart extends StatelessWidget {
  const PriceHistoryChart({
    super.key,
    required this.priceHistory,
    this.selectedDays = 30,
    this.height = 180,
    this.showGrid = true,
    this.showDots = true,
    this.showArea = true,
  });

  /// List of price history records (should be sorted by date ascending)
  final List<PriceHistoryModel> priceHistory;

  /// Selected time range in days (7, 30, or 90)
  final int selectedDays;

  /// Chart height
  final double height;

  /// Whether to show grid lines
  final bool showGrid;

  /// Whether to show dots on data points
  final bool showDots;

  /// Whether to show area fill below line
  final bool showArea;

  @override
  Widget build(BuildContext context) {
    // Handle empty state
    if (priceHistory.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.show_chart,
                size: 48,
                color: AppColors.textDisabled.withValues(alpha: 0.5),
              ),
              AppSpacing.vGapS,
              Text(
                'No price history yet',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sort by date ascending for proper line display
    final sortedHistory = List<PriceHistoryModel>.from(priceHistory)
      ..sort((a, b) => a.changedAt.compareTo(b.changedAt));

    // Calculate min/max for Y-axis auto-scale
    final prices = sortedHistory.map((h) => h.newPrice).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    // Add padding to Y-axis range (10% above and below)
    final priceRange = maxPrice - minPrice;
    final padding = priceRange > 0 ? priceRange * 0.15 : minPrice * 0.1;
    final yMin = (minPrice - padding).clamp(0.0, double.infinity);
    final yMax = maxPrice + padding;

    // Create spots for line chart
    final spots = <FlSpot>[];
    for (var i = 0; i < sortedHistory.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedHistory[i].newPrice));
    }

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.s, top: AppSpacing.s),
        child: LineChart(
          LineChartData(
            minY: yMin,
            maxY: yMax,
            minX: 0,
            maxX: (sortedHistory.length - 1).toDouble().clamp(0, double.infinity),
            gridData: _buildGridData(),
            titlesData: _buildTitlesData(sortedHistory, yMin, yMax),
            borderData: FlBorderData(show: false),
            lineBarsData: [_buildLineBarData(spots)],
            lineTouchData: _buildTouchData(sortedHistory),
          ),
          duration: AppSpacing.animationNormal,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  /// Build grid configuration
  FlGridData _buildGridData() {
    if (!showGrid) return const FlGridData(show: false);

    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: null, // Auto-calculate
      getDrawingHorizontalLine: (value) => FlLine(
        color: AppColors.neutral200.withValues(alpha: 0.5),
        strokeWidth: 1,
        dashArray: [4, 4], // Dashed for subtle look
      ),
    );
  }

  /// Build axis titles configuration
  FlTitlesData _buildTitlesData(
    List<PriceHistoryModel> history,
    double yMin,
    double yMax,
  ) {
    final dateFormat = DateFormat('d MMM');

    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          interval: _calculateXInterval(history.length),
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= history.length) {
              return const SizedBox.shrink();
            }

            // Show first, middle, and last dates
            final shouldShow = index == 0 ||
                index == history.length - 1 ||
                (history.length > 2 && index == history.length ~/ 2);

            if (!shouldShow) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                dateFormat.format(history[index].changedAt),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 48,
          interval: _calculateYInterval(yMin, yMax),
          getTitlesWidget: (value, meta) {
            // Skip first and last to avoid overlap
            if (value == meta.min || value == meta.max) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                'RM ${value.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build main line bar configuration
  LineChartBarData _buildLineBarData(List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.25,
      preventCurveOverShooting: true,
      color: AppColors.primary,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: showDots,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: AppColors.primary,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: showArea,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.primary.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  /// Build touch interaction configuration
  LineTouchData _buildTouchData(List<PriceHistoryModel> history) {
    final dateFormat = DateFormat('d MMM yyyy');

    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => const Color(0xFF78350F),
        tooltipPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        tooltipMargin: 12,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final index = spot.x.toInt();
            if (index < 0 || index >= history.length) {
              return null;
            }

            final record = history[index];
            return LineTooltipItem(
              'RM ${record.newPrice.toStringAsFixed(2)}\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: dateFormat.format(record.changedAt),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: AppColors.primary.withValues(alpha: 0.5),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, idx) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: AppColors.primary,
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                );
              },
            ),
          );
        }).toList();
      },
    );
  }

  /// Calculate appropriate X-axis interval based on data points
  double _calculateXInterval(int dataPoints) {
    if (dataPoints <= 3) return 1;
    if (dataPoints <= 7) return 2;
    if (dataPoints <= 14) return 3;
    return (dataPoints / 4).roundToDouble();
  }

  /// Calculate appropriate Y-axis interval based on price range
  double _calculateYInterval(double min, double max) {
    final range = max - min;
    if (range <= 1) return 0.2;
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    return (range / 4).roundToDouble();
  }
}

/// Time range selector chips for price history chart
class PriceChartTimeRangeSelector extends StatelessWidget {
  const PriceChartTimeRangeSelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  final int selectedDays;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildChip(7, '7 days'),
        AppSpacing.hGapS,
        _buildChip(30, '30 days'),
        AppSpacing.hGapS,
        _buildChip(90, '90 days'),
      ],
    );
  }

  Widget _buildChip(int days, String label) {
    final isSelected = selectedDays == days;

    return GestureDetector(
      onTap: () => onChanged(days),
      child: AnimatedContainer(
        duration: AppSpacing.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.neutral100,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.neutral200,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Skeleton loading placeholder for price chart
class PriceHistoryChartSkeleton extends StatelessWidget {
  const PriceHistoryChartSkeleton({
    super.key,
    this.height = 180,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            AppSpacing.vGapS,
            Text(
              'Loading chart...',
              style: TextStyle(
                color: AppColors.textDisabled,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
