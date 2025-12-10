import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/pineapple_placeholder.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/widgets/verification_badge.dart';
import 'package:nenas_kita/features/market/providers/farm_discovery_providers.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';

/// Buyer home/discover screen with featured farms and quick filters
class BuyerDiscoverScreen extends ConsumerStatefulWidget {
  const BuyerDiscoverScreen({super.key});

  @override
  ConsumerState<BuyerDiscoverScreen> createState() =>
      _BuyerDiscoverScreenState();
}

class _BuyerDiscoverScreenState extends ConsumerState<BuyerDiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentAppUserProvider);
    final nearbyFarmsAsync = ref.watch(nearbyFarmsProvider);
    final randomProductsAsync = ref.watch(randomProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Discover Businesses'),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentAppUserProvider);
          ref.invalidate(nearbyFarmsProvider);
          ref.invalidate(randomProductsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero header with greeting
              _HeroHeader(userName: userAsync.valueOrNull?.name),

              AppSpacing.vGapS,

              // Search + filters row
              _SearchAndFilterRow(
                onSearchTap: () {
                  HapticFeedback.lightImpact();
                  context.push(RouteNames.buyerFarmDiscovery);
                },
                onFilterTap: () {
                  HapticFeedback.lightImpact();
                  context.push(RouteNames.buyerFarmDiscovery);
                },
              ),

              AppSpacing.vGapL,

              // Map preview card (moved up to "Browse nearby" position)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: _MapPreviewCard(
                  onOpenMap: () {
                    HapticFeedback.lightImpact();
                    context.push('${RouteNames.buyerFarmDiscovery}?view=map');
                  },
                ),
              ),

              AppSpacing.vGapL,

              // Nearby Farms Section (max 2 farms)
              _NearbyFarmsSection(
                farmsAsync: nearbyFarmsAsync,
                onFarmTap: (farmId) {
                  HapticFeedback.lightImpact();
                  context.push(RouteNames.buyerFarmDetailPath(farmId));
                },
                onFindMoreTap: () {
                  HapticFeedback.lightImpact();
                  context.push(RouteNames.buyerFarmDiscovery);
                },
              ),

              AppSpacing.vGapL,

              // Products Section (4 random products, horizontal scroll)
              _ProductsSection(
                productsAsync: randomProductsAsync,
                onProductTap: (farmId, productId) {
                  HapticFeedback.lightImpact();
                  context.push(
                    RouteNames.buyerProductDetailPath(
                      productId,
                      farmId: farmId,
                    ),
                  );
                },
                onFindMoreTap: () {
                  HapticFeedback.lightImpact();
                  context.push(RouteNames.buyerFarmDiscovery);
                },
              ),

              AppSpacing.vGapXL,
            ],
          ),
        ),
      ),
    );
  }
}

/// Header with greeting and tagline
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        AppSpacing.m,
        AppSpacing.m,
        AppSpacing.s,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${userName ?? 'Buyer'}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find nearby businesses',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Search + Filter row
