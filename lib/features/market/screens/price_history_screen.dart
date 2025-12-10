import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_empty_state.dart';
import 'package:nenas_kita/features/market/models/price_comparison_model.dart';
import 'package:nenas_kita/features/market/models/price_history_model.dart';
import 'package:nenas_kita/features/market/providers/price_history_providers.dart';
import 'package:nenas_kita/features/market/widgets/price_history_chart.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';

/// Price History Screen (B7.3)
///
/// Displays comprehensive price analytics for a product:
/// - Current price and comparison with market average
/// - Interactive price trend chart
/// - Statistical summary (avg, min, max)
/// - Recent price change history
class PriceHistoryScreen extends ConsumerStatefulWidget {
  const PriceHistoryScreen({
    super.key,
    required this.farmId,
    required this.productId,
    required this.product,
  });

  final String farmId;
  final String productId;
  final ProductModel product;

  @override
  ConsumerState<PriceHistoryScreen> createState() => _PriceHistoryScreenState();
}

class _PriceHistoryScreenState extends ConsumerState<PriceHistoryScreen> {
  int _selectedDays = 30;
  bool _showAllChanges = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Price History'),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Product Info Header (INSTANT)
            _buildProductInfoHeader(textTheme),

            const SizedBox(height: AppSpacing.l),

            // 2. Time Range Selector
            _buildTimeRangeSelector(),

            const SizedBox(height: AppSpacing.l),

            // 4. Price Chart Section (ASYNC)
            _buildPriceChartSection(),

            const SizedBox(height: AppSpacing.l),

            // 5. Stats Row (ASYNC) - RESPONSIVE
            _buildStatsSection(),

            const SizedBox(height: AppSpacing.l),

            // 6. Recent Changes List (ASYNC) - EXPANDABLE
            _buildRecentChangesList(),
          ],
        ),
      ),
    );
  }

  /// 1. Product Info Header - Instant display from product prop
  Widget _buildProductInfoHeader(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name
        Text(
          widget.product.name,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Current price
        Row(
          children: [
            Text(
              'RM ${widget.product.price.toStringAsFixed(2)}',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.product.priceUnit,
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2. Time Range Selector
  Widget _buildTimeRangeSelector() {
    return PriceChartTimeRangeSelector(
      selectedDays: _selectedDays,
      onRangeChanged: (days) {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedDays = days;
        });
      },
    );
  }

  /// 4. Price Chart Section - Async chart display
  Widget _buildPriceChartSection() {
    final historyAsync = ref.watch(
      productPriceHistoryWithFallbackProvider(
        (
          farmId: widget.farmId,
          productId: widget.productId,
          variety: widget.product.variety,
          days: _selectedDays,
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Trend',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: historyAsync.when(
              loading: () => const PriceHistoryChartSkeleton(),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load chart',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              data: (history) {
                if (history.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.show_chart,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No price data for selected period',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return PriceHistoryChart(
                  priceHistory: history,
                  selectedDays: _selectedDays,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Stats Section - Responsive layout with price statistics
  Widget _buildStatsSection() {
    final statsAsync = ref.watch(
      productPriceStatsProvider(
        widget.farmId,
        widget.productId,
        _selectedDays,
      ),
    );

    return statsAsync.when(
      loading: () => _buildStatsShimmer(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (stats) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final useRow = constraints.maxWidth > 360;

            final statCards = [
              _buildStatCard(
                icon: Icons.analytics,
                label: 'Average',
                value: stats.hasData ? stats.average : null,
                color: AppColors.primary,
              ),
              _buildStatCard(
                icon: Icons.arrow_downward,
                label: 'Minimum',
                value: stats.hasData ? stats.minimum : null,
                color: AppColors.success,
              ),
              _buildStatCard(
                icon: Icons.arrow_upward,
                label: 'Maximum',
                value: stats.hasData ? stats.maximum : null,
                color: AppColors.error,
              ),
            ];

            if (useRow) {
              return Row(
                children: statCards
                    .map((card) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: card,
                          ),
                        ))
                    .toList(),
              );
            } else {
              return Column(
                children: statCards
                    .map((card) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: card,
                        ))
                    .toList(),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required double? value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value != null ? 'RM ${value.toStringAsFixed(2)}' : '--',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsShimmer() {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 6. Recent Changes List - Expandable list of price updates
  Widget _buildRecentChangesList() {
    final recentAsync = ref.watch(
      priceHistoryByProductProvider(
        widget.farmId,
        widget.productId,
        limit: 10,
      ),
    );

    return recentAsync.when(
      loading: () => _buildRecentChangesShimmer(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (changes) {
        if (changes.isEmpty) {
          return AppEmptyState(
            icon: Icons.history,
            title: 'No price changes recorded',
            message: 'Price updates will appear here',
          );
        }

        final displayedChanges = _showAllChanges
            ? changes
            : changes.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Changes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  ...displayedChanges.asMap().entries.map((entry) {
                    final index = entry.key;
                    final change = entry.value;
                    final isLast = index == displayedChanges.length - 1;

                    return _buildPriceChangeRow(
                      change: change,
                      isLast: isLast,
                    );
                  }),

                  // Show more button
                  if (changes.length > 5 && !_showAllChanges)
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _showAllChanges = true;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Show ${changes.length - 5} more',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceChangeRow({
    required PriceHistoryModel change,
    required bool isLast,
  }) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    final newPrice = change.newPrice;
    final oldPrice = change.oldPrice;
    final isBaseline = oldPrice <= 0 || oldPrice == newPrice;
    final percentChange = oldPrice > 0
        ? ((newPrice - oldPrice) / oldPrice * 100)
        : 0.0;
    final isIncrease = percentChange > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
      ),
      child: Row(
        children: [
          // Date and time
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(change.changedAt),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeFormat.format(change.changedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // New price
          Expanded(
            flex: 2,
            child: Text(
              'RM ${newPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Change badge
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isBaseline
                    ? Colors.transparent
                    : isIncrease
                        ? AppColors.error.withValues(alpha: 0.1)
                        : AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isBaseline)
                    const SizedBox.shrink()
                  else ...[
                    Icon(
                      isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: isIncrease ? AppColors.error : AppColors.success,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${percentChange.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isIncrease ? AppColors.error : AppColors.success,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentChangesShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          ),
        ),
      ],
    );
  }
}

/// Time Range Selector Widget
///
/// Allows users to switch between different time periods for price analysis
class PriceChartTimeRangeSelector extends StatelessWidget {
  const PriceChartTimeRangeSelector({
    super.key,
    required this.selectedDays,
    required this.onRangeChanged,
  });

  final int selectedDays;
  final ValueChanged<int> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final options = [
      (days: 7, label: '7D'),
      (days: 14, label: '14D'),
      (days: 30, label: '30D'),
      (days: 90, label: '90D'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final isSelected = selectedDays == option.days;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: isSelected ? AppColors.primary : Colors.grey[100],
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              child: InkWell(
                onTap: () => onRangeChanged(option.days),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Center(
                    child: Text(
                      option.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
