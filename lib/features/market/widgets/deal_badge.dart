import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';

/// A circular badge that displays the deal quality level with icon, label, and percentage.
///
/// EXCELLENT deals feature a green glow shadow + pulse animation to draw attention.
/// Designed for outdoor visibility with high contrast colors.
class DealBadge extends StatefulWidget {
  const DealBadge({
    super.key,
    required this.dealLevel,
    required this.percentDiff,
  });

  /// The quality level of this deal
  final DealLevel dealLevel;

  /// Percentage difference from average (negative = below avg, positive = above avg)
  final double percentDiff;

  @override
  State<DealBadge> createState() => _DealBadgeState();
}

class _DealBadgeState extends State<DealBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Only pulse for EXCELLENT deals
    if (widget.dealLevel.shouldPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = widget.dealLevel == DealLevel.excellent ? 70.0 : 60.0;

    Widget badge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.dealLevel.color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.dealLevel.color,
          width: 2.0,
        ),
        boxShadow: widget.dealLevel.hasGlow
            ? [
                BoxShadow(
                  color: widget.dealLevel.color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: widget.dealLevel.color.withValues(alpha: 0.2),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.dealLevel.icon,
            color: widget.dealLevel.color,
            size: 18,
          ),
          const SizedBox(height: 2),
          Text(
            widget.dealLevel.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: widget.dealLevel.color,
              fontWeight: FontWeight.bold,
              fontSize: 8,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 1),
          Text(
            '${widget.percentDiff.abs().toStringAsFixed(0)}%',
            style: theme.textTheme.labelSmall?.copyWith(
              color: widget.dealLevel.color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    // Wrap with pulse animation for EXCELLENT deals
    if (widget.dealLevel.shouldPulse) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: badge,
      );
    }

    return badge;
  }
}
