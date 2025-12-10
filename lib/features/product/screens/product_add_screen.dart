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
import 'package:nenas_kita/features/product/models/product_model.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/product/widgets/product_form.dart';
import 'package:nenas_kita/features/market/models/price_history_model.dart';
import 'package:nenas_kita/features/market/providers/price_history_providers.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Add new product screen
class ProductAddScreen extends ConsumerStatefulWidget {
  const ProductAddScreen({super.key});

  @override
  ConsumerState<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends ConsumerState<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProductFormState _formState;
  bool _isLoading = false;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _formState = ProductFormState();
  }

  @override
  void dispose() {
    _formState.dispose();
    super.dispose();
  }

  /// Check if form has unsaved changes
  bool get _hasUnsavedChanges {
    return _formState.nameController.text.isNotEmpty ||
        _formState.descriptionController.text.isNotEmpty ||
        _formState.priceController.text.isNotEmpty ||
        _formState.newImages.isNotEmpty ||
        _formState.variety != null;
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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_formState.hasImages) {
      AppSnackbar.showError(context, 'Please add at least one image');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final farm = ref.read(myPrimaryFarmProvider).value;
      if (farm == null) {
        AppSnackbar.showError(context, 'No farm found');
        return;
      }

      final productRepo = ref.read(productRepositoryProvider);
      final storageService = ref.read(storageServiceProvider);

      // Upload images
      final imageUrls = <String>[];

      // Add existing URLs (shouldn't have any for new product)
      imageUrls.addAll(_formState.existingImageUrls);

      // Upload new images
      for (final imageData in _formState.newImages) {
        final url = await storageService.uploadProductImage(
          farmId: farm.id,
          productId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          bytes: imageData.bytes,
          fileName: imageData.name,
        );
        imageUrls.add(url);
      }

      // Create product
      final product = ProductModel(
        id: '', // Will be set by Firestore
        farmId: farm.id,
        name: _formState.nameController.text.trim(),
        category: _formState.category,
        variety: _formState.variety, // Nullable - only set for fresh products
        price: double.parse(_formState.priceController.text),
        priceUnit: _formState.priceUnit.label,
        stockStatus: _formState.stockStatus,
        description: _formState.descriptionController.text.trim().isEmpty
            ? null
            : _formState.descriptionController.text.trim(),
        images: imageUrls,
        wholesalePrice: _formState.wholesaleEnabled
            ? double.tryParse(_formState.wholesalePriceController.text)
            : null,
        wholesaleMinQty: _formState.wholesaleEnabled
            ? double.tryParse(_formState.wholesaleMinQtyController.text)
            : null,
        updatedAt: DateTime.now(),
      );

      final productId = await productRepo.create(farm.id, product);

      // Log initial price to price history for trends chart
      try {
        final priceHistoryRepo = ref.read(priceHistoryRepositoryProvider);
        final history = PriceHistoryModel(
          id: '',
          farmId: farm.id,
          productId: productId,
          productName: product.name,
          variety: product.variety,
          oldPrice: product.price,
          newPrice: product.price,
          oldWholesalePrice: product.wholesalePrice,
          newWholesalePrice: product.wholesalePrice,
          changedAt: DateTime.now(),
          expiresAt: null,
        );
        await priceHistoryRepo.create(history);
      } catch (_) {
        // Non-blocking: don't interrupt product creation flow
      }

      if (mounted) {
        HapticFeedback.mediumImpact(); // Success haptic
        setState(() {
          _isLoading = false;
          _showSuccess = true;
        });
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.heavyImpact(); // Error haptic
        AppSnackbar.showError(context, 'Failed to add product: $e');
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
          message: 'Product Added!',
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
          title: const Text('Add Product'),
        ),
        body: farmAsync.when(
        data: (farm) {
          if (farm == null) {
            return const Center(child: Text('Please create a farm first'));
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
                ProductForm(
                  formKey: _formKey,
                  nameController: _formState.nameController,
                  descriptionController: _formState.descriptionController,
                  priceController: _formState.priceController,
                  wholesalePriceController: _formState.wholesalePriceController,
                  wholesaleMinQtyController: _formState.wholesaleMinQtyController,
                  category: _formState.category,
                  onCategoryChanged: (c) => setState(() {
                    _formState.category = c;
                    // Clear variety when switching to processed (not needed)
                    if (c == ProductCategory.processed) {
                      _formState.variety = null;
                    }
                  }),
                  variety: _formState.variety,
                  onVarietyChanged: (v) => setState(() => _formState.variety = v),
                  priceUnit: _formState.priceUnit,
                  onPriceUnitChanged: (u) => setState(() => _formState.priceUnit = u),
                  stockStatus: _formState.stockStatus,
                  onStockStatusChanged: (s) => setState(() => _formState.stockStatus = s),
                  existingImageUrls: _formState.existingImageUrls,
                  newImages: _formState.newImages,
                  onImagesChanged: (urls, files) => setState(() {
                    _formState.existingImageUrls = urls;
                    _formState.newImages = files;
                  }),
                  wholesaleEnabled: _formState.wholesaleEnabled,
                  onWholesaleEnabledChanged: (e) =>
                      setState(() => _formState.wholesaleEnabled = e),
                ),
                AppSpacing.vGapXL,
                AppButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  label: 'Add Product',
                  isLoading: _isLoading,
                ),
                AppSpacing.vGapL,
              ],
            ),
          );
        },
        loading: () => const Center(child: AppLoading()),
        error: (e, _) => AppError(
          message: 'Failed to load farm',
          onRetry: () => ref.invalidate(myPrimaryFarmProvider),
        ),
      ),
      ),
    );
  }
}
