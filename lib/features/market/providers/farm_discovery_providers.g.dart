// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_discovery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cachedUserLocationHash() =>
    r'f2a4bdc97cd86743ca67cd957f195822f98b7c0d';

/// See also [cachedUserLocation].
@ProviderFor(cachedUserLocation)
final cachedUserLocationProvider =
    AutoDisposeFutureProvider<Position?>.internal(
  cachedUserLocation,
  name: r'cachedUserLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cachedUserLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedUserLocationRef = AutoDisposeFutureProviderRef<Position?>;
String _$filteredFarmsHash() => r'802f78dcb79a88b85493ecc504b214aad4a6ba14';

/// See also [filteredFarms].
@ProviderFor(filteredFarms)
final filteredFarmsProvider =
    AutoDisposeFutureProvider<List<FarmWithDistance>>.internal(
  filteredFarms,
  name: r'filteredFarmsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredFarmsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredFarmsRef = AutoDisposeFutureProviderRef<List<FarmWithDistance>>;
String _$nearbyFarmsHash() => r'73eeaa0c32cc42b7b90af1de0cbc5b60c4a25708';

/// Get nearby farms (max 2)
/// If user has location: sort by distance and take 2 nearest
/// If no location: pick 2 random active farms
///
/// Copied from [nearbyFarms].
@ProviderFor(nearbyFarms)
final nearbyFarmsProvider =
    AutoDisposeFutureProvider<List<FarmWithDistance>>.internal(
  nearbyFarms,
  name: r'nearbyFarmsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$nearbyFarmsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NearbyFarmsRef = AutoDisposeFutureProviderRef<List<FarmWithDistance>>;
String _$farmDiscoveryNotifierHash() =>
    r'dc2f89fb2127179dfd771a30293a4dac46343789';

/// See also [FarmDiscoveryNotifier].
@ProviderFor(FarmDiscoveryNotifier)
final farmDiscoveryNotifierProvider = AutoDisposeNotifierProvider<
    FarmDiscoveryNotifier, FarmDiscoveryState>.internal(
  FarmDiscoveryNotifier.new,
  name: r'farmDiscoveryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$farmDiscoveryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FarmDiscoveryNotifier = AutoDisposeNotifier<FarmDiscoveryState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
