import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeletons.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/product/widgets/price_input.dart';
import 'package:nenas_kita/features/product/widgets/product_card.dart';
import 'package:nenas_kita/features/product/widgets/stock_status_selector.dart';

/// Product detail screen (view mode)
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmAsync = ref.watch(myPrimaryFarmProvider);

    return Scaffold(
      body: farmAsync.when(
        data: (farm) {
          if (farm == null) {
            return const Center(child: Text('No farm found'));
          }

          final productAsync = ref.watch(
            productByIdProvider(farm.id, productId),
          );

          return productAsync.when(
            data: (product) {
              if (product == null) {
                return const Center(child: Text('Product not found'));
              }

              return _ProductDetailContent(
                product: product,
                farmId: farm.id,
              );
            },
            loading: () => const ProductDetailSkeleton(),
            error: (e, _) => AppError(
              message: 'Failed to load product',
              onRetry: () =>
                  ref.invalidate(productByIdProvider(farm.id, productId)),
            ),
          );
        },
        loading: () => const ProductDetailSkeleton(),
        error: (e, _) => AppError(
          message: 'Failed to load farm',
          onRetry: () => ref.invalidate(myPrimaryFarmProvider),
        ),
      ),
    );
  }
}

class _ProductDetailContent extends ConsumerStatefulWidget {
  const _ProductDetailContent({
    required this.product,
    required this.farmId,
  });

  final ProductModel product;
  final String farmId;

  @override
  ConsumerState<_ProductDetailContent> createState() =>
      _ProductDetailContentState();
}

class _ProductDetailContentState extends ConsumerState<_ProductDetailContent> {
  int _currentImageIndex = 0;

