# NenasKita - LPNM Melaka Pineapple Farm Digitalization
## Project Plan Documentation | SULAM 2025

---

## 1. Project Overview

| Item | Description |
|------|-------------|
| Project Name | NenasKita |
| Client | Lembaga Perindustrian Nanas Malaysia (LPNM) |
| Scope | Melaka Region Only |
| Type | Mobile App + Admin Web Portal |
| Purpose | Information platform connecting farmers, buyers, LPNM staff |

### Core Problems Addressed
- No centralized market info/pricing
- No stock visibility
- No harvest planning tools
- Difficult farmer-buyer discovery
- Manual LPNM audit process

### Out of Scope
- Payment processing
- Live delivery tracking
- Auto price feeds
- Complex inventory management
- E-commerce transactions

---

## 2. System Architecture

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     FIREBASE CLOUD                          │
│  ┌──────────────┬─────────────┬──────────────────────────┐ │
│  │  Firestore   │  Auth       │  Storage                 │ │
│  │  (NoSQL DB)  │  (Phone OTP)│  (Images)                │ │
│  └──────────────┴─────────────┴──────────────────────────┘ │
│  ┌──────────────┬─────────────┬──────────────────────────┐ │
│  │  FCM         │  Hosting    │  Analytics               │ │
│  │  (Push Notif)│  (Web App)  │  (Usage Metrics)         │ │
│  └──────────────┴─────────────┴──────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                    ▲                    ▲
                    │ Firebase SDK       │ Firebase SDK
                    │                    │
         ┌──────────┴────────┐  ┌───────┴─────────┐
         │   Flutter Mobile  │  │  Flutter Web    │
         │   App             │  │  Admin Portal   │
         │                   │  │                 │
         │ • Farmers         │  │ • LPNM Staff    │
         │ • Buyers          │  │ • Super Admin   │
         │ • Wholesalers     │  │                 │
         └───────────────────┘  └─────────────────┘
                    │
                    ▼
         ┌───────────────────┐
         │  External APIs    │
         │ • OpenWeatherMap  │
         │ • OpenStreetMap   │
         │ • WhatsApp URL    │
         │ • Google Maps App │
         └───────────────────┘
```

### 2.2 Architecture Type: Serverless Modular

| Aspect | Choice | Rationale |
|--------|--------|-----------|
| Backend | Serverless (Firebase) | No server management, auto-scale |
| Database | Cloud Firestore | Offline sync, real-time updates |
| Pattern | Feature-First Modular | Easy to add future modules |
| Codebase | Monorepo | Mobile + Web share code |

### 2.3 Module Structure

```
NenasKita/
├── Core Module (shared)
│   ├── Auth
│   ├── User Management
│   └── Notifications
│
├── Farmer Module
│   ├── Farm Profile
│   ├── Product Catalog
│   ├── Harvest Planner
│   └── Price Management
│
├── Buyer Module
│   ├── Farm Discovery
│   ├── Product Search
│   └── Request Board
│
├── Market Module
│   ├── Price Listings
│   ├── Price Trends
│   └── Weather Info
│
└── Admin Module (LPNM)
    ├── Farmer Registry
    ├── Verification System
    ├── Audit Logs
    └── Reports
```

---

## 3. Design Patterns

### 3.1 Application Layer

| Pattern | Purpose | Where Used |
|---------|---------|------------|
| MVVM | Separate UI from logic | All screens |
| Repository | Abstract data sources | Firestore access |
| Provider/Riverpod | State management | App-wide state |
| Singleton | Single instances | Firebase services |
| Factory | Object creation | User type handling |
| Observer | Reactive updates | Real-time data streams |

### 3.2 Data Layer

| Pattern | Purpose |
|---------|---------|
| DTO | Shape API responses |
| Offline-First | Cache locally, sync later |
| Denormalization | Duplicate data for fast reads |
| Soft Delete | Mark deleted, don't remove |

### 3.3 MVVM Flow

```
┌─────────┐    ┌────────────┐    ┌────────────┐    ┌───────────┐
│  View   │◄───│ ViewModel  │◄───│ Repository │◄───│ Firestore │
│ (UI)    │    │ (Logic)    │    │ (Data)     │    │ (Source)  │
└─────────┘    └────────────┘    └────────────┘    └───────────┘
     │              │                  │
     │   User       │   Process        │   Fetch/
     │   Input      │   & Transform    │   Cache
     ▼              ▼                  ▼
