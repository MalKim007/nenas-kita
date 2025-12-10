# Buyer Module Implementation Plan

## Overview

Breaking down Phase 5 (Buyer Discovery) into smaller executable chunks. Request feature removed per requirements.

---

## Agent Configuration

**Agent to use:** `mobile-developer` (from `frontend-mobile-development`)
- Use for all Flutter UI implementation
- Specialized in React Native/Flutter, cross-platform development
- Will handle screens, widgets, navigation

**Skill available:** `frontend-design:frontend-design`
- Use if custom design components needed

---

## Current State

| Item | Status |
|------|--------|
| Buyer routes | ✅ Configured with BuyerShell |
| BuyerShell | ✅ Created (3-tab bottom nav) |
| Buyer Home Screen | ✅ Created with featured farms |
| Farm Discovery (List) | ✅ Search, filters, distance sorting |
| Farm Discovery (Map) | ✅ OSM map with markers, preview card |
| Farm providers | Ready (allFarms, farmsByDistrict, verifiedFarms, searchFarms) |
| Product providers | Ready (allProducts, productsByVariety, productsByCategory) |
| Reusable widgets | FarmInfoCard, ProductCard, AppCard available |
| Location service | Ready (distance calc, geocoding) |

---

## Sub-Phases

### B1: Buyer Shell & Navigation (3 files) ✅ COMPLETED

**Objective:** Bottom nav shell for buyer + update routes

**Files:**
```
lib/core/widgets/buyer_shell.dart          # 3-tab bottom nav
lib/core/routing/app_router.dart           # Update buyer routes
lib/core/routing/route_names.dart          # Add missing constants
```

**BuyerShell Tabs:**
1. Home/Discover (browse farms)
2. Market (price trends)
3. Settings

**Notes:**
- Follow FarmerShell pattern
- Use StatefulShellRoute with IndexedStack
- Remove request-related routes

---

### B2: Buyer Home Screen (2 files) ✅ COMPLETED

**Objective:** Dashboard with search, featured farms, quick actions

**Files:**
```
lib/features/market/screens/buyer_home_screen.dart
lib/features/market/widgets/featured_farms_section.dart
```

**UI Components:**
- Search bar (tap navigates to discover)
- Featured/verified farms horizontal scroll
- Quick category filters (Fresh, Processed)
- District shortcut chips

**Providers Used:**
- verifiedFarmsProvider (limit 5)
- allFarmsProvider (count)

---

### B3: Farm Discovery - List View (4 files) ✅ COMPLETED

**Objective:** Searchable farm list with filters


**Files:**
```
lib/features/market/screens/farm_discovery_screen.dart
lib/features/market/widgets/farm_list_item.dart
lib/features/market/widgets/filter_bottom_sheet.dart
lib/features/market/widgets/search_header.dart
```

**Features:**
- Search by farm name
- Filter: district, verified only, has delivery
- Sort: name, distance (if location enabled)
- Pull-to-refresh
- Tab: List | Map (toggle)

**Providers Used:**
- allFarmsProvider
- farmsByDistrictProvider
- searchFarmsProvider

---

### B4: Farm Discovery - Map View (3 files) ✅ COMPLETED

**Objective:** OpenStreetMap with farm markers

**Files:**
```
lib/features/market/widgets/farm_map_view.dart
lib/features/market/widgets/farm_map_marker.dart
lib/features/market/widgets/farm_preview_card.dart
```

**Features:**
- flutter_map with OSM tiles
- Custom markers for farms
- Verified farms: different marker color
- Tap marker -> preview card popup
- "Open in Google Maps" button via url_launcher
- Current location button

**Providers Used:**
- allFarmsProvider
- locationServiceProvider

---

### B5: Farm Detail Screen (3 files) ✅ COMPLETED

**Objective:** Full farm info + products grid

**Files:**
```
lib/features/market/screens/buyer_farm_detail_screen.dart
lib/features/market/widgets/contact_section.dart
lib/features/market/widgets/farm_products_grid.dart
```

**UI Sections:**
- Hero image
- Farm name + verified badge
- Description
- Varieties grown
- Products grid (2 columns)
- Contact: Phone, WhatsApp, Directions

**Providers Used:**
- farmByIdProvider
- productsByFarmProvider

---

### B6: Product Detail Screen (2 files) ✅ COMPLETED

**Objective:** Single product view with contact CTA

**Files:**
```
lib/features/market/screens/buyer_product_detail_screen.dart
lib/features/market/widgets/product_image_carousel.dart
```

