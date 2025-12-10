import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/theme/app_text_styles.dart';

/// Standard loading indicator with improved styling
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
    this.message,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );

    if (message == null) {
      return indicator;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        AppSpacing.vGapM,
        Text(
          message!,
          style: AppTextStyles.bodyMediumDim,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Shimmer loading effect for skeleton screens
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.timeout = const Duration(seconds: 10),
    this.onTimeout,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? timeout;
  final VoidCallback? onTimeout;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasTimedOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    // Set up timeout if specified
    if (widget.timeout != null) {
      Future.delayed(widget.timeout!, () {
        if (mounted) {
          setState(() => _hasTimedOut = true);
          widget.onTimeout?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() => _hasTimedOut = false);
    _controller.repeat();

    // Restart timeout
    if (widget.timeout != null) {
      Future.delayed(widget.timeout!, () {
        if (mounted) {
          setState(() => _hasTimedOut = true);
          widget.onTimeout?.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTimedOut) {
      return GestureDetector(
        onTap: _retry,
        child: Container(
          padding: AppSpacing.paddingM,
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 32,
              ),
              AppSpacing.vGapS,
              Text(
                'Loading taking too long',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.vGapXS,
              Text(
                'Tap to retry',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final baseColor = widget.baseColor ?? AppColors.neutral200;
    final highlightColor = widget.highlightColor ?? AppColors.neutral50;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5 + _animation.value * 0.25,
                1.0,
              ],
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Shimmer skeleton box placeholder
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSpacing.radiusS,
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton for a card layout
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.height = 120,
    this.hasImage = true,
  });

  final double height;
  final bool hasImage;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        height: height,
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            if (hasImage) ...[
              Container(
                width: height - 32,
                height: height - 32,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
              ),
              AppSpacing.hGapM,
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                    ),
                  ),
                  AppSpacing.vGapS,
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                    ),
                  ),
                  AppSpacing.vGapS,
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer list of cards
class ShimmerCardList extends StatelessWidget {
  const ShimmerCardList({
    super.key,
    this.itemCount = 3,
    this.cardHeight = 100,
  });

  final int itemCount;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => AppSpacing.vGapM,
      itemBuilder: (_, __) => ShimmerCard(height: cardHeight),
    );
  }
}

/// Circular avatar placeholder with shimmer
class ShimmerAvatar extends StatelessWidget {
  const ShimmerAvatar({
    super.key,
    this.size = 48,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Image placeholder with aspect ratio and shimmer
class ShimmerImage extends StatelessWidget {
  const ShimmerImage({
    super.key,
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final double? aspectRatio;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusM),
      ),
    );

    if (aspectRatio != null) {
      child = AspectRatio(
        aspectRatio: aspectRatio!,
        child: child,
      );
    }

    return ShimmerLoading(child: child);
  }
}

/// Single line text placeholder with shimmer
class ShimmerText extends StatelessWidget {
  const ShimmerText({
    super.key,
    this.width,
    this.height = 14,
  });

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }
}

/// Multi-line paragraph placeholder with shimmer
class ShimmerParagraph extends StatelessWidget {
  const ShimmerParagraph({
    super.key,
    this.lines = 3,
    this.lineHeight = 14,
    this.lineSpacing = 8,
    this.lastLineWidth = 0.6,
  });

  final int lines;
  final double lineHeight;
  final double lineSpacing;
  final double lastLineWidth; // Percentage (0.0 - 1.0)

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(lines, (index) {
          final isLast = index == lines - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : lineSpacing),
            child: FractionallySizedBox(
              widthFactor: isLast ? lastLineWidth : 1.0,
              child: Container(
                height: lineHeight,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(lineHeight / 2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: Colors.black26,
        child: Center(
          child: Container(
            padding: AppSpacing.paddingL,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AppLoading(
              size: 40,
              message: message,
            ),
          ),
        ),
      ),
    );
  }
}

/// Loading screen (full page)
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppLoading(
          size: 48,
          message: message ?? 'Loading...',
        ),
      ),
    );
  }
}

/// Inline loading (for buttons, etc.)
class InlineLoading extends StatelessWidget {
  const InlineLoading({
    super.key,
    this.size = 16,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }
}

/// Loading wrapper that shows loading state while data is being fetched
class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.showChildWhileLoading = false,
  });

  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final bool showChildWhileLoading;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    if (showChildWhileLoading) {
      return Stack(
        children: [
          child,
          const LoadingOverlay(),
        ],
      );
    }

    return loadingWidget ??
        const Center(
          child: AppLoading(
            size: 32,
          ),
        );
  }
}

/// Pull-to-refresh wrapper
class RefreshableWrapper extends StatelessWidget {
  const RefreshableWrapper({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: child,
    );
  }
}
