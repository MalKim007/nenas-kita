import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/animated_checkmark.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';
import 'package:nenas_kita/features/planner/widgets/harvest_plan_form.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Add new harvest plan screen
class PlannerAddScreen extends ConsumerStatefulWidget {
  const PlannerAddScreen({super.key});

  @override
  ConsumerState<PlannerAddScreen> createState() => _PlannerAddScreenState();
}

class _PlannerAddScreenState extends ConsumerState<PlannerAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showSuccess = false;

  // Form state
  PineappleVariety _selectedVariety = PineappleVariety.morris;
  double _quantity = 0;
  DateTime _plantingDate = DateTime.now();
  DateTime _expectedHarvestDate = DateTime.now().add(const Duration(days: 90));
  String _notes = '';

  /// Check if form has unsaved changes
  bool get _hasUnsavedChanges {
    return _quantity > 0 || _notes.isNotEmpty;
  }

  /// Show confirmation dialog when user tries to leave with unsaved changes
  Future<bool> _confirmDiscard() async {
    if (!_hasUnsavedChanges || _showSuccess) return true;

    HapticFeedback.mediumImpact();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) {
      AppSnackbar.showError(context, 'Please fill all required fields');
      return;
    }

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
      final farm = ref.read(myPrimaryFarmProvider).value;
      if (farm == null) {
        AppSnackbar.showError(context, 'No business found');
        return;
      }

      final currentUserId = ref.read(currentUserIdProvider);
      if (currentUserId == null) {
        AppSnackbar.showError(context, 'User not logged in');
        return;
      }

      final planRepo = ref.read(harvestPlanRepositoryProvider);

      // Create harvest plan
      final plan = HarvestPlanModel(
        id: '', // Will be set by Firestore
        farmId: farm.id,
        farmName: farm.farmName,
        ownerId: currentUserId,
        variety: _selectedVariety.name,
        quantityKg: _quantity,
        plantingDate: _plantingDate,
        expectedHarvestDate: _expectedHarvestDate,
        actualHarvestDate: null,
        status: HarvestStatus.planned,
        notes: _notes.trim().isEmpty ? null : _notes.trim(),
        reminderSent: false,
        createdAt: DateTime.now(),
      );

      await planRepo.create(plan);

      if (mounted) {
        HapticFeedback.mediumImpact();
        setState(() {
          _isLoading = false;
          _showSuccess = true;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to create harvest plan: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show success overlay
    if (_showSuccess) {
      return Scaffold(
        body: SuccessOverlay(
          message: 'Harvest Plan Created!',
          onComplete: () {
            if (mounted) context.pop();
          },
        ),
      );
    }

    final farmAsync = ref.watch(myPrimaryFarmProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _confirmDiscard();
        if (shouldPop && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Harvest Plan'),
        ),
        body: farmAsync.when(
          data: (farm) {
            if (farm == null) {
              return const Center(
                child: Text('Please create a business first'),
              );
            }

            // Account for keyboard insets to prevent form fields from being obscured
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              padding: AppSpacing.pagePadding.copyWith(
                bottom: AppSpacing.l + bottomInset,
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                HarvestPlanForm(
                  formKey: _formKey,
                  initialVariety: _selectedVariety,
                  initialQuantity: _quantity == 0 ? null : _quantity,
                  initialPlantingDate: _plantingDate,
                  initialExpectedHarvestDate: _expectedHarvestDate,
                  initialNotes: _notes,
                  showStatusSelector: false,
                  onVarietyChanged: (variety) {
                    setState(() => _selectedVariety = variety);
                  },
                  onQuantityChanged: (quantity) {
                    setState(() => _quantity = quantity);
                  },
                  onPlantingDateChanged: (date) {
                    setState(() => _plantingDate = date);
                  },
                  onExpectedHarvestDateChanged: (date) {
                    setState(() => _expectedHarvestDate = date);
                  },
                  onNotesChanged: (notes) {
                    setState(() => _notes = notes);
                  },
                ),
                AppSpacing.vGapXL,
                AppButton(
                  onPressed: _isLoading ? null : _savePlan,
                  label: 'Create Plan',
                  isLoading: _isLoading,
                ),
                AppSpacing.vGapL,
              ],
            ),
          );
        },
          loading: () => const Center(child: AppLoading()),
          error: (e, _) => AppError(
            message: 'Failed to load business',
            onRetry: () => ref.invalidate(myPrimaryFarmProvider),
          ),
        ),
      ),
    );
  }
}
