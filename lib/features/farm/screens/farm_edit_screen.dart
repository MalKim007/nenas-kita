import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/models/image_data.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/farm/widgets/variety_chips.dart';
import 'package:nenas_kita/features/farm/widgets/social_links_section.dart';
import 'package:nenas_kita/features/farm/widgets/location_picker.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Edit existing farm screen
class FarmEditScreen extends ConsumerStatefulWidget {
  const FarmEditScreen({super.key});

  @override
  ConsumerState<FarmEditScreen> createState() => _FarmEditScreenState();
}

class _FarmEditScreenState extends ConsumerState<FarmEditScreen> {
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
  String? _heroImageUrl;
  ImageData? _newHeroImage;
  bool? _isOwnFarmGrower; // null = unselected, true = Yes, false = No

  bool _isLoading = false;
  bool _initialized = false;
  FarmModel? _farm;

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

  void _initializeForm(FarmModel farm) {
    if (_initialized) return;
    _initialized = true;
    _farm = farm;

    _nameController.text = farm.farmName;
    _descriptionController.text = farm.description ?? '';
    _licensesController.text = farm.licenseNumber ?? '';
    _sizeController.text = farm.farmSizeHectares?.toString() ?? '';
    _whatsappController.text = farm.whatsappLink ?? '';
    _facebookController.text = farm.facebookLink ?? '';
    _instagramController.text = farm.instagramLink ?? '';
    _selectedDistrict = farm.district;
    _selectedVarieties = List.from(farm.varieties);
    _deliveryAvailable = farm.deliveryAvailable;
    _licenseExpiry = farm.licenseExpiry;
    _location = farm.location;
    _address = farm.address;
    _heroImageUrl = farm.socialLinks['heroImage'];
    // Determine if user is a grower based on existing farmSizeHectares
    _isOwnFarmGrower = farm.farmSizeHectares != null && farm.farmSizeHectares! > 0;
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
        _newHeroImage = ImageData(bytes: bytes, name: picked.name);
      });
    }
  }

  Future<void> _pickLicenseExpiry() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          _licenseExpiry ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (date != null) {
      setState(() => _licenseExpiry = date);
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    // Varieties are optional - no validation needed

    setState(() => _isLoading = true);

    try {
      final farmRepo = ref.read(farmRepositoryProvider);
      final storageService = ref.read(storageServiceProvider);

      // Upload hero image if changed
      String? heroImageUrl = _heroImageUrl;
      if (_newHeroImage != null) {
        heroImageUrl = await storageService.uploadFarmImage(
          farmId: _farm!.id,
          bytes: _newHeroImage!.bytes,
          fileName: _newHeroImage!.name,
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

      // Update farm
      final updatedFarm = _farm!.copyWith(
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
        updatedAt: DateTime.now(),
      );

      await farmRepo.update(updatedFarm);

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Business updated successfully');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to update business: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmAsync = ref.watch(myPrimaryFarmProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Business')),
      body: farmAsync.when(
        data: (farm) {
          if (farm == null) {
            return const Center(child: Text('No business found'));
          }

          _initializeForm(farm);

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: AppSpacing.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero image
                  _buildImagePicker(),
                  AppSpacing.vGapL,

                  // Farm name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Business Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  AppSpacing.vGapM,

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
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
                    'VARIETIES',
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
                  AppSpacing.vGapL,

                  // License number
                  TextFormField(
                    controller: _licensesController,
                    decoration: const InputDecoration(
                      labelText: 'LPNM / SSM Licence Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  AppSpacing.vGapM,

                  // License expiry
                  InkWell(
                    onTap: _pickLicenseExpiry,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'License Expiry Date',
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
                  AppSpacing.vGapS,
                  Row(
                    children: [
                      // Yes button
                      Expanded(
                        child: _buildSelectionButton(
                          label: 'Yes',
                          isSelected: _isOwnFarmGrower == true,
                          onTap: () => setState(() => _isOwnFarmGrower = true),
                        ),
                      ),
                      AppSpacing.hGapM,
                      // No button
                      Expanded(
                        child: _buildSelectionButton(
                          label: 'No',
                          isSelected: _isOwnFarmGrower == false,
                          onTap: () {
                            setState(() {
                              _isOwnFarmGrower = false;
                              _sizeController.clear(); // Clear acre value when No selected
                            });
                          },
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
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
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
                  AppSpacing.vGapL,

                  // Location
                  Text(
                    'LOCATION',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  AppSpacing.vGapS,
                  _buildLocationSection(),
                  AppSpacing.vGapXL,

                  // Save button
                  AppButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    label: 'Save Changes',
                    isLoading: _isLoading,
                  ),
                  AppSpacing.vGapL,
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: AppLoading()),
        error: (e, _) => AppError(
          message: 'Failed to load business',
          onRetry: () => ref.invalidate(myPrimaryFarmProvider),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          border: Border.all(color: AppColors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_newHeroImage != null)
              Image.memory(_newHeroImage!.bytes, fit: BoxFit.cover)
            else if (_heroImageUrl != null && _heroImageUrl!.isNotEmpty)
              Image.network(_heroImageUrl!, fit: BoxFit.cover)
            else
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add Business Photo',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            Positioned(
              right: AppSpacing.s,
              bottom: AppSpacing.s,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Change',
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
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

  Widget _buildLocationSection() {
    if (_location != null) {
      return LocationPreview(
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
      );
    }

    return OutlinedButton.icon(
      onPressed: () => LocationPicker.show(
        context: context,
        initialLocation: _location,
        onLocationSelected: (loc, addr) {
          setState(() {
            _location = loc;
            _address = addr;
          });
        },
      ),
      icon: const Icon(Icons.add_location),
      label: const Text('Add Location'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
      ),
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
