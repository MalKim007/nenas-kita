import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Stock status selector - instant change (no confirmation dialog)
class StockStatusSelector extends StatelessWidget {
  const StockStatusSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final StockStatus selected;
  final ValueChanged<StockStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: StockStatus.values.map((status) {
        return _StockOption(
          status: status,
          isSelected: selected == status,
          onTap: () => onChanged(status),
        );
      }).toList(),
    );
  }
}

class _StockOption extends StatelessWidget {
  const _StockOption({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  final StockStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          decoration: BoxDecoration(
            color: isSelected ? _backgroundColor : AppColors.surface,
            border: Border.all(
              color: isSelected ? _borderColor : AppColors.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          ),
          child: Row(
            children: [
              // Radio indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? _borderColor : AppColors.outline,
                    width: 2,
                  ),
                  color: isSelected ? _borderColor : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.onPrimary,
                      )
                    : null,
              ),
              AppSpacing.hGapM,
              // Icon
              Icon(
                _icon,
                size: 24,
                color: isSelected ? _iconColor : AppColors.textSecondary,
              ),
              AppSpacing.hGapS,
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected
                                ? _textColor
                                : AppColors.textPrimary,
                          ),
                    ),
                    Text(
                      _description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case StockStatus.available:
        return AppColors.secondaryContainer;
      case StockStatus.limited:
        return AppColors.primaryContainer;
      case StockStatus.out:
        return AppColors.error.withValues(alpha: 0.1);
    }
  }

  Color get _borderColor {
    switch (status) {
      case StockStatus.available:
        return AppColors.secondary;
      case StockStatus.limited:
        return AppColors.warning;
      case StockStatus.out:
        return AppColors.error;
    }
  }

  Color get _iconColor {
    switch (status) {
      case StockStatus.available:
        return AppColors.secondary;
      case StockStatus.limited:
        return AppColors.warning;
      case StockStatus.out:
        return AppColors.error;
    }
  }

  Color get _textColor {
    switch (status) {
      case StockStatus.available:
        return AppColors.onSecondaryContainer;
      case StockStatus.limited:
        return AppColors.onPrimaryContainer;
      case StockStatus.out:
        return AppColors.error;
    }
  }

  IconData get _icon {
    switch (status) {
      case StockStatus.available:
        return Icons.check_circle;
      case StockStatus.limited:
        return Icons.warning;
      case StockStatus.out:
        return Icons.cancel;
    }
  }

  String get _label {
    switch (status) {
      case StockStatus.available:
        return 'Available';
      case StockStatus.limited:
        return 'Limited Stock';
      case StockStatus.out:
        return 'Out of Stock';
    }
  }

  String get _description {
    switch (status) {
      case StockStatus.available:
        return 'Ready to sell, stock is sufficient';
      case StockStatus.limited:
        return 'Running low, limited quantity';
      case StockStatus.out:
        return 'Currently unavailable';
    }
  }
}

/// Compact inline stock status selector
class StockStatusChips extends StatelessWidget {
  const StockStatusChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final StockStatus selected;
  final ValueChanged<StockStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s,
      children: StockStatus.values.map((status) {
        final isSelected = selected == status;
        return ChoiceChip(
          label: Text(_labelFor(status)),
          selected: isSelected,
          onSelected: (_) => onChanged(status),
          showCheckmark: false,
          avatar: Icon(
            _iconFor(status),
            size: 16,
            color: isSelected ? _colorFor(status) : AppColors.textSecondary,
          ),
          backgroundColor: AppColors.surface,
          selectedColor: _backgroundFor(status),
        );
      }).toList(),
    );
  }

  String _labelFor(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return 'Available';
      case StockStatus.limited:
        return 'Limited';
      case StockStatus.out:
        return 'Out';
    }
  }

  IconData _iconFor(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return Icons.check_circle;
      case StockStatus.limited:
        return Icons.warning;
      case StockStatus.out:
        return Icons.cancel;
    }
  }

  Color _colorFor(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return AppColors.secondary;
      case StockStatus.limited:
        return AppColors.warning;
      case StockStatus.out:
        return AppColors.error;
    }
  }

  Color _backgroundFor(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return AppColors.secondaryContainer;
      case StockStatus.limited:
        return AppColors.primaryContainer;
      case StockStatus.out:
        return AppColors.error.withValues(alpha: 0.1);
    }
  }
}
