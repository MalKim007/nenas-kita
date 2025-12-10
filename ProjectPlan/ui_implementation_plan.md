# NenasKita UI Implementation Plan

## Overview

| Status | Count |
|--------|-------|
| Backend | 100% complete |
| Models | 9 (freezed) |
| Repositories | 9 |
| Providers | 50+ |
| Services | 6 |
| UI | Phase 1-4 complete (50 files) |

**Target:** Mobile-first Flutter app with admin web portal

---
## Global Questions

```
1. Multi-language (BM/EN)? English only
2. App icon + splash assets ready? just put placeholder
3. OpenWeatherMap API key value? a985e08c78055d53b26a4cab71500a5e
4. Cloudinary cloud name? dbbtlsik6
5. Firebase dev vs prod project? dev
6. Android only or iOS too? android only
7. Min Android SDK? refer other project files
8. App store name: "NenasKita"? yes
9. Privacy policy URL? skip
```

> **Note:** Google Maps API key is NOT required. Using OpenStreetMap (flutter_map) for in-app maps (free, no API key needed). Navigation redirects to Google Maps app via url_launcher.


---

## Phase 1: Core Infrastructure - COMPLETED

> Completed: December 7, 2024

### Objective
Setup app foundation: theme, routing, common widgets, app shell

### Files to Create

```
lib/
├── app.dart                              # App widget with ProviderScope + GoRouter
├── core/
│   ├── theme/
│   │   ├── app_theme.dart               # ThemeData config
│   │   ├── app_colors.dart              # Color constants
│   │   ├── app_text_styles.dart         # Typography
│   │   └── app_spacing.dart             # Padding/margin constants
│   ├── routing/
│   │   ├── app_router.dart              # GoRouter config
│   │   ├── route_names.dart             # Route path constants
│   │   └── route_guards.dart            # Auth redirect logic
│   └── widgets/
│       ├── app_button.dart              # Primary/secondary/outline buttons
│       ├── app_text_field.dart          # Styled text input
│       ├── app_card.dart                # Styled card container
│       ├── app_loading.dart             # Loading spinner + shimmer
│       ├── app_error.dart               # Error display widget
│       ├── app_empty_state.dart         # Empty list placeholder
│       ├── app_avatar.dart              # User/farm avatar
│       ├── app_badge.dart               # Status badge (verified, stock status)
│       ├── app_bottom_sheet.dart        # Reusable bottom sheet
│       └── app_snackbar.dart            # Toast/snackbar helper
```

### Implementation Details

**app_theme.dart**
- Material 3 with amber seed color
- Light theme only (dark mode out of scope)
- Custom component themes: ElevatedButton, OutlinedButton, Card, TextField, AppBar, BottomNavigationBar

**app_router.dart**
- GoRouter with redirect logic
- Auth state listener for protected routes
- Route structure:
  ```
  /splash
  /login
  /otp
  /role-select
  /profile-setup
  /farmer/* (farmer routes)
  /buyer/* (buyer routes)
  /admin/* (admin routes - web only)
  ```

**Route Guards**
- Unauthenticated → /login
- Authenticated + no profile → /profile-setup
- Authenticated + profile → role-based home

### Update main.dart
- Wrap with ProviderScope
- Use App widget instead of direct MaterialApp
- Remove placeholder scaffold

### Dependencies Check
All needed deps already in pubspec.yaml:
- go_router: ^15.1.0
- flutter_riverpod: ^2.6.1
- shimmer: ^3.0.0
- cached_network_image: ^3.4.1
- flutter_map: ^7.0.2 (OpenStreetMap - free, no API key)
- latlong2: ^0.9.1 (coordinate handling)
- url_launcher: ^6.3.1 (redirect to Google Maps app for navigation)

### Estimated Files: 14

