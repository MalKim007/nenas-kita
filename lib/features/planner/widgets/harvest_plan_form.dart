import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_text_field.dart';
import 'package:nenas_kita/features/planner/utils/harvest_status_calculator.dart';
import 'package:nenas_kita/features/planner/widgets/date_range_picker.dart';
import 'package:nenas_kita/features/planner/widgets/harvest_status_chip.dart';

/// Shared form widget for creating and editing harvest plans.
///
/// Features:
/// - Variety dropdown (PineappleVariety enum)
/// - Quantity input (kg) with validation
/// - Date range picker with auto-calculation
/// - Notes textarea
/// - Optional status selector (for edit mode)
class HarvestPlanForm extends StatefulWidget {
  /// Initial variety selection.
  final PineappleVariety? initialVariety;

  /// Initial quantity in kg.
  final double? initialQuantity;

  /// Initial planting date.
  final DateTime? initialPlantingDate;

  /// Initial expected harvest date.
  final DateTime? initialExpectedHarvestDate;

  /// Initial notes.
  final String? initialNotes;

  /// Initial status (only used if showStatusSelector is true).
  final HarvestStatus? initialStatus;

  /// Whether to show status selector (edit mode).
  final bool showStatusSelector;

  /// Form key for validation.
  final GlobalKey<FormState> formKey;

  /// Callback when variety changes.
  final ValueChanged<PineappleVariety> onVarietyChanged;

  /// Callback when quantity changes.
  final ValueChanged<double> onQuantityChanged;

  /// Callback when planting date changes.
  final ValueChanged<DateTime> onPlantingDateChanged;

  /// Callback when expected harvest date changes.
  final ValueChanged<DateTime> onExpectedHarvestDateChanged;

  /// Callback when notes change.
  final ValueChanged<String> onNotesChanged;

  /// Callback when status changes (only called if showStatusSelector is true).
  final ValueChanged<HarvestStatus>? onStatusChanged;

  const HarvestPlanForm({
    super.key,
    this.initialVariety,
    this.initialQuantity,
    this.initialPlantingDate,
    this.initialExpectedHarvestDate,
    this.initialNotes,
    this.initialStatus,
    this.showStatusSelector = false,
    required this.formKey,
    required this.onVarietyChanged,
    required this.onQuantityChanged,
    required this.onPlantingDateChanged,
    required this.onExpectedHarvestDateChanged,
    required this.onNotesChanged,
    this.onStatusChanged,
  });

  @override
  State<HarvestPlanForm> createState() => _HarvestPlanFormState();
}

class _HarvestPlanFormState extends State<HarvestPlanForm> {
  late PineappleVariety _selectedVariety;
  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  late HarvestStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedVariety = widget.initialVariety ?? PineappleVariety.morris;
    _selectedStatus = widget.initialStatus ?? HarvestStatus.planned;

    _quantityController = TextEditingController(
      text: widget.initialQuantity?.toStringAsFixed(0) ?? '',
    );
    _quantityController.addListener(_onQuantityChanged);

    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _notesController.addListener(_onNotesChanged);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onQuantityChanged() {
    final text = _quantityController.text;
    final quantity = double.tryParse(text);
    if (quantity != null && quantity > 0) {
      widget.onQuantityChanged(quantity);
    }
  }

  void _onNotesChanged() {
    widget.onNotesChanged(_notesController.text);
  }

  String _formatVarietyName(PineappleVariety variety) {
    switch (variety) {
      case PineappleVariety.morris:
        return 'Morris';
      case PineappleVariety.josapine:
        return 'Josapine';
      case PineappleVariety.md2:
        return 'MD2';
      case PineappleVariety.sarawak:
        return 'Sarawak';
      case PineappleVariety.yankee:
        return 'Yankee';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Variety Dropdown
          Text(
            'Pineapple Variety',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.s),
          DropdownButtonFormField<PineappleVariety>(
            value: _selectedVariety,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              prefixIcon: Icon(Icons.local_florist, color: AppColors.primary),
            ),
            items: PineappleVariety.values.map((variety) {
              return DropdownMenuItem(
                value: variety,
                child: Text(_formatVarietyName(variety)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedVariety = value;
                });
                widget.onVarietyChanged(value);
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a variety';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.l),

          // Quantity Input
          AppTextField(
            label: 'Estimated Quantity (kg)',
            controller: _quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            prefixIcon: Icons.scale,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter quantity';
              }
              final quantity = double.tryParse(value);
              if (quantity == null || quantity <= 0) {
                return 'Please enter a valid quantity';
              }
              if (quantity > 100000) {
                return 'Quantity must be less than 100,000 kg';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.l),

          // Date Range Picker
          DateRangePicker(
            plantingDate: widget.initialPlantingDate,
            expectedHarvestDate: widget.initialExpectedHarvestDate,
            onPlantingDateChanged: widget.onPlantingDateChanged,
            onExpectedHarvestDateChanged: widget.onExpectedHarvestDateChanged,
          ),
          SizedBox(height: AppSpacing.l),

          // Status Display & Harvested Toggle (Edit Mode Only)
          if (widget.showStatusSelector) ...[
            // Current Status Display Card
            _buildCurrentStatusCard(context),
            SizedBox(height: AppSpacing.l),

            // Harvested Toggle
            _buildHarvestedToggle(context),
            SizedBox(height: AppSpacing.l),
          ],

          // Notes Textarea
          AppTextField(
            label: 'Notes (Optional)',
            controller: _notesController,
            maxLines: 4,
            maxLength: 500,
            helperText: 'Add any additional notes about this harvest plan',
            prefixIcon: Icons.notes,
          ),
        ],
      ),
    );
  }

