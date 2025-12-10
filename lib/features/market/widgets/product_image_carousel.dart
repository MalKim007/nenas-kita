import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/pineapple_placeholder.dart';

/// A carousel widget for displaying product images with animated pagination dots.
///
/// Features:
/// - Smooth PageView transitions
/// - Animated pill-shaped pagination indicators
/// - Cached network images with pineapple placeholder
/// - Gradient overlay for better text visibility
/// - Single image fallback mode
class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({
    super.key,
    required this.images,
    this.heroTag,
    this.height,
  });

  /// List of image URLs to display in the carousel
  final List<String> images;

  /// Optional hero tag for shared element transitions
  final String? heroTag;

  /// Optional height override (defaults to 300px)
  final double? height;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildImage(String imageUrl) {
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => const PineapplePlaceholder(),
      errorWidget: (context, url, error) => const PineapplePlaceholder(),
    );

    image = Semantics(
      label: 'Product image',
      child: image,
    );

    // Wrap with Hero if heroTag is provided
    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: image,
      );
    }

    return image;
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? 300.0;

    // Single image fallback - no PageView or pagination needed
    if (widget.images.isEmpty) {
      return SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const PineapplePlaceholder(),
            const _GradientOverlay(),
          ],
        ),
      );
    }

    if (widget.images.length == 1) {
      return SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(widget.images[0]),
            const _GradientOverlay(),
          ],
        ),
      );
    }

    // Multiple images - show carousel with pagination
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return _buildImage(widget.images[index]);
            },
          ),

          // Gradient overlay for better text visibility
          const _GradientOverlay(),

          // Pagination dots
          Positioned(
            bottom: AppSpacing.m,
            left: 0,
            right: 0,
            child: _PaginationDots(
              count: widget.images.length,
              currentIndex: _currentPage,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient overlay at the top for better app bar text visibility
class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x40000000), Colors.transparent],
          stops: [0.0, 0.5],
        ),
      ),
    );
  }
}

/// Animated pagination dots with pill-shaped active indicator
class _PaginationDots extends StatelessWidget {
  const _PaginationDots({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: _PaginationDot(
            isActive: index == currentIndex,
          ),
        ),
      ),
    );
  }
}

/// Individual pagination dot with smooth size and color animation
class _PaginationDot extends StatelessWidget {
  const _PaginationDot({
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppSpacing.animationFast,
      curve: Curves.easeInOut,
      width: isActive ? 24.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