### Unresolved Questions
```
1. Bottom nav icons: Material icons or custom SVG? just Material
2. Primary color: amber or different shade? (refer @ProjectPlan\ui_ux_best_practices.md)
3. Font: default Roboto or custom (e.g., Poppins)? (Use Inter font)
4. Border radius: sharp (4dp), medium (8dp), rounded (12dp)? (medium? or refer @ProjectPlan\ui_ux_best_practices.md)
5. Loading indicator: circular spinner or custom? circular spinner
```

---

## Phase 2: Auth Flow - COMPLETED

> Completed: December 7, 2024

### Objective
Complete authentication screens from splash to profile setup

### Files to Create

```
lib/features/auth/
├── screens/
│   ├── splash_screen.dart               # Logo + auto-login check
│   ├── login_screen.dart                # Phone input + country code
│   ├── otp_screen.dart                  # 6-digit OTP input
│   ├── role_selection_screen.dart       # Farmer/Buyer/Wholesaler choice
│   └── profile_setup_screen.dart        # Name, district, avatar
└── widgets/
    ├── phone_input_field.dart           # +60 prefix phone field
    ├── otp_input_field.dart             # 6-box OTP input
    ├── role_card.dart                   # Role selection card
    └── district_dropdown.dart           # Melaka district picker
```

### Screen Flow
```
Splash → (check auth)
  ├─ Not logged in → Login → OTP → Role Selection → Profile Setup → Home
  ├─ Logged in, no profile → Profile Setup → Home
  └─ Logged in, has profile → Home (role-based)
```

### Implementation Details

**splash_screen.dart**
- App logo centered
- 2-second minimum display
- Check authStateProvider
- Check if user doc exists in Firestore
- Redirect accordingly

**login_screen.dart**
- Malaysia phone format (+60)
- Validate 9-10 digits after prefix
- Call authService.verifyPhoneNumber
- Navigate to OTP with verificationId

**otp_screen.dart**
- 6 individual text fields with auto-focus
- 60-second resend timer
- Call authService.signInWithOtp
- Check if new user → role selection, else home

**role_selection_screen.dart**
- 3 cards: Farmer, Buyer, Wholesaler
- Description for each role
- Store selected role temporarily
- Navigate to profile setup

**profile_setup_screen.dart**
- Name input (required)
- District dropdown (3 Melaka districts)
- Avatar picker (optional)
- Create user doc in Firestore
- Subscribe to FCM topics
- Navigate to home

### Providers Used
- authStateProvider
- authServiceProvider
- currentUserProvider
- userRepositoryProvider

### Estimated Files: 9

### Unresolved Questions
```
1. OTP auto-read from SMS (sms_autofill pkg)? Skip sms_autofill - use manual OTP entry
2. Allow skip avatar upload? skip
3. Show T&C checkbox? skip
4. Resend OTP cooldown: 60s or different? 100 secs
5. Phone validation: strict MY format only? yes
```

---

## Phase 3: Farmer Module - Core - COMPLETED

> Completed: December 7, 2024

### Objective
Farmer home dashboard, farm profile, products management

### Files to Create

```
lib/features/farm/
├── screens/
│   ├── farmer_home_screen.dart          # Dashboard with stats
│   ├── farm_profile_screen.dart         # View farm details
│   ├── farm_edit_screen.dart            # Edit farm info
│   └── farm_setup_screen.dart           # First-time farm creation
└── widgets/
    ├── farm_stats_card.dart             # Products count, etc.
    ├── farm_info_card.dart              # Farm details display
    ├── verification_badge.dart          # LPNM verified badge
    ├── variety_chips.dart               # Pineapple variety tags
    ├── social_links_section.dart        # WhatsApp, Facebook
    └── location_picker.dart             # Maps location select

lib/features/product/
├── screens/
│   ├── products_list_screen.dart        # Products grid/list
│   ├── product_add_screen.dart          # Add product
│   ├── product_edit_screen.dart         # Edit product
│   └── product_detail_screen.dart       # Product detail
└── widgets/
    ├── product_card.dart                # Product grid item
    ├── product_form.dart                # Add/edit form
    ├── price_input.dart                 # Price + unit
    ├── stock_status_selector.dart       # Available/Limited/Out
    ├── image_gallery.dart               # Multi-image picker
    └── wholesale_price_section.dart     # Wholesale price

lib/core/widgets/
└── farmer_shell.dart                    # Bottom nav for farmer
```

