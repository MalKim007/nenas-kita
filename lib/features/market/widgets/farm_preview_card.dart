import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/utils/social_utils.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/widgets/verification_badge.dart';

/// Preview card shown when farm marker is tapped on map
/// Displays farm info with WhatsApp, Facebook, Instagram, and Directions actions
class FarmPreviewCard extends StatelessWidget {
  const FarmPreviewCard({
    super.key,
    required this.farm,
    this.distanceKm,
    required this.onWhatsAppTap,
    required this.onDirectionsTap,
    required this.onViewDetailsTap,
    required this.onClose,
  });

  final FarmModel farm;
  final double? distanceKm;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onDirectionsTap;
  final VoidCallback onViewDetailsTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final heroImage = farm.socialLinks['heroImage'];

    return AppCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top section: Image + Details (tappable)
                InkWell(
                  onTap: onViewDetailsTap,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Farm image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: heroImage != null && heroImage.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: heroImage,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: AppColors.surfaceVariant,
                                    child: const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      _buildPlaceholder(),
                                )
                              : _buildPlaceholder(),
                        ),
                      ),
                      AppSpacing.hGapM,
                      // Farm details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Farm name + verified icon
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    farm.farmName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (farm.verifiedByLPNM) ...[
                                  const SizedBox(width: 4),
                                  const VerifiedIcon(size: 18),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            // District + distance
                            Row(
                              children: [
                                Text(
                                  farm.district,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (distanceKm != null) ...[
                                  const Text(
                                    ' • ',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${distanceKm!.toStringAsFixed(1)} km',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Varieties chips (max 2)
                            if (farm.varieties.isNotEmpty)
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: farm.varieties
                                    .take(2)
                                    .map(
                                      (variety) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryContainer,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          variety,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.onPrimaryContainer,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Social media buttons row
                if (farm.hasWhatsAppContact ||
                    farm.hasFacebookContact ||
                    farm.hasInstagramContact)
                  Row(
                    children: [
                      if (farm.hasWhatsAppContact) ...[
                        IconButton(
                          onPressed: onWhatsAppTap,
                          icon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 18,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.whatsapp,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(36, 36),
                            maximumSize: const Size(36, 36),
                          ),
                          tooltip: 'WhatsApp',
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (farm.hasFacebookContact) ...[
                        IconButton(
                          onPressed: () => SocialUtils.launchFacebook(
                            context,
                            facebookUrl: farm.facebookLink!,
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.facebookF,
                            size: 16,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F2),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(36, 36),
                            maximumSize: const Size(36, 36),
                          ),
                          tooltip: 'Facebook',
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (farm.hasInstagramContact)
                        IconButton(
                          onPressed: () => SocialUtils.launchInstagram(
                            context,
                            instagramUrl: farm.instagramLink!,
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.instagram,
                            size: 18,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFE4405F),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(36, 36),
                            maximumSize: const Size(36, 36),
                          ),
                          tooltip: 'Instagram',
                        ),
                    ],
                  ),
                const SizedBox(height: 12),
                // Directions button - full width on its own row
                Material(
                  color: AppColors.info,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: onDirectionsTap,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.directions, size: 22, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Directions',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Close button (top-right)
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close, size: 20),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface.withValues(alpha: 0.9),
                foregroundColor: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.agriculture,
        size: 32,
        color: AppColors.textDisabled,
      ),
    );
  }
}
