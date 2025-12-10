# NenasKita Firebase Backend Implementation Plan

## Overview

This document outlines the implementation plan for completing the Firebase backend, including repositories, services, and Riverpod providers.

---

## Status Summary

| Done | Remaining |
|------|-----------|
| Firestore Security Rules (deployed) | Repositories (9) |
| Firestore Indexes (deployed) | Services (6) |
| Dart Models (9 with freezed) | Riverpod Providers (10) |
| Enums & Converters | Firebase Storage Rules (1) |

**Total files to create: 26**

---

## User Decisions

| Decision | Choice |
|----------|--------|
| Storage ownership | Validate at app layer (any auth user can upload to farm folder) |
| Image compression | Skip for now |
| FCM topics | Auto-subscribe to district on registration |
| Offline strategy | Firestore cache only, no Hive |
| Weather API key | Hardcode (free tier) |
| Pattern | Concrete classes only, no abstracts |

---

## Implementation Phases

### Phase 1: Services (6 files)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/services/firebase_service.dart` | Firebase singleton, Firestore settings |
| 2 | `lib/services/auth_service.dart` | Phone OTP login/logout |
| 3 | `lib/services/storage_service.dart` | Image upload to Storage |
| 4 | `lib/services/notification_service.dart` | FCM + topic subscription |
| 5 | `lib/services/weather_service.dart` | OpenWeatherMap API (hardcoded key) |
| 6 | `lib/services/location_service.dart` | Geolocator wrapper |

### Phase 2: Repositories (9 files)

| # | File | Collection |
|---|------|------------|
| 7 | `lib/features/auth/repositories/user_repository.dart` | users |
| 8 | `lib/features/farm/repositories/farm_repository.dart` | farms |
| 9 | `lib/features/product/repositories/product_repository.dart` | farms/{farmId}/products |
| 10 | `lib/features/planner/repositories/harvest_plan_repository.dart` | harvestPlans |
| 11 | `lib/features/market/repositories/buyer_request_repository.dart` | buyerRequests |
| 12 | `lib/features/market/repositories/price_history_repository.dart` | priceHistory (read-only) |
| 13 | `lib/features/admin/repositories/audit_log_repository.dart` | auditLogs |
| 14 | `lib/features/admin/repositories/announcement_repository.dart` | announcements |
| 15 | `lib/core/repositories/app_config_repository.dart` | appConfig |

### Phase 3: Providers (10 files)

| # | File |
|---|------|
| 16 | `lib/services/providers/service_providers.dart` |
| 17 | `lib/features/auth/providers/user_providers.dart` |
| 18 | `lib/features/farm/providers/farm_providers.dart` |
| 19 | `lib/features/product/providers/product_providers.dart` |
| 20 | `lib/features/planner/providers/harvest_plan_providers.dart` |
| 21 | `lib/features/market/providers/buyer_request_providers.dart` |
| 22 | `lib/features/market/providers/price_history_providers.dart` |
| 23 | `lib/features/admin/providers/audit_log_providers.dart` |
| 24 | `lib/features/admin/providers/announcement_providers.dart` |
| 25 | `lib/core/providers/app_config_providers.dart` |

### Phase 4: Storage Rules (1 file)

| # | File |
|---|------|
| 26 | `storage.rules` |

### Phase 5: Build & Deploy

```bash
flutter pub run build_runner build --delete-conflicting-outputs
firebase deploy --only storage
flutter analyze
```

---

## Service Specifications

### 1. FirebaseService

```dart
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  Future<void> configureFirestore() async {
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  User? get currentUser => auth.currentUser;
  String? get currentUserId => currentUser?.uid;
  bool get isAuthenticated => currentUser != null;
  Stream<User?> get authStateChanges => auth.authStateChanges();
}
```

### 2. AuthService

```dart
class AuthService {
  final FirebaseService _firebaseService;

  // Phone OTP Methods
  Future<void> verifyPhoneNumber({...});
  Future<UserCredential> signInWithOtp({verificationId, smsCode});
  Future<void> signOut();

  // Helper
  String formatPhoneNumber(String phone); // Format to +60...
}
```

### 3. StorageService

```dart
class StorageService {
  // Paths: farms/{farmId}/products/, farms/{farmId}/farm/
  Future<String> uploadProductImage({farmId, productId, file});
  Future<String> uploadFarmImage({farmId, file});
  Future<void> deleteImage(String url);

  // Validation
  bool isValidImageType(fileName); // jpg, png, gif, webp
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
}
```