### Screen Flow
```
Farmer Home
├── My Farm Profile → Edit Farm
├── My Products → Add/Edit Product
├── Quick Stats
└── Weather Widget (Phase 7)
```

### Implementation Details

**farmer_home_screen.dart**
- Top: Farm name + verified badge
- Stats cards: products count, open requests
- Quick actions: Add Product, View Requests
- Recent activity feed (optional)

**farm_profile_screen.dart**
- Hero image
- Farm details: name, description, varieties
- License info
- Social links
- Edit FAB

**products_list_screen.dart**
- Grid view (2 columns)
- Filter: category, stock status
- Sort: name, price, updated
- FAB: Add Product

**product_add/edit_screen.dart**
- Image picker (max 5)
- Name, description
- Category, variety dropdowns
- Price + unit
- Wholesale price (collapsible)
- Stock status
- Save button

### Providers Used
- myFarmsProvider
- myPrimaryFarmProvider
- productsByFarmProvider
- farmRepositoryProvider
- productRepositoryProvider
- storageServiceProvider

### Estimated Files: 18

### Unresolved Questions
```
1. Max images per product: 5? 3
2. Product grid: 2 columns fixed? 2 columns fixed
3. Multiple farms per farmer or single? Single farm per farmer
4. Wholesale section default collapsed? for wholesale, the difference is price visibility only
5. Image crop: square or flexible? flexxible
```

---

## Phase 4: Farmer Planner - COMPLETED

> Completed: December 7, 2024

### Objective
Harvest planning features for farmers

### Files to Create

```
lib/features/planner/
├── screens/
│   ├── planner_list_screen.dart         # Harvest plans list
│   ├── planner_add_screen.dart          # Add plan
│   ├── planner_edit_screen.dart         # Edit plan
│   └── planner_calendar_screen.dart     # Calendar view
└── widgets/
    ├── harvest_plan_card.dart           # Plan list item
    ├── harvest_plan_form.dart           # Add/edit form
    ├── status_timeline.dart             # Planted→Growing→Ready→Harvested
    ├── date_range_picker.dart           # Planting + harvest dates
    └── harvest_status_chip.dart         # Status badge
```

### Implementation Details

**planner_list_screen.dart**
- Tabs: Active | Completed
- Sort by expected harvest date
- Status filter
- FAB: Add Plan

**planner_add_screen.dart**
- Variety selector
- Quantity (kg)
- Planting date
- Expected harvest 
- Notes field

**planner_calendar_screen.dart**
- Month view
- Dots on harvest dates
- Tap → show plans
- Color code by status

### Providers Used
- myHarvestPlansProvider
- myUpcomingHarvestsProvider
- harvestPlanRepositoryProvider

### Estimated Files: 9

### Unresolved Questions
```
1. Calendar pkg: table_calendar? yes use table_calendar 
2. Default harvest estimate: 18 months? set it 14 months
3. Allow backdating planting date? yes
4. Reminder: 7 days before? 7 days (+ optional 30 days)
5. Batch delete completed plans? skip
```

---

## Phase 5: Buyer Module - Discovery

### Objective
Buyer home, farm discovery (list + map), details

### Files to Create

```
lib/features/market/
├── screens/
│   ├── buyer_home_screen.dart           # Discovery home
│   ├── farm_discovery_screen.dart       # List + Map toggle
│   ├── farm_detail_screen.dart          # Farm info + products
│   └── product_detail_screen.dart       # Single product view
└── widgets/
    ├── farm_list_item.dart              # Farm list row
    ├── farm_map_marker.dart             # Custom marker
    ├── product_grid_item.dart           # Product grid cell
    ├── filter_bottom_sheet.dart         # Filters
    ├── search_bar.dart                  # Search
    ├── whatsapp_button.dart             # WhatsApp link
    └── contact_section.dart             # Phone + WhatsApp

lib/core/widgets/
└── buyer_shell.dart                     # Bottom nav for buyer
```

