import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeleton_widgets.dart';

/// Skeleton loading state for the farmer home dashboard
class FarmerHomeSkeleton extends StatelessWidget {
  const FarmerHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Welcome message skeleton
          _WelcomeSkeleton(),
          AppSpacing.vGapL,

          // My Farm section
          SkeletonSectionHeader(),
          AppSpacing.vGapHeader,
          SkeletonFarmCard(),
          AppSpacing.vGapL,

          // Overview section
          SkeletonSectionHeader(),
          AppSpacing.vGapHeader,
          SkeletonStatsCard(),
          AppSpacing.vGapL,

          // Quick Actions section
          SkeletonSectionHeader(),
          AppSpacing.vGapHeader,
          _QuickActionsSkeleton(),
        ],
      ),
    );
  }
}

/// Welcome message skeleton
class _WelcomeSkeleton extends StatelessWidget {
  const _WelcomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ShimmerText(width: 100, height: 16),
        SizedBox(height: 4),
        ShimmerText(width: 180, height: 24),
      ],
    );
  }
}

/// Quick actions buttons skeleton
class _QuickActionsSkeleton extends StatelessWidget {
  const _QuickActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: SkeletonButton(isFullWidth: true)),
        SizedBox(width: AppSpacing.m),
        Expanded(child: SkeletonButton(isFullWidth: true)),
      ],
    );
  }
}