```

---

## 4. Tech Stack Details

### 4.1 Complete Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Mobile Framework | Flutter | 3.x |
| Language | Dart | 3.x |
| State Management | Riverpod | 2.x |
| Database | Cloud Firestore | Latest |
| Auth | Firebase Auth | Latest |
| Storage | Firebase Storage | Latest |
| Push Notifications | FCM | Latest |
| Maps | flutter_map + latlong2 (OSM) | Latest |
| Charts | fl_chart | Latest |
| Local Storage | Hive | Latest |
| HTTP Client | Dio | Latest |
| Admin Portal | Flutter Web | 3.x |
| Hosting | Firebase Hosting | Latest |

### 4.2 External APIs

| API | Purpose | Free Tier |
|-----|---------|-----------|
| OpenWeatherMap | 7-day forecast | 1000 calls/day |
| OpenStreetMap (via flutter_map) | In-app farm location display | Unlimited (free) |
| Google Maps App (via url_launcher) | Navigation/directions | Free (redirects to user's phone) |
| WhatsApp URL Scheme | Direct chat link | Unlimited |



---

## 5. Database Design (Firestore)

### 5.1 Collections Overview

```
firestore/
├── users/
├── farms/
│   └── {farmId}/products/
├── harvestPlans/
├── buyerRequests/
├── priceHistory/
├── auditLogs/
├── announcements/
└── appConfig/
```

### 5.2 Document Schemas

**users/{userId}**
| Field | Type | Description |
|-------|------|-------------|
| name | string | Full name |
| phone | string | +60xxxxxxxxx |
| role | string | farmer/buyer/wholesaler/admin/superadmin |
| avatarUrl | string | Profile photo URL |
| district | string | Melaka district |
| createdAt | timestamp | Registration date |
| updatedAt | timestamp | Last profile update |
| isVerified | boolean | LPNM verified |
| fcmToken | string | Push notification token |

**farms/{farmId}**
| Field | Type | Description |
|-------|------|-------------|
| ownerId | string | Reference to users |
| ownerName | string | Denormalized |
| ownerPhone | string | Denormalized |
| farmName | string | Business name |
| description | string | About farm |
| location | geopoint | Lat/Long |
| address | string | Full address |
| district | string | Melaka Tengah/Alor Gajah/Jasin |
| licenseNumber | string | LPNM license |
| licenseExpiry | timestamp | Expiry date |
| farmSizeHectares | number | Size |
| varieties | array | [Morris, Josapine, MD2] |
| socialLinks | map | {whatsapp, facebook} |
| deliveryAvailable | boolean | Offers delivery |
| verifiedByLPNM | boolean | Inspection passed |
| verifiedAt | timestamp | Verification date |
| isActive | boolean | Soft delete flag |
| createdAt | timestamp | Created |
| updatedAt | timestamp | Last modified |

**farms/{farmId}/products/{productId}**
| Field | Type | Description |
|-------|------|-------------|
| name | string | Product name |
| category | string | fresh/processed |
| variety | string | Pineapple variety |
| price | number | Retail price |
| wholesalePrice | number | Wholesale price (visible to wholesalers only) |
| wholesaleMinQty | number | Minimum kg for wholesale price |
| priceUnit | string | per kg/per piece/per bottle |
| stockStatus | string | available/limited/out |
| description | string | Details |
| images | array | Photo URLs |
| updatedAt | timestamp | Price update time |

**harvestPlans/{planId}**
| Field | Type | Description |
|-------|------|-------------|
| farmId | string | Reference |
| farmName | string | Denormalized |
| ownerId | string | Reference |
| variety | string | Pineapple type |
| quantityKg | number | Planned amount |
| plantingDate | timestamp | When planted |
| expectedHarvestDate | timestamp | ~18-24 months later |
| actualHarvestDate | timestamp | Actual harvest |
| status | string | planned/growing/ready/harvested |
| notes | string | Batch notes |
| reminderSent | boolean | Notification sent |
| createdAt | timestamp | Created |

**buyerRequests/{requestId}**
| Field | Type | Description |
|-------|------|-------------|
| buyerId | string | Reference |
| buyerName | string | Denormalized |
| buyerPhone | string | Denormalized |
| category | string | fresh/processed |
| variety | string | Preferred type |
| quantityKg | number | Amount needed |
| deliveryDistrict | string | Delivery location |
| neededByDate | timestamp | Deadline |
| status | string | open/fulfilled/closed |
| fulfilledByFarmId | string | Farm that fulfilled (when status=fulfilled) |
| fulfilledByFarmName | string | Denormalized farm name |
| fulfilledAt | timestamp | When request was fulfilled |
| createdAt | timestamp | Created |

**priceHistory/{historyId}**
| Field | Type | Description |
|-------|------|-------------|
| farmId | string | Reference |
| productId | string | Reference |
| productName | string | Denormalized |
| variety | string | Type |
| oldPrice | number | Previous retail price |
| newPrice | number | Updated retail price |
| oldWholesalePrice | number | Previous wholesale price |
| newWholesalePrice | number | Updated wholesale price |
| changedAt | timestamp | When changed |
| expiresAt | timestamp | TTL - auto-delete after 1 year |

**auditLogs/{logId}**
| Field | Type | Description |
|-------|------|-------------|
| adminId | string | LPNM staff |
| adminName | string | Denormalized |
| farmId | string | Target farm |
| farmName | string | Denormalized |
| action | string | inspection/approved/rejected/pending |
| notes | string | Remarks |
| attachments | array | Photo URLs |
| timestamp | timestamp | When logged |

**announcements/{announcementId}**
| Field | Type | Description |
|-------|------|-------------|
| title | string | Headline |
| body | string | Content |
| type | string | info/warning/promo |
| targetRoles | array | [farmer, buyer] |
| createdBy | string | Admin ID |
| createdAt | timestamp | Published |
| expiresAt | timestamp | Auto-hide |

**appConfig/settings**
| Field | Type | Description |
|-------|------|-------------|
| varieties | array | Available varieties |
| districts | array | Melaka districts |
| categories | array | Product categories |
| minAppVersion | string | Force update |

### 5.3 Indexing Strategy

| Collection | Composite Index |
|------------|-----------------|
| farms | district + isActive + verifiedByLPNM |
| farms/products | category + stockStatus |
| harvestPlans | ownerId + status + expectedHarvestDate |
| buyerRequests | status + neededByDate |
| priceHistory | variety + changedAt |

### 5.4 Data Lifecycle & Retention

| Data Type | Retention Policy | Implementation |
|-----------|------------------|----------------|
| Price History | 1 year | Firestore TTL on `expiresAt` field |
| Audit Logs | Indefinite | Required for LPNM compliance |
| Announcements | Until `expiresAt` | Auto-hide in app, manual cleanup |
| User Data | Until account deletion | Soft delete, 30-day recovery window |
| Farm Data | Indefinite | Soft delete via `isActive` flag |

**Soft Delete Policy:**
- All user-initiated deletions set `isActive = false`
- Data remains queryable by admins for audit purposes
- Only SuperAdmin can perform hard deletes
- Deleted data excluded from public queries via security rules

**Denormalized Data Sync:**
When updating denormalized fields, use batch writes to maintain consistency:

| Source Field | Denormalized In |
|--------------|-----------------|
| users.name | farms.ownerName, buyerRequests.buyerName, auditLogs.adminName |
| users.phone | farms.ownerPhone, buyerRequests.buyerPhone |
| farms.farmName | harvestPlans.farmName, buyerRequests.fulfilledByFarmName, auditLogs.farmName |

---

## 6. Feature Specifications

### 6.1 Core Features (MVP)

| # | Feature | User | Priority |
|---|---------|------|----------|
| F1 | Phone OTP Login | All | Must |
| F2 | User Profile | All | Must |
| F3 | Farm Registration | Farmer | Must |
| F4 | Product Listing | Farmer | Must |
| F5 | Price Update | Farmer | Must |
| F6 | Farm Discovery | Buyer | Must |
| F7 | Product Search | Buyer | Must |
| F8 | Farm Detail View | Buyer | Must |
| F9 | Farmer Registry | Admin | Must |
| F10 | Verification Badge | Admin | Must |

### 6.2 Enhanced Features

| # | Feature | User | Priority |
|---|---------|------|----------|
| F11 | Harvest Planner | Farmer | High |
| F12 | Harvest Reminders | Farmer | High |
| F13 | Stock Status | Farmer | High |
| F14 | Buyer Request Board | Buyer | Medium |
| F15 | WhatsApp Quick Chat | Buyer | High |
| F16 | Audit Logging | Admin | High |
| F17 | Announcements | Admin | Medium |

### 6.3 Bonus Features (Your Selections)

| # | Feature | Description | Priority |
|---|---------|-------------|----------|
| F18 | Weather Integration | 7-day forecast on dashboard | Medium |
| F19 | Price Trend Charts | Line graph of price history | Medium |
| F20 | Offline Mode | Cache + sync when online | High |
| F21 | WhatsApp Integration | Pre-filled message deep link | High |
| F22 | Product Variety Catalog | Info about Morris/Josapine/MD2 | Low |
| F23 | Smart Harvest Calendar | Regional harvest aggregate view | Medium |

### 6.4 Feature-Module Mapping

```
┌─────────────────────────────────────────────────────────────┐
│                     FEATURE MODULES                         │
├─────────────┬─────────────┬─────────────┬──────────────────┤
│   AUTH      │   FARM      │   MARKET    │   ADMIN          │
│             │             │             │                  │
│ • Login     │ • Profile   │ • Discovery │ • Registry       │
│ • Register  │ • Products  │ • Search    │ • Verification   │
│ • OTP       │ • Planner   │ • Prices    │ • Audit          │
│ • Profile   │ • Stock     │ • Trends    │ • Reports        │
│             │ • Weather   │ • Requests  │ • Announcements  │
└─────────────┴─────────────┴─────────────┴──────────────────┘
```

---

## 7. User Roles & Permissions

### 7.1 Role Definitions

| Role | Description | Access Level | Special Permissions |
|------|-------------|--------------|---------------------|
| Farmer | Pineapple growers/entrepreneurs | Own data only | Manage farms, products, harvest plans |
| Buyer | Retail/small-quantity purchasers | Read public data | Post buyer requests, view retail prices |
| Wholesaler | Bulk buyers (>50kg orders) | Read public data | View wholesale prices, post buyer requests |
| Admin | LPNM staff | All data (read) | Verify farms, audit logs, announcements |
| SuperAdmin | System administrator | Full access | Manage admins, hard delete, system config |

**Note:** Each user has exactly ONE role. Wholesalers see exclusive wholesale pricing that regular buyers cannot access.

### 7.2 Permission Matrix

| Feature | Farmer | Buyer | Wholesaler | Admin | SuperAdmin |
|---------|--------|-------|------------|-------|------------|
| View farms | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create farm | ✓ | ✗ | ✗ | ✗ | ✗ |
| Edit own farm | ✓ | ✗ | ✗ | ✗ | ✗ |
| Soft delete own farm | ✓ | ✗ | ✗ | ✗ | ✗ |
| Hard delete farm | ✗ | ✗ | ✗ | ✗ | ✓ |
| View products | ✓ | ✓ | ✓ | ✓ | ✓ |
| View retail prices | ✓ | ✓ | ✓ | ✓ | ✓ |
| View wholesale prices | Own | ✗ | **✓** | ✓ | ✓ |
| Manage own products | ✓ | ✗ | ✗ | ✗ | ✗ |
| Update own prices | ✓ | ✗ | ✗ | ✗ | ✗ |
| View harvest plans | Own | Aggregate | Aggregate | ✓ | ✓ |
| Manage harvest plans | ✓ | ✗ | ✗ | ✗ | ✗ |
| Post buyer request | ✗ | ✓ | ✓ | ✗ | ✗ |
| Mark request fulfilled | ✓ | ✗ | ✗ | ✗ | ✗ |
| View buyer requests | ✓ | ✓ | ✓ | ✓ | ✓ |
| Verify farms | ✗ | ✗ | ✗ | ✓ | ✓ |
| View audit logs | ✗ | ✗ | ✗ | ✓ | ✓ |
| Post announcements | ✗ | ✗ | ✗ | ✓ | ✓ |
| View analytics | ✗ | ✗ | ✗ | ✓ | ✓ |
| Manage admin users | ✗ | ✗ | ✗ | ✗ | ✓ |
| System configuration | ✗ | ✗ | ✗ | ✗ | ✓ |

**Legend:**
- ✓ = Full access
- ✗ = No access
- Own = Only own data
- Aggregate = Summary/stats only (e.g., "10 harvests expected in Jasin next month")

### 7.3 Firestore Security Rules Concept

```
users:
  - read: authenticated
  - write: own document only
  - note: phone numbers visible to all authenticated users

