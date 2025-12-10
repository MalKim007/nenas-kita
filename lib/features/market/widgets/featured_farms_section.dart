import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/section_header.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/widgets/verification_badge.dart';

/// Horizontal scrolling section of featured/verified farms
class FeaturedFarmsSection extends StatelessWidget {
  const FeaturedFarmsSection({
    super.key,
    required this.farms,
    this.onSeeAllTap,
    this.maxDisplay = 5,
  });

  final List<FarmModel> farms;
  final VoidCallback? onSeeAllTap;
  final int maxDisplay;

  @override
  Widget build(BuildContext context) {
    final displayFarms = farms.take(maxDisplay).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: SectionHeader(
            title: 'Verified Businesses',
            icon: Icons.verified,
            trailing: onSeeAllTap != null
                ? TextButton(
                    onPressed: onSeeAllTap,
                    child: const Text('See All'),
                  )
                : null,
          ),
        ),
        AppSpacing.vGapS,

        // Empty state or farm list
        if (displayFarms.isEmpty)
          _EmptyFarmsState()
        else
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              itemCount: displayFarms.length,
              separatorBuilder: (_, __) => AppSpacing.hGapM,
              itemBuilder: (context, index) {
                final farm = displayFarms[index];
                return _FeaturedFarmCard(
                  farm: farm,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push(RouteNames.buyerFarmDetailPath(farm.id));
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Compact card for featured farm display
class _FeaturedFarmCard extends StatelessWidget {
  const _FeaturedFarmCard({
    required this.farm,
    this.onTap,
  });

  final FarmModel farm;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final heroImage = farm.socialLinks['heroImage'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
          boxShadow: AppSpacing.shadowSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusM),
              ),
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: heroImage != null && heroImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: heroImage,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _ImagePlaceholder(),
                        errorWidget: (_, __, ___) => _ImagePlaceholder(),
                      )
                    : _ImagePlaceholder(),
              ),
            ),

            // Farm info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name + verified badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            farm.farmName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (farm.verifiedByLPNM) ...[
                          const SizedBox(width: 4),
                          const VerifiedIcon(size: 16),
                        ],
                      ],
                    ),

                    // District
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            farm.district,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for farm image
class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.agriculture_outlined,
          size: 32,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

/// Empty state when no farms available
class _EmptyFarmsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 40,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No verified businesses yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
