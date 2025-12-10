import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Branded pineapple placeholder for images while loading
/// Uses a pineapple icon with brand colors
class PineapplePlaceholder extends StatelessWidget {
  const PineapplePlaceholder({
    super.key,
    this.size,
    this.iconSize,
    this.backgroundColor,
  });

  /// Total size of the placeholder container
  final double? size;

  /// Size of the pineapple icon (defaults to 1/3 of container or 40)
  final double? iconSize;

  /// Background color (defaults to primaryContainer)
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: backgroundColor ?? AppColors.primaryContainer,
      child: Center(
        child: Icon(
          Icons.local_florist, // Using florist icon as pineapple-like
          size: iconSize ?? (size != null ? size! / 3 : 40),
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

/// Square pineapple placeholder with rounded corners
class PineapplePlaceholderRounded extends StatelessWidget {
  const PineapplePlaceholderRounded({
    super.key,
    this.size,
    this.iconSize,
    this.borderRadius,
  });

  final double? size;
  final double? iconSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusM),
      ),
      child: Center(
        child: Icon(
          Icons.local_florist,
          size: iconSize ?? (size != null ? size! / 3 : 40),
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

/// Aspect ratio pineapple placeholder
class PineapplePlaceholderAspect extends StatelessWidget {
  const PineapplePlaceholderAspect({
    super.key,
    this.aspectRatio = 1.0,
    this.iconSize,
    this.borderRadius,
  });

  final double aspectRatio;
  final double? iconSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null,
        ),
        child: Center(
          child: Icon(
            Icons.local_florist,
            size: iconSize ?? 48,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