farms:
  - read: authenticated (where isActive == true)
  - create: role == 'farmer'
  - update: owner only
  - delete: DENY (use isActive = false for soft delete)
  - hard delete: superadmin only

farms/products:
  - read (all fields except wholesalePrice): authenticated
  - read (wholesalePrice, wholesaleMinQty):
      - farm owner OR
      - role == 'wholesaler' OR
      - role == 'admin' OR
      - role == 'superadmin'
  - write: farm owner only

harvestPlans:
  - read (full document): owner OR admin OR superadmin
  - read (aggregate queries by district/month): authenticated
  - write: owner only

buyerRequests:
  - read: authenticated
  - create: role == 'buyer' OR role == 'wholesaler'
  - update (status to fulfilled + fulfillment fields): any farmer
  - update (other fields): owner only

priceHistory:
  - read: authenticated
  - read (wholesale price fields): owner OR wholesaler OR admin
  - write: system only (triggered on product price update)

auditLogs:
  - read: admin OR superadmin
  - write: admin OR superadmin

announcements:
  - read: authenticated
  - write: admin OR superadmin

appConfig:
  - read: authenticated
  - write: superadmin only
```

**Security Notes:**
- All document deletions are soft deletes (isActive = false) except by SuperAdmin
- Wholesale prices are field-level secured - regular buyers cannot read these fields
- Farmers can mark any buyer request as fulfilled (to encourage engagement)

---

## 8. App Screens & Navigation

### 8.1 Screen Inventory

**Auth Flow**
- Splash Screen
- Login Screen (Phone Input)
- OTP Verification Screen
- Role Selection Screen
- Profile Setup Screen

**Farmer Screens**
- Home Dashboard
- My Farm Profile
- My Products List
- Add/Edit Product
- Harvest Planner
- Add/Edit Harvest Plan
- Price Update Screen
- Settings

**Buyer Screens**
- Home Dashboard
- Farm Discovery (List + Map)
- Farm Detail
- Product Detail
- Buyer Request Form
- My Requests
- Settings

**Admin Screens (Web)**
- Login
- Dashboard (Stats)
- Farmers Registry
- Farmer Detail
- Pending Verifications
- Verification Form
- Audit Logs
- Announcements
- Settings

### 8.2 Navigation Structure

```
App
├── Auth Stack (unauthenticated)
│   ├── /splash
│   ├── /login
│   ├── /otp
│   └── /setup
│
└── Main Stack (authenticated)
    │
    ├── Farmer Layout
    │   ├── /home (Dashboard)
    │   ├── /farm (My Farm)
    │   ├── /products
    │   │   ├── /products/add
    │   │   └── /products/:id/edit
    │   ├── /planner
    │   │   ├── /planner/add
    │   │   └── /planner/:id/edit
    │   └── /settings
    │
    ├── Buyer Layout
    │   ├── /home (Discovery)
    │   ├── /farms/:id (Detail)
    │   ├── /products/:id (Detail)
    │   ├── /requests
    │   │   └── /requests/new
    │   └── /settings
    │
    └── Admin Layout (Web)
        ├── /dashboard
        ├── /farmers
        │   └── /farmers/:id
        ├── /verifications
        ├── /audits
        ├── /announcements
        └── /settings
