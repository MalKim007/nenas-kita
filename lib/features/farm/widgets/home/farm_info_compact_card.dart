import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/widgets/variety_chips.dart';

/// Simplified farm display card for home screen
/// Compact version with avatar, name, verification, district, and varieties
class FarmInfoCompactCard extends StatelessWidget {
  const FarmInfoCompactCard({
    super.key,
    required this.farm,
    this.onTap,
  });

  final FarmModel farm;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Business: ${farm.farmName}. ${farm.verifiedByLPNM ? 'LPNM Verified' : 'Not verified'}. Located in ${farm.district}',
      button: onTap != null,
      child: AppCard(
        onTap: () {
          if (onTap != null) {
            HapticFeedback.selectionClick();
            onTap!();
          }
        },
        child: Row(
          children: [
            // Farm avatar (64x64)
            _FarmAvatar(imageUrl: farm.socialLinks['heroImage']),
            AppSpacing.hGapM,
            // Farm details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Farm name + verification badge inline
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          farm.farmName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (farm.verifiedByLPNM) ...[
                        AppSpacing.hGapXS,
                        Tooltip(
                          message: 'LPNM Verified',
                          child: const Icon(
                            Icons.verified,
                            color: AppColors.verified,
                            size: 20,
                          ),
                        ),
                      ],
                    ],
                  ),
                  AppSpacing.vGapXS,
                  // District with location pin icon
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        farm.district,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  // Variety chips
                  if (farm.varieties.isNotEmpty) ...[
                    AppSpacing.vGapS,
                    VarietyChips(
                      varieties: farm.varieties,
                      maxDisplay: 3,
                    ),
                  ],
                ],
              ),
            ),
            // Chevron (if tappable)
            if (onTap != null) ...[
              AppSpacing.hGapS,
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Farm avatar with 64x64 size
class _FarmAvatar extends StatelessWidget {
  const _FarmAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => _placeholder(),
              errorWidget: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return const Center(
      child: Icon(
        Icons.agriculture,
        color: AppColors.primary,
        size: 32,
      ),
    );
  }
}
