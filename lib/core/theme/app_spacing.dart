import 'package:flutter/material.dart';

/// NenasKita spacing system
/// Based on 4dp base grid (Material Design)
class AppSpacing {
  AppSpacing._();

  // Base spacing values
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Section spacing (breathing room between major sections)
  static const double sectionGap = 32.0;
  static const double headerGap = 12.0;

  // Shadow elevation presets (Enhanced depth for modern look)
  static const double shadowElevationS = 2.0;
  static const double shadowElevationM = 4.0;
  static const double shadowElevationL = 8.0;
  static const double shadowElevationXL = 16.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Shimmer animation
  static const Duration shimmerDuration = Duration(milliseconds: 1500);
  static const Duration shimmerDurationFast = Duration(milliseconds: 1000);

  // Image fade-in
  static const Duration imageFadeDuration = Duration(milliseconds: 300);

  // Checkmark draw animation
  static const Duration checkmarkDrawDuration = Duration(milliseconds: 400);

  // Animation curves
  static const Curve animationCurve = Curves.easeOutCubic;
  static const Curve animationCurveBounce = Curves.elasticOut;

  // Specific use cases
  static const double iconPadding = xs;
  static const double inlineSpacing = s;
  static const double componentPadding = m;
  static const double sectionSpacing = l;
  static const double pageMargin = xl;
  static const double majorSections = xxl;

  // Border radius (modernized - larger for softer look)
  static const double radiusS = 6.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusFull = 999.0;

  // Touch targets (accessibility)
  static const double touchTargetMin = 48.0;
  static const double touchTargetPreferred = 56.0;

  // Card dimensions
  static const double cardElevation = 2.0;
  static const double cardRadius = radiusM;

  // Multi-layer shadow definitions for depth perception
  static List<BoxShadow> get shadowSmall => [
    const BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x0F000000), // 6% opacity
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: -1,
    ),
  ];

  static List<BoxShadow> get shadowMedium => [
    const BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x14000000), // 8% opacity
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  static List<BoxShadow> get shadowLarge => [
    const BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x1A000000), // 10% opacity
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  // Button dimensions
  static const double buttonHeight = 48.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonRadius = radiusM;

  // Input field dimensions
  static const double inputHeight = 48.0;
  static const double inputRadius = radiusM;

  // EdgeInsets helpers
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingS = EdgeInsets.all(s);
  static const EdgeInsets paddingM = EdgeInsets.all(m);
  static const EdgeInsets paddingL = EdgeInsets.all(l);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: m);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: l);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: l);

  // Page padding (standard screen padding)
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: m,
    vertical: l,
  );

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(m);

  // List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: m,
    vertical: s,
  );

  // SizedBox helpers
  static const SizedBox gapXS = SizedBox(width: xs, height: xs);
  static const SizedBox gapS = SizedBox(width: s, height: s);
  static const SizedBox gapM = SizedBox(width: m, height: m);
  static const SizedBox gapL = SizedBox(width: l, height: l);
  static const SizedBox gapXL = SizedBox(width: xl, height: xl);

  // Horizontal gaps
  static const SizedBox hGapXS = SizedBox(width: xs);
  static const SizedBox hGapS = SizedBox(width: s);
  static const SizedBox hGapM = SizedBox(width: m);
  static const SizedBox hGapL = SizedBox(width: l);

  // Vertical gaps
  static const SizedBox vGapXXS = SizedBox(height: xxs);
  static const SizedBox vGapXS = SizedBox(height: xs);
  static const SizedBox vGapS = SizedBox(height: s);
  static const SizedBox vGapM = SizedBox(height: m);
  static const SizedBox vGapL = SizedBox(height: l);
  static const SizedBox vGapXL = SizedBox(height: xl);
  static const SizedBox vGapXXL = SizedBox(height: xxl);

  // Section gaps (for major section breathing room)
  static const SizedBox vGapSection = SizedBox(height: sectionGap);
  static const SizedBox vGapHeader = SizedBox(height: headerGap);

  // Micro horizontal gaps
  static const SizedBox hGapXXS = SizedBox(width: xxs);

  // Button press scale (more noticeable feedback)
  static const double buttonPressScale = 0.95;
}
