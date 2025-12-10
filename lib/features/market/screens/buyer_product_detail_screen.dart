import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/pineapple_placeholder.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeleton_widgets.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/farm/widgets/verification_badge.dart';
import 'package:nenas_kita/features/market/widgets/product_image_carousel.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/product/widgets/price_input.dart';
import 'package:nenas_kita/features/product/widgets/product_card.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyerProductDetailScreen extends ConsumerWidget {
  const BuyerProductDetailScreen({
    super.key,
    required this.productId,
    this.farmId,
  });

  final String productId;
  final String? farmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle missing farmId
    if (farmId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: const _NotFoundContent(),
      );
    }

    final productAsync = ref.watch(productByIdProvider(farmId!, productId));

    return productAsync.when(
      loading: () => const _BuyerProductDetailSkeleton(),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: _ErrorContent(
          error: error,
          onRetry: () =>
              ref.invalidate(productByIdProvider(farmId!, productId)),
        ),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product Details')),
            body: const _NotFoundContent(),
          );
        }

        return _BuyerProductDetailContent(product: product, farmId: farmId!);
      },
    );
  }
}

class _BuyerProductDetailContent extends ConsumerWidget {
  const _BuyerProductDetailContent({
    required this.product,
    required this.farmId,
  });

  final ProductModel product;
  final String farmId;

