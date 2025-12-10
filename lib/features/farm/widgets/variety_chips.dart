import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Display pineapple variety chips (read-only)
class VarietyChips extends StatelessWidget {
  const VarietyChips({
    super.key,
    required this.varieties,
    this.maxDisplay,
  });

  final List<String> varieties;
  final int? maxDisplay;

  @override
  Widget build(BuildContext context) {
    if (varieties.isEmpty) {
      return Text(
        'No varieties specified',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      );
    }

    final displayList = maxDisplay != null && varieties.length > maxDisplay!
        ? varieties.take(maxDisplay!).toList()
        : varieties;

    final remainingCount = varieties.length - displayList.length;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        ...displayList.map((variety) => _VarietyChip(variety: variety)),
        if (remainingCount > 0)
          _MoreChip(count: remainingCount),
      ],
    );
  }
}

class _VarietyChip extends StatelessWidget {
  const _VarietyChip({required this.variety});

  final String variety;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        variety,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onSecondaryContainer,
            ),
      ),
    );
  }
}

class _MoreChip extends StatelessWidget {
  const _MoreChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        '+$count more',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}

/// Selectable variety chips for forms
class VarietySelector extends StatelessWidget {
  const VarietySelector({
    super.key,
    required this.selectedVarieties,
    required this.onChanged,
  });

  final List<String> selectedVarieties;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: PineappleVariety.values.map((variety) {
        final isSelected = selectedVarieties.contains(variety.displayName);
        return FilterChip(
          label: Text(variety.displayName),
          selected: isSelected,
          onSelected: (selected) {
            final newList = List<String>.from(selectedVarieties);
            if (selected) {
              newList.add(variety.displayName);
            } else {
              newList.remove(variety.displayName);
            }
            onChanged(newList);
          },
          selectedColor: AppColors.secondaryContainer,
          checkmarkColor: AppColors.onSecondaryContainer,
          labelStyle: TextStyle(
            color: isSelected
                ? AppColors.onSecondaryContainer
                : AppColors.textPrimary,
          ),
        );
      }).toList(),
    );
  }
}

/// Single variety dropdown selector
class VarietyDropdown extends StatelessWidget {
  const VarietyDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Variety',
    this.isRequired = false,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        border: const OutlineInputBorder(),
      ),
      items: PineappleVariety.values.map((variety) {
        return DropdownMenuItem<String>(
          value: variety.displayName,
          child: Text(variety.displayName),
        );
      }).toList(),
      onChanged: onChanged,
      validator: isRequired
          ? (value) => value == null || value.isEmpty ? 'Please select a variety' : null
          : null,
    );
  }
}
