import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Category selector (Fresh/Processed toggle)
class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ProductCategory selected;
  final ValueChanged<ProductCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CategoryOption(
            category: ProductCategory.fresh,
            isSelected: selected == ProductCategory.fresh,
            onTap: () => onChanged(ProductCategory.fresh),
          ),
        ),
        AppSpacing.hGapM,
        Expanded(
          child: _CategoryOption(
            category: ProductCategory.processed,
            isSelected: selected == ProductCategory.processed,
            onTap: () => onChanged(ProductCategory.processed),
          ),
        ),
      ],
    );
  }
}

class _CategoryOption extends StatelessWidget {
  const _CategoryOption({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final ProductCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFresh = category == ProductCategory.fresh;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.m,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isFresh ? AppColors.secondaryContainer : AppColors.primaryContainer)
              : AppColors.surface,
          border: Border.all(
            color: isSelected
                ? (isFresh ? AppColors.secondary : AppColors.primary)
                : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFresh ? Icons.eco : Icons.inventory_2,
              size: 32,
              color: isSelected
                  ? (isFresh ? AppColors.secondary : AppColors.primary)
                  : AppColors.textSecondary,
            ),
            AppSpacing.vGapS,
            Text(
              isFresh ? 'Fresh' : 'Processed',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? (isFresh
                            ? AppColors.onSecondaryContainer
                            : AppColors.onPrimaryContainer)
                        : AppColors.textSecondary,
                  ),
            ),
            AppSpacing.vGapXS,
            Text(
              isFresh ? 'Whole fruits' : 'Products & goods',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact category chip filter with pill-shaped, colored styling
class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
    this.showAll = true,
  });

  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onChanged;
  final bool showAll;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s,
      children: [
        if (showAll)
          _PillChip(
            label: 'All',
            icon: Icons.grid_view,
            isSelected: selected == null,
            selectedColor: AppColors.primary,
            onTap: () => onChanged(null),
          ),
        _PillChip(
          label: 'Fresh',
          icon: Icons.eco,
          isSelected: selected == ProductCategory.fresh,
          selectedColor: AppColors.secondary,
          onTap: () => onChanged(ProductCategory.fresh),
        ),
        _PillChip(
          label: 'Processed',
          icon: Icons.inventory_2,
          isSelected: selected == ProductCategory.processed,
          selectedColor: AppColors.primary,
          onTap: () => onChanged(ProductCategory.processed),
        ),
      ],
    );
  }
}

/// Pill-shaped filter chip with icon and color
class _PillChip extends StatelessWidget {
  const _PillChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? selectedColor : AppColors.outline,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.surface : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.surface : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
