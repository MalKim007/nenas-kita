import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_empty_state.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeleton_widgets.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/product/widgets/product_card.dart';

/// Grid of products for a specific farm (used in buyer farm detail view)
class FarmProductsGrid extends ConsumerWidget {
  const FarmProductsGrid({
    super.key,
    required this.farmId,
  });

  final String farmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByFarmProvider(farmId));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const _EmptyProductsState();
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: AppSpacing.m,
            mainAxisSpacing: AppSpacing.m,
            childAspectRatio: 0.65,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              heroTag: 'buyer_product_${product.id}',
              onTap: () {
                HapticFeedback.lightImpact();
                context.push(RouteNames.buyerProductDetailPath(product.id, farmId: farmId));
              },
            );
          },
        );
      },
      loading: () => const _ProductsGridSkeleton(),
      error: (error, stack) => const _EmptyProductsState(),
    );
  }
}

/// Loading skeleton for products grid
class _ProductsGridSkeleton extends StatelessWidget {
  const _ProductsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
        childAspectRatio: 0.65,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => const SkeletonProductCard(),
    );
  }
}

/// Empty state when farm has no products
class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return const NoProductsEmpty(
      isOwner: false,
    );
  }
}
