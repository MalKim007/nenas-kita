import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';

/// Stats card showing product count and other farm metrics
class FarmStatsCard extends ConsumerWidget {
  const FarmStatsCard({
    super.key,
    required this.farmId,
    this.onProductsTap,
    this.onRequestsTap,
  });

  final String farmId;
  final VoidCallback? onProductsTap;
  final VoidCallback? onRequestsTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productCountAsync = ref.watch(productCountByFarmProvider(farmId));

    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.inventory_2,
            label: 'Products',
            value: productCountAsync.when(
              data: (count) => count.toString(),
              loading: () => '-',
              error: (_, __) => '0',
            ),
            color: AppColors.primary,
            onTap: onProductsTap,
          ),
        ),
        AppSpacing.hGapM,
        Expanded(
          child: _StatItem(
            icon: Icons.shopping_bag,
            label: 'Requests',
            value: '0', // TODO: Wire up buyer requests count in Phase 6
            color: AppColors.secondary,
            onTap: onRequestsTap,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: color,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Larger icon container (48x48)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    AppSpacing.hGapM,
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                  ],
                ),
                AppSpacing.vGapS,
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact stats row for dashboard
class CompactStatsRow extends StatelessWidget {
  const CompactStatsRow({
    super.key,
    required this.stats,
  });

  final List<CompactStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: _CompactStatItem(stat: stat),
        );
      }).toList(),
    );
  }
}

class _CompactStatItem extends StatelessWidget {
  const _CompactStatItem({required this.stat});

  final CompactStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          stat.value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: stat.color ?? AppColors.textPrimary,
              ),
        ),
        AppSpacing.vGapXS,
        Text(
          stat.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class CompactStat {
  const CompactStat({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;
}
