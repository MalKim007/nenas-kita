# Home Screen Widgets

Modern, clean, flat-design widgets for the NenasKita seller (farmer) HomeScreen revamp.

## Widgets Overview

### 1. `OverdueHarvestBanner`
**Purpose**: Conditional alert banner for overdue harvests

**Features**:
- Red left border accent (4px)
- Light red background
- Warning icon with circular background
- Shows count of overdue harvests
- Tappable - navigates to planner
- Only displays when there are overdue plans
- Haptic feedback on tap
- Accessibility: Semantic labels for screen readers

**Usage**:
```dart
import 'package:nenas_kita/features/farm/widgets/home/home_widgets.dart';

// In your build method:
const OverdueHarvestBanner(),
```

**Provider**: Uses `myOverduePlansProvider` from `harvest_plan_providers.dart`

---

### 2. `FarmInfoCompactCard`
**Purpose**: Simplified farm display card for home screen

**Features**:
- 64x64 farm avatar with fallback icon
- Farm name with inline verification badge
- District with location pin icon
- Variety chips (max 3 displayed)
- Tappable with chevron indicator
- Uses existing `AppCard` pattern
- Haptic feedback on tap
- Accessibility: Full semantic labels

**Usage**:
```dart
import 'package:nenas_kita/features/farm/widgets/home/home_widgets.dart';

FarmInfoCompactCard(
  farm: farmModel,
  onTap: () {
    // Navigate to farm details
    context.push(RouteNames.farmerFarm);
  },
),
```

**Props**:
- `farm` (required): `FarmModel` instance
- `onTap` (optional): Callback when card is tapped

---

### 3. `LatestHarvestCard`
**Purpose**: Display single most recent harvest plan with progress

**Features**:
- Section header "Latest Harvest"
- Variety name and expected quantity
- Status chip (Planned/Growing/Ready) with color coding
- Days countdown with contextual icon and color
- Progress bar based on growth stage
- Empty state with "Create Plan" CTA
- Loading state
- Haptic feedback on interactions
- Accessibility: Full semantic descriptions

**Usage**:
```dart
import 'package:nenas_kita/features/farm/widgets/home/home_widgets.dart';

const LatestHarvestCard(),
```

**Provider**: Uses `myUpcomingHarvestsProvider` (takes first item)

**Status Colors**:
- Planned: Blue (info)
- Growing: Amber (warning)
- Ready/Harvested: Green (success)

**Empty State**: Shows when no harvest plans exist, with CTA button to create first plan

---

### 4. `ProductsOverviewCard`
**Purpose**: Products summary with count and navigation

**Features**:
- Section header "Products" with "See All >" trailing action
- Total product count prominently displayed
- Icon container with secondary color
- Tappable - navigates to products tab
- Empty state with "Add Product" CTA
- Loading state
- Haptic feedback
- Accessibility: Announces product count

**Usage**:
```dart
import 'package:nenas_kita/features/farm/widgets/home/home_widgets.dart';

ProductsOverviewCard(
  farmId: 'farm_id_here',
),
```

**Props**:
- `farmId` (required): Farm ID to fetch products for

**Provider**: Uses `productsByFarmProvider(farmId)`

---

### 5. `MarketPriceCard`
**Purpose**: Simple price comparison card

**Features**:
- Section header "Market Snapshot"
- Your average price with person icon
- Market average price with trending icon
- Comparison indicator with color coding:
  - Below market (< -5%): Green "Below market - competitive"
  - At market (±5%): Blue "At market rate"
  - Above market (> 5%): Amber "Above market"
- Handles missing data gracefully
- Loading states for async data
- Accessibility: Full semantic labels

**Usage**:
```dart
import 'package:nenas_kita/features/farm/widgets/home/home_widgets.dart';

MarketPriceCard(
  farmId: 'farm_id_here',
  primaryVariety: 'Morris',
),
```

**Props**:
- `farmId` (required): Farm ID to calculate average price
- `primaryVariety` (required): Variety name for market comparison (e.g., "Morris", "MD2")

**Providers**:
- `myAverageProductPriceProvider(farmId)` - calculates average across all farm products
- `marketAveragePriceProvider(variety)` - gets 30-day market average for variety

---

## Design System Compliance

All widgets follow NenasKita design system:

