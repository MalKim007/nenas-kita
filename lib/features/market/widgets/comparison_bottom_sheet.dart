import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/market/models/product_with_farm.dart';

/// A striking comparison bottom sheet for NenasKita
///
/// Design: "Agricultural Market Intelligence" - combines warm pineapple tones
/// with professional data presentation. Features horizontal scrolling for
/// up to 3 products with best-in-row highlighting.
class ComparisonBottomSheet extends StatefulWidget {
  const ComparisonBottomSheet({
    super.key,
    required this.products,
    this.showWholesalePrice = false,
    this.onProductTap,
    this.onRemoveProduct,
  });

  final List<ProductWithFarm> products;
  final bool showWholesalePrice;
  final void Function(ProductWithFarm)? onProductTap;
  final void Function(ProductWithFarm)? onRemoveProduct;

  /// Show the comparison sheet as a modal bottom sheet
  static Future<void> show({
    required BuildContext context,
    required List<ProductWithFarm> products,
    bool showWholesalePrice = false,
    void Function(ProductWithFarm)? onProductTap,
    void Function(ProductWithFarm)? onRemoveProduct,
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ComparisonBottomSheet(
        products: products,
        showWholesalePrice: showWholesalePrice,
        onProductTap: onProductTap,
        onRemoveProduct: onRemoveProduct,
      ),
    );
  }

  @override
  State<ComparisonBottomSheet> createState() => _ComparisonBottomSheetState();
}

