import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeleton_widgets.dart';

/// Skeleton loading state for the product detail screen
class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // Image area skeleton
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.edit, color: AppColors.onPrimary),
              ),
            ),
          ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Status row
                Row(
                  children: const [
                    SkeletonChip(width: 70),
                    SizedBox(width: AppSpacing.s),
                    SkeletonChip(width: 90),
                  ],
                ),
                AppSpacing.vGapM,

                // Name
                const ShimmerText(width: 200, height: 24),
                AppSpacing.vGapXS,

                // Variety
                const ShimmerText(width: 120, height: 16),
                AppSpacing.vGapL,

                // Price
                const _PriceSkeleton(),
                AppSpacing.vGapL,

                // Description section
                const _SectionSkeleton(
                  titleWidth: 100,
                  child: ShimmerParagraph(lines: 3),
                ),
                AppSpacing.vGapL,

                // Quick Actions section
                const _SectionSkeleton(
                  titleWidth: 120,
                  child: Column(
                    children: [
                      _QuickActionSkeleton(),
                      _QuickActionSkeleton(),
                    ],
                  ),
                ),
                AppSpacing.vGapL,

                // Product Info section
                const _SectionSkeleton(
                  titleWidth: 110,
                  child: Column(
                    children: [
                      _InfoRowSkeleton(),
                      _InfoRowSkeleton(),
                      _InfoRowSkeleton(),
                      _InfoRowSkeleton(),
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
}

/// Price display skeleton
class _PriceSkeleton extends StatelessWidget {
  const _PriceSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ShimmerText(width: 100, height: 28),
        SizedBox(height: 4),
        ShimmerText(width: 140, height: 14),
      ],
    );
  }
}

/// Section with title skeleton
class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({
    required this.titleWidth,
    required this.child,
  });

  final double titleWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerText(width: titleWidth, height: 18),
        AppSpacing.vGapHeader,
        child,
      ],
    );
  }
}

/// Quick action row skeleton
class _QuickActionSkeleton extends StatelessWidget {
  const _QuickActionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        children: [
          ShimmerLoading(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              ),
            ),
          ),
          AppSpacing.hGapM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerText(width: 140, height: 16),
                SizedBox(height: 4),
                ShimmerText(width: 200, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info row skeleton (label: value)
class _InfoRowSkeleton extends StatelessWidget {
  const _InfoRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          ShimmerText(width: 80, height: 14),
          ShimmerText(width: 100, height: 14),
        ],
      ),
    );
  }
}
