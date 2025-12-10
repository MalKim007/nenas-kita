import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Button variant types
enum AppButtonVariant {
  primary,   // ElevatedButton - main CTAs
  secondary, // OutlinedButton - secondary actions
  text,      // TextButton - tertiary actions
  danger,    // Red button for destructive actions
}

/// Icon position in button
enum IconPosition { leading, trailing }

/// Reusable button component with consistent styling
/// Sharp & Minimal design with subtle press animation
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.iconPosition = IconPosition.leading,
  });

  /// Callback when button is pressed (null = disabled)
  final VoidCallback? onPressed;

  /// Button label text
  final String label;

  /// Button variant (primary, secondary, text, danger)
  final AppButtonVariant variant;

  /// Show loading spinner instead of label
  final bool isLoading;

  /// Expand to full width
  final bool isFullWidth;

  /// Optional icon
  final IconData? icon;

  /// Icon position (leading or trailing)
  final IconPosition iconPosition;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppSpacing.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppSpacing.buttonPressScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppSpacing.animationCurve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();

    Widget button;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        button = Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF59E0B), // Amber 500 (lighter)
                Color(0xFFD97706), // Amber 600 (primary)
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isPressed ? 0.4 : 0.3),
                blurRadius: _isPressed ? 8 : 12,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
            child: child,
          ),
        );
        break;
      case AppButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: _isPressed ? AppColors.primary : AppColors.outline,
              width: _isPressed ? 2 : 1,
            ),
          ),
          child: child,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          child: child,
        );
        break;
      case AppButtonVariant.danger:
        button = Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEF4444), // Red 500 (lighter)
                Color(0xFFDC2626), // Red 600 (error)
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withValues(alpha: _isPressed ? 0.4 : 0.3),
                blurRadius: _isPressed ? 8 : 12,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
            child: child,
          ),
        );
        break;
    }

    // Wrap with gesture detector for press animation
    Widget animatedButton = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: button,
      ),
    );

    if (widget.isFullWidth) {
      return SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeight,
        child: animatedButton,
      );
    }

    return animatedButton;
  }

  Widget _buildChild() {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.variant == AppButtonVariant.secondary ||
                    widget.variant == AppButtonVariant.text
                ? AppColors.primary
                : Colors.white,
          ),
        ),
      );
    }

    if (widget.icon == null) {
      return Text(widget.label);
    }

    final iconWidget = Icon(widget.icon, size: 20);
    final textWidget = Text(widget.label);

    if (widget.iconPosition == IconPosition.trailing) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textWidget,
          AppSpacing.hGapS,
          iconWidget,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconWidget,
        AppSpacing.hGapS,
        textWidget,
      ],
    );
  }
}

/// WhatsApp button with green color and icon
/// Sharp & Minimal design with press animation
class WhatsAppButton extends StatefulWidget {
  const WhatsAppButton({
    super.key,
    required this.onPressed,
    this.label = 'WhatsApp',
    this.isFullWidth = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isFullWidth;

  @override
  State<WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<WhatsAppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppSpacing.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppSpacing.buttonPressScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppSpacing.animationCurve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: widget.onPressed,
      icon: const Icon(Icons.chat, size: 20),
      label: Text(widget.label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.whatsapp,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        elevation: 1,
        shadowColor: AppColors.whatsapp.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
      ),
    );

    Widget animatedButton = GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: button,
      ),
    );

    if (widget.isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: animatedButton,
      );
    }

    return animatedButton;
  }
}
