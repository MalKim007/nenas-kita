import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// LPNM verification badge widget
/// Shows verified/pending status with icon + color + label (accessibility compliant)
class VerificationBadge extends StatelessWidget {
  const VerificationBadge({
    super.key,
    required this.isVerified,
    this.size = VerificationBadgeSize.medium,
    this.showLabel = true,
  });

  final bool isVerified;
  final VerificationBadgeSize size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final color = isVerified ? AppColors.verified : AppColors.pending;
    final icon = isVerified ? Icons.verified : Icons.pending;
    final label = isVerified ? 'LPNM Verified' : 'Pending';

    final iconSize = switch (size) {
      VerificationBadgeSize.small => 14.0,
      VerificationBadgeSize.medium => 18.0,
      VerificationBadgeSize.large => 24.0,
    };

    final textStyle = switch (size) {
      VerificationBadgeSize.small => Theme.of(context).textTheme.labelSmall,
      VerificationBadgeSize.medium => Theme.of(context).textTheme.labelMedium,
      VerificationBadgeSize.large => Theme.of(context).textTheme.labelLarge,
    };

    if (!showLabel) {
      return Tooltip(
        message: label,
        child: Icon(icon, color: color, size: iconSize),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == VerificationBadgeSize.small ? AppSpacing.xs : AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(width: size == VerificationBadgeSize.small ? 2 : 4),
          Text(
            label,
            style: textStyle?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

enum VerificationBadgeSize { small, medium, large }

/// Simple verified icon for inline use
class VerifiedIcon extends StatelessWidget {
  const VerifiedIcon({
    super.key,
    this.size = 18.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'LPNM Verified',
      child: Icon(
        Icons.verified,
        color: AppColors.verified,
        size: size,
      ),
    );
  }
}

/// License expiry warning badge
class LicenseExpiryBadge extends StatelessWidget {
  const LicenseExpiryBadge({
    super.key,
    required this.expiryDate,
    this.warningDays = 30,
  });

  final DateTime? expiryDate;
  final int warningDays;

  @override
  Widget build(BuildContext context) {
    if (expiryDate == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final daysUntilExpiry = expiryDate!.difference(now).inDays;
    final isExpired = daysUntilExpiry < 0;
    final isWarning = daysUntilExpiry >= 0 && daysUntilExpiry <= warningDays;

    if (!isExpired && !isWarning) return const SizedBox.shrink();

    final color = isExpired ? AppColors.error : AppColors.warning;
    final icon = isExpired ? Icons.error : Icons.warning;
    final message = isExpired
        ? 'License expired'
        : 'License expires in $daysUntilExpiry days';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            message,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
