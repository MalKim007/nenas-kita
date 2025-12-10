import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';

/// Custom map marker for farms
/// - Green (AppColors.secondary) for verified farms
/// - Amber (AppColors.primary) for unverified farms
/// - AnimatedScale for selection state with haptic feedback
class FarmMapMarker extends StatelessWidget {
  const FarmMapMarker({
    super.key,
    required this.isVerified,
    required this.onTap,
    this.isSelected = false,
  });

  final bool isVerified;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final markerColor = isVerified ? AppColors.secondary : AppColors.primary;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: markerColor.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  )
                : null,
            padding: isSelected ? const EdgeInsets.all(2) : null,
            child: Icon(
              Icons.location_pin,
              color: markerColor,
              size: 40,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
