import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';

/// Conditional alert banner for overdue harvests
/// Only displays when there are overdue harvest plans
class OverdueHarvestBanner extends ConsumerWidget {
  const OverdueHarvestBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overduePlansAsync = ref.watch(myOverduePlansProvider);

    return overduePlansAsync.when(
      data: (overduePlans) {
        if (overduePlans.isEmpty) {
          return const SizedBox.shrink();
        }

        return Semantics(
          label: 'Warning: You have ${overduePlans.length} overdue harvest plans',
          button: true,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              context.push(RouteNames.farmerPlanner);
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            child: Container(
              padding: AppSpacing.paddingM,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: const Border(
                  left: BorderSide(
                    color: AppColors.error,
                    width: 4,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: AppColors.error,
                      size: 24,
                    ),
                  ),
                  AppSpacing.hGapM,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overdue Harvest',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        AppSpacing.vGapXXS,
                        Text(
                          'You have ${overduePlans.length} overdue harvest${overduePlans.length > 1 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.error,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