```

---

## 9. Offline Strategy

### 9.1 Firestore Offline Persistence

| Data Type | Cache Strategy |
|-----------|----------------|
| Own farm data | Always cached |
| Own products | Always cached |
| Own harvest plans | Always cached |
| Farm listings | Cache on view |
| Product listings | Cache on view |
| Prices | Cache on view |

### 9.2 Offline Capabilities

| Action | Offline Behavior |
|--------|------------------|
| View cached data | ✓ Works |
| Edit own farm | ✓ Queued, syncs later |
| Add product | ✓ Queued, syncs later |
| Update price | ✓ Queued, syncs later |
| Add harvest plan | ✓ Queued, syncs later |
| Search farms | ✗ Needs connection |
| Upload images | ✗ Needs connection |

### 9.3 Sync Indicator UI

```
┌────────────────────────────┐
│ ⚠️ Offline Mode           │
│ Changes will sync when    │
│ connection restored       │
└────────────────────────────┘
```

---

## 10. External Integrations

### 10.1 Weather API (OpenWeatherMap)

| Endpoint | Usage |
|----------|-------|
| /weather | Current conditions |
| /forecast | 7-day forecast |

**Display**: Farmer dashboard widget showing temperature, humidity, rain forecast

**Caching**: Store forecast locally, refresh every 6 hours

### 10.2 OpenStreetMap (flutter_map)

| Feature | Usage |
|---------|-------|
| FlutterMap | Display farm locations on map (free, no API key) |
| OSM Tiles | Map tiles from OpenStreetMap |
| Markers | Custom markers for each farm |
| url_launcher | Redirect to Google Maps app for navigation |

**Display**: Map view in discovery screen with farm markers

**Navigation Flow**:
```
In-App Map (OSM) → Tap Marker → Popup Card → "Get Directions" → Opens Google Maps App
```

**Cost**: Free (no API key required, unlike Google Maps embed which charges after free tier)

### 10.3 WhatsApp Integration

**Method**: URL scheme deep link

**Format**: `https://wa.me/60xxxxxxxxx?text=Salam,%20saya%20berminat%20dengan%20nanas%20anda`