### 4. NotificationService

```dart
class NotificationService {
  Future<void> initialize();
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;

  // Topic subscription
  Future<void> subscribeToDistrict(String district);
  Future<void> subscribeToRole(String role);
}
```

### 5. WeatherService

```dart
class WeatherService {
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';

  Future<WeatherData> getCurrentWeather({latitude, longitude});
  Future<WeatherForecast> getForecast({latitude, longitude});
  Future<WeatherData> getWeatherByDistrict(String district);
}
```

### 6. LocationService

```dart
class LocationService {
  Future<bool> checkPermission();
  Future<Position?> getCurrentPosition();
  GeoPoint? positionToGeoPoint(Position? position);
  double calculateDistance({startLat, startLng, endLat, endLng});
  Stream<Position> getPositionStream();
}
```

---

## Repository Method Signatures

### UserRepository

```dart
class UserRepository {
  // CRUD
  Future<void> create(UserModel user);
  Future<UserModel?> getById(String userId);
  Future<void> update(UserModel user);

  // Streams
  Stream<UserModel?> watchUser(String userId);
  Stream<List<UserModel>> watchAllUsers();

  // Queries
  Future<UserModel?> getByPhone(String phone);
  Future<List<UserModel>> getByRole(UserRole role);
  Future<List<UserModel>> getByDistrict(String district);

  // Specific
  Future<void> updateFcmToken(String userId, String token);
}
```

### FarmRepository

```dart
class FarmRepository {
  // CRUD
  Future<String> create(FarmModel farm);
  Future<FarmModel?> getById(String farmId);
  Future<void> update(FarmModel farm);
  Future<void> delete(String farmId);

  // Streams
  Stream<FarmModel?> watchFarm(String farmId);
  Stream<List<FarmModel>> watchAllFarms();
  Stream<List<FarmModel>> watchFarmsByOwner(String ownerId);
  Stream<List<FarmModel>> watchFarmsByDistrict(String district);

  // Queries
  Future<List<FarmModel>> getByOwner(String ownerId);
  Future<List<FarmModel>> getVerifiedFarms();
  Future<List<FarmModel>> getUnverifiedFarms();
  Future<List<FarmModel>> searchByName(String query);

  // Admin
  Future<void> verifyFarm(String farmId, bool verified);
}
```

### ProductRepository (Subcollection)

```dart
class ProductRepository {
  // All methods need farmId parameter
  Future<String> create(String farmId, ProductModel product);
  Future<ProductModel?> getById(String farmId, String productId);
  Future<void> update(String farmId, ProductModel product);
  Future<void> delete(String farmId, String productId);

  Stream<List<ProductModel>> watchProductsByFarm(String farmId);
  Stream<List<ProductModel>> watchAvailableProducts(String farmId);

  // Cross-farm (collectionGroup)
  Stream<List<ProductModel>> watchAllProducts();
  Future<List<ProductModel>> getAllByCategory(ProductCategory category);
}
```

### HarvestPlanRepository

```dart
class HarvestPlanRepository {
  Future<String> create(HarvestPlanModel plan);
  Future<HarvestPlanModel?> getById(String planId);
  Future<void> update(HarvestPlanModel plan);
  Future<void> delete(String planId);

  Stream<List<HarvestPlanModel>> watchPlansByOwner(String ownerId);
  Stream<List<HarvestPlanModel>> watchUpcomingHarvests(String ownerId);

  Future<List<HarvestPlanModel>> getOverduePlans(String ownerId);
  Future<void> updateStatus(String planId, HarvestStatus status);
  Future<void> markReminderSent(String planId);
}
```

### BuyerRequestRepository

```dart
class BuyerRequestRepository {
  Future<String> create(BuyerRequestModel request);
  Future<BuyerRequestModel?> getById(String requestId);
  Future<void> update(BuyerRequestModel request);
  Future<void> delete(String requestId);

  Stream<List<BuyerRequestModel>> watchOpenRequests();
  Stream<List<BuyerRequestModel>> watchRequestsByBuyer(String buyerId);

  Future<void> fulfillRequest(String requestId, String farmId, String farmName);
}
```

