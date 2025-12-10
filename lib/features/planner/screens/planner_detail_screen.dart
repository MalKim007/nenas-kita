import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';
import 'package:nenas_kita/features/planner/utils/harvest_status_calculator.dart';
import 'package:nenas_kita/features/planner/widgets/status_timeline.dart';
import 'package:nenas_kita/features/planner/widgets/harvest_status_chip.dart';

/// View Harvest Plan Detail Screen
///
/// Displays comprehensive details of a harvest plan including:
/// - Status timeline with auto-calculation indicator
/// - Plan overview (variety, farm, quantity, created date)
/// - Growth progress visualization
/// - Current status with description
/// - Optional notes
/// - Special celebration view for completed harvests
/// - Edit action button
class PlannerDetailScreen extends ConsumerWidget {
  const PlannerDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(harvestPlanByIdProvider(planId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harvest Plan Details'),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: planAsync.when(
        loading: () => const Center(
          child: AppLoading(size: 48, message: 'Loading plan details...'),
        ),
        error: (error, stack) => AppError(
          title: 'Failed to Load Plan',
          message: error.toString(),
          onRetry: () => ref.invalidate(harvestPlanByIdProvider(planId)),
        ),
        data: (plan) {
          if (plan == null) {
            return NotFoundError(
              itemName: 'Harvest Plan',
              onGoBack: () => context.pop(),
            );
          }

          return _PlanDetailContent(plan: plan);
        },
      ),
    );
  }
}

class _PlanDetailContent extends StatelessWidget {
  const _PlanDetailContent({required this.plan});

  final HarvestPlanModel plan;

  @override
  Widget build(BuildContext context) {
    final isHarvested = plan.status == HarvestStatus.harvested;

    return SingleChildScrollView(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Timeline Section
          _StatusTimelineSection(plan: plan),
          AppSpacing.vGapL,

          // Special Celebration View for Harvested Plans
          if (isHarvested) ...[
            _HarvestedCelebrationCard(plan: plan),
            AppSpacing.vGapL,
          ],

          // Plan Overview Card
          _PlanOverviewCard(plan: plan),
          AppSpacing.vGapL,

          // Growth Progress Section (only for non-harvested)
          if (!isHarvested) ...[
            _GrowthProgressSection(plan: plan),
            AppSpacing.vGapL,
          ],

          // Status Info Card
          _StatusInfoCard(plan: plan),
          AppSpacing.vGapL,

          // Notes Section (only if notes exist)
          if (plan.notes != null && plan.notes!.isNotEmpty) ...[
            _NotesSection(notes: plan.notes!),
            AppSpacing.vGapL,
          ],

          // Action Button
          _EditPlanButton(planId: plan.id),
          AppSpacing.vGapXL,
        ],
      ),
    );
  }
}

/// Status Timeline Section
class _StatusTimelineSection extends StatelessWidget {
  const _StatusTimelineSection({required this.plan});

  final HarvestPlanModel plan;

  @override
  Widget build(BuildContext context) {
    // Use computed status for display (unless harvested which is manual)
    final displayStatus = plan.status == HarvestStatus.harvested
        ? HarvestStatus.harvested
        : plan.computedStatus;
    final isAutoCalculated = plan.status != HarvestStatus.harvested;
    final infoText = plan.statusChangeInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Timeline',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        AppSpacing.vGapS,
        StatusTimeline(
          currentStatus: displayStatus,
          infoText: infoText,
          isAutoCalculated: isAutoCalculated,
        ),
      ],
    );
  }
}

/// Harvested Celebration Card
class _HarvestedCelebrationCard extends StatelessWidget {
  const _HarvestedCelebrationCard({required this.plan});

  final HarvestPlanModel plan;

  @override
  Widget build(BuildContext context) {
    final actualHarvestDate = plan.actualHarvestDate;
    final totalGrowingDays =
        actualHarvestDate != null && plan.plantingDate != null
        ? actualHarvestDate.difference(plan.plantingDate!).inDays
        : null;

    return Container(
      padding: AppSpacing.paddingL,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF16A34A), // Success green
            Color(0xFF15803D), // Darker green
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Celebration header with checkmark icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 48,
              color: Colors.white,
            ),
          ),
          AppSpacing.vGapM,
          Text(
            'Harvest Completed!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGapS,
          if (actualHarvestDate != null) ...[
            _CelebrationInfoRow(
              icon: Icons.event_available,
              label: 'Harvested on',
              value: DateFormat('MMM d, yyyy').format(actualHarvestDate),
            ),
            if (totalGrowingDays != null) ...[
              AppSpacing.vGapS,
              _CelebrationInfoRow(
                icon: Icons.timer,
                label: 'Total growing days',
                value: '$totalGrowingDays days',
              ),
            ],
          ],
          AppSpacing.vGapM,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.done_all, size: 16, color: AppColors.success),
                AppSpacing.hGapS,
                Text(
                  'Completed',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CelebrationInfoRow extends StatelessWidget {
  const _CelebrationInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        AppSpacing.hGapS,
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Plan Overview Card
class _PlanOverviewCard extends StatelessWidget {
  const _PlanOverviewCard({required this.plan});

  final HarvestPlanModel plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingM,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
        boxShadow: AppSpacing.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan Overview',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.vGapM,
          _InfoRow(
            icon: Icons.grass,
            label: 'Variety',
            value: _formatVarietyName(plan.variety),
          ),
          AppSpacing.vGapS,
          _InfoRow(
            icon: Icons.location_on,
            label: 'Business',
            value: plan.farmName,
          ),
          AppSpacing.vGapS,
          _InfoRow(
            icon: Icons.scale,
            label: 'Quantity',
            value: '${plan.quantityKg.toStringAsFixed(0)} kg',
          ),
          AppSpacing.vGapS,
          _InfoRow(
            icon: Icons.calendar_today,
            label: 'Created',
            value: DateFormat('MMM d, yyyy').format(plan.createdAt),
          ),
        ],
      ),
    );
  }

  String _formatVarietyName(String variety) {
    switch (variety) {
      case 'morris':
        return 'Morris';
      case 'josapine':
        return 'Josapine';
      case 'md2':
        return 'MD2';
      case 'sarawak':
        return 'Sarawak';
      case 'yankee':
        return 'Yankee';
      default:
        return variety;
    }
  }
}

