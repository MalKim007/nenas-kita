// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseServiceHash() => r'96c36d6d8bd4ac5115681565ea28f3edb95a9e01';

/// Firebase service singleton provider
///
/// Copied from [firebaseService].
@ProviderFor(firebaseService)
final firebaseServiceProvider = Provider<FirebaseService>.internal(
  firebaseService,
  name: r'firebaseServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseServiceRef = ProviderRef<FirebaseService>;
String _$authServiceHash() => r'd95f6f0327b9783a3e7e039c4caaa93c6a60aa27';

/// Auth service provider (uses Hive for session, Firestore for user data)
///
/// Copied from [authService].
@ProviderFor(authService)
final authServiceProvider = Provider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = ProviderRef<AuthService>;
String _$currentUserIdHash() => r'bcdc900e85ed88461de62f5699ed5b27339e010a';

/// Current user ID from Hive local storage (nullable)
/// Watches authRefreshNotifierProvider to re-read from Hive after logout/login
///
/// Copied from [currentUserId].
@ProviderFor(currentUserId)
final currentUserIdProvider = AutoDisposeProvider<String?>.internal(
  currentUserId,
  name: r'currentUserIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserIdRef = AutoDisposeProviderRef<String?>;
String _$isAuthenticatedHash() => r'ce3d1e023440cf4373bb3dce8c74f6aae04af674';

/// Is user authenticated (has stored userId in Hive)
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$storageServiceHash() => r'59688abd0fb16e355f55dd53d8827bcf69375a56';

/// Storage service provider (uses Cloudinary, not Firebase Storage)
///
/// Copied from [storageService].
@ProviderFor(storageService)
final storageServiceProvider = Provider<StorageService>.internal(
  storageService,
  name: r'storageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageServiceRef = ProviderRef<StorageService>;
String _$notificationServiceHash() =>
    r'83edc07c66a8a4c14918be8e331e027d71a8774c';

/// Notification service provider
///
/// Copied from [notificationService].
@ProviderFor(notificationService)
final notificationServiceProvider = Provider<NotificationService>.internal(
  notificationService,
  name: r'notificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationServiceRef = ProviderRef<NotificationService>;
String _$weatherServiceHash() => r'7fa4ce0cfdf7441c83b1a7685c591048cd17835b';

/// Weather service provider
///
/// Copied from [weatherService].
@ProviderFor(weatherService)
final weatherServiceProvider = Provider<WeatherService>.internal(
  weatherService,
  name: r'weatherServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weatherServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherServiceRef = ProviderRef<WeatherService>;
String _$currentWeatherHash() => r'd9b810d33a75f98cdceaeaa96df4354b385eaf58';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Get current weather by coordinates
///
/// Copied from [currentWeather].
@ProviderFor(currentWeather)
const currentWeatherProvider = CurrentWeatherFamily();

/// Get current weather by coordinates
///
/// Copied from [currentWeather].
class CurrentWeatherFamily extends Family<AsyncValue<WeatherData>> {
  /// Get current weather by coordinates
  ///
  /// Copied from [currentWeather].
  const CurrentWeatherFamily();

  /// Get current weather by coordinates
  ///
  /// Copied from [currentWeather].
  CurrentWeatherProvider call({
    required double latitude,
    required double longitude,
  }) {
    return CurrentWeatherProvider(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  CurrentWeatherProvider getProviderOverride(
    covariant CurrentWeatherProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currentWeatherProvider';
}

/// Get current weather by coordinates
///
/// Copied from [currentWeather].
class CurrentWeatherProvider extends AutoDisposeFutureProvider<WeatherData> {
  /// Get current weather by coordinates
  ///
  /// Copied from [currentWeather].
  CurrentWeatherProvider({
    required double latitude,
    required double longitude,
  }) : this._internal(
          (ref) => currentWeather(
            ref as CurrentWeatherRef,
            latitude: latitude,
            longitude: longitude,
          ),
          from: currentWeatherProvider,
          name: r'currentWeatherProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentWeatherHash,
          dependencies: CurrentWeatherFamily._dependencies,
          allTransitiveDependencies:
              CurrentWeatherFamily._allTransitiveDependencies,
          latitude: latitude,
          longitude: longitude,
        );

  CurrentWeatherProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
  }) : super.internal();

  final double latitude;
  final double longitude;

  @override
  Override overrideWith(
    FutureOr<WeatherData> Function(CurrentWeatherRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentWeatherProvider._internal(
        (ref) => create(ref as CurrentWeatherRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WeatherData> createElement() {
    return _CurrentWeatherProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentWeatherProvider &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentWeatherRef on AutoDisposeFutureProviderRef<WeatherData> {
  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;
}

class _CurrentWeatherProviderElement
    extends AutoDisposeFutureProviderElement<WeatherData>
    with CurrentWeatherRef {
  _CurrentWeatherProviderElement(super.provider);

  @override
  double get latitude => (origin as CurrentWeatherProvider).latitude;
  @override
  double get longitude => (origin as CurrentWeatherProvider).longitude;
}

String _$weatherForecastByDistrictHash() =>
    r'b8ce4472d5431a8256a7ec2844358495f89a7f8b';

/// Get weather forecast by district
///
/// Copied from [weatherForecastByDistrict].
@ProviderFor(weatherForecastByDistrict)
const weatherForecastByDistrictProvider = WeatherForecastByDistrictFamily();

/// Get weather forecast by district
///
/// Copied from [weatherForecastByDistrict].
class WeatherForecastByDistrictFamily
    extends Family<AsyncValue<WeatherForecast>> {
  /// Get weather forecast by district
  ///
  /// Copied from [weatherForecastByDistrict].
  const WeatherForecastByDistrictFamily();

  /// Get weather forecast by district
  ///
  /// Copied from [weatherForecastByDistrict].
  WeatherForecastByDistrictProvider call(
    String district,
  ) {
    return WeatherForecastByDistrictProvider(
      district,
    );
  }

  @override
  WeatherForecastByDistrictProvider getProviderOverride(
    covariant WeatherForecastByDistrictProvider provider,
  ) {
    return call(
      provider.district,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'weatherForecastByDistrictProvider';
}

/// Get weather forecast by district
///
/// Copied from [weatherForecastByDistrict].
class WeatherForecastByDistrictProvider
    extends AutoDisposeFutureProvider<WeatherForecast> {
  /// Get weather forecast by district
  ///
  /// Copied from [weatherForecastByDistrict].
  WeatherForecastByDistrictProvider(
    String district,
  ) : this._internal(
          (ref) => weatherForecastByDistrict(
            ref as WeatherForecastByDistrictRef,
            district,
          ),
          from: weatherForecastByDistrictProvider,
          name: r'weatherForecastByDistrictProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weatherForecastByDistrictHash,
          dependencies: WeatherForecastByDistrictFamily._dependencies,
          allTransitiveDependencies:
              WeatherForecastByDistrictFamily._allTransitiveDependencies,
          district: district,
        );

  WeatherForecastByDistrictProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.district,
  }) : super.internal();

  final String district;

  @override
  Override overrideWith(
    FutureOr<WeatherForecast> Function(WeatherForecastByDistrictRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeatherForecastByDistrictProvider._internal(
        (ref) => create(ref as WeatherForecastByDistrictRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        district: district,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WeatherForecast> createElement() {
    return _WeatherForecastByDistrictProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeatherForecastByDistrictProvider &&
        other.district == district;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, district.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeatherForecastByDistrictRef
    on AutoDisposeFutureProviderRef<WeatherForecast> {
  /// The parameter `district` of this provider.
  String get district;
}

class _WeatherForecastByDistrictProviderElement
    extends AutoDisposeFutureProviderElement<WeatherForecast>
    with WeatherForecastByDistrictRef {
  _WeatherForecastByDistrictProviderElement(super.provider);

  @override
  String get district => (origin as WeatherForecastByDistrictProvider).district;
}

String _$locationServiceHash() => r'656c951c27c11890bb58727952ecb6cde8a2100e';

/// Location service provider
///
/// Copied from [locationService].
@ProviderFor(locationService)
final locationServiceProvider = Provider<LocationService>.internal(
  locationService,
  name: r'locationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationServiceRef = ProviderRef<LocationService>;
String _$pwaServiceHash() => r'4e104d9a2a721c8b8d2ae586e9dc557064828869';

/// PWA service singleton provider (web-only functionality)
///
/// Copied from [pwaService].
@ProviderFor(pwaService)
final pwaServiceProvider = Provider<PwaService>.internal(
  pwaService,
  name: r'pwaServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pwaServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PwaServiceRef = ProviderRef<PwaService>;
String _$isPwaInstalledHash() => r'5d60dcf739282b7e3c7c4f3c3fb4a7abf2a38f1b';

/// Whether app is running as installed PWA (web only)
///
/// Copied from [IsPwaInstalled].
@ProviderFor(IsPwaInstalled)
final isPwaInstalledProvider =
    AutoDisposeNotifierProvider<IsPwaInstalled, bool>.internal(
  IsPwaInstalled.new,
  name: r'isPwaInstalledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isPwaInstalledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _$IsPwaInstalled = AutoDisposeNotifier<bool>;
String _$pwaInstallAvailableHash() =>
    r'8e7d2f0f1baa3286c680ea9764ac71f06f0d8890';

/// Whether PWA install prompt is available (web only)
///
/// Copied from [PwaInstallAvailable].
@ProviderFor(PwaInstallAvailable)
final pwaInstallAvailableProvider =
    AutoDisposeNotifierProvider<PwaInstallAvailable, bool>.internal(
  PwaInstallAvailable.new,
  name: r'pwaInstallAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pwaInstallAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PwaInstallAvailable = AutoDisposeNotifier<bool>;
String _$pwaInstallDismissedHash() =>
    r'1ea04a3272f5c3e2d686fafbe31d385fc767c64d';

/// Whether install banner was dismissed by user (stored in memory)
///
/// Copied from [PwaInstallDismissed].
@ProviderFor(PwaInstallDismissed)
final pwaInstallDismissedProvider =
    AutoDisposeNotifierProvider<PwaInstallDismissed, bool>.internal(
  PwaInstallDismissed.new,
  name: r'pwaInstallDismissedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pwaInstallDismissedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PwaInstallDismissed = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