### Colors
- Primary: `AppColors.primary` (Amber #D97706)
- Secondary: `AppColors.secondary` (Green #16A34A)
- Success: `AppColors.success` (Green)
- Warning: `AppColors.warning` (Amber)
- Error: `AppColors.error` (Red #DC2626)
- Background: `AppColors.errorLight`, `AppColors.successLight`, etc.

### Spacing
- Uses `AppSpacing.vGapM`, `AppSpacing.hGapS`, etc.
- Consistent padding with `AppSpacing.paddingM`
- Border radius: `AppSpacing.radiusM` (12px)

### Components
- `AppCard` - Base card component with haptic feedback
- `SectionHeader` - Consistent section headers with icons
- `AppButton` - Primary/secondary button variants
- `VarietyChips` - Pineapple variety display chips

### Typography
- Title: `Theme.of(context).textTheme.titleMedium` with `fontWeight: FontWeight.w600`
- Body: `Theme.of(context).textTheme.bodyMedium`
- Secondary text: `color: AppColors.textSecondary`

### Accessibility
- All interactive elements have semantic labels
- Haptic feedback on tap actions
- Screen reader support
- Sufficient touch target sizes (min 48dp)

---

## Integration Example

Complete example of using all widgets in a HomeScreen:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/farm/widgets/home/home_widgets.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';

class FarmerHomeScreen extends ConsumerWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Overdue harvest alert (conditional)
              const OverdueHarvestBanner(),
              AppSpacing.vGapM,

              // 2. Farm info compact card
              FarmInfoCompactCard(
                farm: farmModel, // Get from provider
                onTap: () {
                  context.push(RouteNames.farmerFarm);
                },
              ),
              AppSpacing.vGapL,

              // 3. Latest harvest card
              const LatestHarvestCard(),
              AppSpacing.vGapL,

              // 4. Products overview
              ProductsOverviewCard(
                farmId: user.farmId ?? '',
              ),
              AppSpacing.vGapL,

              // 5. Market price comparison
              MarketPriceCard(
                farmId: user.farmId ?? '',
                primaryVariety: 'Morris', // Get from farm model
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading data')),
    );
  }
}
```

---

## Dependencies

### Required Providers
- `myOverduePlansProvider` - from `harvest_plan_providers.dart`
- `myUpcomingHarvestsProvider` - from `harvest_plan_providers.dart`
- `productsByFarmProvider` - from `product_providers.dart`
- `myAverageProductPriceProvider` - from `dashboard_providers.dart`
- `marketAveragePriceProvider` - from `dashboard_providers.dart`

### Required Models
- `FarmModel` - from `farm/models/farm_model.dart`
- `HarvestPlanModel` - from `planner/models/harvest_plan_model.dart`
- `HarvestStatus` enum - from `core/constants/enums.dart`

### Required Widgets
- `AppCard` - from `core/widgets/app_card.dart`
- `SectionHeader` - from `core/widgets/section_header.dart`
- `AppButton` - from `core/widgets/app_button.dart`
- `VarietyChips` - from `farm/widgets/variety_chips.dart`

---

## Testing Checklist

- [ ] OverdueHarvestBanner shows when overdue plans exist
- [ ] OverdueHarvestBanner hidden when no overdue plans
- [ ] FarmInfoCompactCard displays farm info correctly
- [ ] FarmInfoCompactCard shows verification badge for verified farms
- [ ] LatestHarvestCard shows correct status and countdown
- [ ] LatestHarvestCard empty state shows CTA button
- [ ] ProductsOverviewCard displays correct product count
- [ ] ProductsOverviewCard empty state shows "Add Product" button
- [ ] MarketPriceCard calculates price difference correctly
- [ ] MarketPriceCard shows correct comparison indicator
- [ ] All haptic feedback works on interactions
- [ ] All navigation actions work correctly
- [ ] Loading states display properly
- [ ] Error states handled gracefully
- [ ] Accessibility labels read correctly with screen reader
- [ ] Touch targets are sufficiently large (min 48dp)

---

## File Structure

```
lib/features/farm/widgets/home/
├── README.md                       # This file
├── home_widgets.dart               # Barrel export file
├── overdue_harvest_banner.dart     # Widget 1
├── farm_info_compact_card.dart     # Widget 2
├── latest_harvest_card.dart        # Widget 3
├── products_overview_card.dart     # Widget 4
└── market_price_card.dart          # Widget 5
```

---

## Maintenance Notes

- All widgets use Riverpod for state management
- No gradients used (flat design requirement)
- All colors from `AppColors` constants
- All spacing from `AppSpacing` constants
- All widgets are production-ready with error handling
- Generated files (`.g.dart`) are excluded from version control
- Run `dart run build_runner build --delete-conflicting-outputs` if providers are modified

---

**Created**: 2025-12-09
**Flutter Version**: 3.x+
**Riverpod Version**: 2.x+ (with code generation)
