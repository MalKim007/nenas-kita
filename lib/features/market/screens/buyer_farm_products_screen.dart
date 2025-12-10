import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_empty_state.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeleton_widgets.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/product/widgets/product_card.dart';

/// Buyer farm products screen - Full grid view of all products from a farm
class BuyerFarmProductsScreen extends ConsumerStatefulWidget {
  const BuyerFarmProductsScreen({
    super.key,
    required this.farmId,
  });

  final String farmId;

  @override
  ConsumerState<BuyerFarmProductsScreen> createState() =>
      _BuyerFarmProductsScreenState();
}

class _BuyerFarmProductsScreenState
    extends ConsumerState<BuyerFarmProductsScreen> {
  ProductCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final farmAsync = ref.watch(farmByIdProvider(widget.farmId));
    final productsAsync = ref.watch(productsByFarmProvider(widget.farmId));

    return Scaffold(
      appBar: AppBar(
        title: farmAsync.when(
          data: (farm) => Text(farm?.farmName ?? 'Products'),
          loading: () => const Text('Products'),
          error: (_, __) => const Text('Products'),
        ),
        elevation: 0,
      ),
      body: productsAsync.when(
        loading: () => const _ProductsLoadingSkeleton(),
        error: (error, stack) => AppError(
          title: 'Failed to Load Products',
          message: 'Unable to load products. Please try again.',
          onRetry: () {
            ref.invalidate(productsByFarmProvider(widget.farmId));
          },
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: NoProductsEmpty(isOwner: false),
            );
          }

          // Filter products by category if selected
          final filteredProducts = _selectedCategory == null
              ? products
              : products
                  .where((p) => p.category == _selectedCategory)
                  .toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productsByFarmProvider(widget.farmId));
            },
            child: CustomScrollView(
              slivers: [
                // Category filter chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m,
                      vertical: AppSpacing.m,
                    ),
                    child: _CategoryFilterChips(
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  ),
                ),

                // Products count
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m,
                    ),
                    child: Text(
                      '${filteredProducts.length} ${filteredProducts.length == 1 ? 'product' : 'products'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  sliver: filteredProducts.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: _EmptyFilterState(
                              category: _selectedCategory!,
                            ),
                          ),
                        )
                      : SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: AppSpacing.m,
                            mainAxisSpacing: AppSpacing.m,
                            childAspectRatio: 0.65,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = filteredProducts[index];
                              return ProductCard(
                                product: product,
                                heroTag: 'buyer_product_grid_${product.id}',
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  context.push(
                                    RouteNames.buyerProductDetailPath(
                                      product.id,
                                      farmId: widget.farmId,
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: filteredProducts.length,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Category filter chips
class _CategoryFilterChips extends StatelessWidget {
  const _CategoryFilterChips({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final ProductCategory? selectedCategory;
  final ValueChanged<ProductCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            icon: Icons.apps,
            isSelected: selectedCategory == null,
            onTap: () => onCategoryChanged(null),
          ),
          const SizedBox(width: AppSpacing.s),
          _FilterChip(
            label: 'Fresh',
            icon: Icons.eco,
            isSelected: selectedCategory == ProductCategory.fresh,
            onTap: () => onCategoryChanged(ProductCategory.fresh),
          ),
          const SizedBox(width: AppSpacing.s),
          _FilterChip(
            label: 'Processed',
            icon: Icons.inventory_2,
            isSelected: selectedCategory == ProductCategory.processed,
            onTap: () => onCategoryChanged(ProductCategory.processed),
          ),
        ],
      ),
    );
  }
}

/// Individual filter chip
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: AnimatedContainer(
          duration: AppSpacing.animationFast,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.outline.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.onPrimary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state when filter yields no results
class _EmptyFilterState extends StatelessWidget {
  const _EmptyFilterState({required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    final categoryName = category == ProductCategory.fresh ? 'fresh' : 'processed';

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              category == ProductCategory.fresh
                  ? Icons.eco
                  : Icons.inventory_2,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.vGapL,
          Text(
            'No $categoryName products',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
          AppSpacing.vGapS,
          Text(
            'This business doesn\'t have any $categoryName products yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Loading skeleton for products grid
class _ProductsLoadingSkeleton extends StatelessWidget {
  const _ProductsLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Filter chips skeleton
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.m,
            ),
            child: ShimmerLoading(
              child: Row(
                children: [
                  Container(
                    height: 36,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Container(
                    height: 36,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Container(
                    height: 36,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Products count skeleton
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
            ),
            child: ShimmerLoading(
              child: Container(
                height: 16,
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),

        // Products grid skeleton
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.m),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: AppSpacing.m,
              mainAxisSpacing: AppSpacing.m,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const SkeletonProductCard(),
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }
}
