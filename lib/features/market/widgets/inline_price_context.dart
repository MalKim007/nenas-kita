import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/features/market/models/price_comparison_model.dart';

/// Compact inline price context showing average price and difference.
///
/// Displays two chips side-by-side:
/// - Left: Average price with neutral icon
/// - Right: Percentage difference with trending icon (colored based on deal level)
///
/// Optimized for space efficiency in product cards.
class InlinePriceContext extends StatelessWidget {
  const InlinePriceContext({
    super.key,
    required this.comparison,
    required this.dealLevel,
  });

  /// Price comparison data
  final PriceComparison comparison;

  /// Deal level for color coding
  final DealLevel dealLevel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Average price chip (neutral gray)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neutral200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.trending_flat,
                size: 12,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 3),
              Text(
                'Avg ${comparison.formattedAveragePrice}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 6),

        // Percentage difference chip (colored based on deal level)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: dealLevel.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: dealLevel.color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                dealLevel.icon,
                size: 12,
                color: dealLevel.color,
              ),
              const SizedBox(width: 3),
              Text(
                comparison.formattedPercentDiff,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: dealLevel.color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
