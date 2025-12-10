import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/features/auth/providers/auth_flow_providers.dart';
import 'package:nenas_kita/services/firebase_service.dart';
import 'package:nenas_kita/services/auth_service.dart';
import 'package:nenas_kita/services/storage_service.dart';
import 'package:nenas_kita/services/notification_service.dart';
import 'package:nenas_kita/services/weather_service.dart';
import 'package:nenas_kita/services/location_service.dart';
import 'package:nenas_kita/services/pwa_service.dart';

part 'service_providers.g.dart';

// ============ FIREBASE SERVICE ============

/// Firebase service singleton provider
@Riverpod(keepAlive: true)
FirebaseService firebaseService(FirebaseServiceRef ref) {
  return FirebaseService();
}

// ============ AUTH SERVICE ============

/// Auth service provider (uses Hive for session, Firestore for user data)
@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

/// Current user ID from Hive local storage (nullable)
/// Watches authRefreshNotifierProvider to re-read from Hive after logout/login
@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  // Watch the refresh notifier to force re-read after auth state changes
  ref.watch(authRefreshNotifierProvider);
  return ref.watch(authServiceProvider).currentUserId;
}

/// Is user authenticated (has stored userId in Hive)
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(currentUserIdProvider) != null;
}

// ============ STORAGE SERVICE (Cloudinary) ============

/// Storage service provider (uses Cloudinary, not Firebase Storage)
@Riverpod(keepAlive: true)
StorageService storageService(StorageServiceRef ref) {
  return StorageService();
}

// ============ NOTIFICATION SERVICE ============

/// Notification service provider
@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService(firebaseService: ref.watch(firebaseServiceProvider));
}

// ============ WEATHER SERVICE ============

/// Weather service provider
@Riverpod(keepAlive: true)
WeatherService weatherService(WeatherServiceRef ref) {
  return WeatherService();
}

/// Get current weather by coordinates
@riverpod
Future<WeatherData> currentWeather(
  CurrentWeatherRef ref, {
  required double latitude,
  required double longitude,
}) async {
  return ref.watch(weatherServiceProvider).getCurrentWeather(
    latitude: latitude,
    longitude: longitude,
  );
}

/// Get weather forecast by district
@riverpod
Future<WeatherForecast> weatherForecastByDistrict(
  WeatherForecastByDistrictRef ref,
  String district,
) async {
  return ref.watch(weatherServiceProvider).getForecastByDistrict(district);
}

// ============ LOCATION SERVICE ============

/// Location service provider
@Riverpod(keepAlive: true)
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}

// ============ PWA SERVICE ============

/// PWA service singleton provider (web-only functionality)
@Riverpod(keepAlive: true)
PwaService pwaService(PwaServiceRef ref) {
  final service = PwaService.instance;
  service.initialize();
  return service;
}

/// Whether PWA install prompt is available (web only)
@riverpod
class PwaInstallAvailable extends _$PwaInstallAvailable {
  @override
  bool build() {
    if (!kIsWeb) return false;

    final pwa = ref.watch(pwaServiceProvider);

    // Listen for changes
    final subscription = pwa.onInstallAvailableChanged.listen((available) {
      state = available;
    });

    ref.onDispose(() => subscription.cancel());

    return pwa.isInstallAvailable;
  }
}

/// Whether app is running as installed PWA (web only)
@riverpod
class IsPwaInstalled extends _$IsPwaInstalled {
  @override
  bool build() {
    if (!kIsWeb) return false;

    final pwa = ref.watch(pwaServiceProvider);
    final subscription = pwa.onInstalledChanged.listen((installed) {
      state = installed;
    });

    ref.onDispose(() => subscription.cancel());

    return pwa.isInstalled;
  }
}

/// Whether install banner was dismissed by user (stored in memory)
@riverpod
class PwaInstallDismissed extends _$PwaInstallDismissed {
  @override
  bool build() => false;

  void dismiss() {
    state = true;
  }

  void reset() {
    state = false;
  }
}
