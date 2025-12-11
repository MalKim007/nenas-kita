## Project Structure

```
lib/
├── main.dart                     # App entry, Firebase & Hive initialization
├── app.dart                      # MaterialApp.router with Riverpod
├── firebase_options.dart         # Firebase configuration (auto-generated)
│
├── core/                         # Shared infrastructure
│   ├── constants/
│   │   └── enums.dart           # UserRole, StockStatus, HarvestStatus, etc.
│   ├── routing/
│   │   ├── app_router.dart      # GoRouter configuration
│   │   ├── route_names.dart     # Route path constants
│   │   └── route_guards.dart    # Auth & role-based redirects
│   ├── theme/
│   │   ├── app_colors.dart      # Material 3 color system
│   │   ├── app_theme.dart       # ThemeData configuration
│   │   └── app_text_styles.dart # Typography system
│   ├── utils/
│   │   └── firestore_converters.dart
│   └── widgets/                  # Reusable UI components
│       ├── app_button.dart
│       ├── app_card.dart
│       ├── app_text_field.dart
│       ├── farmer_shell.dart    # Farmer bottom navigation
│       └── buyer_shell.dart     # Buyer bottom navigation
│
├── features/                     # Feature modules
│   ├── auth/                    # Authentication
│   │   ├── models/user_model.dart
│   │   ├── providers/user_providers.dart
│   │   ├── repositories/user_repository.dart
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   │
│   ├── farm/                    # Farm management
│   │   ├── models/farm_model.dart
│   │   ├── providers/farm_providers.dart
│   │   ├── repositories/farm_repository.dart
│   │   └── screens/
│   │       ├── farmer_home_screen.dart
│   │       ├── farm_profile_screen.dart
│   │       └── farm_edit_screen.dart
│   │
│   ├── product/                 # Product catalog
│   │   ├── models/product_model.dart
│   │   ├── providers/product_providers.dart
│   │   ├── repositories/product_repository.dart
│   │   └── screens/
│   │       ├── products_list_screen.dart
│   │       ├── product_detail_screen.dart
│   │       └── product_add_screen.dart
│   │
│   ├── planner/                 # Harvest planning
│   │   ├── models/harvest_plan_model.dart
│   │   ├── providers/harvest_plan_providers.dart
│   │   ├── repositories/harvest_plan_repository.dart
│   │   └── screens/
│   │       ├── planner_list_screen.dart
│   │       └── planner_calendar_screen.dart
│   │
│   ├── market/                  # Buyer discovery & marketplace
│   │   ├── models/
│   │   ├── providers/
│   │   └── screens/
│   │       ├── buyer_discover_screen.dart
│   │       ├── farm_discovery_screen.dart
│   │       └── price_history_screen.dart
│   │
│   ├── admin/                   # LPNM admin tools
│   │   ├── models/
│   │   │   ├── audit_log_model.dart
│   │   │   └── announcement_model.dart
│   │   └── repositories/
│   │
│   └── settings/                # App settings
│       └── screens/
│           └── farmer_settings_screen.dart
│
└── services/                    # External integrations
    ├── auth_service.dart        # Firebase Auth wrapper
    ├── firebase_service.dart    # Firebase initialization
    ├── weather_service.dart     # OpenWeatherMap API
    ├── location_service.dart    # Geolocator wrapper
    ├── storage_service.dart     # Cloudinary uploads
    ├── notification_service.dart # FCM push notifications
    └── providers/
        └── service_providers.dart
```

## Feature Module Pattern

Each feature follows the same structure:

```
feature_name/
├── models/         # Freezed data classes with fromFirestore/toFirestore
├── providers/      # Riverpod providers (use @riverpod annotation)
├── repositories/   # Firestore CRUD operations
├── screens/        # Screen widgets
└── widgets/        # Feature-specific widgets
```
