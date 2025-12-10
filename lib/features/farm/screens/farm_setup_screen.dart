import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/models/image_data.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/animated_checkmark.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/farm/widgets/variety_chips.dart';
import 'package:nenas_kita/features/farm/widgets/social_links_section.dart';
import 'package:nenas_kita/features/farm/widgets/location_picker.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// First-time farm setup screen
class FarmSetupScreen extends ConsumerStatefulWidget {
  const FarmSetupScreen({super.key});

  @override
  ConsumerState<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends ConsumerState<FarmSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _licensesController = TextEditingController();
  final _sizeController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();

  String? _selectedDistrict;
  List<String> _selectedVarieties = [];
  bool _deliveryAvailable = false;
  DateTime? _licenseExpiry;
  GeoPoint? _location;
  String? _address;
  ImageData? _heroImage;
  bool? _isOwnFarmGrower; // null = unselected, true = Yes, false = No

  bool _isLoading = false;
  bool _showSuccess = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _licensesController.dispose();
    _sizeController.dispose();
    _whatsappController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 720,
      imageQuality: 80,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _heroImage = ImageData(bytes: bytes, name: picked.name);
      });
    }
  }

  Future<void> _pickLicenseExpiry() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (date != null) {
      setState(() => _licenseExpiry = date);
    }
  }

  bool _validateStep(int step) {
    switch (step) {
      case 0:
        if (_nameController.text.isEmpty) {
          AppSnackbar.showError(context, 'Business name is required');
          return false;
        }
        if (_selectedDistrict == null) {
          AppSnackbar.showError(context, 'Please select a district');
          return false;
        }
        // Varieties are optional - no validation needed
        return true;
      case 1:
        return true; // Optional fields
      case 2:
        if (_location == null) {
          AppSnackbar.showError(context, 'Please add your business location');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _nextStep() {
    if (_validateStep(_currentStep)) {
      if (_currentStep < 2) {
        setState(() => _currentStep++);
      } else {
        _createFarm();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _createFarm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentAppUserProvider).value;
      if (user == null) throw Exception('User not found');

      final farmRepo = ref.read(farmRepositoryProvider);
      final storageService = ref.read(storageServiceProvider);

      // Generate temporary ID for image upload
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload hero image if selected
      String? heroImageUrl;
      if (_heroImage != null) {
        heroImageUrl = await storageService.uploadFarmImage(
          farmId: tempId,
          bytes: _heroImage!.bytes,
          fileName: _heroImage!.name,
        );
      }

      // Build social links
      final socialLinks = <String, String>{};
      if (_whatsappController.text.isNotEmpty) {
        socialLinks['whatsapp'] = _whatsappController.text;
      }
      if (_facebookController.text.isNotEmpty) {
        socialLinks['facebook'] = _facebookController.text;
      }
      if (_instagramController.text.isNotEmpty) {
        socialLinks['instagram'] = _instagramController.text;
      }
      if (heroImageUrl != null && heroImageUrl.isNotEmpty) {
        socialLinks['heroImage'] = heroImageUrl;
      }

      // Create farm
      final farm = FarmModel(
        id: '', // Will be set by repository
        ownerId: user.id,
        ownerName: user.name,
        ownerPhone: user.phone,
        farmName: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        district: _selectedDistrict!,
        varieties: _selectedVarieties,
        licenseNumber: _licensesController.text.trim().isEmpty
            ? null
            : _licensesController.text.trim(),
        licenseExpiry: _licenseExpiry,
        farmSizeHectares: _sizeController.text.isEmpty
            ? null
            : double.tryParse(_sizeController.text),
        deliveryAvailable: _deliveryAvailable,
        socialLinks: socialLinks,
        location: _location,
        address: _address,
        createdAt: DateTime.now(),
      );

      await farmRepo.create(farm);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuccess = true;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to create business: $e');
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
          message: 'Business Created!',
          onComplete: () {
            if (mounted) context.go(RouteNames.farmerHome);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Your Business')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Step indicator
            _buildStepIndicator(),

            // Step content - keyboard insets handled
            Expanded(
              child: Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  return SingleChildScrollView(
                    padding: AppSpacing.pagePadding.copyWith(
                      bottom: AppSpacing.l + bottomInset,
                    ),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: _buildCurrentStep(),
                  );
                },
              ),
            ),

            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.outlineVariant),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: AppButton(
                          onPressed: _isLoading ? null : _previousStep,
                          label: 'Back',
                          variant: AppButtonVariant.secondary,
                        ),
                      ),
                    if (_currentStep > 0) AppSpacing.hGapM,
                    Expanded(
                      child: AppButton(
                        onPressed: _isLoading ? null : _nextStep,
                        label: _currentStep == 2 ? 'Create Business' : 'Next',
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Row(
        children: [
          _StepDot(
            label: '1',
            title: 'Basics',
            isActive: _currentStep >= 0,
            isCompleted: _currentStep > 0,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep > 0 ? AppColors.primary : AppColors.outline,
            ),
          ),
          _StepDot(
            label: '2',
            title: 'Details',
            isActive: _currentStep >= 1,
            isCompleted: _currentStep > 1,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep > 1 ? AppColors.primary : AppColors.outline,
            ),
          ),
          _StepDot(
            label: '3',
            title: 'Location',
            isActive: _currentStep >= 2,
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicsStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildLocationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppSpacing.vGapS,
        Text(
          'Tell us about your business',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        AppSpacing.vGapL,

        // Hero image
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              border: Border.all(color: AppColors.outline),
            ),
            clipBehavior: Clip.antiAlias,
            child: _heroImage != null
                ? Image.memory(
                    _heroImage!.bytes,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add Business Photo (Optional)',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        AppSpacing.vGapL,

        // Farm name
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Business Name *',
            border: OutlineInputBorder(),
            hintText: 'e.g., Pak Ali Pineapple Shop',
          ),
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
        AppSpacing.vGapM,

        // Description
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            hintText: 'Tell buyers about your business...',
          ),
          maxLines: 3,
        ),
        AppSpacing.vGapM,

        // District
        DropdownButtonFormField<String>(
          value: _selectedDistrict,
          decoration: const InputDecoration(
            labelText: 'District *',
            border: OutlineInputBorder(),
          ),
          items: District.values.map((d) {
            return DropdownMenuItem(
              value: d.displayName,
              child: Text(d.displayName),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedDistrict = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        AppSpacing.vGapL,

        // Varieties
        Text(
          'PINEAPPLE VARIETIES',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        AppSpacing.vGapS,
        VarietySelector(
          selectedVarieties: _selectedVarieties,
          onChanged: (v) => setState(() => _selectedVarieties = v),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Details',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppSpacing.vGapS,
        Text(
          'Optional information to help buyers find you',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        AppSpacing.vGapL,

        // License number
        TextFormField(
          controller: _licensesController,
          decoration: const InputDecoration(
            labelText: 'LPNM / SSM Licence Number (Optional)',
            border: OutlineInputBorder(),
          ),
        ),
        AppSpacing.vGapM,

        // License expiry
        InkWell(
          onTap: _pickLicenseExpiry,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'License Expiry Date (Optional)',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              _licenseExpiry != null
                  ? '${_licenseExpiry!.day}/${_licenseExpiry!.month}/${_licenseExpiry!.year}'
                  : 'Select date',
              style: TextStyle(
                color: _licenseExpiry != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        AppSpacing.vGapM,

        // "Do you grow your own farm?" question
        Text(
          'DO YOU GROW YOUR OWN FARM?',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue: _isOwnFarmGrower,
                onChanged: (value) => setState(() => _isOwnFarmGrower = value),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: _isOwnFarmGrower,
                onChanged: (value) {
                  setState(() {
                    _isOwnFarmGrower = value;
                    _sizeController.clear(); // Clear acre value when No selected
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        AppSpacing.vGapM,

        // Farm size - only show when Yes is selected
        if (_isOwnFarmGrower == true) ...[
          TextFormField(
            controller: _sizeController,
            decoration: const InputDecoration(
              labelText: 'Farm Size (acres)',
              border: OutlineInputBorder(),
              suffixText: 'ac',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          AppSpacing.vGapM,
        ],

        // Delivery available
        SwitchListTile(
          title: const Text('Delivery Available'),
          subtitle: const Text('Can deliver products to buyers'),
          value: _deliveryAvailable,
          onChanged: (v) => setState(() => _deliveryAvailable = v),
          contentPadding: EdgeInsets.zero,
        ),
        AppSpacing.vGapL,

        // Social links
        Text(
          'CONTACT LINKS',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        AppSpacing.vGapS,
        WhatsAppInputField(controller: _whatsappController),
        AppSpacing.vGapM,
        FacebookInputField(controller: _facebookController),
        AppSpacing.vGapM,
        InstagramInputField(controller: _instagramController),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Location',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppSpacing.vGapS,
        Text(
          'Help buyers find your business',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        AppSpacing.vGapL,

        if (_location != null) ...[
          LocationPreview(
            location: _location!,
            onTap: () => LocationPicker.show(
              context: context,
              initialLocation: _location,
              onLocationSelected: (loc, addr) {
                setState(() {
                  _location = loc;
                  _address = addr;
                });
              },
            ),
          ),
          if (_address != null && _address!.isNotEmpty) ...[
            AppSpacing.vGapS,
            Text(
              _address!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ] else
          OutlinedButton.icon(
            onPressed: () => LocationPicker.show(
              context: context,
              onLocationSelected: (loc, addr) {
                setState(() {
                  _location = loc;
                  _address = addr;
                });
              },
            ),
            icon: const Icon(Icons.add_location),
            label: const Text('Add Business Location'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
        AppSpacing.vGapL,

        // Location required hint
        Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.textSecondary),
              AppSpacing.hGapS,
              Expanded(
                child: Text(
                  'Location is required to help buyers find your business',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.title,
    required this.isActive,
    required this.isCompleted,
  });

  final String label;
  final String title;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.outline,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        AppSpacing.vGapXS,
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
