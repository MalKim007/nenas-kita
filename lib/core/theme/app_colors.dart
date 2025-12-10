import 'package:flutter/material.dart';

/// NenasKita color palette
/// Based on ui_ux_best_practices.md - Amber (pineapple) + Green (agricultural)
/// Sharp & Minimal design with tertiary accent
class AppColors {
  AppColors._();

  // Primary (Amber - pineapple inspired)
  static const Color primary = Color(0xFFD97706);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFEF3C7);
  static const Color onPrimaryContainer = Color(0xFF78350F);

  // Secondary (Green - agricultural)
  static const Color secondary = Color(0xFF16A34A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFDCFCE7);
  static const Color onSecondaryContainer = Color(0xFF14532D);

  // Tertiary (Teal/Cyan - modern accent for Sharp & Minimal design)
  static const Color tertiary = Color(0xFF0891B2);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFCFFAFE);
  static const Color onTertiaryContainer = Color(0xFF164E63);

  // Semantic colors (always use with icons for accessibility)
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Light semantic variants (for backgrounds)
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Neutral gray scale (for subtle backgrounds)
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);

  // Surface colors (optimized for outdoor/sunlight visibility)
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFEF3C7);
  static const Color outline = Color(0xFFD1D5DB);
  static const Color outlineVariant = Color(0xFFE5E7EB);

  // Text colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textDisabled = Color(0xFF9CA3AF);

  // Status badge colors
  static const Color verified = success;
  static const Color pending = warning;
  static const Color rejected = error;
  static const Color available = success;
  static const Color limited = warning;
  static const Color outOfStock = error;

  // Social media brand colors
  static const Color whatsapp = Color(0xFF25D366);
  static const Color facebook = Color(0xFF1877F2);
  static const Color instagram = Color(0xFFE4405F);

  // Overlay colors
  static const Color scrim = Color(0x80000000);
  static const Color shadow = Color(0x1A000000);
}
