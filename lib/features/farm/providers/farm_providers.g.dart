// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$farmRepositoryHash() => r'8785defd257a73447be0c8c3ba927cdf5469f8ca';

/// Farm repository provider
///
/// Copied from [farmRepository].
@ProviderFor(farmRepository)
final farmRepositoryProvider = Provider<FarmRepository>.internal(
  farmRepository,
  name: r'farmRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$farmRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FarmRepositoryRef = ProviderRef<FarmRepository>;
String _$farmByIdHash() => r'fc3d2257451fadff0a592ed62422f1f0b82bad37';

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

/// Get farm by ID
///
/// Copied from [farmById].
@ProviderFor(farmById)
const farmByIdProvider = FarmByIdFamily();

/// Get farm by ID
///
/// Copied from [farmById].
class FarmByIdFamily extends Family<AsyncValue<FarmModel?>> {
  /// Get farm by ID
  ///
  /// Copied from [farmById].
  const FarmByIdFamily();

  /// Get farm by ID
  ///
  /// Copied from [farmById].
  FarmByIdProvider call(
    String farmId,
  ) {
    return FarmByIdProvider(
      farmId,
    );
  }

  @override
  FarmByIdProvider getProviderOverride(
    covariant FarmByIdProvider provider,
  ) {
    return call(
      provider.farmId,
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
  String? get name => r'farmByIdProvider';
}

/// Get farm by ID
///
/// Copied from [farmById].
class FarmByIdProvider extends AutoDisposeStreamProvider<FarmModel?> {
  /// Get farm by ID
  ///
  /// Copied from [farmById].
  FarmByIdProvider(
    String farmId,
  ) : this._internal(
          (ref) => farmById(
            ref as FarmByIdRef,
            farmId,
          ),
          from: farmByIdProvider,
          name: r'farmByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$farmByIdHash,
          dependencies: FarmByIdFamily._dependencies,
          allTransitiveDependencies: FarmByIdFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  FarmByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
  }) : super.internal();

  final String farmId;

  @override
  Override overrideWith(
    Stream<FarmModel?> Function(FarmByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmByIdProvider._internal(
        (ref) => create(ref as FarmByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<FarmModel?> createElement() {
    return _FarmByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmByIdProvider && other.farmId == farmId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FarmByIdRef on AutoDisposeStreamProviderRef<FarmModel?> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _FarmByIdProviderElement
    extends AutoDisposeStreamProviderElement<FarmModel?> with FarmByIdRef {
  _FarmByIdProviderElement(super.provider);

  @override
  String get farmId => (origin as FarmByIdProvider).farmId;
}

String _$myFarmsHash() => r'7a27bb6eae59a77b68c4da38dbb2e4bb2dd76251';

/// Current user's farms
///
/// Copied from [myFarms].
@ProviderFor(myFarms)
final myFarmsProvider = AutoDisposeStreamProvider<List<FarmModel>>.internal(
  myFarms,
  name: r'myFarmsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myFarmsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyFarmsRef = AutoDisposeStreamProviderRef<List<FarmModel>>;
String _$myPrimaryFarmHash() => r'2f0e01f9ad43c3b39605fffa7b6de732e9932f81';

/// Current user's first farm (for single-farm users)
///
/// Copied from [myPrimaryFarm].
@ProviderFor(myPrimaryFarm)
final myPrimaryFarmProvider = AutoDisposeStreamProvider<FarmModel?>.internal(
  myPrimaryFarm,
  name: r'myPrimaryFarmProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myPrimaryFarmHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyPrimaryFarmRef = AutoDisposeStreamProviderRef<FarmModel?>;
String _$allFarmsHash() => r'86ecffc92bd939a82cee8297f3f9490caa1cbcc8';

/// All active farms
///
/// Copied from [allFarms].
@ProviderFor(allFarms)
final allFarmsProvider = AutoDisposeStreamProvider<List<FarmModel>>.internal(
  allFarms,
  name: r'allFarmsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allFarmsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllFarmsRef = AutoDisposeStreamProviderRef<List<FarmModel>>;
String _$farmsByDistrictHash() => r'05b7864ec1115171bb02c51eb7d1d2e3d1cb1b0b';

/// Farms by district
///
/// Copied from [farmsByDistrict].
@ProviderFor(farmsByDistrict)
const farmsByDistrictProvider = FarmsByDistrictFamily();

/// Farms by district
///
/// Copied from [farmsByDistrict].
class FarmsByDistrictFamily extends Family<AsyncValue<List<FarmModel>>> {
  /// Farms by district
  ///
  /// Copied from [farmsByDistrict].
  const FarmsByDistrictFamily();

  /// Farms by district
  ///
  /// Copied from [farmsByDistrict].
  FarmsByDistrictProvider call(
    String district,
  ) {
    return FarmsByDistrictProvider(
      district,
    );
  }

  @override
  FarmsByDistrictProvider getProviderOverride(
    covariant FarmsByDistrictProvider provider,
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
  String? get name => r'farmsByDistrictProvider';
}

/// Farms by district
///
/// Copied from [farmsByDistrict].
class FarmsByDistrictProvider
    extends AutoDisposeStreamProvider<List<FarmModel>> {
  /// Farms by district
  ///
  /// Copied from [farmsByDistrict].
  FarmsByDistrictProvider(
    String district,
  ) : this._internal(
          (ref) => farmsByDistrict(
            ref as FarmsByDistrictRef,
            district,
          ),
          from: farmsByDistrictProvider,
          name: r'farmsByDistrictProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$farmsByDistrictHash,
          dependencies: FarmsByDistrictFamily._dependencies,
          allTransitiveDependencies:
              FarmsByDistrictFamily._allTransitiveDependencies,
          district: district,
        );

  FarmsByDistrictProvider._internal(
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
    Stream<List<FarmModel>> Function(FarmsByDistrictRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmsByDistrictProvider._internal(
        (ref) => create(ref as FarmsByDistrictRef),
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
  AutoDisposeStreamProviderElement<List<FarmModel>> createElement() {
    return _FarmsByDistrictProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmsByDistrictProvider && other.district == district;
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
mixin FarmsByDistrictRef on AutoDisposeStreamProviderRef<List<FarmModel>> {
  /// The parameter `district` of this provider.
  String get district;
}

class _FarmsByDistrictProviderElement
    extends AutoDisposeStreamProviderElement<List<FarmModel>>
    with FarmsByDistrictRef {
  _FarmsByDistrictProviderElement(super.provider);

  @override
  String get district => (origin as FarmsByDistrictProvider).district;
}

String _$farmsByOwnerHash() => r'da792dddfd55937e1ba33f83e1da12fbf7742790';

/// Farms by owner
///
/// Copied from [farmsByOwner].
@ProviderFor(farmsByOwner)
const farmsByOwnerProvider = FarmsByOwnerFamily();

/// Farms by owner
///
/// Copied from [farmsByOwner].
class FarmsByOwnerFamily extends Family<AsyncValue<List<FarmModel>>> {
  /// Farms by owner
  ///
  /// Copied from [farmsByOwner].
  const FarmsByOwnerFamily();

  /// Farms by owner
  ///
  /// Copied from [farmsByOwner].
  FarmsByOwnerProvider call(
    String ownerId,
  ) {
    return FarmsByOwnerProvider(
      ownerId,
    );
  }

  @override
  FarmsByOwnerProvider getProviderOverride(
    covariant FarmsByOwnerProvider provider,
  ) {
    return call(
      provider.ownerId,
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
  String? get name => r'farmsByOwnerProvider';
}

/// Farms by owner
///
/// Copied from [farmsByOwner].
class FarmsByOwnerProvider extends AutoDisposeStreamProvider<List<FarmModel>> {
  /// Farms by owner
  ///
  /// Copied from [farmsByOwner].
  FarmsByOwnerProvider(
    String ownerId,
  ) : this._internal(
          (ref) => farmsByOwner(
            ref as FarmsByOwnerRef,
            ownerId,
          ),
          from: farmsByOwnerProvider,
          name: r'farmsByOwnerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$farmsByOwnerHash,
          dependencies: FarmsByOwnerFamily._dependencies,
          allTransitiveDependencies:
              FarmsByOwnerFamily._allTransitiveDependencies,
          ownerId: ownerId,
        );

  FarmsByOwnerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ownerId,
  }) : super.internal();

  final String ownerId;

  @override
  Override overrideWith(
    Stream<List<FarmModel>> Function(FarmsByOwnerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmsByOwnerProvider._internal(
        (ref) => create(ref as FarmsByOwnerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ownerId: ownerId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<FarmModel>> createElement() {
    return _FarmsByOwnerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmsByOwnerProvider && other.ownerId == ownerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ownerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FarmsByOwnerRef on AutoDisposeStreamProviderRef<List<FarmModel>> {
  /// The parameter `ownerId` of this provider.
  String get ownerId;
}

class _FarmsByOwnerProviderElement
    extends AutoDisposeStreamProviderElement<List<FarmModel>>
    with FarmsByOwnerRef {
  _FarmsByOwnerProviderElement(super.provider);

  @override
  String get ownerId => (origin as FarmsByOwnerProvider).ownerId;
}

String _$verifiedFarmsHash() => r'b859275a47c6a48b5c1bd37f090307beeba92210';

/// Verified farms only
///
/// Copied from [verifiedFarms].
@ProviderFor(verifiedFarms)
final verifiedFarmsProvider =
    AutoDisposeStreamProvider<List<FarmModel>>.internal(
  verifiedFarms,
  name: r'verifiedFarmsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verifiedFarmsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VerifiedFarmsRef = AutoDisposeStreamProviderRef<List<FarmModel>>;
String _$unverifiedFarmsHash() => r'd681dc50d0422150e9372c9a0bfd9a574b9c40a4';

/// Unverified farms (pending verification - for admin)
///
/// Copied from [unverifiedFarms].
@ProviderFor(unverifiedFarms)
final unverifiedFarmsProvider =
    AutoDisposeStreamProvider<List<FarmModel>>.internal(
  unverifiedFarms,
  name: r'unverifiedFarmsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unverifiedFarmsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnverifiedFarmsRef = AutoDisposeStreamProviderRef<List<FarmModel>>;
String _$searchFarmsHash() => r'476beceabed6c0526ed22cfe3d18bf4282f37a24';

/// Search farms by name
///
/// Copied from [searchFarms].
@ProviderFor(searchFarms)
const searchFarmsProvider = SearchFarmsFamily();

/// Search farms by name
///
/// Copied from [searchFarms].
class SearchFarmsFamily extends Family<AsyncValue<List<FarmModel>>> {
  /// Search farms by name
  ///
  /// Copied from [searchFarms].
  const SearchFarmsFamily();

  /// Search farms by name
  ///
  /// Copied from [searchFarms].
  SearchFarmsProvider call(
    String query,
  ) {
    return SearchFarmsProvider(
      query,
    );
  }

  @override
  SearchFarmsProvider getProviderOverride(
    covariant SearchFarmsProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchFarmsProvider';
}

/// Search farms by name
///
/// Copied from [searchFarms].
class SearchFarmsProvider extends AutoDisposeFutureProvider<List<FarmModel>> {
  /// Search farms by name
  ///
  /// Copied from [searchFarms].
  SearchFarmsProvider(
    String query,
  ) : this._internal(
          (ref) => searchFarms(
            ref as SearchFarmsRef,
            query,
          ),
          from: searchFarmsProvider,
          name: r'searchFarmsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchFarmsHash,
          dependencies: SearchFarmsFamily._dependencies,
          allTransitiveDependencies:
              SearchFarmsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchFarmsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<FarmModel>> Function(SearchFarmsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchFarmsProvider._internal(
        (ref) => create(ref as SearchFarmsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<FarmModel>> createElement() {
    return _SearchFarmsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchFarmsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchFarmsRef on AutoDisposeFutureProviderRef<List<FarmModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchFarmsProviderElement
    extends AutoDisposeFutureProviderElement<List<FarmModel>>
    with SearchFarmsRef {
  _SearchFarmsProviderElement(super.provider);

  @override
  String get query => (origin as SearchFarmsProvider).query;
}

String _$totalFarmsCountHash() => r'9d3f816941e873ddb57eb2a4ab50edcad8327bae';

/// Total farms count
///
/// Copied from [totalFarmsCount].
@ProviderFor(totalFarmsCount)
final totalFarmsCountProvider = AutoDisposeFutureProvider<int>.internal(
  totalFarmsCount,
  name: r'totalFarmsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalFarmsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalFarmsCountRef = AutoDisposeFutureProviderRef<int>;
String _$verifiedFarmsCountHash() =>
    r'f39af546811aba53637091d329cd223aada93b83';

/// Verified farms count
///
/// Copied from [verifiedFarmsCount].
@ProviderFor(verifiedFarmsCount)
final verifiedFarmsCountProvider = AutoDisposeFutureProvider<int>.internal(
  verifiedFarmsCount,
  name: r'verifiedFarmsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verifiedFarmsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VerifiedFarmsCountRef = AutoDisposeFutureProviderRef<int>;
String _$farmsCountByDistrictHash() =>
    r'a983f22761e868fb3e46c6b91252ec03e674e820';

/// Farms count by district
///
/// Copied from [farmsCountByDistrict].
@ProviderFor(farmsCountByDistrict)
const farmsCountByDistrictProvider = FarmsCountByDistrictFamily();

/// Farms count by district
///
/// Copied from [farmsCountByDistrict].
class FarmsCountByDistrictFamily extends Family<AsyncValue<int>> {
  /// Farms count by district
  ///
  /// Copied from [farmsCountByDistrict].
  const FarmsCountByDistrictFamily();

  /// Farms count by district
  ///
  /// Copied from [farmsCountByDistrict].
  FarmsCountByDistrictProvider call(
    String district,
  ) {
    return FarmsCountByDistrictProvider(
      district,
    );
  }

  @override
  FarmsCountByDistrictProvider getProviderOverride(
    covariant FarmsCountByDistrictProvider provider,
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
  String? get name => r'farmsCountByDistrictProvider';
}

/// Farms count by district
///
/// Copied from [farmsCountByDistrict].
class FarmsCountByDistrictProvider extends AutoDisposeFutureProvider<int> {
  /// Farms count by district
  ///
  /// Copied from [farmsCountByDistrict].
  FarmsCountByDistrictProvider(
    String district,
  ) : this._internal(
          (ref) => farmsCountByDistrict(
            ref as FarmsCountByDistrictRef,
            district,
          ),
          from: farmsCountByDistrictProvider,
          name: r'farmsCountByDistrictProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$farmsCountByDistrictHash,
          dependencies: FarmsCountByDistrictFamily._dependencies,
          allTransitiveDependencies:
              FarmsCountByDistrictFamily._allTransitiveDependencies,
          district: district,
        );

  FarmsCountByDistrictProvider._internal(
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
    FutureOr<int> Function(FarmsCountByDistrictRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmsCountByDistrictProvider._internal(
        (ref) => create(ref as FarmsCountByDistrictRef),
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
  AutoDisposeFutureProviderElement<int> createElement() {
    return _FarmsCountByDistrictProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmsCountByDistrictProvider && other.district == district;
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
mixin FarmsCountByDistrictRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `district` of this provider.
  String get district;
}

class _FarmsCountByDistrictProviderElement
    extends AutoDisposeFutureProviderElement<int> with FarmsCountByDistrictRef {
  _FarmsCountByDistrictProviderElement(super.provider);

  @override
  String get district => (origin as FarmsCountByDistrictProvider).district;
}

String _$isActualFarmerHash() => r'2476d289d42c2f6fa846c3819d7469b5c129ee4f';

/// Check if current user is an actual farmer (has farm with land, not just a seller)
/// Returns false if: no farm exists, farm has no size, or size is 0
/// Used to determine access to Harvest Planner feature
///
/// Copied from [isActualFarmer].
@ProviderFor(isActualFarmer)
final isActualFarmerProvider = AutoDisposeProvider<bool>.internal(
  isActualFarmer,
  name: r'isActualFarmerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isActualFarmerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsActualFarmerRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
