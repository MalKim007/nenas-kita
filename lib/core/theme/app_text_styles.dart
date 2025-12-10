import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// NenasKita typography system
/// Uses Inter font via google_fonts package
class AppTextStyles {
  AppTextStyles._();

  // Base text theme using Inter font
  static TextTheme get textTheme => GoogleFonts.interTextTheme();

  // Display styles (splash screen) - Sharp & Minimal with tight letter-spacing
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -1.5,
        height: 1.1,
        color: AppColors.textPrimary,
      );

  // Headline styles (page titles, section headers) - Bolder for impact
  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.75,
        height: 1.15,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.15,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  // Title styles (card titles, farm names) - Bolder for hierarchy
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  // Body styles (primary/secondary content) - Comfortable reading
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  // Label styles (buttons, chips, badges)
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  // Helper methods for common variations
  static TextStyle bodyMediumSecondary() => bodyMedium.copyWith(
        color: AppColors.textSecondary,
      );

  static TextStyle bodyLargeSecondary() => bodyLarge.copyWith(
        color: AppColors.textSecondary,
      );

  static TextStyle titleMediumPrimary() => titleMedium.copyWith(
        color: AppColors.primary,
      );

  static TextStyle labelLargeWhite() => labelLarge.copyWith(
        color: Colors.white,
      );

  // Price styles - Bold for emphasis
  static TextStyle get price => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get priceSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  static TextStyle get priceLarge => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  // Error text
  static TextStyle get error => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.error,
      );

  // Bold variants for emphasis
  static TextStyle get bodyLargeBold => bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyMediumBold => bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
      );

  // Dim variants for secondary content
  static TextStyle get bodyLargeDim => bodyLarge.copyWith(
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyMediumDim => bodyMedium.copyWith(
        color: AppColors.textSecondary,
      );

  static TextStyle get titleMediumDim => titleMedium.copyWith(
        color: AppColors.textSecondary,
      );
}
