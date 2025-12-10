// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appConfigRepositoryHash() =>
    r'f8163ac60b5641461b6902f7bd12c60c4824a574';

/// App config repository provider
///
/// Copied from [appConfigRepository].
@ProviderFor(appConfigRepository)
final appConfigRepositoryProvider = Provider<AppConfigRepository>.internal(
  appConfigRepository,
  name: r'appConfigRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appConfigRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppConfigRepositoryRef = ProviderRef<AppConfigRepository>;
String _$appConfigHash() => r'5d6a7f96a0422872373d0af3dd30d713172ee7d1';

/// App configuration stream
///
/// Copied from [appConfig].
@ProviderFor(appConfig)
final appConfigProvider = AutoDisposeStreamProvider<AppConfigModel>.internal(
  appConfig,
  name: r'appConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppConfigRef = AutoDisposeStreamProviderRef<AppConfigModel>;
String _$appConfigFutureHash() => r'09ace2fccffc087f5bbc480b60d6c1a7186fbc37';

/// App configuration (one-time fetch)
///
/// Copied from [appConfigFuture].
@ProviderFor(appConfigFuture)
final appConfigFutureProvider =
    AutoDisposeFutureProvider<AppConfigModel>.internal(
  appConfigFuture,
  name: r'appConfigFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appConfigFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppConfigFutureRef = AutoDisposeFutureProviderRef<AppConfigModel>;
String _$availableVarietiesHash() =>
    r'47e6e2cb4fc5236bce2e17b67f287db5ec4dad4a';

/// Available pineapple varieties
///
/// Copied from [availableVarieties].
@ProviderFor(availableVarieties)
final availableVarietiesProvider = AutoDisposeProvider<List<String>>.internal(
  availableVarieties,
  name: r'availableVarietiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableVarietiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableVarietiesRef = AutoDisposeProviderRef<List<String>>;
String _$availableDistrictsHash() =>
    r'f6d27a350571200e763243f991debaef22d3f53f';

/// Available districts
///
/// Copied from [availableDistricts].
@ProviderFor(availableDistricts)
final availableDistrictsProvider = AutoDisposeProvider<List<String>>.internal(
  availableDistricts,
  name: r'availableDistrictsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableDistrictsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableDistrictsRef = AutoDisposeProviderRef<List<String>>;
String _$availableCategoriesHash() =>
    r'2521dd0abd206c0265593679b8fef56765cf9a44';

/// Available product categories
///
/// Copied from [availableCategories].
@ProviderFor(availableCategories)
final availableCategoriesProvider = AutoDisposeProvider<List<String>>.internal(
  availableCategories,
  name: r'availableCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableCategoriesRef = AutoDisposeProviderRef<List<String>>;
String _$minAppVersionHash() => r'986179c6b75d3182816d5db5838021667a01d1f8';

/// Minimum required app version
///
/// Copied from [minAppVersion].
@ProviderFor(minAppVersion)
final minAppVersionProvider = AutoDisposeProvider<String>.internal(
  minAppVersion,
  name: r'minAppVersionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$minAppVersionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MinAppVersionRef = AutoDisposeProviderRef<String>;
String _$isVersionSupportedHash() =>
    r'7c121e1812093ec56a4289808be363b0ececfb9e';

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

/// Check if current version is supported
///
/// Copied from [isVersionSupported].
@ProviderFor(isVersionSupported)
const isVersionSupportedProvider = IsVersionSupportedFamily();

/// Check if current version is supported
///
/// Copied from [isVersionSupported].
class IsVersionSupportedFamily extends Family<bool> {
  /// Check if current version is supported
  ///
  /// Copied from [isVersionSupported].
  const IsVersionSupportedFamily();

  /// Check if current version is supported
  ///
  /// Copied from [isVersionSupported].
  IsVersionSupportedProvider call(
    String currentVersion,
  ) {
    return IsVersionSupportedProvider(
      currentVersion,
    );
  }

  @override
  IsVersionSupportedProvider getProviderOverride(
    covariant IsVersionSupportedProvider provider,
  ) {
    return call(
      provider.currentVersion,
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
  String? get name => r'isVersionSupportedProvider';
}

/// Check if current version is supported
///
/// Copied from [isVersionSupported].
class IsVersionSupportedProvider extends AutoDisposeProvider<bool> {
  /// Check if current version is supported
  ///
  /// Copied from [isVersionSupported].
  IsVersionSupportedProvider(
    String currentVersion,
  ) : this._internal(
          (ref) => isVersionSupported(
            ref as IsVersionSupportedRef,
            currentVersion,
          ),
          from: isVersionSupportedProvider,
          name: r'isVersionSupportedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isVersionSupportedHash,
          dependencies: IsVersionSupportedFamily._dependencies,
          allTransitiveDependencies:
              IsVersionSupportedFamily._allTransitiveDependencies,
          currentVersion: currentVersion,
        );

  IsVersionSupportedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentVersion,
  }) : super.internal();

  final String currentVersion;

  @override
  Override overrideWith(
    bool Function(IsVersionSupportedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsVersionSupportedProvider._internal(
        (ref) => create(ref as IsVersionSupportedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentVersion: currentVersion,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsVersionSupportedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsVersionSupportedProvider &&
        other.currentVersion == currentVersion;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentVersion.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsVersionSupportedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `currentVersion` of this provider.
  String get currentVersion;
}

class _IsVersionSupportedProviderElement
    extends AutoDisposeProviderElement<bool> with IsVersionSupportedRef {
  _IsVersionSupportedProviderElement(super.provider);

  @override
  String get currentVersion =>
      (origin as IsVersionSupportedProvider).currentVersion;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
