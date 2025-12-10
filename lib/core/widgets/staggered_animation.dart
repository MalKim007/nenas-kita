import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// A widget that animates its child with a staggered fade + slide animation
/// Perfect for list items and grid items
class StaggeredFadeSlide extends StatefulWidget {
  const StaggeredFadeSlide({
    super.key,
    required this.child,
    required this.index,
    this.direction = SlideDirection.up,
    this.delay = const Duration(milliseconds: 50),
    this.duration = AppSpacing.animationNormal,
    this.curve = Curves.easeOutCubic,
    this.slideOffset = 20.0,
  });

  /// The child widget to animate
  final Widget child;

  /// Index of the item in the list (used for stagger delay)
  final int index;

  /// Direction to slide from
  final SlideDirection direction;

  /// Delay between each item animation
  final Duration delay;

  /// Duration of the animation
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// How far to slide (in logical pixels)
  final double slideOffset;

  @override
  State<StaggeredFadeSlide> createState() => _StaggeredFadeSlideState();
}

class _StaggeredFadeSlideState extends State<StaggeredFadeSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: _getStartOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation after stagger delay
    Future.delayed(widget.delay * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  Offset _getStartOffset() {
    final offset = widget.slideOffset / 100; // Convert to relative offset
    switch (widget.direction) {
      case SlideDirection.up:
        return Offset(0, offset);
      case SlideDirection.down:
        return Offset(0, -offset);
      case SlideDirection.left:
        return Offset(offset, 0);
      case SlideDirection.right:
        return Offset(-offset, 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Direction for slide animation
enum SlideDirection { up, down, left, right }

/// A widget that animates its child with a scale + fade animation
/// Good for cards and prominent UI elements
class ScaleFadeIn extends StatefulWidget {
  const ScaleFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppSpacing.animationNormal,
    this.curve = Curves.easeOutBack,
    this.initialScale = 0.8,
  });

  /// The child widget to animate
  final Widget child;

  /// Delay before animation starts
  final Duration delay;

  /// Duration of the animation
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Initial scale (0.0 to 1.0)
  final double initialScale;

  @override
  State<ScaleFadeIn> createState() => _ScaleFadeInState();
}

class _ScaleFadeInState extends State<ScaleFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation after delay
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// A builder for staggered grid animations
/// Wraps GridView.builder with automatic stagger animations
class StaggeredGridView extends StatelessWidget {
  const StaggeredGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.animationDuration = AppSpacing.animationNormal,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Duration staggerDelay;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return StaggeredFadeSlide(
          index: index,
          delay: staggerDelay,
          duration: animationDuration,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// A builder for staggered list animations
/// Wraps ListView.builder with automatic stagger animations
class StaggeredListView extends StatelessWidget {
  const StaggeredListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.animationDuration = AppSpacing.animationNormal,
    this.direction = SlideDirection.up,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Duration staggerDelay;
  final Duration animationDuration;
  final SlideDirection direction;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return StaggeredFadeSlide(
          index: index,
          delay: staggerDelay,
          duration: animationDuration,
          direction: direction,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}
