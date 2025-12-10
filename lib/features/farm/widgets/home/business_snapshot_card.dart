import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/core/widgets/section_header.dart';
import 'package:nenas_kita/features/farm/providers/dashboard_providers.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';

/// Unified business snapshot card showing products and market comparison
/// Replaces ProductsOverviewCard + MarketPriceCard with a single full-width card
/// Design: Warm agricultural aesthetic with clear data hierarchy
class BusinessSnapshotCard extends ConsumerWidget {
  const BusinessSnapshotCard({
    super.key,
    required this.farmId,
    required this.primaryVariety,
  });

  final String farmId;
  final String primaryVariety;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByFarmProvider(farmId));
    final myAveragePriceAsync = ref.watch(myAverageProductPriceProvider(farmId));
    final marketAveragePriceAsync = ref.watch(marketAveragePriceProvider(primaryVariety));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header outside card for consistency
        const SectionHeader(
          title: 'Business Snapshot',
          icon: Icons.insights,
        ),
        AppSpacing.vGapM,

        // Main card with warm gradient accent at top
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Subtle warm gradient accent bar
              Container(
                height: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.cardRadius),
                    topRight: Radius.circular(AppSpacing.cardRadius),
                  ),
                ),
              ),

              // Products Section
              _buildProductsSection(context, productsAsync),

              // Elegant divider with gradient fade
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.outline.withValues(alpha: 0.0),
                        AppColors.outline.withValues(alpha: 0.3),
                        AppColors.outline.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Market Section
              _buildMarketSection(
                context,
                myAveragePriceAsync,
                marketAveragePriceAsync,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Products section with thumbnails
  Widget _buildProductsSection(
    BuildContext context,
    AsyncValue<List<dynamic>> productsAsync,
  ) {
    return productsAsync.when(
      data: (products) {
        return Semantics(
          label: 'Products section: ${products.length} products listed',
          button: true,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              context.go(RouteNames.farmerProducts);
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.zero,
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
            ),
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Products count header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${products.length} Product${products.length != 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),

                  if (products.isNotEmpty) ...[
                    AppSpacing.vGapS,
                    // Product thumbnails row
                    _buildProductThumbnails(products),
                  ] else ...[
                    AppSpacing.vGapS,
                    Text(
                      'No products yet. Tap to add your first product.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            AppSpacing.hGapM,
            Text(
              'Loading products...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
      error: (_, __) => Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              size: 20,
              color: AppColors.error,
            ),
            AppSpacing.hGapM,
            Text(
              'Error loading products',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build product thumbnails (max 4, with +N more indicator)
  Widget _buildProductThumbnails(List<dynamic> products) {
    const maxThumbnails = 4;
    final displayProducts = products.take(maxThumbnails).toList();
    final remainingCount = products.length - maxThumbnails;

    return Row(
      children: [
        ...displayProducts.map((product) {
          final imageUrl = product.images.isNotEmpty ? product.images.first : null;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s),
            child: _buildProductThumbnail(imageUrl),
          );
        }),
        if (remainingCount > 0)
          _buildMoreIndicator(remainingCount),
      ],
    );
  }

  /// Individual product thumbnail (44x44 rounded rectangle with shadow)
  Widget _buildProductThumbnail(String? imageUrl) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _defaultProductIcon(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _defaultProductIcon();
              },
            )
          : _defaultProductIcon(),
    );
  }

  /// Default pineapple icon for products without images
  Widget _defaultProductIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryContainer,
            AppColors.primaryContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.grass, // Pineapple crown / agricultural icon
          size: 22,
          color: AppColors.primary,
        ),
      ),
    );
  }

  /// +N more indicator with warm accent
  Widget _buildMoreIndicator(int count) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryContainer,
            AppColors.primaryContainer.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }

  /// Market comparison section
  Widget _buildMarketSection(
    BuildContext context,
    AsyncValue<double> myAveragePriceAsync,
    AsyncValue<double?> marketAveragePriceAsync,
  ) {
    return myAveragePriceAsync.when(
      data: (myPrice) {
        return marketAveragePriceAsync.when(
          data: (marketPrice) {
            if (myPrice == 0.0 || marketPrice == null || marketPrice == 0.0) {
              return _buildInsufficientDataState(context);
            }

            final difference = myPrice - marketPrice;
            final percentDiff = (difference / marketPrice) * 100;
            final isAboveMarket = percentDiff > 5; // More than 5% above
            final isBelowMarket = percentDiff < -5; // More than 5% below

            return Semantics(
              label: 'Market comparison: Your price RM ${myPrice.toStringAsFixed(2)} is ${percentDiff.toStringAsFixed(0)}% ${isAboveMarket ? 'above' : isBelowMarket ? 'below' : 'at'} market rate',
              button: true,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  // Navigate to market/price details - using products for now
                  context.go(RouteNames.farmerProducts);
                },
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppSpacing.cardRadius),
                  bottomRight: Radius.circular(AppSpacing.cardRadius),
                ),
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Your Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Price',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      AppSpacing.vGapXXS,
                      Text(
                        'RM ${myPrice.toStringAsFixed(2)}/kg',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      AppSpacing.vGapM,

                      // Price difference indicator - BOLD prominent display
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        decoration: BoxDecoration(
                          color: isAboveMarket
                              ? AppColors.warningLight
                              : AppColors.successLight,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                          border: Border.all(
                            color: isAboveMarket
                                ? AppColors.warning.withValues(alpha: 0.2)
                                : AppColors.success.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Large percentage number
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Icon(
                                  isAboveMarket
                                      ? Icons.trending_up
                                      : isBelowMarket
                                          ? Icons.trending_down
                                          : Icons.trending_flat,
                                  size: 28,
                                  color: isAboveMarket
                                      ? AppColors.warning
                                      : AppColors.success,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${percentDiff > 0 ? '+' : ''}${percentDiff.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: isAboveMarket
                                            ? AppColors.warning
                                            : AppColors.success,
                                        letterSpacing: -1,
                                        height: 1,
                                      ),
                                ),
                                Text(
                                  '%',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isAboveMarket
                                            ? AppColors.warning.withValues(alpha: 0.7)
                                            : AppColors.success.withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                            AppSpacing.hGapM,
                            // Label and hint
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAboveMarket
                                        ? 'above market'
                                        : isBelowMarket
                                            ? 'below market'
                                            : 'at market rate',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: isAboveMarket
                                              ? AppColors.warning
                                              : AppColors.success,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  if (isAboveMarket) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Consider reviewing prices',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.warning.withValues(alpha: 0.8),
                                          ),
                                    ),
                                  ],
                                  if (!isAboveMarket && !isBelowMarket) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Competitively priced',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.success.withValues(alpha: 0.8),
                                          ),
                                    ),
                                  ],
                                  if (isBelowMarket) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Very competitive pricing',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.success.withValues(alpha: 0.8),
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => _buildMarketLoadingState(context, myPrice),
          error: (_, __) => _buildInsufficientDataState(context),
        );
      },
      loading: () => _buildFullLoadingState(context),
      error: (_, __) => _buildInsufficientDataState(context),
    );
  }

  /// Insufficient data state (no prices available)
  Widget _buildInsufficientDataState(BuildContext context) {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  color: AppColors.neutral300.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppColors.neutral300,
                ),
              ),
              AppSpacing.hGapM,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Comparison',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    AppSpacing.vGapXXS,
                    Text(
                      'Add products to see market insights',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Loading state while fetching market price (but we have user price)
  Widget _buildMarketLoadingState(BuildContext context, double myPrice) {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Price',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          AppSpacing.vGapXXS,
          Text(
            'RM ${myPrice.toStringAsFixed(2)}/kg',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          AppSpacing.vGapM,
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              AppSpacing.hGapS,
              Text(
                'Comparing with market...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Full loading state (both prices loading)
  Widget _buildFullLoadingState(BuildContext context) {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          AppSpacing.hGapM,
          Text(
            'Loading market data...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
