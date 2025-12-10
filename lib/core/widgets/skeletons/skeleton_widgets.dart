import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';

/// Export all shimmer widgets from app_loading.dart for convenience
export 'package:nenas_kita/core/widgets/app_loading.dart'
    show
        ShimmerLoading,
        ShimmerBox,
        ShimmerCard,
        ShimmerCardList,
        ShimmerAvatar,
        ShimmerImage,
        ShimmerText,
        ShimmerParagraph;

/// Skeleton section header (icon + text)
class SkeletonSectionHeader extends StatelessWidget {
  const SkeletonSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShimmerLoading(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(AppSpacing.radiusS),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const ShimmerText(width: 100, height: 16),
      ],
    );
  }
}

/// Skeleton button placeholder
class SkeletonButton extends StatelessWidget {
  const SkeletonButton({
    super.key,
    this.width,
    this.height = 48,
    this.isFullWidth = false,
  });

  final double? width;
  final double height;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: isFullWidth ? double.infinity : width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        ),
      ),
    );
  }
}

/// Skeleton for farm info card layout
class SkeletonFarmCard extends StatelessWidget {
  const SkeletonFarmCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              ),
            ),
            AppSpacing.hGapM,
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  AppSpacing.vGapS,
                  Container(
                    height: 14,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  AppSpacing.vGapXS,
                  // Chips row
                  Row(
                    children: [
                      Container(
                        height: 24,
                        width: 60,
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                      ),
                      AppSpacing.hGapS,
                      Container(
                        height: 24,
                        width: 60,
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for stats card layout
class SkeletonStatsCard extends StatelessWidget {
  const SkeletonStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            // Stat 1
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 32,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  AppSpacing.vGapXS,
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: AppColors.neutral200,
            ),
            // Stat 2
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 32,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  AppSpacing.vGapXS,
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for product grid card (square layout)
class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusL - 1),
                  ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  AppSpacing.vGapXS,
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  AppSpacing.vGapS,
                  Container(
                    height: 18,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid of skeleton product cards
class SkeletonProductGrid extends StatelessWidget {
  const SkeletonProductGrid({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpacing.pagePadding,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
        childAspectRatio: 0.7,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => const SkeletonProductCard(),
    );
  }
}

/// Skeleton chip/filter item
class SkeletonChip extends StatelessWidget {
  const SkeletonChip({
    super.key,
    this.width = 80,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),
    );
  }
}

/// Row of skeleton filter chips
class SkeletonFilterRow extends StatelessWidget {
  const SkeletonFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          SkeletonChip(width: 60),
          SizedBox(width: 8),
          SkeletonChip(width: 80),
          SizedBox(width: 8),
          SkeletonChip(width: 100),
        ],
      ),
    );
  }
}
