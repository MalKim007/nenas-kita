<!-- <p align="center">
  <!-- PROJECT LOGO: Replace with actual logo 
  <img src="assets\images\AppIcon.jpeg" alt="NenasKita Logo" width="240" height="240">
</p>
-->
<h1 align="center">NenasKita</h1>

<p align="center">
  <strong>Digitalizing Melaka's Pineapple Industry</strong>
  <br>
  <em>Mendigitalkan Industri Nanas Melaka</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-blue" alt="License">
</p>

<p align="center">
  <!-- <a href="#live-demo--download">View Demo</a> &bull; -->
  <a href="#key-features">Features</a> &bull;
  <a href="#technology-stack">Technology Stack</a> &bull;
  <a href="#getting-started">Get Started</a> &bull;
  <a href="#team">Team</a>
</p>

---

## Executive Summary

**NenasKita** is a comprehensive mobile application developed to digitalize and modernize the pineapple farming industry in Melaka, Malaysia. Built in collaboration with **LPNM (Lembaga Perindustrian Nanas Malaysia)**, this platform connects farmers, buyers and wholesalers in a unified digital ecosystem.

The application addresses critical challenges faced by Melaka's pineapple farmers and entreprenuers, including lack of market visibility, absence of price transparency and inefficient seller-buyer connections. By providing real-time market data, harvest planning tools and direct communication channels, NenasKita empowers local farmers and entreprenuers.

---

## Team

<table>
<tr>
<td align="center">
<strong>Muhammad Akmal Hakim Hishamuddin</strong><br>
B032310162<br>
<em>Project Manager & System Analyst</em>
</td>
<td align="center">
<strong>Muhammad Arif Aiman Bin Karim</strong><br>
B032310257<br>
<em>Backend Developer</em>
</td>
<td align="center">
<strong>Nur Aqilah Binti Zaidi</strong><br>
B032310148<br>
<em>Frontend Developer</em>
</td>
</tr>
<tr>
<td align="center">
<strong>Nur Aina Sofea Binti Ahmad Nazzib</strong><br>
B032310108<br>
<em>Database Designer</em>
</td>
<td align="center">
<strong>Siti Balqis Binti Mat Muharam</strong><br>
B032310135<br>
<em>Software Testing, Validation and Deployment</em>
</td>
<td align="center">
</td>
</tr>
</table>

**Course**: Software Project Management (SULAM) 2025
**Institution**: Universiti Teknikal Malaysia Melaka (UTeM)

---

## Acknowledgments

We would like to express our sincere gratitude to:

- **LPNM (Lembaga Perindustrian Nanas Malaysia)** - For the opportunity to contribute to Melaka's pineapple industry digitalization
- **Universiti Teknikal Malaysia Melaka (UTeM)** - For providing the educational platform and resources
- **Course Instructors** - Sir 	Muhammad Huzaifah Bin Ismail for guidance throughout the Software Project Management course
- **Flutter & Firebase Communities** - For excellent documentation and open-source tools
- **Melaka Pineapple Farmers** - For inspiring this solution

---

## Contact

For inquiries about NenasKita:

- **Email**: [mkim8189@gmail.com]
- **Phone Number**: [011-72731088]


## Table of Contents

