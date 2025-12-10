import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/widgets/harvest_status_chip.dart';

/// Card displaying harvest plan summary with status and countdown.
///
/// Shows:
/// - Variety name
/// - Quantity in kg
/// - Status chip
/// - Days countdown or overdue warning
/// - Tap to navigate to details
class HarvestPlanCard extends StatelessWidget {
  /// The harvest plan to display.
  final HarvestPlanModel plan;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  const HarvestPlanCard({super.key, required this.plan, this.onTap});

  /// Calculate days until expected harvest or overdue days.
  ({int days, bool isOverdue}) _calculateCountdown() {
    final now = DateTime.now();
    final expectedDate = plan.expectedHarvestDate;
    final difference = expectedDate.difference(now).inDays;

    return (days: difference.abs(), isOverdue: difference < 0);
  }

  String _formatVarietyName(String variety) {
    // Convert variety string to display name
    final pineappleVariety = PineappleVariety.fromString(variety);
    return pineappleVariety.displayName;
  }

  @override
  Widget build(BuildContext context) {
    final countdown = _calculateCountdown();
    final dateFormat = DateFormat('dd MMM yyyy');

    // Use computed status for display (unless harvested which is manual)
    final displayStatus = plan.status == HarvestStatus.harvested
        ? HarvestStatus.harvested
        : plan.computedStatus;

    return AppCard(
      onTap: () {
        if (onTap != null) {
          HapticFeedback.selectionClick();
          onTap!();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Variety and Status
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatVarietyName(plan.variety),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              HarvestStatusChip(status: displayStatus),
            ],
          ),
          SizedBox(height: AppSpacing.m),

          // Quantity
          Row(
            children: [
              Icon(Icons.scale, size: 18, color: AppColors.textSecondary),
              SizedBox(width: AppSpacing.s),
              Text(
                '${plan.quantityKg.toStringAsFixed(0)} kg',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.s),

          // Planting Date
          if (plan.plantingDate != null)
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppSpacing.s),
                Text(
                  'Planted: ${dateFormat.format(plan.plantingDate!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          SizedBox(height: AppSpacing.s),

          // Expected Harvest Date
          Row(
            children: [
              Icon(
                Icons.event_available,
                size: 18,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSpacing.s),
              Text(
                'Expected: ${dateFormat.format(plan.expectedHarvestDate)}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.m),

          // Countdown or Overdue Warning
          if (displayStatus != HarvestStatus.harvested) ...[
            Divider(height: 1, color: AppColors.outline),
            SizedBox(height: AppSpacing.m),
            _CountdownDisplay(
              days: countdown.days,
              isOverdue: countdown.isOverdue,
            ),
          ],

          // View Details Indicator
          SizedBox(height: AppSpacing.m),
          Divider(height: 1, color: AppColors.outline),
          SizedBox(height: AppSpacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tap to view details',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountdownDisplay extends StatelessWidget {
  final int days;
  final bool isOverdue;

  const _CountdownDisplay({required this.days, required this.isOverdue});

  @override
  Widget build(BuildContext context) {
    if (isOverdue) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.error),
            SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                'Overdue by $days ${days == 1 ? 'day' : 'days'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 20, color: AppColors.primary),
            SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                '$days ${days == 1 ? 'day' : 'days'} until harvest',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