**UI Components:**
- Image carousel (swipe with dots)
- Product name, variety, category badge
- Price display (retail)
- Wholesale price (if user is wholesaler)
- Stock status badge
- Description
- Farm info mini card
- WhatsApp button

**Providers Used:**
- productByIdProvider
- farmByIdProvider
- canViewWholesalePricesProvider

---

### B7: Price History & Product Comparison (12 files) - REVISED

**Objective:** Per-product price history + Price comparison across farms

**See:** `b7_implementation_plan.md` for detailed breakdown

**Sub-phases:**
- B7.1: Price History Providers (2 files)
- B7.2: Price Chart Widget (2 files)
- B7.3: Price History Screen (1 file)
- B7.4: Update Product Detail (1 file modify)
- B7.5: Comparison Providers (2 files)
- B7.6: Comparison Screen (2 files)
- B7.7: Routes & Navigation (2 files modify)

**Key Changes from Original:**
- Removed aggregate price trends (not useful for buyers)
- Per-product price history with "X% below avg" indicator
- Market tab → Product Price Comparison feature
- Line chart with dots, toggle 7/30/90 days

---

### B8: Buyer Settings Screen (2 files)

**Objective:** Buyer-specific settings

**Files:**
```
lib/features/market/screens/buyer_settings_screen.dart
lib/features/market/widgets/buyer_profile_card.dart
```

**Sections:**
- Profile card (name, phone, district)
- Edit profile link
- Clear cache (images + data)
- About app
- Logout

**Reuse:**
- Existing settings widgets from auth feature

---

### B9: Polish & Skeletons (4 files)

**Objective:** Loading states, empty states, error handling

**Files:**
```
lib/features/market/widgets/farm_list_skeleton.dart
lib/features/market/widgets/farm_detail_skeleton.dart
lib/features/market/widgets/product_detail_skeleton.dart
lib/features/market/widgets/no_farms_empty.dart
```

**States:**
- Loading skeletons for all list/detail screens
- Empty state when no farms found
- Error state with retry

---

## Summary

| Phase | Focus | Files | Status |
|-------|-------|-------|--------|
| B1 | Shell & Navigation | 3 | ✅ Done |
| B2 | Home Screen | 2 | ✅ Done |
| B3 | Discovery List | 4 | ✅ Done |
| B4 | Discovery Map | 3 | ✅ Done |
| B5 | Farm Detail | 3 | ✅ Done |
| B6 | Product Detail | 2 | ✅ Done |
| B7 | Price History & Comparison | 12 | ⏳ Pending |
| B8 | Settings | 2 | ⏳ Pending |
| B9 | Polish | 4 | ⏳ Pending |
| **Total** | | **35** | **6/9** |

---

## Execution Order

```
B1 (Shell) -> B2 (Home) -> B3 (List) -> B4 (Map) -> B5 (Farm) -> B6 (Product) -> B7 (Prices) -> B8 (Settings) -> B9 (Polish)
```

Each phase is independent after B1 completes.

---

## Resolved Decisions

| # | Question | Answer |
|---|----------|--------|
| 1 | Tab icons | Material Icons |
| 2 | Tab2 label | "Discover" |
| 3 | Badge on tabs | No |
| 4 | Featured farms | Verified only |
| 5 | Featured count | 5 |
| 6 | Show user district | Yes |
| 7 | Default sort | Distance |
| 8 | Show farm distance | Yes |
| 9 | Pagination | Infinite scroll |
| 10 | Search debounce | 300ms |
| 11 | Initial map zoom | User location (fallback: Melaka center) |
| 12 | Marker color | Different for verified |
| 13 | User location marker | Yes |
| 14 | Cluster markers | No |
| 15 | Show phone | WhatsApp only |
| 16 | Products grid | 2 columns fixed |
| 17 | Mini map on detail | No |
| 18 | Directions | Opens Google Maps app |
| 19 | Image carousel | Manual swipe |
| 20 | Show price last updated | Yes |
| 21 | WhatsApp pre-filled | Yes |
| 22 | Default variety | Morris |
| 23 | Chart color | Primary amber |
| 24 | Raw data table | No |
| 25 | App version | Yes |
| 26 | Profile edit | Link to edit screen |
| 27 | Skeleton shimmer | Fast |
| 28 | Empty state | Icon only (Material) |

---

## How to Execute

Say: **"Execute Phase B1 of buyer_implementation_plan.md"**

After each phase:
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

---

*Version: 1.3 | December 2024 | NenasKita - LPNM Melaka*
*Progress: B1-B6 completed (17/26 files)*