- [The Problem](#the-problem)
- [Our Solution](#our-solution)
- [Key Features](#key-features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Database Schema](#database-schema)
- [API Integrations](#api-integrations)
- [Security](#security)
- [Deployment](#deployment)
- [Implementation Status](#implementation-status)
- [Future Improvements](#future-improvements)
- [Team](#team)
- [Acknowledgments](#acknowledgments)

---

## The Problem

Melaka's pineapple industry faces several critical challenges that hinder growth and efficiency:

| Challenge | Impact |
|-----------|--------|
| **Price Opacity** | No standardized pricing reference; buyers and farmers/entreprenuers negotiate blindly |
| **No Stock Visibility** | Buyers cannot easily find available products across multiple farms |
| **Absence of Planning Tools** | Farmers manage months of harvest cycles manually without digital assistance |
| **Difficult Discovery** | Buyers struggle to locate and connect with verified local farmers |

### Industry Context

- **Major Varieties**: Morris, Josapine, MD2, Sarawak, Yankee and more
- **3 Districts**: Melaka Tengah, Alor Gajah, Jasin
- **Harvest Cycle**: Multiple months from planting to harvest
- **Stakeholders**: Individual farmers, family farms, local buyers, wholesalers, processing companies

---

## Our Solution

NenasKita provides a **unified digital platform** that addresses each challenge:

```
Problem                          Solution
─────────────────────────────────────────────────────────────
No market information      ──►   Real-time product listings
Price opacity              ──►   Price history & trend analytics
No stock visibility        ──►   Centralized product catalog
No planning tools          ──►   Harvest planner with calendar
Difficult discovery        ──►   Map-based farm finder
```

### User Journey

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                                 NENASKITA ECOSYSTEM                            │
├────────────────────────────────────────────────────────────────────────────────┤
│                                                            LPNM ADMIN          │
│           BUYER                    Business Owner        (not implemented yet) │
│   ┌───────────────────┐          ┌─────────────────┐      ┌────────────┐       │
│   │ Register Business │          │ Discover Farms  │      │ Verify     │       │
│   │ List Products     │◄────────►│ Browse Products │      │ Farms      │       │
│   │ Plan Harvests     │          │ Compare Prices  │      │ Audit Logs │       │
│   │ Update Prices     │          │ Contact Farmer  │      │ Announce   │       │
│   └───────────────────┘          └─────────────────┘      └────────────┘       │
│          │                            │                       │                │
│          └────────────────────────────┼───────────────────────┘                │
│                                       │                                        │
│                          ┌────────────┴────────────┐                           │ 
│                          │    FIREBASE BACKEND     │                           │
│                          │  Firestore • Auth • FCM │                           │
│                          └─────────────────────────┘                           │
└────────────────────────────────────────────────────────────────────────────────┘
```

---

## Key Features

### For Farmers / Entreprenuers 

| Feature | Description |
|---------|-------------|
| **Business Profile Management** | Complete farm registration with LPNM license, location, varieties grown and social links |
| **Product Catalog** | List fresh and processed pineapple products with retail & wholesale pricing |
| **Harvest Planner** | Calendar-based planning with status tracking (Planned → Growing → Ready → Harvested) |
| **Social Media (Facebook & Instagram) and WhatsApp Integration** | Direct buyer communication via WhatsApp deep links |

### For Buyers & Wholesalers 

| Feature | Description |
|---------|-------------|
| **Farm Discovery** | Search and filter farms by district, verification status and delivery availability |
| **Interactive Map View** | OpenStreetMap integration showing farm locations across Melaka |
| **Product Search** | Filter by category (Fresh/Processed), variety, and price range |
| **Price Comparison** | Compare up to 3 products side-by-side across different farms |
| **Price History Analytics** | View 7/14/30/90-day price trends with interactive charts |
| **Distance Calculator** | See distance from current location to farm |
| **Direct Contact** | One-tap WhatsApp, call, or view social media links |

### For LPNM Administrators

> **Note**: Backend infrastructure (models, repositories, security rules) is fully implemented. Web portal UI is planned for Phase 2.

| Feature | Status | Description |
|---------|--------|-------------|
| **Farm Verification** | Backend Ready | Data models and Firestore rules for verification workflow |
| **Audit Log System** | Backend Ready | Immutable records infrastructure for compliance |
| **Announcements** | Backend Ready | Notification system with role/district targeting |
| **Admin Web Portal** | *Coming Soon* | Full management dashboard UI (Phase 2) |


---

## Technology Stack

<table>
<tr>
<td align="center" width="150">

**Frontend**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)

Flutter 3.x<br>Dart 3.x

</td>
<td align="center" width="150">

**State Management**

![Riverpod](https://img.shields.io/badge/Riverpod-0553B1?style=for-the-badge)

Riverpod 2.x<br>Freezed

</td>
<td align="center" width="150">

**Backend**

![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

Firestore<br>Auth • FCM

</td>
<td align="center" width="150">

**Maps**

![OpenStreetMap](https://img.shields.io/badge/OpenStreetMap-7EBC6F?style=for-the-badge&logo=openstreetmap&logoColor=white)

flutter_map<br>Geolocator

</td>
</tr>
<tr>
<td align="center">

**Weather**

![Weather](https://img.shields.io/badge/OpenWeather-EB6E4B?style=for-the-badge)

OpenWeatherMap<br>API

</td>
<td align="center">

**Storage**

![Cloudinary](https://img.shields.io/badge/Cloudinary-3448C5?style=for-the-badge)

Image CDN<br>Optimization

</td>
<td align="center">

**Charts**

![Charts](https://img.shields.io/badge/FL_Chart-FF6384?style=for-the-badge)

Price Trends<br>Analytics

</td>
<td align="center">

**Navigation**

![GoRouter](https://img.shields.io/badge/GoRouter-00B4AB?style=for-the-badge)

Type-safe<br>Routing

</td>
</tr>
</table>

### Full Dependency List

| Category | Libraries |
|----------|-----------|
| **Core** | flutter_riverpod, riverpod_annotation, freezed, json_serializable |
| **Firebase** | firebase_core, cloud_firestore, firebase_auth, firebase_messaging, firebase_analytics |
| **Navigation** | go_router |
| **Maps & Location** | flutter_map, latlong2, geolocator |
| **UI** | google_fonts, shimmer, fl_chart, table_calendar, cached_network_image |
| **Utilities** | intl, url_launcher, connectivity_plus, image_picker |
| **Storage** | hive, hive_flutter, cloudinary_public |

---

## Architecture

### Feature-First Modular Design

NenasKita follows a **feature-first architecture** that promotes code organization, maintainability, and team scalability:

```
┌────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                      │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐            │
│  │ Screens │  │ Widgets │  │  Shell  │  │ Routing │            │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘            │
└───────┼────────────┼────────────┼────────────┼─────────────────┘
        │            │            │            │
┌───────┴────────────┴────────────┴────────────┴─────────────────┐
│                         STATE LAYER                            │
│         ┌──────────────────────────────────────┐               │
│         │      RIVERPOD PROVIDERS              │               │
│         │  (Generated with @riverpod)          │               │
│         └──────────────────────────────────────┘               │
└────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────┴──────────────────────────────────┐
│                         DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ Repositories│  │   Models    │  │  Services   │             │
│  │  (Firestore)│  │  (Freezed)  │  │ (APIs/Auth) │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────┴──────────────────────────────────┐
│                       EXTERNAL SERVICES                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │ Firebase │  │ Weather  │  │Cloudinary│  │   Maps   │        │
│  │Firestore │  │   API    │  │   CDN    │  │   OSM    │        │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘        │
└────────────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

| Decision | Rationale |
|----------|-----------|
| **Offline-First** | Firestore persistence ensures app works in rural areas with poor connectivity |
| **Code Generation** | Riverpod + Freezed reduce boilerplate and catch errors at compile time |
| **Feature Modules** | Each feature is self-contained with its own models, providers, repos, and screens |
| **Repository Pattern** | Abstracts Firestore operations for testability and consistency |
| **Role-Based UI** | StatefulShellRoute provides role-specific bottom navigation |

---

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

---

## Getting Started

### Prerequisites

- **Flutter SDK** 3.8.1 or higher
- **Dart SDK** 3.x
- **Firebase CLI** (for deployment)
- **Android Studio** or **VS Code** with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/[YOUR_USERNAME]/nenas_kita.git
   cd nenas_kita
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Riverpod + Freezed)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # For Android/iOS
   flutter run

   # For Web
   flutter run -d chrome
   ```

### Common Commands

```bash
# Install dependencies
flutter pub get

# Generate Freezed/Riverpod code (run after modifying models)
dart run build_runner build --delete-conflicting-outputs

# Run analyzer
flutter analyze

# Run tests
flutter test

# Build Android APK
flutter build apk --release

# Build for web
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

---

## Database Schema

### Firestore Collections

```
firestore/
├── users/                      # User profiles
│   └── {userId}
│       ├── name, email, phone
│       ├── role (farmer|buyer|wholesaler|admin)
│       ├── district
│       └── isVerified
│
├── farms/                      # Farm registrations
│   └── {farmId}
│       ├── ownerId, ownerName, ownerPhone
│       ├── name, description
│       ├── location (GeoPoint)
│       ├── district
│       ├── licenseNumber, licenseExpiry
│       ├── varieties[] (Morris, Josapine, etc.)
│       ├── hasDelivery
│       ├── isVerified, verifiedAt, verifiedBy
│       └── socialLinks (whatsapp, facebook, instagram)
│
├── farms/{farmId}/products/    # Products (subcollection)
│   └── {productId}
│       ├── name, description
│       ├── category (fresh|processed)
│       ├── variety
│       ├── retailPrice, priceUnit
│       ├── wholesalePrice, minWholesaleQty
│       ├── stockStatus (available|limited|out)
│       └── images[]
│
├── harvestPlans/               # Harvest planning
│   └── {planId}
│       ├── farmId, farmName
│       ├── variety
│       ├── quantity
│       ├── plantingDate
│       ├── expectedHarvestDate
│       ├── actualHarvestDate
│       └── status (planned|growing|ready|harvested)
│
├── priceHistory/               # Price change tracking
├── buyerRequests/              # Buyer purchase requests
├── auditLogs/                  # LPNM verification actions (immutable)
├── announcements/              # System announcements
└── appConfig/                  # App-wide settings
```

### Data Models (Freezed)

All models use **Freezed** for immutability and include `fromFirestore()` / `toFirestore()` converters:

- `UserModel` - User profile with role
- `FarmModel` - Farm registration with location
- `ProductModel` - Product with pricing
- `HarvestPlanModel` - Harvest schedule
- `AuditLogModel` - Verification records
- `AnnouncementModel` - Admin notifications

---

## API Integrations


### Cloudinary

- **Purpose**: Image storage and CDN
- **Features**: Automatic optimization, responsive images
- **Usage**: Farm and product image uploads

### OpenStreetMap (flutter_map)

- **Purpose**: Interactive maps for farm discovery
- **Features**: Farm markers, user location, distance calculation
- **Advantage**: Free, no API key required

---

## Security

### Role-Based Access Control (RBAC)

```
┌────────────────────────────────────────────────────────────────┐
│                    PERMISSION MATRIX                           │
├───────────────┬─────────┬───────┬─────────────┬───────┬────────┤
│ Resource      │ Farmer  │ Buyer │ Wholesaler  │ Admin │ Super  │
├───────────────┼─────────┼───────┼─────────────┼───────┼────────┤
│ Own Profile   │ RW      │ RW    │ RW          │ RW    │ RW     │
│ Own Farm      │ CRUD    │ -     │ -           │ R     │ CRUD   │
│ Own Products  │ CRUD    │ -     │ -           │ R     │ CRUD   │
│ All Farms     │ R       │ R     │ R           │ R     │ CRUD   │
│ Retail Prices │ RW      │ R     │ R           │ R     │ RW     │
│ Wholesale $   │ RW      │ -     │ R           │ R     │ RW     │
│ Audit Logs    │ -       │ -     │ -           │ CR    │ CR     │
│ Verification  │ -       │ -     │ -           │ RW    │ RW     │
└───────────────┴─────────┴───────┴─────────────┴───────┴────────┘

R = Read, W = Write, C = Create, U = Update, D = Delete
```

### Security Measures

- **Firebase Auth**: Email/password authentication with session management
- **Firestore Security Rules**: Row-level and field-level access control
- **Immutable Audit Logs**: Verification records cannot be modified or deleted
- **Soft Delete**: Records use `isActive` flag; hard delete restricted to superadmin
- **Offline Data**: Firestore persistence with automatic sync

---

## Deployment

### Android APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Web (Firebase Hosting)

```bash
# Build web app
flutter build web

# Deploy to Firebase
firebase deploy --only hosting
```

### iOS (Future)

```bash
flutter build ios --release
```

---

## Implementation Status

A transparent overview of current implementation progress:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        IMPLEMENTATION STATUS                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   FULLY IMPLEMENTED                      BACKEND READY (not yet integrated) │
│   ────────────────────                   ─────────────────────────          │
│   ✅ User Authentication                 🔧 LPNM Admin Web Portal          │
│   ✅ Farm Profile Management             🔧 Weather Integration            │
│   ✅ Product Catalog (CRUD)              🔧 Push Notifications             │
│   ✅ Harvest Planner & Calendar                                            │
│   ✅ Buyer Farm Discovery                FUTURE PLANNING                   │
│   ✅ Interactive Map View                ─────────────────────             │
│   ✅ Product Search & Filters            📋 Inter-Farmer Network           │
│   ✅ Price History & Charts              📋 Regional Expansion             │
│   ✅ Product Comparison                                                    │
│   ✅ WhatsApp Integration                                                  │
│   ✅ Firestore Security Rules                                              │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## Future Improvements

### 1. LPNM Admin Web Portal

A comprehensive web-based dashboard for LPNM administrators to manage the platform:

| Feature | Description |
|---------|-------------|
| **Farm Verification Dashboard** | Review pending farm registrations, approve/reject with notes, track verification history |
| **Audit Log Viewer** | Searchable, filterable log of all administrative actions for compliance |
| **Announcement Management** | Create, schedule, and target announcements by role, district, or all users |
| **User Management** | View all users, manage roles, handle account issues |
| **Platform Analytics** | Dashboard showing active farmers, product listings, user engagement metrics |

### 2. Weather Integration

Integrate weather data into the farmer experience for better harvest planning:

| Feature | Description |
|---------|-------------|
| **Dashboard Weather Widget** | 7-day forecast displayed on farmer home screen |
| **Harvest Weather Alerts** | Notifications when severe weather may affect planned harvests |
| **Weather-Aware Suggestions** | Smart recommendations based on upcoming weather conditions |
| **Historical Weather Data** | Past weather patterns for crop cycle analysis |

### 3. Inter-Farmer Harvest Network (Rangkaian Petani)

**The Vision**: Create an interconnected network where Melaka's pineapple farmers can coordinate supply to prevent market oversaturation and maximize collective profitability.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     INTER-FARMER HARVEST NETWORK                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   FARMER A          FARMER B          FARMER C          FARMER D            │
│   ┌────────┐        ┌────────┐        ┌────────┐        ┌────────┐          │
│   │ Morris │        │ MD2    │        │Josapine│        │ Morris │          │
│   │ Jan 25 │        │ Feb 25 │        │ Jan 25 │        │ Mar 25 │          │
│   │ 500kg  │        │ 300kg  │        │ 400kg  │        │ 600kg  │          │
│   └────┬───┘        └────┬───┘        └────┬───┘        └────┬───┘          │
│        │                 │                 │                 │              │
│        └─────────────────┴─────────────────┴─────────────────┘              │
│                                   │                                         │
│                    ┌──────────────▼──────────────┐                          │
│                    │   AGGREGATED SUPPLY VIEW    │                          │
│                    │                             │                          │
│                    │  Jan 2025: 900kg Morris     │                          │
│                    │            400kg Josapine   │                          │
│                    │  Feb 2025: 300kg MD2        │                          │
│                    │  Mar 2025: 600kg Morris     │                          │
│                    └─────────────────────────────┘                          │
│                                                                             │
│   Benefits:                                                                 │
│   • Farmers see when others are harvesting same varieties                   │
│   • Prevents oversupply of single variety in same period                    │
│   • LPNM gains visibility into total Melaka supply                          │
│   • Buyers can plan purchases based on expected availability                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

| Feature | Description |
|---------|-------------|
| **Shared Harvest Calendar** | Opt-in view of other farmers' expected harvest dates by variety |
| **Supply Aggregation** | Total expected supply per variety per month across all participating farms |
| **Market Coordination** | Alerts when multiple farmers plan same variety harvest in same period |
| **District View** | Filter harvest network by Melaka Tengah, Alor Gajah, or Jasin |
| **Privacy Controls** | Farmers choose what to share (variety, quantity, timing) |

---

<p align="center">
  <strong>NenasKita</strong> - Empowering Melaka's Pineapple Farmers Through Technology
  <br>
  <em>Memperkasakan Petani Nanas Melaka Melalui Teknologi</em>
</p>

<p align="center">
  Made with Flutter & Firebase
</p>
