import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/core/widgets/section_header.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';
import 'package:nenas_kita/features/planner/utils/harvest_status_calculator.dart';

/// Single most recent harvest plan with progress indicator
/// Shows countdown and status, or empty state with CTA
class LatestHarvestCard extends ConsumerWidget {
  const LatestHarvestCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingHarvestsAsync = ref.watch(myUpcomingHarvestsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Latest Harvest',
          icon: Icons.calendar_today,
        ),
        AppSpacing.vGapM,
        upcomingHarvestsAsync.when(
          data: (harvests) {
            if (harvests.isEmpty) {
              return _buildEmptyState(context);
            }

            final latestHarvest = harvests.first;
            // Use computed status so planned items progress to growing/ready automatically
            final displayStatus = latestHarvest.status == HarvestStatus.harvested
                ? HarvestStatus.harvested
                : latestHarvest.computedStatus;
            final daysUntilHarvest =
                latestHarvest.expectedHarvestDate.difference(DateTime.now()).inDays;
            final progress = _calculateProgress(latestHarvest);

            return Semantics(
              label:
                  'Latest harvest: ${latestHarvest.variety}. Status: ${displayStatus.name}. $daysUntilHarvest days until harvest',
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Variety name + quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            latestHarvest.variety,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        _StatusChip(status: displayStatus),
                      ],
                    ),
                    AppSpacing.vGapXS,
                    // Expected quantity
                    Text(
                      'Expected: ${latestHarvest.quantityKg.toStringAsFixed(0)} kg',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    AppSpacing.vGapM,
                    // Days countdown
                    Row(
                      children: [
                        Icon(
                          _getCountdownIcon(daysUntilHarvest),
                          size: 16,
                          color: _getCountdownColor(daysUntilHarvest),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getCountdownText(daysUntilHarvest),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getCountdownColor(daysUntilHarvest),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    AppSpacing.vGapM,
                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        AppSpacing.vGapXS,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: AppColors.neutral200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(displayStatus),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const AppCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.l),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (_, __) => _buildEmptyState(context),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(
            Icons.event_note,
            size: 48,
            color: AppColors.textDisabled,
          ),
          AppSpacing.vGapM,
          Text(
            'No harvest plans yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          AppSpacing.vGapS,
          Text(
            'Create your first harvest plan to track your pineapple growth',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGapM,
          AppButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push(RouteNames.farmerPlannerAdd);
            },
            label: 'Create Plan',
            icon: Icons.add,
            variant: AppButtonVariant.primary,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  double _calculateProgress(HarvestPlanModel plan) {
    if (plan.status == HarvestStatus.harvested) return 1.0;

    return HarvestStatusCalculator.calculateGrowingProgress(
      plantingDate: plan.plantingDate,
      expectedHarvestDate: plan.expectedHarvestDate,
    ).clamp(0.0, 1.0);
  }

  IconData _getCountdownIcon(int days) {
    if (days < 0) return Icons.error_outline;
    if (days <= 7) return Icons.notifications_active;
    return Icons.schedule;
  }

  Color _getCountdownColor(int days) {
    if (days < 0) return AppColors.error;
    if (days <= 7) return AppColors.warning;
    return AppColors.textSecondary;
  }

  String _getCountdownText(int days) {
    if (days < 0) return '${days.abs()} days overdue';
    if (days == 0) return 'Ready to harvest today';
    if (days == 1) return '1 day until harvest';
    return '$days days until harvest';
  }

  Color _getProgressColor(HarvestStatus status) {
    switch (status) {
      case HarvestStatus.planned:
        return AppColors.info;
      case HarvestStatus.growing:
        return AppColors.warning;
      case HarvestStatus.ready:
      case HarvestStatus.harvested:
        return AppColors.success;
    }
  }
}

/// Status chip with color coding
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final HarvestStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final label = _getStatusLabel();

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
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case HarvestStatus.planned:
        return AppColors.info;
      case HarvestStatus.growing:
        return AppColors.warning;
      case HarvestStatus.ready:
      case HarvestStatus.harvested:
        return AppColors.success;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case HarvestStatus.planned:
        return 'Planned';
      case HarvestStatus.growing:
        return 'Growing';
      case HarvestStatus.ready:
        return 'Ready';
      case HarvestStatus.harvested:
        return 'Harvested';
    }
  }
}
