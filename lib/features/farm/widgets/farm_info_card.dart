import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/widgets/verification_badge.dart';
import 'package:nenas_kita/features/farm/widgets/variety_chips.dart';

/// Card displaying farm info (used in farmer home dashboard)
class FarmInfoCard extends StatelessWidget {
  const FarmInfoCard({
    super.key,
    required this.farm,
    this.onTap,
    this.showVarieties = true,
  });

  final FarmModel farm;
  final VoidCallback? onTap;
  final bool showVarieties;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          // Farm image/placeholder
          _FarmAvatar(imageUrl: farm.socialLinks['heroImage']),
          AppSpacing.hGapM,
          // Farm info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Farm name + verified badge
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
                    if (farm.verifiedByLPNM)
                      const Padding(
                        padding: EdgeInsets.only(left: AppSpacing.xs),
                        child: VerifiedIcon(size: 18),
                      ),
                  ],
                ),
                AppSpacing.vGapXS,
                // District
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      farm.district,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                if (showVarieties && farm.varieties.isNotEmpty) ...[
                  AppSpacing.vGapS,
                  VarietyChips(varieties: farm.varieties, maxDisplay: 3),
                ],
              ],
            ),
          ),
          // Chevron
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

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

/// Large farm header with hero image (for profile screen)
class FarmHeader extends StatelessWidget {
  const FarmHeader({
    super.key,
    required this.farm,
    this.heroImageUrl,
  });

  final FarmModel farm;
  final String? heroImageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero image with Hero animation
        Hero(
          tag: 'farm_image_${farm.id}',
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              ),
              clipBehavior: Clip.antiAlias,
              child: heroImageUrl != null && heroImageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: heroImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _heroPlaceholder(),
                      errorWidget: (_, __, ___) => _heroPlaceholder(),
                    )
                  : _heroPlaceholder(),
            ),
          ),
        ),
        AppSpacing.vGapM,
        // Farm name + badge
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                farm.farmName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            AppSpacing.hGapS,
            VerificationBadge(isVerified: farm.verifiedByLPNM),
          ],
        ),
        AppSpacing.vGapXS,
        // District
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              farm.district,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        // License expiry warning
        if (farm.licenseExpiry != null) ...[
          AppSpacing.vGapS,
          LicenseExpiryBadge(expiryDate: farm.licenseExpiry),
        ],
      ],
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      color: AppColors.primaryContainer,
      child: const Center(
        child: Icon(
          Icons.agriculture,
          size: 64,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Farm detail info section
class FarmDetailSection extends StatelessWidget {
  const FarmDetailSection({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        AppSpacing.vGapHeader,
        child,
      ],
    );
  }
}

/// Collapsible farm detail section with expand/collapse animation
class CollapsibleFarmSection extends StatefulWidget {
  const CollapsibleFarmSection({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.initiallyExpanded = true,
  });

  final String title;
  final Widget child;
  final IconData? icon;
  final bool initiallyExpanded;

  @override
  State<CollapsibleFarmSection> createState() => _CollapsibleFarmSectionState();
}

class _CollapsibleFarmSectionState extends State<CollapsibleFarmSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconRotation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: AppSpacing.animationNormal,
      vsync: this,
    );

    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          // Header (tappable)
          InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusM),
              topRight: Radius.circular(AppSpacing.radiusM),
              bottomLeft: Radius.circular(_isExpanded ? 0 : AppSpacing.radiusM),
              bottomRight: Radius.circular(_isExpanded ? 0 : AppSpacing.radiusM),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.hGapM,
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  RotationTransition(
                    turns: _iconRotation,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          ClipRect(
            child: AnimatedBuilder(
              animation: _heightFactor,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                );
              },
              child: Column(
                children: [
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Info row for farm details
class FarmInfoRow extends StatelessWidget {
  const FarmInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            AppSpacing.hGapS,
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
