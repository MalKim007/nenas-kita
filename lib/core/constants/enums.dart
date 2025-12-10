// All enums used across the NenasKita application
import 'package:flutter/material.dart';

/// User roles for authentication and authorization
enum UserRole {
  farmer,
  buyer,
  wholesaler,
  admin,
  superadmin;

  /// Convert string to enum
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.buyer,
    );
  }
}

/// Product stock availability status
enum StockStatus {
  available,
  limited,
  out;

  static StockStatus fromString(String value) {
    return StockStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StockStatus.available,
    );
  }
}

/// Harvest plan lifecycle status
enum HarvestStatus {
  planned,
  growing,
  ready,
  harvested;

  static HarvestStatus fromString(String value) {
    return HarvestStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => HarvestStatus.planned,
    );
  }
}

/// Buyer request status
enum RequestStatus {
  open,
  fulfilled,
  closed;

  static RequestStatus fromString(String value) {
    return RequestStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RequestStatus.open,
    );
  }
}

/// LPNM audit action types
enum AuditAction {
  inspection,
  approved,
  rejected,
  pending;

  static AuditAction fromString(String value) {
    return AuditAction.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AuditAction.pending,
    );
  }
}

/// Announcement type for styling/priority
enum AnnouncementType {
  info,
  warning,
  promo;

  static AnnouncementType fromString(String value) {
    return AnnouncementType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AnnouncementType.info,
    );
  }
}

/// Product category
enum ProductCategory {
  fresh,
  processed;

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ProductCategory.fresh,
    );
  }
}

/// Melaka districts
enum District {
  melakaTengah,
  alorGajah,
  jasin;

  String get displayName {
    switch (this) {
      case District.melakaTengah:
        return 'Melaka Tengah';
      case District.alorGajah:
        return 'Alor Gajah';
      case District.jasin:
        return 'Jasin';
    }
  }

  static District fromString(String value) {
    switch (value.toLowerCase().replaceAll(' ', '')) {
      case 'melakatengah':
        return District.melakaTengah;
      case 'alorgajah':
        return District.alorGajah;
      case 'jasin':
        return District.jasin;
      default:
        return District.melakaTengah;
    }
  }
}

/// Pineapple varieties available in Melaka
enum PineappleVariety {
  morris,
  josapine,
  md2,
  sarawak,
  yankee;

  String get displayName {
    switch (this) {
      case PineappleVariety.morris:
        return 'Morris';
      case PineappleVariety.josapine:
        return 'Josapine';
      case PineappleVariety.md2:
        return 'MD2';
      case PineappleVariety.sarawak:
        return 'Sarawak';
      case PineappleVariety.yankee:
        return 'Yankee';
    }
  }

  static PineappleVariety fromString(String value) {
    return PineappleVariety.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PineappleVariety.morris,
    );
  }
}

/// Product comparison sort options
enum ProductSortOption {
  priceLowToHigh,
  priceHighToLow,
  distance,
  farmName;

  String get displayName {
    switch (this) {
      case ProductSortOption.priceLowToHigh:
        return 'Lowest Price';
      case ProductSortOption.priceHighToLow:
        return 'Highest Price';
      case ProductSortOption.distance:
        return 'Nearest';
      case ProductSortOption.farmName:
        return 'Farm Name';
    }
  }

  static ProductSortOption fromString(String value) {
    return ProductSortOption.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ProductSortOption.priceLowToHigh,
    );
  }
}

/// Price deal quality levels based on percentage difference from average
enum DealLevel {
  excellent, // >15% below avg - green glow + pulse
  good,      // 5-15% below avg - green solid
  fair,      // ±5% of avg - gray neutral
  high;      // >5% above avg - red muted

  /// Create DealLevel from percentage difference
  /// Positive percentDiff = above average (expensive)
  /// Negative percentDiff = below average (cheap)
  factory DealLevel.fromPercentDiff(double percentDiff) {
    if (percentDiff < -15) {
      return DealLevel.excellent;
    } else if (percentDiff < -5) {
      return DealLevel.good;
    } else if (percentDiff <= 5) {
      return DealLevel.fair;
    } else {
      return DealLevel.high;
    }
  }

  /// Get color for this deal level
  Color get color {
    switch (this) {
      case DealLevel.excellent:
        return const Color(0xFF16A34A); // AppColors.success
      case DealLevel.good:
        return const Color(0xFF16A34A); // AppColors.success
      case DealLevel.fair:
        return const Color(0xFFD1D5DB); // AppColors.neutral300
      case DealLevel.high:
        return const Color(0xFFDC2626); // AppColors.error
    }
  }

  /// Get label for this deal level
  String get label {
    switch (this) {
      case DealLevel.excellent:
        return 'EXCELLENT';
      case DealLevel.good:
        return 'GOOD DEAL';
      case DealLevel.fair:
        return 'FAIR';
      case DealLevel.high:
        return 'HIGH';
    }
  }

  /// Get icon for this deal level
  IconData get icon {
    switch (this) {
      case DealLevel.excellent:
        return Icons.star;
      case DealLevel.good:
        return Icons.trending_down;
      case DealLevel.fair:
        return Icons.trending_flat;
      case DealLevel.high:
        return Icons.trending_up;
    }
  }

  /// Whether this deal level should have glow effect
  bool get hasGlow => this == DealLevel.excellent;

  /// Whether this deal level should pulse
  bool get shouldPulse => this == DealLevel.excellent;
}