**Trigger**: "Chat on WhatsApp" button on farm/product detail

---

## 11. Push Notifications

### 11.1 Notification Types

| Type | Trigger | Recipient |
|------|---------|-----------|
| Harvest Reminder | 7 days before expected harvest | Farmer |
| New Buyer Request | Buyer posts matching request | Farmers in district |
| Price Update Alert | Farmer updates price | Subscribed buyers |
| Verification Status | Admin approves/rejects | Farmer |
| Announcement | Admin posts | Target roles |

### 11.2 FCM Topic Structure

```
topics/
├── all_users
├── farmers
├── buyers
├── district_melaka_tengah
├── district_alor_gajah
├── district_jasin
└── variety_morris
```

---

## 12. Analytics & Monitoring

### 12.1 Firebase Analytics Events

| Event | Parameters |
|-------|------------|
| login | method, role |
| sign_up | role, district |
| farm_created | district, varieties |
| product_added | category, variety |
| price_updated | product_id, old, new |
| farm_viewed | farm_id, viewer_role |
| search_performed | query, filters |
| whatsapp_clicked | farm_id |
| harvest_plan_created | variety, quantity |

### 12.2 Admin Dashboard Metrics

| Metric | Description |
|--------|-------------|
| Total Users | By role |
| Active Farms | Registered + verified |
| Products Listed | By category |
| Price Updates | Last 7 days |
| Pending Verifications | Queue count |
| Regional Distribution | Farms per district |

