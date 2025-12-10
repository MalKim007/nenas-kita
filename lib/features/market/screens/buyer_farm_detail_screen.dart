import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/pineapple_placeholder.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeleton_widgets.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/farm/widgets/farm_info_card.dart';
import 'package:nenas_kita/features/farm/widgets/variety_chips.dart';
import 'package:nenas_kita/features/farm/widgets/verification_badge.dart';
import 'package:nenas_kita/features/market/widgets/contact_section.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';

/// Buyer farm detail screen
/// Shows farm information and products for potential buyers
class BuyerFarmDetailScreen extends ConsumerWidget {
  const BuyerFarmDetailScreen({
    super.key,
    required this.farmId,
  });

  final String farmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmAsync = ref.watch(farmByIdProvider(farmId));

    return farmAsync.when(
      loading: () => const _BuyerFarmDetailSkeleton(),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Business Details'),
        ),
        body: AppError(
          title: 'Failed to Load Business',
          message: 'Unable to load business details. Please try again.',
          onRetry: () {
            ref.invalidate(farmByIdProvider(farmId));
          },
        ),
      ),
      data: (farm) {
        if (farm == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Business Details'),
            ),
            body: const NotFoundError(
              itemName: 'Business',
            ),
          );
        }

        return _BuyerFarmDetailContent(farm: farm);
      },
    );
  }
}

/// Main content widget for farm details
class _BuyerFarmDetailContent extends StatelessWidget {
  const _BuyerFarmDetailContent({required this.farm});

  final FarmModel farm;

  @override
  Widget build(BuildContext context) {
    final heroImageUrl = farm.socialLinks['heroImage'];

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible app bar with hero image - responsive height
          SliverAppBar(
            expandedHeight: screenHeight * 0.28,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'farm_image_${farm.id}',
                child: heroImageUrl != null && heroImageUrl.isNotEmpty
                    ? _HeroImage(imageUrl: heroImageUrl)
                    : _FarmAvatarFallback(farmId: farm.id),
              ),
            ),
          ),

          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Farm name and verification
                  _FarmNameRow(farm: farm),
                  AppSpacing.vGapS,

                  // Location
                  _LocationRow(farm: farm),
                  AppSpacing.vGapL,

                  // Description (if available)
                  if (farm.description != null &&
                      farm.description!.trim().isNotEmpty) ...[
                    FarmDetailSection(
                      title: 'About the Business',
                      icon: Icons.info_outline,
                      child: Text(
                        farm.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                      ),
                    ),
                    AppSpacing.vGapL,
                  ],

                  // Varieties
                  if (farm.varieties.isNotEmpty) ...[
                    FarmDetailSection(
                      title: 'Pineapple Varieties',
                      icon: Icons.spa,
                      child: VarietyChips(varieties: farm.varieties),
                    ),
                    AppSpacing.vGapL,
                  ],

                  // Farm size (if available)
                  if (farm.farmSizeHectares != null) ...[
                    _FarmSizeInfo(sizeHectares: farm.farmSizeHectares!),
                    AppSpacing.vGapL,
                  ],

                  // Products section
                  _ProductsSection(farmId: farm.id),
                  AppSpacing.vGapL,

                  // Contact section wrapped in AppCard for visual prominence
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: ContactSection(farm: farm),
                  ),
                  AppSpacing.vGapXL,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero image with full coverage
class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: AppColors.primaryContainer,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (_, __, ___) => _FarmAvatarFallback(farmId: ''),
        ),
        // Gradient overlay for better app bar visibility
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x40000000),
                Colors.transparent,
              ],
              stops: [0.0, 0.5],
            ),
          ),
        ),
      ],
    );
  }
}

/// Farm avatar fallback (centered icon like FarmInfoCard pattern)
class _FarmAvatarFallback extends StatelessWidget {
  const _FarmAvatarFallback({required this.farmId});

  final String farmId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryContainer,
      child: const Center(
        child: Icon(
          Icons.agriculture,
          size: 64,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Farm name with verification badge
class _FarmNameRow extends StatelessWidget {
  const _FarmNameRow({required this.farm});

  final FarmModel farm;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            farm.farmName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
        ),
        if (farm.verifiedByLPNM)
          const Padding(
            padding: EdgeInsets.only(left: AppSpacing.s),
            child: VerifiedIcon(size: 24),
          ),
      ],
    );
  }
}

/// Location row with district
class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.farm});

  final FarmModel farm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          farm.district,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
        ),
        if (farm.deliveryAvailable) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_shipping,
                  size: 12,
                  color: AppColors.onSecondaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  'Delivery',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Farm size information
class _FarmSizeInfo extends StatelessWidget {
  const _FarmSizeInfo({required this.sizeHectares});

