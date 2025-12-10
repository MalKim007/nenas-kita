import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Reusable card component with consistent styling
/// Sharp & Minimal design with subtle borders and refined shadows
/// Enhanced with hover/press scale animation and haptic feedback
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.elevation,
    this.border,
    this.showBorder = true,
    this.clipBehavior = Clip.antiAlias,
    this.enableHapticFeedback = true,
    this.enableScaleAnimation = true,
  });

  /// Card content
  final Widget child;

  /// Tap callback (adds InkWell if provided)
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Custom padding (default: AppSpacing.cardPadding)
  final EdgeInsetsGeometry? padding;

  /// Card margin
  final EdgeInsetsGeometry? margin;

  /// Card background color (default: surface)
  final Color? color;

  /// Border radius (default: AppSpacing.cardRadius)
  final BorderRadius? borderRadius;

  /// Elevation (default: AppSpacing.cardElevation)
  final double? elevation;

  /// Optional border (overrides showBorder)
  final Border? border;

  /// Show subtle border for scanability (Sharp & Minimal)
  final bool showBorder;

  /// Clip behavior
  final Clip clipBehavior;

  /// Enable haptic feedback on tap
  final bool enableHapticFeedback;

  /// Enable scale animation on press
  final bool enableScaleAnimation;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: AppSpacing.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98, // Subtle scale down on press
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: AppSpacing.animationCurve,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null || widget.onLongPress != null) {
      setState(() => _isPressed = true);
      if (widget.enableScaleAnimation) {
        _scaleController.forward();
      }
      if (widget.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    if (widget.enableScaleAnimation) {
      _scaleController.reverse();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    if (widget.enableScaleAnimation) {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = widget.borderRadius ??
        BorderRadius.circular(AppSpacing.cardRadius);

    Widget cardContent = Padding(
      padding: widget.padding ?? AppSpacing.cardPadding,
      child: widget.child,
    );

    // Add InkWell for tap interaction with visual feedback
    if (widget.onTap != null || widget.onLongPress != null) {
      cardContent = InkWell(
        onTap: () {
          if (widget.enableHapticFeedback) {
            HapticFeedback.selectionClick();
          }
          widget.onTap?.call();
        },
        onLongPress: widget.onLongPress,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        borderRadius: effectiveBorderRadius,
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: cardContent,
      );
    }

    // Determine border
    final effectiveBorder = widget.border ??
        (widget.showBorder
            ? Border.all(
                color: AppColors.outline.withValues(alpha: _isHovered ? 0.8 : 0.5),
                width: 1,
              )
            : null);

    Widget card = AnimatedContainer(
      duration: AppSpacing.animationFast,
      curve: AppSpacing.animationCurve,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.color ?? AppColors.surface,
        borderRadius: effectiveBorderRadius,
        border: effectiveBorder,
        boxShadow: _isPressed
            ? AppSpacing.shadowMedium
            : _isHovered
                ? AppSpacing.shadowMedium
                : AppSpacing.shadowSmall,
      ),
      clipBehavior: widget.clipBehavior,
      child: Material(
        color: Colors.transparent,
        child: cardContent,
      ),
    );

    // Wrap with mouse region and scale animation
    if (widget.onTap != null || widget.onLongPress != null) {
      card = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: widget.enableScaleAnimation
            ? AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: card,
              )
            : card,
      );
    }

    return card;
  }
}

/// Card with image header
class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.child,
    this.onTap,
    this.imageHeight = 120,
    this.imageFit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.padding,
    this.margin,
  });

  final String? imageUrl;
  final Widget child;
  final VoidCallback? onTap;
  final double imageHeight;
  final BoxFit imageFit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          SizedBox(
            height: imageHeight,
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    imageUrl!,
                    fit: imageFit,
                    errorBuilder: (_, __, ___) =>
                        errorWidget ?? _defaultPlaceholder(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return placeholder ?? _defaultPlaceholder();
                    },
                  )
                : placeholder ?? _defaultPlaceholder(),
          ),
          // Content section
          Padding(
            padding: padding ?? AppSpacing.cardPadding,
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: AppColors.textDisabled,
        ),
      ),
    );
  }
}

/// Outlined card variant (no elevation, with border)
/// Sharp & Minimal design with clean selection state
class OutlinedCard extends StatelessWidget {
  const OutlinedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderColor,
    this.isSelected = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppSpacing.animationFast,
      curve: AppSpacing.animationCurve,
      child: AppCard(
        onTap: onTap,
        padding: padding,
        margin: margin,
        elevation: 0,
        showBorder: false,
        color: isSelected ? AppColors.primaryContainer : AppColors.surface,
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : (borderColor ?? AppColors.outline),
          width: isSelected ? 2 : 1,
        ),
        child: child,
      ),
    );
  }
}

/// Warm colored card (using surfaceVariant background)
class WarmCard extends StatelessWidget {
  const WarmCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: padding,
      margin: margin,
      color: AppColors.surfaceVariant,
      child: child,
    );
  }
}
