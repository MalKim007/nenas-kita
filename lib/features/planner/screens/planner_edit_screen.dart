import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';
import 'package:nenas_kita/features/planner/utils/harvest_status_calculator.dart';
import 'package:nenas_kita/features/planner/widgets/harvest_plan_form.dart';
import 'package:nenas_kita/features/planner/widgets/status_timeline.dart';

/// Edit existing harvest plan screen
class PlannerEditScreen extends ConsumerStatefulWidget {
  const PlannerEditScreen({super.key, required this.planId});

  final String planId;

  @override
  ConsumerState<PlannerEditScreen> createState() => _PlannerEditScreenState();
}

class _PlannerEditScreenState extends ConsumerState<PlannerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _initialized = false;
  HarvestPlanModel? _plan;

  // Form state
  PineappleVariety _selectedVariety = PineappleVariety.morris;
  double _quantity = 0;
  DateTime _plantingDate = DateTime.now();
  DateTime _expectedHarvestDate = DateTime.now().add(const Duration(days: 90));
  String _notes = '';
  HarvestStatus _status = HarvestStatus.planned;

  void _initializeForm(HarvestPlanModel plan) {
    if (_initialized) return;
    _initialized = true;
    _plan = plan;

    setState(() {
      _selectedVariety = PineappleVariety.fromString(plan.variety);
      _quantity = plan.quantityKg;
      _plantingDate = plan.plantingDate ?? DateTime.now();
      _expectedHarvestDate = plan.expectedHarvestDate;
      _notes = plan.notes ?? '';
      // If not harvested, use computed status; otherwise keep harvested
      if (plan.status == HarvestStatus.harvested) {
        _status = HarvestStatus.harvested;
      } else {
        _status = HarvestStatusCalculator.calculateStatus(
          plantingDate: plan.plantingDate,
          expectedHarvestDate: plan.expectedHarvestDate,
        );
      }
    });
  }

  /// Update status dynamically when dates change
  void _updateComputedStatus() {
    if (_status == HarvestStatus.harvested) {
      return; // Don't change if manually harvested
    }

    final newStatus = HarvestStatusCalculator.calculateStatus(
      plantingDate: _plantingDate,
      expectedHarvestDate: _expectedHarvestDate,
    );

    if (newStatus != _status) {
      setState(() {
        _status = newStatus;
      });
    }
  }

  /// Get info text for the timeline
  String _getStatusInfoText() {
    return HarvestStatusCalculator.getStatusChangeInfo(
      plantingDate: _plantingDate,
      expectedHarvestDate: _expectedHarvestDate,
      currentStatus: _status,
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      AppSnackbar.showError(context, 'Please fill all required fields');
      return;
    }

    if (_plan == null) return;

    // Validate dates
    if (_expectedHarvestDate.isBefore(_plantingDate)) {
      AppSnackbar.showError(
        context,
        'Expected harvest date must be after planting date',
      );
      return;
    }

    if (_quantity <= 0) {
      AppSnackbar.showError(context, 'Please enter a valid quantity');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final planRepo = ref.read(harvestPlanRepositoryProvider);

      // Update harvest plan
      final updatedPlan = _plan!.copyWith(
        variety: _selectedVariety.name,
        quantityKg: _quantity,
        plantingDate: _plantingDate,
        expectedHarvestDate: _expectedHarvestDate,
        notes: _notes.trim().isEmpty ? null : _notes.trim(),
        status: _status,
        actualHarvestDate: _status == HarvestStatus.harvested
            ? DateTime.now()
            : null,
      );

      await planRepo.update(updatedPlan);

      if (mounted) {
        // Invalidate providers to ensure fresh data after navigation
        ref.invalidate(harvestPlanByIdProvider(widget.planId));
        ref.invalidate(myHarvestPlansProvider);

        HapticFeedback.mediumImpact();
        AppSnackbar.showSuccess(context, 'Harvest plan updated successfully');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to update harvest plan: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deletePlan() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Harvest Plan'),
        content: const Text(
          'Are you sure you want to delete this harvest plan? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final planRepo = ref.read(harvestPlanRepositoryProvider);
      await planRepo.delete(widget.planId);

      if (mounted) {
        HapticFeedback.mediumImpact();
        AppSnackbar.showSuccess(context, 'Harvest plan deleted');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to delete harvest plan: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(harvestPlanByIdProvider(widget.planId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Harvest Plan'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _deletePlan,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Plan',
            color: AppColors.error,
          ),
        ],
      ),
      body: planAsync.when(
        data: (plan) {
          if (plan == null) {
            return const Center(child: Text('Harvest plan not found'));
          }

          _initializeForm(plan);

          return SingleChildScrollView(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Timeline with dynamic updates
                StatusTimeline(
                  currentStatus: _status,
                  infoText: _getStatusInfoText(),
                  isAutoCalculated: _status != HarvestStatus.harvested,
                ),
                AppSpacing.vGapL,

                // Overdue Warning
                if (plan.isOverdue)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.m),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error,
                          size: 24,
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overdue',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'This harvest is ${plan.daysUntilHarvest.abs()} days overdue. Consider updating the status.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (plan.isOverdue) AppSpacing.vGapL,

                // Form
                HarvestPlanForm(
                  formKey: _formKey,
                  initialVariety: _selectedVariety,
                  initialQuantity: _quantity,
                  initialPlantingDate: _plantingDate,
                  initialExpectedHarvestDate: _expectedHarvestDate,
                  initialNotes: _notes,
                  initialStatus: _status,
                  showStatusSelector: true,
                  onVarietyChanged: (variety) {
                    setState(() => _selectedVariety = variety);
                  },
                  onQuantityChanged: (quantity) {
                    setState(() => _quantity = quantity);
                  },
                  onPlantingDateChanged: (date) {
                    setState(() => _plantingDate = date);
                    _updateComputedStatus();
                  },
                  onExpectedHarvestDateChanged: (date) {
                    setState(() => _expectedHarvestDate = date);
                    _updateComputedStatus();
                  },
                  onNotesChanged: (notes) {
                    setState(() => _notes = notes);
                  },
                  onStatusChanged: (status) {
                    setState(() => _status = status);
                  },
                ),
                AppSpacing.vGapXL,
                AppButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  label: 'Save Changes',
                  isLoading: _isLoading,
                ),
                AppSpacing.vGapL,
              ],
            ),
          );
        },
        loading: () => const Center(child: AppLoading()),
        error: (e, _) => AppError(
          message: 'Failed to load harvest plan',
          onRetry: () => ref.invalidate(harvestPlanByIdProvider(widget.planId)),
        ),
      ),
    );
  }
}
