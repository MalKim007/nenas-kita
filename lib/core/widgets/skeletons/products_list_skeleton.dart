import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeleton_widgets.dart';

/// Skeleton loading state for the products list screen
class ProductsListSkeleton extends StatelessWidget {
  const ProductsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category filter skeleton
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
          child: const SkeletonFilterRow(),
        ),
        // Products grid skeleton
        const Expanded(
          child: SkeletonProductGrid(itemCount: 4),
        ),
      ],
    );
  }
}

/// Skeleton for products grid only (use when farm is already loaded)
class ProductsGridSkeleton extends StatelessWidget {
  const ProductsGridSkeleton({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonProductGrid(itemCount: itemCount);
  }
}