  /// Calculate computed status based on current dates
  HarvestStatus _getComputedStatus() {
    return HarvestStatusCalculator.calculateStatus(
      plantingDate: widget.initialPlantingDate,
      expectedHarvestDate:
          widget.initialExpectedHarvestDate ??
          DateTime.now().add(const Duration(days: 90)),
    );
  }

  /// Get status change info text
  String _getStatusChangeInfo() {
    return HarvestStatusCalculator.getStatusChangeInfo(
      plantingDate: widget.initialPlantingDate,
      expectedHarvestDate:
          widget.initialExpectedHarvestDate ??
          DateTime.now().add(const Duration(days: 90)),
      currentStatus: _selectedStatus,
    );
  }

  /// Build the current status display card
  Widget _buildCurrentStatusCard(BuildContext context) {
    final computedStatus = _getComputedStatus();
    final isHarvested = _selectedStatus == HarvestStatus.harvested;
    final displayStatus = isHarvested
        ? HarvestStatus.harvested
        : computedStatus;

    return Container(
      padding: EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.primary),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Current Status',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              if (!isHarvested)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 10, color: AppColors.info),
                      SizedBox(width: 3),
                      Text(
                        'AUTO',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.s),
          Row(
            children: [
              HarvestStatusChip(status: displayStatus, compact: false),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            HarvestStatusCalculator.getStatusDescription(displayStatus),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          if (!isHarvested) ...[
            SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: AppColors.primary),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _getStatusChangeInfo(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build the harvested toggle switch
  Widget _buildHarvestedToggle(BuildContext context) {
    final isHarvested = _selectedStatus == HarvestStatus.harvested;

    return Container(
      decoration: BoxDecoration(
        color: isHarvested
            ? AppColors.success.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHarvested
              ? AppColors.success.withValues(alpha: 0.5)
              : AppColors.outline,
          width: isHarvested ? 2 : 1,
        ),
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Icon(
              Icons.done_all,
              size: 20,
              color: isHarvested ? AppColors.success : AppColors.textSecondary,
            ),
            SizedBox(width: AppSpacing.s),
            Text(
              'Mark as Harvested',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isHarvested ? AppColors.success : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(left: 28),
          child: Text(
            isHarvested
                ? 'Harvest completed! Toggle off to revert.'
                : 'Toggle when harvest is complete',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        value: isHarvested,
        activeColor: AppColors.success,
        onChanged: (value) async {
          // If toggling ON (marking as harvested), show confirmation
          if (value) {
            final confirmed = await _showHarvestConfirmation(context);
            if (!confirmed) return;
          }
          // If toggling OFF (reverting), also confirm
          else {
            final confirmed = await _showRevertConfirmation(context);
            if (!confirmed) return;
          }

          HapticFeedback.mediumImpact();
          setState(() {
            _selectedStatus = value
                ? HarvestStatus.harvested
                : _getComputedStatus();
          });
          widget.onStatusChanged?.call(_selectedStatus);
        },
      ),
    );
  }

  /// Show confirmation dialog for marking as harvested
  Future<bool> _showHarvestConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success),
                SizedBox(width: AppSpacing.s),
                Text('Mark as Harvested?'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('This will record today as your harvest date.'),
                SizedBox(height: AppSpacing.s),
                Container(
                  padding: EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.success,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'You can revert this later if needed.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: Icon(Icons.check),
                label: Text('Confirm Harvest'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Show confirmation dialog for reverting harvested status
  Future<bool> _showRevertConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.undo, color: AppColors.warning),
                SizedBox(width: AppSpacing.s),
                Text('Revert Harvest Status?'),
              ],
            ),
            content: Text(
              'This plan is marked as harvested. Do you want to change it back to the auto-calculated status?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppColors.warning),
                child: Text('Yes, Revert'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