  Future<void> _onRefresh(WidgetRef ref) async {
    await Future.wait([
      ref.refresh(productByIdProvider(farmId, product.id).future),
      ref.refresh(farmByIdProvider(farmId).future),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmAsync = ref.watch(farmByIdProvider(farmId));
    final canViewWholesale = ref.watch(canViewWholesalePricesProvider);
    final currentUser = ref.watch(currentAppUserProvider).value;

    final farm = farmAsync.value;
    final isOwner = farm?.ownerId == currentUser?.id;
    final showWholesale = canViewWholesale || isOwner;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(ref),
        child: CustomScrollView(
          slivers: [
            // Hero image header
            SliverAppBar(
              pinned: true,
              expandedHeight: 280,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
                    tooltip: 'Back',
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'buyer_product_${product.id}',
                  child: product.images.length > 1
                      ? ProductImageCarousel(images: product.images)
                      : _SingleImage(
                          imageUrl: product.images.isNotEmpty
                              ? product.images.first
                              : null,
                        ),
                ),
              ),
            ),

            // Product content
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.vGapM,

                    // Product header
                    _ProductHeader(product: product),
                    AppSpacing.vGapM,

                    // Variety chip - only for fresh products
                    if (product.category == ProductCategory.fresh &&
                        product.variety != null) ...[
                      _VarietyChip(variety: product.variety!),
                      AppSpacing.vGapL,
                    ],

                    // Price section
                    _PriceSection(
                      product: product,
                      showWholesale: showWholesale,
                    ),
                    AppSpacing.vGapM,

                    // View Price History button
                    _PriceHistoryButton(product: product, farmId: farmId),
                    AppSpacing.vGapL,

                    // Description section
                    if (product.description != null &&
                        product.description!.isNotEmpty) ...[
                      _DescriptionSection(description: product.description!),
                      AppSpacing.vGapL,
                    ],

                    // Last updated
                    _LastUpdatedRow(updatedAt: product.updatedAt),
                    AppSpacing.vGapL,

                    // Farm info card
                    if (farm != null) ...[
                      _FarmInfoCard(farm: farm),
                      AppSpacing.vGapL,
                    ],

                    // FAB clearance
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: farm != null
          ? _WhatsAppFAB(product: product, farm: farm)
          : null,
    );
  }
}

// ============================================================================
// Product Header
// ============================================================================

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppSpacing.vGapS,
        Row(
          children: [
            CategoryBadge(category: product.category),
            AppSpacing.hGapS,
            StockBadge(status: product.stockStatus),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// Variety Chip
// ============================================================================

class _VarietyChip extends StatelessWidget {
  const _VarietyChip({required this.variety});

  final String variety;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(variety),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

// ============================================================================
// Price Section
// ============================================================================

class _PriceSection extends StatelessWidget {
  const _PriceSection({required this.product, required this.showWholesale});

  final ProductModel product;
  final bool showWholesale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.payments_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
            AppSpacing.hGapS,
            Text(
              'Price',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        AppSpacing.vGapM,
        PriceDisplay(
          price: product.price,
          unit: product.priceUnit,
          wholesalePrice: showWholesale && product.hasWholesalePrice
              ? product.wholesalePrice
              : null,
          wholesaleMinQty: showWholesale && product.hasWholesalePrice
              ? product.wholesaleMinQty
              : null,
          size: PriceDisplaySize.large,
        ),
      ],
    );
  }
}

// ============================================================================
// Price History Button
// ============================================================================

class _PriceHistoryButton extends StatelessWidget {
  const _PriceHistoryButton({required this.product, required this.farmId});

  final ProductModel product;
  final String farmId;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        context.push(
          RouteNames.buyerProductHistoryPath(product.id, farmId: farmId),
          extra: product,
        );
      },
      icon: const Icon(Icons.show_chart, size: 20),
      label: const Text('View Price History'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.outline),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}

// ============================================================================
// Description Section
// ============================================================================

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
            AppSpacing.hGapS,
            Text(
              'Description',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        AppSpacing.vGapM,
        Text(description, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

// ============================================================================
// Last Updated Row
// ============================================================================

class _LastUpdatedRow extends StatelessWidget {
  const _LastUpdatedRow({required this.updatedAt});

  final DateTime updatedAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
        AppSpacing.hGapS,
        Text(
          'Updated ${_formatRelativeTime(updatedAt)}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 30) {
      return DateFormat('d MMM yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

// ============================================================================
// Farm Info Card
// ============================================================================

class _FarmInfoCard extends StatelessWidget {
  const _FarmInfoCard({required this.farm});

  final FarmModel farm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppSpacing.vGapM,
        AppCard(
          onTap: () => context.push(RouteNames.buyerFarmDetailPath(farm.id)),
          child: Row(
            children: [
              // Farm image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                child: CachedNetworkImage(
                  imageUrl: farm.socialLinks['heroImage'] ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const PineapplePlaceholder(size: 80),
                  errorWidget: (context, url, error) =>
                      const PineapplePlaceholder(size: 80),
                ),
              ),
              AppSpacing.hGapM,

              // Farm info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            farm.farmName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (farm.verifiedByLPNM) ...[
                          AppSpacing.hGapS,
                          const VerificationBadge(
                            isVerified: true,
                            size: VerificationBadgeSize.medium,
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.vGapS,
                    if (farm.varieties.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: farm.varieties
                            .take(3)
                            .map(
                              (variety) => Chip(
                                label: Text(
                                  variety,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(fontSize: 11),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),

              // Chevron
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// WhatsApp FAB
// ============================================================================

class _WhatsAppFAB extends StatelessWidget {
  const _WhatsAppFAB({required this.product, required this.farm});

  final ProductModel product;
  final FarmModel farm;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _launchWhatsApp(context, product, farm),
      backgroundColor: const Color(0xFF25D366),
      icon: const Icon(Icons.chat),
      label: const Text('WhatsApp'),
    );
  }

  Future<void> _launchWhatsApp(
    BuildContext context,
    ProductModel product,
    FarmModel farm,
  ) async {
    final phone = farm.effectiveWhatsAppNumber;
    if (phone == null || phone.isEmpty) {
      if (context.mounted) {
        _showErrorSnackbar(context, 'Phone number not available');
      }
      return;
    }

    try {
      final cleanNumber = phone.replaceAll(RegExp(r'[^\d+]'), '');
      final phoneWithCode = cleanNumber.startsWith('+')
          ? cleanNumber
          : '+60$cleanNumber';
      final message =
          'Hi, I am interested in ${product.name} from ${farm.farmName}.\n\nSent via NenasKita App';

      final url = Uri.parse(
        'https://wa.me/${phoneWithCode.replaceFirst('+', '')}?text=${Uri.encodeComponent(message)}',
      );

      if (!await canLaunchUrl(url)) {
        if (context.mounted) {
          _showErrorSnackbar(context, 'WhatsApp is not installed');
        }
        return;
      }

      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackbar(context, 'Could not open WhatsApp');
      }
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}

// ============================================================================
// Single Image
// ============================================================================

class _SingleImage extends StatelessWidget {
  const _SingleImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        color: AppColors.surface,
        child: const Center(child: PineapplePlaceholder(size: 120)),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.surface,
        child: const Center(child: PineapplePlaceholder(size: 120)),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surface,
        child: const Center(child: PineapplePlaceholder(size: 120)),
      ),
    );
  }
}

// ============================================================================
// Skeleton Loading
// ============================================================================

class _BuyerProductDetailSkeleton extends StatelessWidget {
  const _BuyerProductDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
                  tooltip: 'Back',
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surface,
                child: const ShimmerLoading(child: ShimmerBox(height: 280)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.pagePadding,
              child: ShimmerLoading(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.vGapM,

                    // Title skeleton
                    const ShimmerBox(width: 200, height: 28),
                    AppSpacing.vGapS,

                    // Badges skeleton
                    Row(
                      children: [
                        const ShimmerBox(width: 80, height: 24),
                        AppSpacing.hGapS,
                        const ShimmerBox(width: 80, height: 24),
                      ],
                    ),
                    AppSpacing.vGapM,

                    // Variety chip skeleton
                    const ShimmerBox(width: 100, height: 32),
                    AppSpacing.vGapL,

                    // Price section skeleton
                    const ShimmerBox(width: 80, height: 20),
                    AppSpacing.vGapM,
                    const ShimmerBox(width: 150, height: 36),
                    AppSpacing.vGapL,

                    // Description skeleton
                    const ShimmerBox(width: 120, height: 20),
                    AppSpacing.vGapM,
                    const ShimmerBox(height: 60),
                    AppSpacing.vGapL,

                    // Last updated skeleton
                    const ShimmerBox(width: 150, height: 16),
                    AppSpacing.vGapL,

                    // Farm card skeleton
                    const ShimmerBox(width: 80, height: 20),
                    AppSpacing.vGapM,
                    Container(
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardRadius,
                        ),
                      ),
                      child: Row(
                        children: [
                          const ShimmerBox(width: 80, height: 80),
                          AppSpacing.hGapM,
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerBox(width: 150, height: 20),
                                SizedBox(height: 8),
                                ShimmerBox(width: 100, height: 16),
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
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Error Content
// ============================================================================

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppError(
        title: 'Failed to Load Product',
        message: error.toString(),
        onRetry: onRetry,
      ),
    );
  }
}

// ============================================================================
// Not Found Content
// ============================================================================

class _NotFoundContent extends StatelessWidget {
  const _NotFoundContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PineapplePlaceholder(size: 80),
          AppSpacing.vGapL,
          Text(
            'Product not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          AppSpacing.vGapM,
          Text(
            'This product may have been removed or does not exist.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