### Screen Flow
```
Buyer Home
├── Farm Discovery (List/Map)
│   └── Farm Detail
│       └── Product Detail
├── Search
└── My Requests (Phase 6)
```

### Implementation Details

**buyer_home_screen.dart**
- Search bar
- Featured farms scroll
- Recent viewed
- Quick filters

**farm_discovery_screen.dart**
- Toggle: List / Map
- Filter bottom sheet
- Sort: distance, name, verified
- Pull to refresh

**Map View (OpenStreetMap)**
- flutter_map with OSM tiles (free, no API key)
- Custom markers for farms
- Marker tap → preview card with "Open in Google Maps" button
- Current location button
- Tap marker → popup card → redirects to Google Maps app for navigation

**farm_detail_screen.dart**
- Hero images
- Info: name, description, varieties
- Verified badge
- Products grid
- Contact: Phone, WhatsApp, Directions (opens Google Maps app via url_launcher)

**product_detail_screen.dart**
- Image carousel
- Name, description, variety
- Price (retail)
- Wholesale price (if wholesaler)
- Stock status
- WhatsApp button

### Providers Used
- allFarmsProvider
- farmsByDistrictProvider
- verifiedFarmsProvider
- productsByFarmProvider
- canViewWholesalePricesProvider

### Estimated Files: 12

### Unresolved Questions
```
1. Map initial zoom: all Melaka or user location? User location (fallback: Melaka center) 
2. Farm images: swipe or dots? Swipe (with dots indicator) 
3. WhatsApp message template? yes 
4. Show distance from user? Yes, show "X km away" 
5. Cache farms for offline? Yes, 6 hours with Hive 
```

---

## Phase 6: Buyer Requests

### Objective
Buyer posts requests, farmers fulfill

### Files to Create

```
lib/features/market/
├── screens/
│   ├── buyer_requests_screen.dart       # My requests (buyer)
│   ├── request_form_screen.dart         # Create request
│   ├── open_requests_screen.dart        # All open (farmer)
│   └── request_detail_screen.dart       # Detail + fulfill
└── widgets/
    ├── request_card.dart                # Request list item
    ├── request_form.dart                # Form fields
    ├── request_status_chip.dart         # Status badge
    └── fulfill_dialog.dart              # Confirm dialog
```

### Implementation Details

**buyer_requests_screen.dart** (Buyer)
- Tabs: Open | Fulfilled | Closed
- Request cards
- FAB: New Request

**request_form_screen.dart**
- Category: Fresh/Processed
- Variety (optional)
- Quantity (kg)
- Delivery district
- Needed by date

**open_requests_screen.dart** (Farmer)
- Open requests in farmer's district
- Filter by category, urgency
- Tap → detail

**request_detail_screen.dart**
- Request info
- Buyer contact
- "I can fulfill this" button

### Providers Used
- myBuyerRequestsProvider
- openBuyerRequestsProvider
- openRequestsByDistrictProvider
- buyerRequestRepositoryProvider

### Estimated Files: 8

### Unresolved Questions
```
1. Farmer see buyer phone before fulfilling? Show after clicking "Fulfill" 
2. Multiple farmers fulfill same request? Yes, buyer chooses from responders
3. Notify buyer when fulfilled? Yes, push notification 
4. Auto-close after needed_by date? Yes, status → "expired" 
5. Edit request after posting? Only if status is "open"  
```

---

## Phase 7: Market Features

### Objective
Price trends, weather, harvest calendar aggregate

### Files to Create

