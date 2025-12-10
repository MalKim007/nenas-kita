import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_empty_state.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeletons.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/product/widgets/category_selector.dart';
import 'package:nenas_kita/features/product/widgets/product_card.dart';

/// Products list screen with grid display and category filter
class ProductsListScreen extends ConsumerStatefulWidget {
  const ProductsListScreen({super.key});

  @override
  ConsumerState<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends ConsumerState<ProductsListScreen> {
  ProductCategory? _selectedCategory;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showButton =
        _scrollController.hasClients && _scrollController.offset > 200;
    if (showButton != _showScrollToTop) {
      setState(() => _showScrollToTop = showButton);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmAsync = ref.watch(myPrimaryFarmProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Products')),
      body: farmAsync.when(
        data: (farm) {
          if (farm == null) {
            return const Center(
              child: Text('Please setup your business profile first.'),
            );
          }

          return Column(
            children: [
              // Category filter
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
                child: CategoryFilter(
                  selected: _selectedCategory,
                  onChanged: (category) {
                    setState(() => _selectedCategory = category);
                  },
                ),
              ),
              // Products grid
              Expanded(
                child: _ProductsGrid(
                  farmId: farm.id,
                  categoryFilter: _selectedCategory,
                  scrollController: _scrollController,
                ),
              ),
            ],
          );
        },
        loading: () => const ProductsListSkeleton(),
        error: (e, _) => AppError(
          message: 'Failed to load farm',
          onRetry: () => ref.invalidate(myPrimaryFarmProvider),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scroll to top FAB
          AnimatedScale(
            scale: _showScrollToTop ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: FloatingActionButton.small(
              heroTag: 'scroll_to_top',
              onPressed: _scrollToTop,
              backgroundColor: AppColors.neutral100,
              foregroundColor: AppColors.textPrimary,
              child: const Icon(Icons.arrow_upward),
            ),
          ),
          if (_showScrollToTop) const SizedBox(height: AppSpacing.m),
          // Add Product FAB
          FloatingActionButton.extended(
            heroTag: 'add_product',
            onPressed: () => context.push(RouteNames.farmerProductAdd),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}

class _ProductsGrid extends ConsumerStatefulWidget {
  const _ProductsGrid({
    required this.farmId,
    this.categoryFilter,
    required this.scrollController,
  });

  final String farmId;
  final ProductCategory? categoryFilter;
  final ScrollController scrollController;

  @override
  ConsumerState<_ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends ConsumerState<_ProductsGrid> {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsByFarmProvider(widget.farmId));

    return productsAsync.when(
      data: (products) {
        // Apply category filter
        final filtered = widget.categoryFilter == null
            ? products
            : products
                  .where((p) => p.category == widget.categoryFilter)
                  .toList();

        if (filtered.isEmpty) {
          if (products.isEmpty) {
            return NoProductsEmpty(
              onAddProduct: () => context.push(RouteNames.farmerProductAdd),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.categoryFilter == ProductCategory.fresh
                      ? Icons.eco
                      : Icons.inventory_2,
                  size: 64,
                  color: AppColors.textDisabled,
                ),
                AppSpacing.vGapM,
                Text(
                  'No ${widget.categoryFilter == ProductCategory.fresh ? 'fresh' : 'processed'} products',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(productsByFarmProvider(widget.farmId));
          },
          child: GridView.builder(
            controller: widget.scrollController,
            // Extra bottom padding to prevent FAB overlap
            padding: AppSpacing.pagePadding.copyWith(
              bottom: AppSpacing.l + 80, // 80dp for FAB + spacing
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: AppSpacing.m,
              mainAxisSpacing: AppSpacing.m,
              childAspectRatio: 0.65,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final product = filtered[index];
              return ProductCard(
                product: product,
                onTap: () =>
                    context.push('${RouteNames.farmerProducts}/${product.id}'),
              );
            },
          ),
        );
      },
      loading: () => const ProductsGridSkeleton(itemCount: 4),
      error: (e, _) => AppError(
        message: 'Failed to load products',
        onRetry: () => ref.invalidate(productsByFarmProvider(widget.farmId)),
      ),
    );
  }
}
