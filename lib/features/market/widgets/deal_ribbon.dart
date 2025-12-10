import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';

/// Diagonal ribbon label positioned at the top-left corner of product card.
///
/// Used to highlight top 3 results:
/// - BEST VALUE (amber/warning)
/// - CHEAPEST (green/success)
/// - CLOSEST (teal/tertiary)
class DealRibbon extends StatelessWidget {
  const DealRibbon({
    super.key,
    required this.type,
  });

  /// Type of ribbon to display
  final DealRibbonType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      top: 8,
      left: -20,
      child: Transform.rotate(
        angle: -0.785398, // -45 degrees in radians
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
          decoration: BoxDecoration(
            color: type.color,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            type.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Types of deal ribbons
enum DealRibbonType {
  bestValue,
  cheapest,
  closest;

  /// Get label text for this ribbon type
  String get label {
    switch (this) {
      case DealRibbonType.bestValue:
        return 'BEST VALUE';
      case DealRibbonType.cheapest:
        return 'CHEAPEST';
      case DealRibbonType.closest:
        return 'CLOSEST';
    }
  }

  /// Get color for this ribbon type
  Color get color {
    switch (this) {
      case DealRibbonType.bestValue:
        return AppColors.warning; // Amber
      case DealRibbonType.cheapest:
        return AppColors.success; // Green
      case DealRibbonType.closest:
        return AppColors.tertiary; // Teal
    }
  }
}