/// Growth Progress Section
class _GrowthProgressSection extends StatelessWidget {
  const _GrowthProgressSection({required this.plan});

  final HarvestPlanModel plan;

  @override
  Widget build(BuildContext context) {
    final progress = HarvestStatusCalculator.calculateGrowingProgress(
      plantingDate: plan.plantingDate,
      expectedHarvestDate: plan.expectedHarvestDate,
    );
    final progressPercentage = (progress * 100).toInt();

    final plantingDate = plan.plantingDate;
    final expectedHarvestDate = plan.expectedHarvestDate;

    int? daysAgo;
    int? daysLeft;
    int? totalGrowingDays;

    if (plantingDate != null) {
      daysAgo = DateTime.now().difference(plantingDate).inDays;
      totalGrowingDays = expectedHarvestDate.difference(plantingDate).inDays;
    }

    daysLeft = expectedHarvestDate.difference(DateTime.now()).inDays;

    return Container(
      padding: AppSpacing.paddingM,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Growth Progress',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '$progressPercentage%',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppSpacing.vGapM,
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppColors.outline.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          AppSpacing.vGapM,
          // Date information
          if (plantingDate != null) ...[
            _ProgressInfoRow(
              icon: Icons.wb_sunny,
              label: 'Planted',
              value:
                  '${DateFormat('MMM d, yyyy').format(plantingDate)} ($daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago)',
            ),
            AppSpacing.vGapS,
          ],
          _ProgressInfoRow(
            icon: Icons.event,
            label: 'Expected Harvest',
            value: daysLeft >= 0
                ? '${DateFormat('MMM d, yyyy').format(expectedHarvestDate)} ($daysLeft ${daysLeft == 1 ? 'day' : 'days'} left)'
                : '${DateFormat('MMM d, yyyy').format(expectedHarvestDate)} (${daysLeft.abs()} ${daysLeft.abs() == 1 ? 'day' : 'days'} overdue)',
            valueColor: daysLeft < 0 ? AppColors.error : null,
          ),
          if (totalGrowingDays != null) ...[
            AppSpacing.vGapS,
            _ProgressInfoRow(
              icon: Icons.timeline,
              label: 'Total Growing Period',
              value: '$totalGrowingDays days',
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressInfoRow extends StatelessWidget {
  const _ProgressInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        AppSpacing.hGapS,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.vGapXXS,
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Status Info Card
class _StatusInfoCard extends StatelessWidget {
  const _StatusInfoCard({required this.plan});

  final HarvestPlanModel plan;

  @override
  Widget build(BuildContext context) {
    // Use computed status for display (unless harvested which is manual)
    final displayStatus = plan.status == HarvestStatus.harvested
        ? HarvestStatus.harvested
        : plan.computedStatus;
    final isAutoCalculated = plan.status != HarvestStatus.harvested;
    final statusDescription = HarvestStatusCalculator.getStatusDescription(
      displayStatus,
    );

    return Container(
      padding: AppSpacing.paddingM,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
        boxShadow: AppSpacing.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Status',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.vGapM,
          Row(
            children: [
              HarvestStatusChip(status: displayStatus),
              if (isAutoCalculated) ...[
                AppSpacing.hGapS,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 12, color: AppColors.info),
                      AppSpacing.hGapXXS,
                      Text(
                        'AUTO',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          AppSpacing.vGapS,
          Text(
            statusDescription,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Notes Section
class _NotesSection extends StatelessWidget {
  const _NotesSection({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingM,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
        boxShadow: AppSpacing.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notes, size: 20, color: AppColors.primary),
              AppSpacing.hGapS,
              Text(
                'Notes',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          AppSpacing.vGapM,
          Text(notes, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// Edit Plan Button
class _EditPlanButton extends StatelessWidget {
  const _EditPlanButton({required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: () {
        context.push(RouteNames.farmerPlannerEditPath(planId));
      },
      label: 'Edit Plan',
      icon: Icons.edit,
    );
  }
}

/// Reusable Info Row Widget
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        AppSpacing.hGapM,
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
