import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/features/market/models/product_with_farm.dart';
import 'package:nenas_kita/features/market/models/price_comparison_model.dart';
import 'package:nenas_kita/features/market/widgets/deal_badge.dart';
import 'package:nenas_kita/features/market/widgets/deal_ribbon.dart';
import 'package:nenas_kita/features/market/widgets/inline_price_context.dart';
import 'package:nenas_kita/features/market/providers/product_comparison_providers.dart';

/// A distinctive product comparison card widget for NenasKita.
///
/// Displays product information alongside its associated farm data in a
/// horizontal layout optimized for outdoor visibility. Shows product image,
/// name, farm details, location, pricing (retail and optional wholesale),
/// and stock status badges with high contrast.
///
/// Designed for farmers/buyers in Melaka who may use the app outdoors in
/// bright sunlight, with amber/gold primary (pineapple-inspired) and green
/// secondary (agricultural) colors.
class ProductComparisonCard extends ConsumerWidget {
  const ProductComparisonCard({
    super.key,
    required this.productWithFarm,
    this.onTap,
    this.showWholesalePrice = false,
    this.ribbon,
    this.showPriceComparison = true,
  });

  /// The product with associated farm data to display
  final ProductWithFarm productWithFarm;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Whether to show wholesale pricing (controlled by parent based on user role)
  final bool showWholesalePrice;

  /// Optional ribbon to show (for top 3 results)
  final DealRibbonType? ribbon;

  /// Whether to show price comparison stats
  final bool showPriceComparison;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final displayImage = productWithFarm.displayImage;
    final isVerified = productWithFarm.isVerified;
    final stockStatus = productWithFarm.product.stockStatus;

    // Detect variety from product name
    final variety = _detectVariety(productWithFarm.productName);

    // Get price stats and calculate comparison
    final priceStatsAsync = variety != null && showPriceComparison
        ? ref.watch(varietyPriceStatsProvider(variety))
        : null;

    PriceComparison? comparison;
    DealLevel? dealLevel;

    priceStatsAsync?.whenData((stats) {
      if (stats.hasReliableData) {
        comparison = PriceComparison.fromStats(
          currentPrice: productWithFarm.product.price,
          stats: stats,
        );
        dealLevel = DealLevel.fromPercentDiff(comparison!.percentDiff);
      }
    });

    // Determine if this is an excellent deal for haptic feedback
    final isExcellentDeal = dealLevel == DealLevel.excellent;

    return AppCard(
      onTap: () {
        // Haptic feedback for excellent deals
        if (isExcellentDeal) {
          HapticFeedback.heavyImpact();
        }
        onTap?.call();
      },
      padding: EdgeInsets.zero,
      // Add green border for excellent deals
      showBorder: true,
      border: isExcellentDeal
          ? Border.all(
              color: AppColors.success,
              width: 2,
            )
          : null,
      elevation: isExcellentDeal ? 8 : null,
      child: Container(
        decoration: isExcellentDeal
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              )
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Stack(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                // Product/Farm Image with Badges
                SizedBox(
                  width: 100,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppSpacing.radiusM),
                            bottomLeft: Radius.circular(AppSpacing.radiusM),
                          ),
                          child: displayImage != null && displayImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: displayImage,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                        ),
                      ),

                      // Verified Badge (if farm is LPNM verified)
                      if (isVerified)
                        const Positioned(
                          top: 4,
                          left: 4,
                          child: _VerifiedBadge(),
                        ),

                      // Deal Badge (top-right, overlapping edge)
                      if (dealLevel != null)
                        Positioned(
                          top: -8,
                          right: -8,
                          child: DealBadge(
                            dealLevel: dealLevel!,
                            percentDiff: comparison!.percentDiff,
                          ),
                        ),
                    ],
                  ),
                ),

                // Product Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product Name
                        Text(
                          productWithFarm.productName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2),

                        // Farm Name
                        Text(
                          productWithFarm.farmName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // District and Distance
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              productWithFarm.district,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (productWithFarm.formattedDistance != null) ...[
                              const SizedBox(width: 8),
                              const Text(
                                '•',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.straighten,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                productWithFarm.formattedDistance!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Retail Price (prominent)
                        Text(
                          productWithFarm.formattedPrice,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),

                        // Price Context (if available)
                        if (comparison != null && dealLevel != null) ...[
                          const SizedBox(height: 4),
                          InlinePriceContext(
                            comparison: comparison!,
                            dealLevel: dealLevel!,
                          ),
                        ],

                        // Wholesale Price (conditional)
                        if (showWholesalePrice &&
                            productWithFarm.hasWholesalePrice) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Wholesale: ${productWithFarm.formattedWholesalePrice}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 8),

                        // Stock Status Badge
                        _StockStatusBadge(status: stockStatus),
                      ],
                    ),
                  ),
                ),
                  ],
                ),
              ),

              // Ribbon (if provided, for top 3)
              if (ribbon != null) DealRibbon(type: ribbon!),
            ],
          ),
        ),
      ),
    );
  }

  /// Detect pineapple variety from product name
  PineappleVariety? _detectVariety(String productName) {
    final nameLower = productName.toLowerCase();

    for (final variety in PineappleVariety.values) {
      if (nameLower.contains(variety.displayName.toLowerCase())) {
        return variety;
      }
    }

    return null;
  }

  /// Build placeholder when image is unavailable
  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.agriculture,
          size: 32,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

/// Verified badge displayed on top-right corner of product image
class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Icon(
        Icons.verified,
        size: 14,
        color: AppColors.secondary,
      ),
    );
  }
}

/// Stock status badge with icon and colored text
///
/// High contrast design for outdoor visibility. Always combines
/// icon + color + text for accessibility.
class _StockStatusBadge extends StatelessWidget {
  const _StockStatusBadge({
    required this.status,
  });

  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine badge properties based on stock status
    final IconData icon;
    final Color color;
    final String label;

    switch (status) {
      case StockStatus.available:
        icon = Icons.check_circle;
        color = AppColors.success;
        label = 'Available';
        break;
      case StockStatus.limited:
        icon = Icons.warning;
        color = AppColors.warning;
        label = 'Limited Stock';
        break;
      case StockStatus.out:
        icon = Icons.cancel;
        color = AppColors.error;
        label = 'Out of Stock';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