  final double sizeHectares;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusS),
            ),
            child: const Icon(
              Icons.landscape,
              size: 20,
              color: AppColors.tertiary,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Size',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onTertiaryContainer,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                '${sizeHectares.toStringAsFixed(1)} acres',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onTertiaryContainer,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Products carousel section with header and "More Products" button
class _ProductsSection extends ConsumerWidget {
  const _ProductsSection({required this.farmId});

  final String farmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByFarmProvider(farmId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with conditional "More Products" button
        productsAsync.when(
          data: (products) => _buildHeader(context, products),
          loading: () => _buildHeader(context, []),
          error: (_, __) => _buildHeader(context, []),
        ),
        AppSpacing.vGapM,
        // Products carousel
        _ProductsCarousel(farmId: farmId),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, List<ProductModel> products) {
    return Row(
      children: [
        // Icon container
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.inventory_2,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        // Title
        Text(
          'Available Products',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        // "More Products" button - always visible when there are products
        if (products.isNotEmpty)
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push(RouteNames.buyerFarmProductsPath(farmId));
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'More Products',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
          ),
      ],
    );
  }
}

/// Horizontal scrolling product carousel (max 4 products)
class _ProductsCarousel extends ConsumerWidget {
  const _ProductsCarousel({required this.farmId});

  final String farmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByFarmProvider(farmId));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return _EmptyProductsState();
        }

        // Take max 4 products for carousel
        final displayProducts = products.take(4).toList();

        return SizedBox(
          height: 200, // Compact height as confirmed
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(), // Free scroll
            padding: EdgeInsets.zero,
            itemCount: displayProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (context, index) {
              final product = displayProducts[index];
              return _CarouselProductCard(
                product: product,
                farmId: farmId,
              );
            },
          ),
        );
      },
      loading: () => const _CarouselSkeleton(),
      error: (_, __) => _EmptyProductsState(),
    );
  }
}

/// Compact product card for horizontal carousel with stock badge
class _CarouselProductCard extends StatelessWidget {
  const _CarouselProductCard({
    required this.product,
    required this.farmId,
  });

  final ProductModel product;
  final String farmId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(RouteNames.buyerProductDetailPath(product.id, farmId: farmId));
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with stock badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusM),
                    topRight: Radius.circular(AppSpacing.radiusM),
                  ),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: product.primaryImage != null
                        ? CachedNetworkImage(
                            imageUrl: product.primaryImage!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const PineapplePlaceholder(),
                            errorWidget: (_, __, ___) => const PineapplePlaceholder(),
                          )
                        : const PineapplePlaceholder(),
                  ),
                ),
                // Stock badge - bottom right
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: _StockBadge(status: product.stockStatus),
                ),
              ],
            ),
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Variety badge - only for fresh products
                    if (product.category == ProductCategory.fresh &&
                        product.variety != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.variety!,
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    // Product name
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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

/// Compact stock badge for carousel cards
class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.status});

  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, text) = switch (status) {
      StockStatus.available => (AppColors.success, 'In Stock'),
      StockStatus.limited => (AppColors.warning, 'Low'),
      StockStatus.out => (AppColors.error, 'Out'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Loading skeleton for product carousel
class _CarouselSkeleton extends StatelessWidget {
  const _CarouselSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (_, __) => ShimmerLoading(
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty state when no products available
class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 32,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No products available',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading skeleton for farm detail screen
class _BuyerFarmDetailSkeleton extends StatelessWidget {
  const _BuyerFarmDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar skeleton
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ShimmerLoading(
                child: Container(
                  color: AppColors.neutral200,
                ),
              ),
            ),
          ),

          // Content skeleton
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.pagePadding,
              child: ShimmerLoading(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title skeleton
                    Container(
                      height: 28,
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    AppSpacing.vGapS,

                    // Location skeleton
                    Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    AppSpacing.vGapL,

                    // Section header skeleton
                    const SkeletonSectionHeader(),
                    AppSpacing.vGapHeader,

                    // Chips skeleton
                    Row(
                      children: const [
                        SkeletonChip(width: 80),
                        SizedBox(width: 8),
                        SkeletonChip(width: 70),
                        SizedBox(width: 8),
                        SkeletonChip(width: 90),
                      ],
                    ),
                    AppSpacing.vGapL,

                    // Section header skeleton
                    const SkeletonSectionHeader(),
                    AppSpacing.vGapHeader,

                    // Products grid skeleton - responsive
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: AppSpacing.m,
                        mainAxisSpacing: AppSpacing.m,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: 4,
                      itemBuilder: (_, __) => const SkeletonProductCard(),
                    ),
                    AppSpacing.vGapL,

                    // Buttons skeleton
                    Row(
                      children: const [
                        Expanded(
                          child: SkeletonButton(height: 48),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: SkeletonButton(height: 48),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
