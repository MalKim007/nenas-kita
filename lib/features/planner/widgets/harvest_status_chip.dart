import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Status chip displaying harvest plan status with color-coded design.
///
/// Shows an icon, label, and background color based on [HarvestStatus]:
/// - planned: Blue (#2563EB) with calendar icon
/// - growing: Amber (#D97706) with grass icon
/// - ready: Green (#16A34A) with check_circle icon
/// - harvested: Gray (#6B7280) with done_all icon
class HarvestStatusChip extends StatelessWidget {
  /// The harvest status to display.
  final HarvestStatus status;

  /// Optional custom size for the chip. Defaults to medium.
  final double? height;

  /// Whether to show full label or compact version.
  final bool compact;

  const HarvestStatusChip({
    super.key,
    required this.status,
    this.height,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      height: height ?? 32,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.s : AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: config.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 16,
            color: config.color,
          ),
          if (!compact) ...[
            SizedBox(width: AppSpacing.xs),
            Text(
              config.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: config.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(HarvestStatus status) {
    switch (status) {
      case HarvestStatus.planned:
        return _StatusConfig(
          color: AppColors.info,
          icon: Icons.calendar_today,
          label: 'Planned',
        );
      case HarvestStatus.growing:
        return _StatusConfig(
          color: AppColors.primary,
          icon: Icons.grass,
          label: 'Growing',
        );
      case HarvestStatus.ready:
        return _StatusConfig(
          color: AppColors.success,
          icon: Icons.check_circle,
          label: 'Ready',
        );
      case HarvestStatus.harvested:
        return _StatusConfig(
          color: const Color(0xFF6B7280),
          icon: Icons.done_all,
          label: 'Harvested',
        );
    }
  }
}

class _StatusConfig {
  final Color color;
  final IconData icon;
  final String label;

  _StatusConfig({
    required this.color,
    required this.icon,
    required this.label,
  });
}