### PriceHistoryRepository (Read-Only)

```dart
class PriceHistoryRepository {
  // Read only - writes via Cloud Function
  Future<PriceHistoryModel?> getById(String historyId);

  Stream<List<PriceHistoryModel>> watchRecent({int limit = 50});
  Stream<List<PriceHistoryModel>> watchByProduct(String productId);

  Future<double?> getAveragePrice(String variety, {int days = 30});
}
```

### AuditLogRepository (Create + Read Only)

```dart
class AuditLogRepository {
  Future<String> create(AuditLogModel log);
  Future<AuditLogModel?> getById(String logId);

  Stream<List<AuditLogModel>> watchRecent({int limit = 100});
  Stream<List<AuditLogModel>> watchByFarm(String farmId);
}
```

### AnnouncementRepository

```dart
class AnnouncementRepository {
  Future<String> create(AnnouncementModel announcement);
  Future<void> update(AnnouncementModel announcement);
  Future<void> delete(String announcementId);

  Stream<List<AnnouncementModel>> watchActive();
  Stream<List<AnnouncementModel>> watchForRole(UserRole role);
}
```

### AppConfigRepository

```dart
class AppConfigRepository {
  Future<AppConfigModel> get();
  Stream<AppConfigModel> watch();
  Future<void> update(AppConfigModel config);
}
```

---

## Provider Examples

### Service Providers

```dart
@Riverpod(keepAlive: true)
FirebaseService firebaseService(FirebaseServiceRef ref) => FirebaseService();

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return AuthService(firebaseService: ref.watch(firebaseServiceProvider));
}

@riverpod
Stream<User?> authState(AuthStateRef ref) {
  return ref.watch(authServiceProvider).authStateChanges;
}

@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  return ref.watch(authServiceProvider).currentUserId;
}
```

### Feature Providers

```dart
@Riverpod(keepAlive: true)
FarmRepository farmRepository(FarmRepositoryRef ref) => FarmRepository();

@riverpod
Stream<List<FarmModel>> myFarms(MyFarmsRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(farmRepositoryProvider).watchFarmsByOwner(userId);
}

@riverpod
Stream<FarmModel?> farmById(FarmByIdRef ref, String farmId) {
  return ref.watch(farmRepositoryProvider).watchFarm(farmId);
}
```

---

## Firebase Storage Rules

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    function isAuthenticated() {
      return request.auth != null;
    }

    function isValidImageType() {
      return request.resource.contentType.matches('image/(jpeg|jpg|png|gif|webp)');
    }

    function isValidFileSize() {
      return request.resource.size < 5 * 1024 * 1024;
    }

    // Farm storage: farms/{farmId}/*
    match /farms/{farmId}/{allPaths=**} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated()
        && isValidImageType()
        && isValidFileSize();
      allow delete: if isAuthenticated();
    }

    // Deny all other paths
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

---

## Code Patterns

### Repository Pattern

```dart
class ExampleRepository {
  final FirebaseFirestore _firestore;

  ExampleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('collectionName');

  Future<ExampleModel?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return ExampleModel.fromFirestore(doc);
  }

  Stream<List<ExampleModel>> watchAll() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => ExampleModel.fromFirestore(doc))
          .toList(),
    );
  }
}
```

### Provider Naming Convention

- Repository: `{name}Repository` with `@Riverpod(keepAlive: true)`
- Single item: `{name}ById(ref, String id)`
- List stream: `all{PluralName}` or `{action}{PluralName}`
- Current user's: `my{PluralName}`
- Filtered: `{pluralName}By{Filter}`

---

## Critical Reference Files

| File | Purpose |
|------|---------|
| `lib/core/utils/firestore_converters.dart` | TimestampConverter, GeoPointConverter |
| `lib/features/auth/models/user_model.dart` | fromFirestore/toFirestore pattern |
| `lib/core/constants/enums.dart` | All enums for type-safe queries |
| `firestore.rules` | Security rules to respect |

---

## Execution Instructions

When continuing in new session:

1. Read this plan and `project_plan_v1.md`
2. Create files in order (Phase 1 → 2 → 3 → 4)
3. Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. Run `firebase deploy --only storage`
5. Run `flutter analyze` to verify

---

*Document Version: 1.0*
*Created: December 2024*
*Project: NenasKita - LPNM Melaka Pineapple Digitalization*
