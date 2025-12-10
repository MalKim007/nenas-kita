import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Animated checkmark widget with draw animation
/// Uses CustomPainter to draw the checkmark path progressively
class AnimatedCheckmark extends StatefulWidget {
  const AnimatedCheckmark({
    super.key,
    this.size = 80,
    this.color,
    this.strokeWidth = 6,
    this.onComplete,
    this.autoStart = true,
  });

  /// Size of the checkmark container
  final double size;

  /// Color of the checkmark (defaults to secondary/success color)
  final Color? color;

  /// Stroke width of the checkmark line
  final double strokeWidth;

  /// Callback when animation completes
  final VoidCallback? onComplete;

  /// Whether to start animation automatically
  final bool autoStart;

  @override
  State<AnimatedCheckmark> createState() => AnimatedCheckmarkState();
}

class AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppSpacing.checkmarkDrawDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Manually start the animation
  void start() {
    _controller.forward(from: 0);
  }

  /// Reset the animation
  void reset() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _CheckmarkPainter(
              progress: _animation.value,
              color: widget.color ?? AppColors.secondary,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  _CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Checkmark path points (relative to size)
    // Start from left-middle, go down to bottom-middle, then up to top-right
    final startX = size.width * 0.2;
    final startY = size.height * 0.5;
    final midX = size.width * 0.4;
    final midY = size.height * 0.7;
    final endX = size.width * 0.8;
    final endY = size.height * 0.3;

    final path = Path();

    // Calculate the total path length for proper animation
    final firstSegmentLength = _distance(startX, startY, midX, midY);
    final secondSegmentLength = _distance(midX, midY, endX, endY);
    final totalLength = firstSegmentLength + secondSegmentLength;

    final currentLength = progress * totalLength;

    if (currentLength <= 0) return;

    path.moveTo(startX, startY);

    if (currentLength <= firstSegmentLength) {
      // Still drawing first segment
      final t = currentLength / firstSegmentLength;
      final x = startX + (midX - startX) * t;
      final y = startY + (midY - startY) * t;
      path.lineTo(x, y);
    } else {
      // First segment complete, drawing second segment
      path.lineTo(midX, midY);
      final remainingLength = currentLength - firstSegmentLength;
      final t = remainingLength / secondSegmentLength;
      final x = midX + (endX - midX) * t;
      final y = midY + (endY - midY) * t;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  double _distance(double x1, double y1, double x2, double y2) {
    return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2));
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Animated checkmark with circular background
class AnimatedCheckmarkCircle extends StatefulWidget {
  const AnimatedCheckmarkCircle({
    super.key,
    this.size = 100,
    this.checkmarkColor,
    this.backgroundColor,
    this.strokeWidth = 5,
    this.onComplete,
    this.autoStart = true,
  });

  final double size;
  final Color? checkmarkColor;
  final Color? backgroundColor;
  final double strokeWidth;
  final VoidCallback? onComplete;
  final bool autoStart;

  @override
  State<AnimatedCheckmarkCircle> createState() => _AnimatedCheckmarkCircleState();
}

class _AnimatedCheckmarkCircleState extends State<AnimatedCheckmarkCircle>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _checkController = AnimationController(
      duration: AppSpacing.checkmarkDrawDuration,
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOut,
    );

    _checkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.autoStart) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    await _scaleController.forward();
    await _checkController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppColors.secondaryContainer,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _checkAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size * 0.5, widget.size * 0.5),
                painter: _CheckmarkPainter(
                  progress: _checkAnimation.value,
                  color: widget.checkmarkColor ?? AppColors.secondary,
                  strokeWidth: widget.strokeWidth,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Success overlay with animated checkmark
/// Shows a centered checkmark with optional message
class SuccessOverlay extends StatelessWidget {
  const SuccessOverlay({
    super.key,
    this.message,
    this.onComplete,
    this.autoDismissDelay = const Duration(milliseconds: 1500),
  });

  /// Optional success message to display
  final String? message;

  /// Callback when animation completes
  final VoidCallback? onComplete;

  /// Delay before calling onComplete (for auto-navigation)
  final Duration autoDismissDelay;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedCheckmarkCircle(
              size: 100,
              onComplete: () {
                Future.delayed(autoDismissDelay, () {
                  onComplete?.call();
                });
              },
            ),
            if (message != null) ...[
              AppSpacing.vGapL,
              Text(
                message!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