class _SearchAndFilterRow extends StatelessWidget {
  const _SearchAndFilterRow({this.onSearchTap, this.onFilterTap});

  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search...',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          SizedBox(
            height: 52,
            width: 52,
            child: OutlinedButton(
              onPressed: onFilterTap,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                ),
              ),
              child: const Icon(Icons.tune, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nearby Farms Section - shows max 2 farms with "Find more" link
class _NearbyFarmsSection extends StatelessWidget {
  const _NearbyFarmsSection({
    required this.farmsAsync,
    required this.onFarmTap,
    required this.onFindMoreTap,
  });

  final AsyncValue<List<FarmWithDistance>> farmsAsync;
  final void Function(String farmId) onFarmTap;
  final VoidCallback onFindMoreTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Businesses',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              TextButton.icon(
                onPressed: onFindMoreTap,
                icon: const Text('Find more'),
                label: const Icon(Icons.arrow_forward, size: 16),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
        ),
        AppSpacing.vGapS,
        // Farm cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: farmsAsync.when(
            data: (farms) {
              if (farms.isEmpty) {
                return _buildEmptyState(context);
              }
              return Column(
                children: farms.map((farmWithDistance) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s),
                    child: _NearbyFarmCard(
                      farm: farmWithDistance.farm,
                      distanceKm: farmWithDistance.distanceKm,
                      onTap: () => onFarmTap(farmWithDistance.farm.id),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => Column(
              children: List.generate(
                2,
                (_) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.s),
                  child: _FarmCardShimmer(),
                ),
              ),
            ),
            error: (_, __) => _buildEmptyState(context),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.agriculture_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
          AppSpacing.vGapS,
          Text(
            'No businesses found nearby',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Individual farm card for nearby farms section
class _NearbyFarmCard extends StatelessWidget {
  const _NearbyFarmCard({
    required this.farm,
    this.distanceKm,
    required this.onTap,
  });

  final FarmModel farm;
  final double? distanceKm;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final heroImage = farm.socialLinks['heroImage'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Farm image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusM),
                bottomLeft: Radius.circular(AppSpacing.radiusM),
              ),
              child: SizedBox(
                width: 88,
                height: 88,
                child: heroImage != null && heroImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: heroImage,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            const PineapplePlaceholder(size: 88),
                        errorWidget: (_, __, ___) =>
                            const PineapplePlaceholder(size: 88),
                      )
                    : const PineapplePlaceholder(size: 88),
              ),
            ),
            // Farm details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + verified badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            farm.farmName,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (farm.verifiedByLPNM) ...[
                          const SizedBox(width: 4),
                          const VerifiedIcon(size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // District + distance
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          farm.district,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        if (distanceKm != null) ...[
                          const Text(
                            ' • ',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          Text(
                            '${distanceKm!.toStringAsFixed(1)} km',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Varieties chips
                    if (farm.varieties.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: farm.varieties.take(2).map((variety) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(
                                alpha: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              variety,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            // Arrow indicator
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.m),
              child: Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading state for farm cards
class _FarmCardShimmer extends StatelessWidget {
  const _FarmCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Row(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusM),
                bottomLeft: Radius.circular(AppSpacing.radiusM),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Products Section - shows 4 random products in horizontal scroll
class _ProductsSection extends StatelessWidget {
  const _ProductsSection({
    required this.productsAsync,
    required this.onProductTap,
    required this.onFindMoreTap,
  });

  final AsyncValue<List<ProductModel>> productsAsync;
  final void Function(String farmId, String productId) onProductTap;
  final VoidCallback onFindMoreTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nenas Products',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              TextButton.icon(
                onPressed: onFindMoreTap,
                icon: const Text('Find more'),
                label: const Icon(Icons.arrow_forward, size: 16),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
        ),
        AppSpacing.vGapS,
        // Horizontal product scroll
        SizedBox(
          height: 240,
          child: productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < products.length - 1 ? AppSpacing.m : 0,
                    ),
                    child: _ProductCardCompact(
                      product: product,
                      onTap: () => onProductTap(product.farmId, product.id),
                    ),
                  );
                },
              );
            },
            loading: () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: index < 3 ? AppSpacing.m : 0),
                  child: const _ProductCardShimmer(),
                );
              },
            ),
            error: (_, __) => _buildEmptyState(context),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 40,
              color: AppColors.textSecondary,
            ),
            AppSpacing.vGapS,
            Text(
              'No products available',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact product card for horizontal scroll
class _ProductCardCompact extends StatelessWidget {
  const _ProductCardCompact({required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusM),
                topRight: Radius.circular(AppSpacing.radiusM),
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: product.primaryImage != null
                    ? CachedNetworkImage(
                        imageUrl: product.primaryImage!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const PineapplePlaceholder(),
                        errorWidget: (_, __, ___) =>
                            const PineapplePlaceholder(),
                      )
                    : const PineapplePlaceholder(),
              ),
            ),
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Variety badge - only for fresh products
                    if (product.category == ProductCategory.fresh &&
                        product.variety != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.variety!,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    // Product name
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      product.formattedPrice,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading state for product cards
class _ProductCardShimmer extends StatelessWidget {
  const _ProductCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusM),
                topRight: Radius.circular(AppSpacing.radiusM),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Map preview card with CTA
class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({required this.onOpenMap});

  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenMap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.05),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore businesses on map',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Find businesses near you',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Map preview placeholder with pattern
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: Border.all(
                  color: AppColors.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Stack(
                children: [
                  // Grid pattern to simulate map
                  Positioned.fill(
                    child: CustomPaint(painter: _MapGridPainter()),
                  ),
                  // Location markers - pineapple for farms, shop for stores
                  Positioned(
                    top: 30,
                    left: 50,
                    child: _buildMarker(
                      AppColors.primary,
                      Icons.local_florist,
                    ), // Pineapple/farm
                  ),
                  Positioned(
                    top: 50,
                    right: 80,
                    child: _buildMarker(
                      AppColors.secondary,
                      Icons.storefront,
                    ), // Shop
                  ),
                  Positioned(
                    bottom: 40,
                    left: 100,
                    child: _buildMarker(
                      AppColors.primary,
                      Icons.local_florist,
                    ), // Pineapple/farm
                  ),
                  // Center icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.my_location,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onOpenMap,
                icon: const Icon(Icons.navigation),
                label: const Text('Open Map View'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarker(Color color, IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 14),
    );
  }
}

/// Custom painter for map grid pattern
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outline.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
