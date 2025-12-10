import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_text_field.dart';

/// Date range picker for harvest planning with auto-calculation.
///
/// Features:
/// - Planting date picker
/// - Expected harvest date auto-calculated (planting + 14 months)
/// - Manual override allowed for expected date
/// - Shows duration between dates
/// - Planting date defaults to today
class DateRangePicker extends StatefulWidget {
  /// Initial planting date. Defaults to today.
  final DateTime? plantingDate;

  /// Initial expected harvest date.
  final DateTime? expectedHarvestDate;

  /// Callback when planting date changes.
  final ValueChanged<DateTime> onPlantingDateChanged;

  /// Callback when expected harvest date changes.
  final ValueChanged<DateTime> onExpectedHarvestDateChanged;

  /// Whether the fields are enabled.
  final bool enabled;

  const DateRangePicker({
    super.key,
    this.plantingDate,
    this.expectedHarvestDate,
    required this.onPlantingDateChanged,
    required this.onExpectedHarvestDateChanged,
    this.enabled = true,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTime _plantingDate;
  late DateTime _expectedHarvestDate;
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  // Controllers must be instance variables, not created in build()
  late final TextEditingController _plantingDateController;
  late final TextEditingController _expectedHarvestDateController;

  @override
  void initState() {
    super.initState();
    _plantingDate = widget.plantingDate ?? DateTime.now();
    _expectedHarvestDate = widget.expectedHarvestDate ??
        _calculateExpectedHarvestDate(_plantingDate);

    // Initialize controllers with formatted dates
    _plantingDateController = TextEditingController(
      text: _dateFormat.format(_plantingDate),
    );
    _expectedHarvestDateController = TextEditingController(
      text: _dateFormat.format(_expectedHarvestDate),
    );
  }

  @override
  void dispose() {
    _plantingDateController.dispose();
    _expectedHarvestDateController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.plantingDate != null &&
        widget.plantingDate != oldWidget.plantingDate) {
      _plantingDate = widget.plantingDate!;
      _plantingDateController.text = _dateFormat.format(_plantingDate);
    }
    if (widget.expectedHarvestDate != null &&
        widget.expectedHarvestDate != oldWidget.expectedHarvestDate) {
      _expectedHarvestDate = widget.expectedHarvestDate!;
      _expectedHarvestDateController.text = _dateFormat.format(_expectedHarvestDate);
    }
  }

  /// Calculate expected harvest date as planting date + 14 months.
  DateTime _calculateExpectedHarvestDate(DateTime plantingDate) {
    return DateTime(
      plantingDate.year + 1,
      plantingDate.month + 2,
      plantingDate.day,
    );
  }

  /// Calculate duration between planting and expected harvest dates.
  String _calculateDuration() {
    final difference = _expectedHarvestDate.difference(_plantingDate).inDays;

    if (difference < 0) {
      return 'Invalid date range';
    }

    final months = (difference / 30).floor();
    final days = difference % 30;

    if (months == 0) {
      return '$days days';
    } else if (days == 0) {
      return '$months months';
    } else {
      return '$months months, $days days';
    }
  }

  Future<void> _selectPlantingDate(BuildContext context) async {
    HapticFeedback.selectionClick();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _plantingDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _plantingDate) {
      setState(() {
        _plantingDate = picked;
        // Auto-calculate expected harvest date
        _expectedHarvestDate = _calculateExpectedHarvestDate(picked);
        // Update controller text to reflect new dates
        _plantingDateController.text = _dateFormat.format(_plantingDate);
        _expectedHarvestDateController.text = _dateFormat.format(_expectedHarvestDate);
      });
      widget.onPlantingDateChanged(picked);
      widget.onExpectedHarvestDateChanged(_expectedHarvestDate);
    }
  }

  Future<void> _selectExpectedHarvestDate(BuildContext context) async {
    HapticFeedback.selectionClick();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expectedHarvestDate,
      firstDate: _plantingDate,
      lastDate: DateTime(_plantingDate.year + 3),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _expectedHarvestDate) {
      setState(() {
        _expectedHarvestDate = picked;
        // Update controller text to reflect new date
        _expectedHarvestDateController.text = _dateFormat.format(_expectedHarvestDate);
      });
      widget.onExpectedHarvestDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Planting Date Field
        AppTextField(
          label: 'Planting Date',
          controller: _plantingDateController,
          readOnly: true,
          enabled: widget.enabled,
          suffixIcon: Icons.calendar_today,
          onTap: widget.enabled
              ? () => _selectPlantingDate(context)
              : null,
        ),
        SizedBox(height: AppSpacing.m),

        // Expected Harvest Date Field
        AppTextField(
          label: 'Expected Harvest Date',
          controller: _expectedHarvestDateController,
          readOnly: true,
          enabled: widget.enabled,
          suffixIcon: Icons.event_available,
          onTap: widget.enabled
              ? () => _selectExpectedHarvestDate(context)
              : null,
          helperText: 'Tap to manually adjust (auto-calculated: 14 months)',
        ),
        SizedBox(height: AppSpacing.m),

        // Duration Display
        Container(
          padding: EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timeline,
                size: 20,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSpacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Growing Period',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      _calculateDuration(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