```
lib/features/market/
├── screens/
│   ├── price_trends_screen.dart         # Price charts
│   └── harvest_calendar_screen.dart     # Regional aggregate
└── widgets/
    ├── price_chart.dart                 # fl_chart line graph
    ├── price_stats_card.dart            # Avg, min, max
    ├── variety_price_card.dart          # Price by variety
    └── harvest_aggregate_card.dart      # X harvests in Y district

lib/core/widgets/
├── weather_widget.dart                  # Weather card
└── weather_forecast_card.dart           # 5-day forecast
```

### Implementation Details

**price_trends_screen.dart**
- Variety selector
- Line chart: price over time
- Stats: avg, min, max
- Change indicator (+/- %)

**harvest_calendar_screen.dart**
- Month view
- Aggregate: "15 harvests in Jasin"
- District filter

**weather_widget.dart**
- Current temp, humidity
- Weather icon
- Last updated

### Providers Used
- priceHistoryByVarietyProvider
- averagePriceByVarietyProvider
- dailyPriceAveragesProvider
- currentWeatherProvider
- weatherForecastByDistrictProvider

### Estimated Files: 8

### Unresolved Questions
```
1. Chart range: 30/60/90 days toggle? 30/60/90 toggle, default 30
2. Show wholesale price trend? Yes, role-restricted 
3. Weather: auto-detect or manual district? Auto-detect + manual override
4. Cache weather: 1hr or 6hr? 1hr current, 6hr forecast 
5. Harvest aggregate: quantity or count? Count (not kg)   
```

---

## Phase 8: Admin Module (Web)

### Objective
LPNM admin web portal

### Files to Create

```
lib/features/admin/
├── screens/
│   ├── admin_dashboard_screen.dart      # Stats overview
│   ├── farmers_registry_screen.dart     # All farmers
│   ├── farmer_detail_screen.dart        # Farmer + farms
│   ├── pending_verifications_screen.dart # Pending farms
│   ├── verification_form_screen.dart    # Approve/reject
│   ├── audit_logs_screen.dart           # Audit history
│   └── announcements_screen.dart        # Manage announcements
└── widgets/
    ├── admin_stats_card.dart            # Metric card
    ├── farmer_row.dart                  # List row
    ├── farm_verification_card.dart      # Pending card
    ├── verification_form.dart           # Form
    ├── audit_log_item.dart              # Log row
    ├── announcement_card.dart           # Announcement item
    └── announcement_form.dart           # Create/edit form

lib/core/widgets/
└── admin_shell.dart                     # Sidebar layout (web)
```

### Implementation Details

**admin_dashboard_screen.dart**
- Stats: farmers, verified, pending
- Recent audits
- Quick actions

**farmers_registry_screen.dart**
- Data table
- Search + filter
- Click → detail

**pending_verifications_screen.dart**
- Farms where verifiedByLPNM = false
- Oldest first

**verification_form_screen.dart**
- Farm info
- Approve / Reject / Request Info
- Notes (required for reject)
- Attachments
- Create audit log

**Admin Shell (Web)**
- Sidebar navigation
- Responsive collapse

### Providers Used
- allFarmersProvider
- unverifiedFarmsProvider
- recentAuditLogsProvider
- auditLogRepositoryProvider
- announcementRepositoryProvider

### Estimated Files: 15

### Unresolved Questions
```
1. Admin web only or mobile too? web only
2. Dark mode for admin? no, skip for MVP
3. Export logs: CSV, PDF? CSV only
4. Schedule announcements? Skip for MVP, publish immediately 
5. Admin vs superadmin UI differences? Same UI, SuperAdmin sees extra tab
```

---

## Phase 9: Settings & Profile

### Objective
User settings, profile editing

### Files to Create

```
lib/features/auth/
├── screens/
│   ├── settings_screen.dart             # Settings menu
│   ├── profile_edit_screen.dart         # Edit profile
│   ├── notification_settings_screen.dart # Notification prefs
│   └── about_screen.dart                # App info
└── widgets/
    ├── settings_tile.dart               # List item
    ├── avatar_editor.dart               # Avatar change
    └── logout_dialog.dart               # Confirm logout
```