---

## 13. Security Considerations

### 13.1 Authentication

| Measure | Implementation |
|---------|----------------|
| Phone OTP | Firebase Auth, 6-digit code |
| Session | Firebase handles token refresh |
| Logout | Clear local data + FCM token |

### 13.2 Data Protection

| Measure | Implementation |
|---------|----------------|
| Row-Level Security | Firestore rules |
| Role-Based Access | Custom claims |
| Input Validation | Client + rules |
| XSS Prevention | Flutter handles |

### 13.3 Privacy

| Data | Visibility |
|------|------------|
| Phone number | All authenticated users |
| Wholesale prices | Farm owner, wholesalers, admins only |
| Exact location | Admin only (inspection) |
| Approximate location | Public (district level) |
| License details | Admin only |
| Harvest plan details | Farm owner, admins only |
| Harvest aggregates | All authenticated users |

---

## 14. Scalability Design

### 14.1 Current Capacity (Free Tier)

| Resource | Limit | Sufficient For |
|----------|-------|----------------|
| Firestore Reads | 50K/day | ~500 active users |
| Firestore Writes | 20K/day | ~200 active farmers |
| Storage | 5GB | ~5000 product images |
| Auth | Unlimited | No limit |

### 14.2 Scaling Strategy

**Phase 1 (0-100 users)**: Free tier sufficient

