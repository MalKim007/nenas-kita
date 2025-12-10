import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/models/image_data.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/product/widgets/category_selector.dart';
import 'package:nenas_kita/features/product/widgets/image_picker_grid.dart';
import 'package:nenas_kita/features/product/widgets/price_input.dart';
import 'package:nenas_kita/features/product/widgets/stock_status_selector.dart';

/// Shared product add/edit form
class ProductForm extends StatelessWidget {
  const ProductForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.wholesalePriceController,
    required this.wholesaleMinQtyController,
    required this.category,
    required this.onCategoryChanged,
    required this.variety,
    required this.onVarietyChanged,
    required this.priceUnit,
    required this.onPriceUnitChanged,
    required this.stockStatus,
    required this.onStockStatusChanged,
    required this.existingImageUrls,
    required this.newImages,
    required this.onImagesChanged,
    required this.wholesaleEnabled,
    required this.onWholesaleEnabledChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController wholesalePriceController;
  final TextEditingController wholesaleMinQtyController;
  final ProductCategory category;
  final ValueChanged<ProductCategory> onCategoryChanged;
  final String? variety;
  final ValueChanged<String?> onVarietyChanged;
  final PriceUnit priceUnit;
  final ValueChanged<PriceUnit> onPriceUnitChanged;
  final StockStatus stockStatus;
  final ValueChanged<StockStatus> onStockStatusChanged;
  final List<String> existingImageUrls;
  final List<ImageData> newImages;
  final void Function(List<String> urls, List<ImageData> images) onImagesChanged;
  final bool wholesaleEnabled;
  final ValueChanged<bool> onWholesaleEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Images
          _buildSection(
            context,
            title: 'PRODUCT IMAGES',
            child: ImagePickerGrid(
              existingUrls: existingImageUrls,
              newImages: newImages,
              onImagesChanged: onImagesChanged,
            ),
          ),
          AppSpacing.vGapL,

          // Name
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name *',
              border: OutlineInputBorder(),
              hintText: 'e.g., Fresh Morris Pineapple',
            ),
            textCapitalization: TextCapitalization.words,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          AppSpacing.vGapM,

          // Description
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
              hintText: 'Describe your product...',
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          AppSpacing.vGapL,

          // Category
          _buildSection(
            context,
            title: 'CATEGORY *',
            child: CategorySelector(
              selected: category,
              onChanged: onCategoryChanged,
            ),
          ),
          AppSpacing.vGapL,

          // Variety - only shown for fresh products
          if (category == ProductCategory.fresh) ...[
            DropdownButtonFormField<String>(
              value: variety,
              decoration: const InputDecoration(
                labelText: 'Variety *',
                border: OutlineInputBorder(),
              ),
              items: PineappleVariety.values.map((v) {
                return DropdownMenuItem(
                  value: v.displayName,
                  child: Text(v.displayName),
                );
              }).toList(),
              onChanged: onVarietyChanged,
              validator: (v) => v == null ? 'Required' : null,
            ),
            AppSpacing.vGapL,
          ],

          // Price
          _buildSection(
            context,
            title: 'PRICING *',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PriceInput(
                  controller: priceController,
                  unit: priceUnit,
                  onUnitChanged: onPriceUnitChanged,
                ),
                AppSpacing.vGapL,
                WholesalePriceInput(
                  priceController: wholesalePriceController,
                  minQtyController: wholesaleMinQtyController,
                  enabled: wholesaleEnabled,
                  onEnabledChanged: onWholesaleEnabledChanged,
                  priceUnit: priceUnit,
                ),
              ],
            ),
          ),
          AppSpacing.vGapL,

          // Stock status
          _buildSection(
            context,
            title: 'STOCK STATUS *',
            child: StockStatusSelector(
              selected: stockStatus,
              onChanged: onStockStatusChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
        ),
        AppSpacing.vGapHeader,
        child,
      ],
    );
  }
}

/// Form state holder for product add/edit screens
class ProductFormState {
  ProductFormState({
    String? name,
    String? description,
    String? price,
    String? wholesalePrice,
    String? wholesaleMinQty,
    ProductCategory? category,
    this.variety,
    PriceUnit? priceUnit,
    StockStatus? stockStatus,
    List<String>? existingImageUrls,
    List<ImageData>? newImages,
    bool? wholesaleEnabled,
  })  : nameController = TextEditingController(text: name),
        descriptionController = TextEditingController(text: description),
        priceController = TextEditingController(text: price),
        wholesalePriceController = TextEditingController(text: wholesalePrice),
        wholesaleMinQtyController = TextEditingController(text: wholesaleMinQty),
        category = category ?? ProductCategory.fresh,
        priceUnit = priceUnit ?? PriceUnit.perKg,
        stockStatus = stockStatus ?? StockStatus.available,
        existingImageUrls = existingImageUrls ?? [],
        newImages = newImages ?? [],
        wholesaleEnabled = wholesaleEnabled ?? false;

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController wholesalePriceController;
  final TextEditingController wholesaleMinQtyController;
  ProductCategory category;
  String? variety;
  PriceUnit priceUnit;
  StockStatus stockStatus;
  List<String> existingImageUrls;
  List<ImageData> newImages;
  bool wholesaleEnabled;

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    wholesalePriceController.dispose();
    wholesaleMinQtyController.dispose();
  }

  /// Check if form has images
  bool get hasImages => existingImageUrls.isNotEmpty || newImages.isNotEmpty;
}