class _ComparisonBottomSheetState extends State<ComparisonBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drag handle
                  _buildDragHandle(),

                  // Header
                  _buildHeader(context),

                  // Divider with gradient
                  _buildGradientDivider(),

                  // Comparison content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: _buildComparisonTable(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.neutral300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      child: Row(
        children: [
          // Icon with gradient background
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.compare_arrows_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compare Products',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '${widget.products.length} products selected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Close button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientDivider() {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.4),
            AppColors.secondary.withValues(alpha: 0.4),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildComparisonTable(BuildContext context) {
    // Find best values for highlighting
    final bestPriceIndex = _findBestPriceIndex();
    final bestDistanceIndex = _findBestDistanceIndex();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product headers
            _buildProductHeaders(context),

            const SizedBox(height: 16),

            // Comparison rows
            _buildComparisonRow(
              context: context,
              label: 'Price',
              icon: Icons.attach_money_rounded,
              values: widget.products.map((p) => p.formattedPrice).toList(),
              bestIndex: bestPriceIndex,
              iconColor: AppColors.primary,
            ),

            _buildComparisonRow(
              context: context,
              label: 'Business',
              icon: Icons.agriculture_rounded,
              values: widget.products.map((p) => p.farmName).toList(),
              iconColor: AppColors.secondary,
            ),

            _buildComparisonRow(
              context: context,
              label: 'Location',
              icon: Icons.location_on_rounded,
              values: widget.products.map((p) => p.district).toList(),
              iconColor: AppColors.tertiary,
            ),

            _buildComparisonRow(
              context: context,
              label: 'Distance',
              icon: Icons.straighten_rounded,
              values: widget.products.map((p) => p.formattedDistance ?? 'N/A').toList(),
              bestIndex: bestDistanceIndex,
              iconColor: AppColors.info,
            ),

            _buildComparisonRow(
              context: context,
              label: 'Stock',
              icon: Icons.inventory_2_rounded,
              values: widget.products.map((p) => _getStockLabel(p.product.stockStatus)).toList(),
              customColors: widget.products.map((p) => _getStockColor(p.product.stockStatus)).toList(),
              iconColor: AppColors.success,
            ),

            _buildComparisonRow(
              context: context,
              label: 'Verified',
              icon: Icons.verified_rounded,
              values: widget.products.map((p) => p.isVerified ? 'LPNM Verified' : 'Not Verified').toList(),
              customColors: widget.products.map((p) => p.isVerified ? AppColors.secondary : AppColors.textSecondary).toList(),
              iconColor: AppColors.secondary,
            ),

            if (widget.showWholesalePrice)
              _buildComparisonRow(
                context: context,
                label: 'Wholesale',
                icon: Icons.local_shipping_rounded,
                values: widget.products.map((p) => p.formattedWholesalePrice ?? 'N/A').toList(),
                iconColor: AppColors.primary,
              ),

            const SizedBox(height: 24),

            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeaders(BuildContext context) {
    return Row(
      children: [
        // Empty space for row labels
        const SizedBox(width: 100),

        // Product cards
        ...widget.products.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 12,
            ),
            child: _ProductHeaderCard(
              product: product,
              onTap: () => widget.onProductTap?.call(product),
              onRemove: () => widget.onRemoveProduct?.call(product),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildComparisonRow({
    required BuildContext context,
    required String label,
    required IconData icon,
    required List<String> values,
    int? bestIndex,
    List<Color>? customColors,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Row label with icon
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Values
          ...values.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            final isBest = index == bestIndex;
            final customColor = customColors != null && index < customColors.length
                ? customColors[index]
                : null;

            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
              child: _ComparisonValueCell(
                value: value,
                isBest: isBest,
                customColor: customColor,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    // Find the best overall deal (lowest price with available stock)
    ProductWithFarm? bestDeal;
    double? lowestPrice;

    for (final product in widget.products) {
      if (product.product.stockStatus != StockStatus.out) {
        if (lowestPrice == null || product.product.price < lowestPrice) {
          lowestPrice = product.product.price;
          bestDeal = product;
        }
      }
    }

    return Row(
      children: [
        const SizedBox(width: 100),

        ...widget.products.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          final isBestDeal = product == bestDeal;

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
            child: SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  widget.onProductTap?.call(product);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBestDeal ? AppColors.success : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isBestDeal ? 4 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isBestDeal) ...[
                      const Icon(Icons.star_rounded, size: 16),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      isBestDeal ? 'Best Pick' : 'View',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  int? _findBestPriceIndex() {
    if (widget.products.isEmpty) return null;

    int bestIndex = 0;
    double bestPrice = widget.products.first.product.price;

    for (int i = 1; i < widget.products.length; i++) {
      if (widget.products[i].product.price < bestPrice) {
        bestPrice = widget.products[i].product.price;
        bestIndex = i;
      }
    }

    return bestIndex;
  }

  int? _findBestDistanceIndex() {
    if (widget.products.isEmpty) return null;

    int? bestIndex;
    double? bestDistance;

    for (int i = 0; i < widget.products.length; i++) {
      final distance = widget.products[i].distanceKm;
      if (distance != null) {
        if (bestDistance == null || distance < bestDistance) {
          bestDistance = distance;
          bestIndex = i;
        }
      }
    }

    return bestIndex;
  }

  String _getStockLabel(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return 'Available';
      case StockStatus.limited:
        return 'Limited';
      case StockStatus.out:
        return 'Out of Stock';
    }
  }

  Color _getStockColor(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return AppColors.success;
      case StockStatus.limited:
        return AppColors.warning;
      case StockStatus.out:
        return AppColors.error;
    }
  }
}

/// Product header card in the comparison table
class _ProductHeaderCard extends StatelessWidget {
  const _ProductHeaderCard({
    required this.product,
    this.onTap,
    this.onRemove,
  });

  final ProductWithFarm product;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.neutral50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outline.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Remove button
            if (onRemove != null)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onRemove?.call();
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),

            // Product image
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Image
                    product.displayImage != null && product.displayImage!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.displayImage!,
                            fit: BoxFit.cover,
                            width: 64,
                            height: 64,
                            placeholder: (context, url) => _buildPlaceholder(),
                            errorWidget: (context, url, error) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),

                    // Verified badge
                    if (product.isVerified)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 12,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Product name
            Text(
              product.productName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

            // Variety badge - only for fresh products
            if (product.product.category == ProductCategory.fresh &&
                product.product.variety != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product.product.variety!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.agriculture_rounded,
          color: AppColors.primary.withValues(alpha: 0.4),
          size: 28,
        ),
      ),
    );
  }
}

/// Value cell in the comparison table with optional "best" highlighting
class _ComparisonValueCell extends StatelessWidget {
  const _ComparisonValueCell({
    required this.value,
    this.isBest = false,
    this.customColor,
  });

  final String value;
  final bool isBest;
  final Color? customColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isBest
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.neutral50,
        borderRadius: BorderRadius.circular(10),
        border: isBest
            ? Border.all(
                color: AppColors.success,
                width: 2,
              )
            : Border.all(
                color: AppColors.outline.withValues(alpha: 0.3),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isBest) ...[
            const Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: AppColors.success,
            ),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBest ? FontWeight.w700 : FontWeight.w500,
                color: customColor ?? (isBest ? AppColors.success : AppColors.textPrimary),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