### Implementation Details

**settings_screen.dart**
- Profile section
- Notification settings
- About app
- Logout
- Delete account

**profile_edit_screen.dart**
- Avatar change
- Name edit
- District change
- Phone (read-only)
- Role (read-only)

**notification_settings_screen.dart**
- Toggle: Price updates
- Toggle: Requests in district
- Toggle: Announcements
- Toggle: Harvest reminders

### Providers Used
- currentAppUserProvider
- userRepositoryProvider
- notificationServiceProvider

### Estimated Files: 7

### Unresolved Questions
```
1. Allow role change? No - create new account  
2. Account deletion: soft or hard? Soft delete, 30-day recovery
3. Language settings (BM/EN)? ENGLISH Only
4. Theme settings? Light Only
5. Clear cache option? Yes - images + offline data (show how many MBs)
```

---

## Phase 10: Polish & Error Handling

### Objective
Error states, loading skeletons, empty states

### Files to Create

```
lib/core/widgets/
├── error_screen.dart                    # Full-screen error
├── no_connection_screen.dart            # Offline screen
├── not_found_screen.dart                # 404
├── skeleton_loading/
│   ├── farm_card_skeleton.dart
│   ├── product_card_skeleton.dart
│   ├── list_item_skeleton.dart
│   └── detail_skeleton.dart
└── empty_states/
    ├── no_farms_empty.dart
    ├── no_products_empty.dart
    ├── no_requests_empty.dart
    └── no_plans_empty.dart

lib/core/utils/
├── error_handler.dart                   # Global error handling
└── connectivity_wrapper.dart            # Offline wrapper
```

### Implementation Details

**error_screen.dart**
- Error icon + message
- Retry button
- Go home button

**Skeleton Loading**
- Shimmer package
- Match card dimensions

**Empty States**
- Icon/illustration
- Helpful message
- CTA button

**connectivity_wrapper.dart**
- Listen connectivity_plus
- Show offline banner
- Queue actions

### Estimated Files: 13

### Unresolved Questions
```
1. Custom illustrations or icons only? Icons only (Material Icons) 
2. Offline banner: top or bottom? Top (more visible) 
3. Animations: built-in or lottie? Built-in Flutter
4. Error tracking: Crashlytics? Yes, Firebase Crashlytics
5. Retry: exponential backoff? Yes, exponential backoff (1s, 2s, 4s)
```

---

## Summary

| Phase | Focus | Files |
|-------|-------|-------|
| 1 | Core Infrastructure | 14 |
| 2 | Auth Flow | 9 |
| 3 | Farmer Core | 18 |
| 4 | Farmer Planner | 9 |
| 5 | Buyer Discovery | 12 |
| 6 | Buyer Requests | 8 |
| 7 | Market Features | 8 |
| 8 | Admin Module | 15 |
| 9 | Settings | 7 |
| 10 | Polish | 13 |
| **Total** | | **~113** |

### Execution Order

```
Phase 1 (Core)
    ↓
Phase 2 (Auth)
    ↓
    ├── Phase 3 (Farmer) → Phase 4 (Planner) → Phase 7 (Market)
    │
    └── Phase 5 (Buyer) → Phase 6 (Requests) → Phase 7 (Market)
    ↓
Phase 8 (Admin) - parallel
    ↓
Phase 9 (Settings)
    ↓
Phase 10 (Polish)
```

---

## Execution Instructions

Per phase conversation:
1. Say: "Execute Phase X of ui_implementation_plan.md"
2. I create all files listed
3. Run after:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   flutter analyze
   ```
4. Test before next phase

---



*Version: 1.1 | December 2024 | NenasKita - LPNM Melaka*
*Updated: Switched from Google Maps API to OpenStreetMap (flutter_map) - free, no API key required*