**Phase 2 (100-1000 users)**: 
- Upgrade to Blaze plan (pay-as-you-go)
- Implement pagination
- Add caching layers

**Phase 3 (1000+ users)**:
- Cloud Functions for heavy operations
- CDN for images
- Regional expansion consideration

### 14.3 Performance Optimizations

| Optimization | Purpose |
|--------------|---------|
| Pagination | 20 items per load |
| Lazy loading | Images load on scroll |
| Denormalization | Reduce read operations |
| Compound queries | Efficient filtering |
| Offline cache | Reduce server hits |

---

## 15. Project Folder Structure

### 15.1 Flutter Project

```
nenas_kita/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── widgets/
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   ├── repositories/
│   │   │   └── screens/
│   │   │
│   │   ├── farm/
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   ├── repositories/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   │
│   │   ├── product/
│   │   │   └── ... (same structure)
│   │   │
│   │   ├── planner/
│   │   │   └── ...
│   │   │
│   │   ├── market/
│   │   │   └── ...
│   │   │
│   │   └── admin/
│   │       └── ...
│   │
│   └── services/
│       ├── firebase_service.dart
│       ├── auth_service.dart
│       ├── storage_service.dart
│       ├── notification_service.dart
│       ├── weather_service.dart
│       └── location_service.dart
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── android/
├── ios/
├── web/
│
├── pubspec.yaml
└── README.md
```

### 15.2 Feature Module Structure

```
feature_name/
├── models/
│   └── feature_model.dart
├── providers/
│   └── feature_provider.dart
├── repositories/
│   └── feature_repository.dart
├── screens/
│   ├── feature_list_screen.dart
│   └── feature_detail_screen.dart
└── widgets/
    ├── feature_card.dart
    └── feature_form.dart
```


---

## 17. Deployment

### 17.1 Mobile App

| Platform | Method |
|----------|--------|
| Android | APK direct distribution OR Play Store |
| iOS | TestFlight OR App Store (requires Apple Dev Account) |

**Build Commands**:
```
flutter build apk --release
flutter build appbundle --release
```

### 17.2 Admin Portal

| Service | Details |
|---------|---------|
| Host | Firebase Hosting |
| Domain | nenaskita.web.app (free) |
| SSL | Auto-provisioned |

**Deploy Command**:
```
flutter build web
firebase deploy --only hosting
```

### 17.3 Environment Configuration

| Environment | Firebase Project | Purpose |
|-------------|------------------|---------|
| Development | nenaskita-dev | Testing |
| Production | nenaskita-prod | Live app |


---

## 20. Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Registered farmers | 20+ | Firebase Auth count |
| Active farms | 15+ | Farms with products |
| Daily active users | 30+ | Firebase Analytics |
| Products listed | 50+ | Firestore count |
| Price updates/week | 20+ | priceHistory count |
| LPNM satisfaction | Positive | Stakeholder feedback |
| App crashes | <1% | Firebase Crashlytics |

---

## Appendix A: Pineapple Varieties (Melaka)

| Variety | Local Name | Characteristics |
|---------|------------|-----------------|
| Morris | Nanas Morris | Sweet, golden, most common |
| Josapine | Nanas Josapine | Hybrid, sweet-sour, premium |
| MD2 | Nanas MD2 | Export quality, very sweet |
| Sarawak | Nanas Sarawak | Smaller, intense flavor |
| Yankee | Nanas Yankee | Large, cooking variety |

---

## Appendix B: Melaka Districts

| District | Area |
|----------|------|
| Melaka Tengah | Central, urban |
| Alor Gajah | North, agricultural |
| Jasin | South, agricultural |

---

*Document Version: 1.2*
*Last Updated: December 2025*
*Project: NenasKita - LPNM Melaka Pineapple Digitalization*
*Course: Software Project Management (SULAM)*

**Version History:**
| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Dec 2025 | Initial project plan |
| 1.1 | Dec 2025 | Added wholesale pricing, fulfillment tracking, data lifecycle, expanded permission matrix |
| 1.2 | Dec 2025 | Switched from Google Maps API to OpenStreetMap (flutter_map) - free, no API key required |
