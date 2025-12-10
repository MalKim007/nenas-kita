import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';
import 'package:nenas_kita/features/market/models/price_history_model.dart';
import 'package:nenas_kita/features/market/providers/price_history_providers.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/product/widgets/price_input.dart';
import 'package:nenas_kita/features/product/widgets/product_form.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Edit existing product screen
class ProductEditScreen extends ConsumerStatefulWidget {
  const ProductEditScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends ConsumerState<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  ProductFormState? _formState;
  bool _isLoading = false;
  bool _initialized = false;
  ProductModel? _product;

  @override
  void dispose() {
    _formState?.dispose();
    super.dispose();
  }

  void _initializeForm(ProductModel product) {
    if (_initialized) return;
    _initialized = true;
    _product = product;

    _formState = ProductFormState(
      name: product.name,
      description: product.description,
      price: product.price.toString(),
      wholesalePrice: product.wholesalePrice?.toString(),
      wholesaleMinQty: product.wholesaleMinQty?.toStringAsFixed(0),
      category: product.category,
      variety: product.variety,
      priceUnit: PriceUnit.fromString(product.priceUnit),
      stockStatus: product.stockStatus,
      existingImageUrls: product.images,
      wholesaleEnabled: product.hasWholesalePrice,
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_formState == null || _product == null) return;

    if (!_formState!.hasImages) {
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
      final priceHistoryRepo = ref.read(priceHistoryRepositoryProvider);

      // Upload new images
      final imageUrls = <String>[];
      imageUrls.addAll(_formState!.existingImageUrls);

      for (final imageData in _formState!.newImages) {
        final url = await storageService.uploadProductImage(
          farmId: farm.id,
          productId: _product!.id,
          bytes: imageData.bytes,
          fileName: imageData.name,
        );
        imageUrls.add(url);
      }

      // Update product
      final updatedProduct = _product!.copyWith(
        name: _formState!.nameController.text.trim(),
        category: _formState!.category,
        variety: _formState!.variety, // Nullable - only set for fresh products
        price: double.parse(_formState!.priceController.text),
        priceUnit: _formState!.priceUnit.label,
        stockStatus: _formState!.stockStatus,
        description: _formState!.descriptionController.text.trim().isEmpty
            ? null
            : _formState!.descriptionController.text.trim(),
        images: imageUrls,
        wholesalePrice: _formState!.wholesaleEnabled
            ? double.tryParse(_formState!.wholesalePriceController.text)
            : null,
        wholesaleMinQty: _formState!.wholesaleEnabled
            ? double.tryParse(_formState!.wholesaleMinQtyController.text)
            : null,
        updatedAt: DateTime.now(),
      );

      await productRepo.update(farm.id, updatedProduct);

      // Log price change history when price or wholesale price changes
      final priceChanged = _product!.price != updatedProduct.price ||
          (_product!.wholesalePrice ?? 0) != (updatedProduct.wholesalePrice ?? 0);
      if (priceChanged) {
        final history = PriceHistoryModel(
          id: '', // will be set by repository
          farmId: farm.id,
          productId: updatedProduct.id,
          productName: updatedProduct.name,
          variety: updatedProduct.variety,
          oldPrice: _product!.price,
          newPrice: updatedProduct.price,
          oldWholesalePrice: _product!.wholesalePrice,
          newWholesalePrice: updatedProduct.wholesalePrice,
          changedAt: DateTime.now(),
          expiresAt: null,
        );
        try {
          await priceHistoryRepo.create(history);
        } catch (_) {
          // Do not block the user if history logging fails
        }
      }

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Product updated successfully');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to update product: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
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
      final farm = ref.read(myPrimaryFarmProvider).value;
      if (farm == null) return;

      final productRepo = ref.read(productRepositoryProvider);
      await productRepo.delete(farm.id, widget.productId);

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Product deleted');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to delete product: $e');
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
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _deleteProduct,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Product',
            color: AppColors.error,
          ),
        ],
      ),
      body: farmAsync.when(
        data: (farm) {
          if (farm == null) {
            return const Center(child: Text('No farm found'));
          }

          final productAsync = ref.watch(
            productByIdProvider(farm.id, widget.productId),
          );

          return productAsync.when(
            data: (product) {
              if (product == null) {
                return const Center(child: Text('Product not found'));
              }

              _initializeForm(product);

              if (_formState == null) {
                return const Center(child: AppLoading());
              }

              return SingleChildScrollView(
                padding: AppSpacing.pagePadding,
                child: Column(
                  children: [
                    ProductForm(
                      formKey: _formKey,
                      nameController: _formState!.nameController,
                      descriptionController: _formState!.descriptionController,
                      priceController: _formState!.priceController,
                      wholesalePriceController: _formState!.wholesalePriceController,
                      wholesaleMinQtyController: _formState!.wholesaleMinQtyController,
                      category: _formState!.category,
                      onCategoryChanged: (c) => setState(() {
                        _formState!.category = c;
                        // Clear variety when switching to processed (not needed)
                        if (c == ProductCategory.processed) {
                          _formState!.variety = null;
                        }
                      }),
                      variety: _formState!.variety,
                      onVarietyChanged: (v) => setState(() => _formState!.variety = v),
                      priceUnit: _formState!.priceUnit,
                      onPriceUnitChanged: (u) => setState(() => _formState!.priceUnit = u),
                      stockStatus: _formState!.stockStatus,
                      onStockStatusChanged: (s) =>
                          setState(() => _formState!.stockStatus = s),
                      existingImageUrls: _formState!.existingImageUrls,
                      newImages: _formState!.newImages,
                      onImagesChanged: (urls, files) => setState(() {
                        _formState!.existingImageUrls = urls;
                        _formState!.newImages = files;
                      }),
                      wholesaleEnabled: _formState!.wholesaleEnabled,
                      onWholesaleEnabledChanged: (e) =>
                          setState(() => _formState!.wholesaleEnabled = e),
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
              message: 'Failed to load product',
              onRetry: () => ref.invalidate(
                productByIdProvider(farm.id, widget.productId),
              ),
            ),
          );
        },
        loading: () => const Center(child: AppLoading()),
        error: (e, _) => AppError(
          message: 'Failed to load farm',
          onRetry: () => ref.invalidate(myPrimaryFarmProvider),
        ),
      ),
    );
  }
}
