import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/pineapple_placeholder.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';

/// Product card for grid display with hero animation support
///
/// Design: "Agricultural Elegance" - Warm, organic feel with modern polish.
/// Features refined typography, warm gradient overlays, and satisfying micro-interactions.
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onLongPress,
    this.heroTag,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? heroTag;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    // Subtle shimmer effect for premium feel
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = widget.heroTag ?? 'product_${widget.product.id}';

    return Semantics(
      label: '${widget.product.name}, ${widget.product.variety}, ${widget.product.formattedPrice}. ${_getStockStatusLabel()}',
      button: true,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
            // Warm amber tint on press for brand connection
            color: _isPressed
                ? AppColors.primaryContainer.withValues(alpha: 0.1)
                : Colors.transparent,
            boxShadow: [
              // Primary soft shadow
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isPressed ? 0.12 : 0.08),
                blurRadius: _isPressed ? 20 : 16,
                offset: Offset(0, _isPressed ? 8 : 6),
                spreadRadius: _isPressed ? -2 : -4,
              ),
              // Ambient fill shadow for depth
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              side: BorderSide(
                color: _isPressed
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.outline.withValues(alpha: 0.15),
                width: _isPressed ? 1.5 : 1,
              ),
            ),
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: InkWell(
                onTap: widget.onTap != null
                    ? () {
                        HapticFeedback.selectionClick();
                        widget.onTap!();
                      }
                    : null,
                onLongPress: widget.onLongPress != null
                    ? () {
                        HapticFeedback.mediumImpact();
                        widget.onLongPress!();
                      }
                    : null,
                splashColor: AppColors.primary.withValues(alpha: 0.1),
                highlightColor: AppColors.primaryContainer.withValues(alpha: 0.15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section with Hero animation and warm gradient overlay
                    Expanded(
                      flex: 3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: heroTag,
                            child: _buildImage(),
                          ),
                          // Warm gradient overlay - amber tinted for brand
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.0, 0.5, 1.0],
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    // Warm amber-tinted dark for brand cohesion
                                    const Color(0xFF1A1408).withValues(alpha: 0.65),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Stock status badge - bottom right with glassmorphism
                          Positioned(
                            bottom: AppSpacing.s,
                            right: AppSpacing.s,
                            child: _StockBadgeEnhanced(status: widget.product.stockStatus),
                          ),
                        ],
                      ),
                    ),
                    // Content section with refined typography
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.m,
                        AppSpacing.s,
                        AppSpacing.m,
                        AppSpacing.s,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Name - bold with slight letter spacing
                          Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                  height: 1.2,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Variety row - consistent height for all products
                          SizedBox(
                            height: 16, // Fixed height for consistency
                            child: (widget.product.category == ProductCategory.fresh &&
                                    widget.product.variety != null)
                                ? Text(
                                    widget.product.variety!,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null, // Empty space for processed products
                          ),
                          const SizedBox(height: 6),
                          // Price with enhanced styling - split currency
                          _buildPriceDisplay(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds an enhanced price display with currency emphasis
  Widget _buildPriceDisplay(BuildContext context) {
    // Parse price to separate currency and amount
    final priceText = widget.product.formattedPrice;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Currency symbol - smaller, lighter weight
        Text(
          'RM',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(width: 2),
        // Price amount - prominent
        Expanded(
          child: Text(
            priceText.replaceAll('RM ', '').replaceAll('RM', ''),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getStockStatusLabel() {
    switch (widget.product.stockStatus) {
      case StockStatus.available:
        return 'In stock';
      case StockStatus.limited:
        return 'Limited stock';
      case StockStatus.out:
        return 'Out of stock';
    }
  }

  Widget _buildImage() {
    if (widget.product.primaryImage != null && widget.product.primaryImage!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.product.primaryImage!,
        fit: BoxFit.cover,
        fadeInDuration: AppSpacing.imageFadeDuration,
        fadeOutDuration: AppSpacing.animationFast,
        placeholder: (_, __) => const PineapplePlaceholder(),
        errorWidget: (_, __, ___) => const PineapplePlaceholder(),
      );
    }
    return const PineapplePlaceholder();
  }
}

/// Enhanced stock badge with glassmorphism effect for ProductCard
/// Private widget used only within this file for the refined card design
class _StockBadgeEnhanced extends StatelessWidget {
  const _StockBadgeEnhanced({required this.status});

  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _semanticLabel,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusS + 2),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s + 2,
            vertical: AppSpacing.xs + 1,
          ),
          decoration: BoxDecoration(
            // Glassmorphism: semi-transparent with blur simulation
            color: _backgroundColor.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(AppSpacing.radiusS + 2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, size: 11, color: _textColor),
              const SizedBox(width: 4),
              Text(
                _label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _semanticLabel {
    switch (status) {
      case StockStatus.available:
        return 'In stock';
      case StockStatus.limited:
        return 'Limited stock available';
      case StockStatus.out:
        return 'Currently out of stock';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case StockStatus.available:
        return const Color(0xFFE8F5E9); // Softer green
      case StockStatus.limited:
        return const Color(0xFFFFF8E1); // Warm amber
      case StockStatus.out:
        return const Color(0xFFFFEBEE); // Soft red
    }
  }

  Color get _textColor {
    switch (status) {
      case StockStatus.available:
        return const Color(0xFF2E7D32); // Deep green
      case StockStatus.limited:
        return const Color(0xFFE65100); // Deep orange
      case StockStatus.out:
        return const Color(0xFFC62828); // Deep red
    }
  }

  IconData get _icon {
    switch (status) {
      case StockStatus.available:
        return Icons.check_circle_rounded;
      case StockStatus.limited:
        return Icons.schedule_rounded;
      case StockStatus.out:
        return Icons.remove_circle_rounded;
    }
  }

  String get _label {
    switch (status) {
      case StockStatus.available:
        return 'In Stock';
      case StockStatus.limited:
        return 'Limited';
      case StockStatus.out:
        return 'Sold Out';
    }
  }
}

/// Stock status badge with semantic support (legacy - for use in other widgets)
class StockBadge extends StatelessWidget {
  const StockBadge({super.key, required this.status});

  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _semanticLabel,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          boxShadow: [
            BoxShadow(
              color: _backgroundColor.withValues(alpha: 0.5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 12, color: _textColor),
            const SizedBox(width: 4),
            Text(
              _label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _semanticLabel {
    switch (status) {
      case StockStatus.available:
        return 'In stock';
      case StockStatus.limited:
        return 'Limited stock available';
      case StockStatus.out:
        return 'Currently out of stock';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case StockStatus.available:
        return AppColors.secondaryContainer;
      case StockStatus.limited:
        return AppColors.primaryContainer;
      case StockStatus.out:
        return AppColors.errorLight;
    }
  }

  Color get _textColor {
    switch (status) {
      case StockStatus.available:
        return AppColors.secondary;
      case StockStatus.limited:
        return AppColors.warning;
      case StockStatus.out:
        return AppColors.error;
    }
  }

  IconData get _icon {
    switch (status) {
      case StockStatus.available:
        return Icons.check_circle;
      case StockStatus.limited:
        return Icons.warning;
      case StockStatus.out:
        return Icons.cancel;
    }
  }

  String get _label {
    switch (status) {
      case StockStatus.available:
        return 'Available';
      case StockStatus.limited:
        return 'Limited';
      case StockStatus.out:
        return 'Out';
    }
  }
}

/// Category badge (Fresh/Processed) with semantic support
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: category == ProductCategory.fresh ? 'Fresh product' : 'Processed product',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          boxShadow: AppSpacing.shadowSmall,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category == ProductCategory.fresh
                  ? Icons.eco
                  : Icons.inventory_2,
              size: 12,
              color: category == ProductCategory.fresh
                  ? AppColors.secondary
                  : AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              category == ProductCategory.fresh ? 'Fresh' : 'Processed',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact product list item with enhanced accessibility
class ProductListItem extends StatelessWidget {
  const ProductListItem({
    super.key,
    required this.product,
    this.onTap,
    this.trailing,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${product.name}, ${product.formattedPrice}',
      button: true,
      child: ListTile(
        onTap: onTap != null
            ? () {
                HapticFeedback.selectionClick();
                onTap!();
              }
            : null,
        // Minimum touch target size of 48x48 for accessibility
        minVerticalPadding: 12,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusS),
          child: SizedBox(
            width: 56,
            height: 56,
            child: product.primaryImage != null
                ? CachedNetworkImage(
                    imageUrl: product.primaryImage!,
                    fit: BoxFit.cover,
                    fadeInDuration: AppSpacing.imageFadeDuration,
                    fadeOutDuration: AppSpacing.animationFast,
                    placeholder: (_, __) => const PineapplePlaceholder(size: 56),
                    errorWidget: (_, __, ___) => const PineapplePlaceholder(size: 56),
                  )
                : const PineapplePlaceholder(size: 56),
          ),
        ),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          product.formattedPrice,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing ?? StockBadge(status: product.stockStatus),
      ),
    );
  }
}