  void _updateStockStatus(StockStatus newStatus) async {
    try {
      final productRepo = ref.read(productRepositoryProvider);
      final updatedProduct = widget.product.copyWith(
        stockStatus: newStatus,
        updatedAt: DateTime.now(),
      );
      await productRepo.update(widget.farmId, updatedProduct);
      if (mounted) {
        AppSnackbar.showSuccess(context, 'Stock status updated');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to update status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomScrollView(
      slivers: [
        // Image carousel with app bar - responsive height
        SliverAppBar(
          expandedHeight: screenHeight * 0.35,
          pinned: true,
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  onPressed: () => context.push(
                    '${context.namedLocation('farmerProducts')}/${product.id}/edit',
                  ),
                  icon: const Icon(Icons.edit, color: AppColors.onPrimary),
                  tooltip: 'Edit Product',
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _buildImageCarousel(product),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Status row
                Row(
                  children: [
                    CategoryBadge(category: product.category),
                    AppSpacing.hGapS,
                    StockBadge(status: product.stockStatus),
                    const Spacer(),
                    // Quick stock toggle dropdown
                    PopupMenuButton<StockStatus>(
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'Change stock status',
                      onSelected: _updateStockStatus,
                      itemBuilder: (context) => [
                        _buildStatusMenuItem(
                          StockStatus.available,
                          product.stockStatus,
                        ),
                        _buildStatusMenuItem(
                          StockStatus.limited,
                          product.stockStatus,
                        ),
                        _buildStatusMenuItem(
                          StockStatus.out,
                          product.stockStatus,
                        ),
                      ],
                    ),
                  ],
                ),
                AppSpacing.vGapM,

                // Name
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                AppSpacing.vGapXS,

                // Variety - only shown for fresh products
                if (product.category == ProductCategory.fresh &&
                    product.variety != null) ...[
                  Text(
                    product.variety!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  AppSpacing.vGapL,
                ],

                // Price
                PriceDisplay(
                  price: product.price,
                  unit: product.priceUnit,
                  wholesalePrice: product.wholesalePrice,
                  wholesaleMinQty: product.wholesaleMinQty,
                  size: PriceDisplaySize.large,
                ),
                AppSpacing.vGapL,

                // Description
                if (product.description != null &&
                    product.description!.isNotEmpty) ...[
                  _buildSection(
                    context,
                    title: 'Description',
                    child: Text(
                      product.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  AppSpacing.vGapL,
                ],

                // Quick Actions
                _buildSection(
                  context,
                  title: 'Quick Actions',
                  child: Column(
                    children: [
                      _buildQuickAction(
                        context,
                        icon: Icons.inventory,
                        label: 'Update Stock Status',
                        subtitle: 'Current: ${_statusLabel(product.stockStatus)}',
                        onTap: () => _showStockStatusSheet(context),
                      ),
                      _buildQuickAction(
                        context,
                        icon: Icons.edit,
                        label: 'Edit Product',
                        subtitle: 'Update details, images, and pricing',
                        onTap: () => context.push(
                          '${context.namedLocation('farmerProducts')}/${product.id}/edit',
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.vGapL,

                // Info
                _buildSection(
                  context,
                  title: 'Product Info',
                  child: Column(
                    children: [
                      _buildInfoRow('Category',
                          product.category.name.toUpperCase()),
                      if (product.category == ProductCategory.fresh &&
                          product.variety != null)
                        _buildInfoRow('Variety', product.variety!),
                      _buildInfoRow('Price Unit', product.priceUnit),
                      if (product.hasWholesalePrice)
                        _buildInfoRow(
                          'Wholesale',
                          'RM ${product.wholesalePrice!.toStringAsFixed(2)} (min ${product.wholesaleMinQty!.toStringAsFixed(0)})',
                        ),
                      _buildInfoRow(
                        'Images',
                        '${product.images.length} photo${product.images.length == 1 ? '' : 's'}',
                      ),
                      _buildInfoRow(
                        'Last Updated',
                        _formatDate(product.updatedAt),
                      ),
                    ],
                  ),
                ),
                AppSpacing.vGapXL,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(ProductModel product) {
    if (product.images.isEmpty) {
      return Container(
        color: AppColors.surfaceVariant,
        child: const Center(
          child: Icon(
            Icons.local_florist,
            size: 64,
            color: AppColors.textDisabled,
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        PageView.builder(
          itemCount: product.images.length,
          onPageChanged: (index) {
            setState(() => _currentImageIndex = index);
          },
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: product.images[index],
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.error, color: AppColors.error),
              ),
            );
          },
        ),
        // Gradient overlay
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black45],
              ),
            ),
          ),
        ),
        // Improved page indicator with image count
        if (product.images.length > 1)
          Positioned(
            bottom: AppSpacing.m,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Pill-style indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    '${_currentImageIndex + 1} / ${product.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AppSpacing.vGapS,
                // Dot indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(product.images.length, (index) {
                    return AnimatedContainer(
                      duration: AppSpacing.animationFast,
                      width: _currentImageIndex == index ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentImageIndex == index
                            ? AppColors.onPrimary
                            : AppColors.onPrimary.withValues(alpha: 0.4),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
        ),
        AppSpacing.vGapHeader,
        child,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(label),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  PopupMenuItem<StockStatus> _buildStatusMenuItem(
    StockStatus status,
    StockStatus current,
  ) {
    return PopupMenuItem(
      value: status,
      enabled: status != current,
      child: Row(
        children: [
          Icon(
            _statusIcon(status),
            size: 20,
            color: status == current
                ? AppColors.textDisabled
                : _statusColor(status),
          ),
          AppSpacing.hGapS,
          Text(_statusLabel(status)),
          if (status == current) ...[
            const Spacer(),
            const Icon(Icons.check, size: 18, color: AppColors.primary),
          ],
        ],
      ),
    );
  }

  void _showStockStatusSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Stock Status',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              AppSpacing.vGapM,
              StockStatusSelector(
                selected: widget.product.stockStatus,
                onChanged: (status) {
                  Navigator.pop(context);
                  _updateStockStatus(status);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return 'Available';
      case StockStatus.limited:
        return 'Limited Stock';
      case StockStatus.out:
        return 'Out of Stock';
    }
  }

  IconData _statusIcon(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return Icons.check_circle;
      case StockStatus.limited:
        return Icons.warning;
      case StockStatus.out:
        return Icons.cancel;
    }
  }

  Color _statusColor(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return AppColors.secondary;
      case StockStatus.limited:
        return AppColors.warning;
      case StockStatus.out:
        return AppColors.error;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
