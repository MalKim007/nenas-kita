import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Price units - fixed list only
enum PriceUnit {
  perKg('per kg'),
  perPiece('per piece'),
  perBottle('per bottle');

  const PriceUnit(this.label);
  final String label;

  static PriceUnit fromString(String value) {
    return PriceUnit.values.firstWhere(
      (e) => e.label == value || e.name == value,
      orElse: () => PriceUnit.perKg,
    );
  }
}

/// Price input with RM prefix and unit selector
class PriceInput extends StatelessWidget {
  const PriceInput({
    super.key,
    required this.controller,
    required this.unit,
    required this.onUnitChanged,
    this.label = 'Price',
    this.isRequired = true,
    this.showUnitSelector = true,
    this.validator,
  });

  final TextEditingController controller;
  final PriceUnit unit;
  final ValueChanged<PriceUnit> onUnitChanged;
  final String label;
  final bool isRequired;
  final bool showUnitSelector;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price field
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: isRequired ? '$label *' : label,
            border: const OutlineInputBorder(),
            prefixText: 'RM ',
            prefixStyle: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            suffixText: showUnitSelector ? null : unit.label,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          validator: validator ??
              (v) {
                if (isRequired && (v == null || v.isEmpty)) {
                  return 'Required';
                }
                if (v != null && v.isNotEmpty) {
                  final value = double.tryParse(v);
                  if (value == null || value <= 0) {
                    return 'Invalid price';
                  }
                }
                return null;
              },
        ),
        if (showUnitSelector) ...[
          AppSpacing.vGapS,
          PriceUnitSelector(
            selected: unit,
            onChanged: onUnitChanged,
          ),
        ],
      ],
    );
  }
}

/// Price unit selector chips
class PriceUnitSelector extends StatelessWidget {
  const PriceUnitSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PriceUnit selected;
  final ValueChanged<PriceUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s,
      children: PriceUnit.values.map((unit) {
        final isSelected = selected == unit;
        return ChoiceChip(
          label: Text(unit.label),
          selected: isSelected,
          onSelected: (_) => onChanged(unit),
          showCheckmark: false,
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.primaryContainer,
          labelStyle: TextStyle(
            color: isSelected
                ? AppColors.onPrimaryContainer
                : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          side: isSelected
              ? BorderSide.none
              : const BorderSide(color: AppColors.outline),
        );
      }).toList(),
    );
  }
}

/// Wholesale price section (optional)
class WholesalePriceInput extends StatelessWidget {
  const WholesalePriceInput({
    super.key,
    required this.priceController,
    required this.minQtyController,
    required this.enabled,
    required this.onEnabledChanged,
    required this.priceUnit,
  });

  final TextEditingController priceController;
  final TextEditingController minQtyController;
  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final PriceUnit priceUnit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enable toggle
        SwitchListTile(
          title: const Text('Wholesale Pricing'),
          subtitle: const Text('Offer discount for bulk orders'),
          value: enabled,
          onChanged: onEnabledChanged,
          contentPadding: EdgeInsets.zero,
        ),
        if (enabled) ...[
          AppSpacing.vGapS,
          // Wholesale price
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Wholesale Price',
              border: const OutlineInputBorder(),
              prefixText: 'RM ',
              prefixStyle: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              suffixText: priceUnit.label,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            validator: (v) {
              if (enabled && (v == null || v.isEmpty)) {
                return 'Required when wholesale is enabled';
              }
              if (v != null && v.isNotEmpty) {
                final value = double.tryParse(v);
                if (value == null || value <= 0) {
                  return 'Invalid price';
                }
              }
              return null;
            },
          ),
          AppSpacing.vGapM,
          // Minimum quantity
          TextFormField(
            controller: minQtyController,
            decoration: InputDecoration(
              labelText: 'Minimum Quantity',
              border: const OutlineInputBorder(),
              suffixText: _quantityUnit,
              helperText: 'Minimum order for wholesale price',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (v) {
              if (enabled && (v == null || v.isEmpty)) {
                return 'Required';
              }
              if (v != null && v.isNotEmpty) {
                final value = int.tryParse(v);
                if (value == null || value < 1) {
                  return 'Minimum 1';
                }
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  String get _quantityUnit {
    switch (priceUnit) {
      case PriceUnit.perKg:
        return 'kg';
      case PriceUnit.perPiece:
        return 'pcs';
      case PriceUnit.perBottle:
        return 'bottles';
    }
  }
}

/// Price display widget
class PriceDisplay extends StatelessWidget {
  const PriceDisplay({
    super.key,
    required this.price,
    required this.unit,
    this.wholesalePrice,
    this.wholesaleMinQty,
    this.size = PriceDisplaySize.medium,
  });

  final double price;
  final String unit;
  final double? wholesalePrice;
  final double? wholesaleMinQty;
  final PriceDisplaySize size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main price
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'RM ${price.toStringAsFixed(2)}',
              style: _priceStyle(context),
            ),
            AppSpacing.hGapXS,
            Text(
              unit,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        // Wholesale price
        if (wholesalePrice != null && wholesaleMinQty != null) ...[
          AppSpacing.vGapXS,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusS),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_offer,
                  size: 14,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'RM ${wholesalePrice!.toStringAsFixed(2)} $unit (min ${wholesaleMinQty!.toStringAsFixed(0)})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSecondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  TextStyle? _priceStyle(BuildContext context) {
    switch (size) {
      case PriceDisplaySize.small:
        return Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            );
      case PriceDisplaySize.medium:
        return Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            );
      case PriceDisplaySize.large:
        return Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            );
    }
  }
}

enum PriceDisplaySize { small, medium, large }
