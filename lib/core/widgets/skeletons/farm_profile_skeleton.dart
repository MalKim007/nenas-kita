import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeleton_widgets.dart';

/// Skeleton loading state for the farm profile screen
class FarmProfileSkeleton extends StatelessWidget {
  const FarmProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Hero header skeleton
          _FarmHeaderSkeleton(),
          AppSpacing.vGapL,

          // About section
          _DetailSectionSkeleton(
            titleWidth: 60,
            child: ShimmerParagraph(lines: 3),
          ),
          AppSpacing.vGapL,

          // Varieties section
          _DetailSectionSkeleton(
            titleWidth: 80,
            child: _VarietyChipsSkeleton(),
          ),
          AppSpacing.vGapL,

          // Farm Details (collapsible)
          _CollapsibleSectionSkeleton(
            titleWidth: 100,
            child: Column(
              children: [
                _InfoRowSkeleton(),
                _InfoRowSkeleton(),
                _InfoRowSkeleton(),
              ],
            ),
          ),
          AppSpacing.vGapM,

          // Contact Information (collapsible)
          _CollapsibleSectionSkeleton(
            titleWidth: 140,
            child: Column(
              children: [
                _InfoRowSkeleton(),
                _InfoRowSkeleton(),
              ],
            ),
          ),
          AppSpacing.vGapL,

          // Location section
          _DetailSectionSkeleton(
            titleWidth: 70,
            child: _LocationSkeleton(),
          ),
          AppSpacing.vGapXL,
        ],
      ),
    );
  }
}

/// Farm header skeleton (image + name + district)
class _FarmHeaderSkeleton extends StatelessWidget {
  const _FarmHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero image
        ShimmerImage(
          aspectRatio: 16 / 9,
          borderRadius: AppSpacing.radiusL,
        ),
        AppSpacing.vGapM,
        // Farm name
        const ShimmerText(width: 200, height: 24),
        AppSpacing.vGapXS,
        // District
        const ShimmerText(width: 120, height: 16),
        AppSpacing.vGapS,
        // Verification badge
        Row(
          children: const [
            SkeletonChip(width: 100),
          ],
        ),
      ],
    );
  }
}

/// Detail section skeleton
class _DetailSectionSkeleton extends StatelessWidget {
  const _DetailSectionSkeleton({
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
        Row(
          children: [
            ShimmerLoading(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ShimmerText(width: titleWidth, height: 18),
          ],
        ),
        AppSpacing.vGapHeader,
        child,
      ],
    );
  }
}

/// Collapsible section skeleton
class _CollapsibleSectionSkeleton extends StatelessWidget {
  const _CollapsibleSectionSkeleton({
    required this.titleWidth,
    required this.child,
  });

  final double titleWidth;
  final Widget child;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: titleWidth,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            AppSpacing.vGapM,
            child,
          ],
        ),
      ),
    );
  }
}

/// Variety chips row skeleton
class _VarietyChipsSkeleton extends StatelessWidget {
  const _VarietyChipsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        SkeletonChip(width: 80),
        SkeletonChip(width: 90),
        SkeletonChip(width: 70),
      ],
    );
  }
}

/// Info row skeleton (icon + label: value)
class _InfoRowSkeleton extends StatelessWidget {
  const _InfoRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          ShimmerLoading(
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const ShimmerText(width: 70, height: 14),
          const Spacer(),
          const ShimmerText(width: 100, height: 14),
        ],
      ),
    );
  }
}

/// Location preview skeleton
class _LocationSkeleton extends StatelessWidget {
  const _LocationSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerText(width: double.infinity, height: 14),
        AppSpacing.vGapS,
        ShimmerLoading(
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
          ),
        ),
        AppSpacing.vGapS,
        const ShimmerText(width: 120, height: 14),
      ],
    );
  }
}
