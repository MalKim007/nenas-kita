// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_request_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$buyerRequestRepositoryHash() =>
    r'e400c295a0c116935722f7e6dacf892349662674';

/// Buyer request repository provider
///
/// Copied from [buyerRequestRepository].
@ProviderFor(buyerRequestRepository)
final buyerRequestRepositoryProvider =
    Provider<BuyerRequestRepository>.internal(
  buyerRequestRepository,
  name: r'buyerRequestRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$buyerRequestRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BuyerRequestRepositoryRef = ProviderRef<BuyerRequestRepository>;
String _$buyerRequestByIdHash() => r'63451cb8840c89c017b067807c89de5e770e3889';

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

/// Get buyer request by ID
///
/// Copied from [buyerRequestById].
@ProviderFor(buyerRequestById)
const buyerRequestByIdProvider = BuyerRequestByIdFamily();

/// Get buyer request by ID
///
/// Copied from [buyerRequestById].
class BuyerRequestByIdFamily extends Family<AsyncValue<BuyerRequestModel?>> {
  /// Get buyer request by ID
  ///
  /// Copied from [buyerRequestById].
  const BuyerRequestByIdFamily();

  /// Get buyer request by ID
  ///
  /// Copied from [buyerRequestById].
  BuyerRequestByIdProvider call(
    String requestId,
  ) {
    return BuyerRequestByIdProvider(
      requestId,
    );
  }

  @override
  BuyerRequestByIdProvider getProviderOverride(
    covariant BuyerRequestByIdProvider provider,
  ) {
    return call(
      provider.requestId,
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
  String? get name => r'buyerRequestByIdProvider';
}

/// Get buyer request by ID
///
/// Copied from [buyerRequestById].
class BuyerRequestByIdProvider
    extends AutoDisposeStreamProvider<BuyerRequestModel?> {
  /// Get buyer request by ID
  ///
  /// Copied from [buyerRequestById].
  BuyerRequestByIdProvider(
    String requestId,
  ) : this._internal(
          (ref) => buyerRequestById(
            ref as BuyerRequestByIdRef,
            requestId,
          ),
          from: buyerRequestByIdProvider,
          name: r'buyerRequestByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$buyerRequestByIdHash,
          dependencies: BuyerRequestByIdFamily._dependencies,
          allTransitiveDependencies:
              BuyerRequestByIdFamily._allTransitiveDependencies,
          requestId: requestId,
        );

  BuyerRequestByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestId,
  }) : super.internal();

  final String requestId;

  @override
  Override overrideWith(
    Stream<BuyerRequestModel?> Function(BuyerRequestByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BuyerRequestByIdProvider._internal(
        (ref) => create(ref as BuyerRequestByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestId: requestId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<BuyerRequestModel?> createElement() {
    return _BuyerRequestByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BuyerRequestByIdProvider && other.requestId == requestId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BuyerRequestByIdRef on AutoDisposeStreamProviderRef<BuyerRequestModel?> {
  /// The parameter `requestId` of this provider.
  String get requestId;
}

class _BuyerRequestByIdProviderElement
    extends AutoDisposeStreamProviderElement<BuyerRequestModel?>
    with BuyerRequestByIdRef {
  _BuyerRequestByIdProviderElement(super.provider);

  @override
  String get requestId => (origin as BuyerRequestByIdProvider).requestId;
}

String _$myBuyerRequestsHash() => r'e3de534335e158e8328bd50d414bcee7cb6da8e6';

/// Current user's buyer requests
///
/// Copied from [myBuyerRequests].
@ProviderFor(myBuyerRequests)
final myBuyerRequestsProvider =
    AutoDisposeStreamProvider<List<BuyerRequestModel>>.internal(
  myBuyerRequests,
  name: r'myBuyerRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myBuyerRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyBuyerRequestsRef
    = AutoDisposeStreamProviderRef<List<BuyerRequestModel>>;
String _$openBuyerRequestsHash() => r'0722844e4d55fafac39a0993a05e032443bac121';

/// All open requests
///
/// Copied from [openBuyerRequests].
@ProviderFor(openBuyerRequests)
final openBuyerRequestsProvider =
    AutoDisposeStreamProvider<List<BuyerRequestModel>>.internal(
  openBuyerRequests,
  name: r'openBuyerRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$openBuyerRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OpenBuyerRequestsRef
    = AutoDisposeStreamProviderRef<List<BuyerRequestModel>>;
String _$openRequestsByDistrictHash() =>
    r'0b67cbb64b7589e79f5e27b0ddbe997ed76affaf';

/// Open requests by district
///
/// Copied from [openRequestsByDistrict].
@ProviderFor(openRequestsByDistrict)
const openRequestsByDistrictProvider = OpenRequestsByDistrictFamily();

/// Open requests by district
///
/// Copied from [openRequestsByDistrict].
class OpenRequestsByDistrictFamily
    extends Family<AsyncValue<List<BuyerRequestModel>>> {
  /// Open requests by district
  ///
  /// Copied from [openRequestsByDistrict].
  const OpenRequestsByDistrictFamily();

  /// Open requests by district
  ///
  /// Copied from [openRequestsByDistrict].
  OpenRequestsByDistrictProvider call(
    String district,
  ) {
    return OpenRequestsByDistrictProvider(
      district,
    );
  }

  @override
  OpenRequestsByDistrictProvider getProviderOverride(
    covariant OpenRequestsByDistrictProvider provider,
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
  String? get name => r'openRequestsByDistrictProvider';
}

/// Open requests by district
///
/// Copied from [openRequestsByDistrict].
class OpenRequestsByDistrictProvider
    extends AutoDisposeStreamProvider<List<BuyerRequestModel>> {
  /// Open requests by district
  ///
  /// Copied from [openRequestsByDistrict].
  OpenRequestsByDistrictProvider(
    String district,
  ) : this._internal(
          (ref) => openRequestsByDistrict(
            ref as OpenRequestsByDistrictRef,
            district,
          ),
          from: openRequestsByDistrictProvider,
          name: r'openRequestsByDistrictProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$openRequestsByDistrictHash,
          dependencies: OpenRequestsByDistrictFamily._dependencies,
          allTransitiveDependencies:
              OpenRequestsByDistrictFamily._allTransitiveDependencies,
          district: district,
        );

  OpenRequestsByDistrictProvider._internal(
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
    Stream<List<BuyerRequestModel>> Function(OpenRequestsByDistrictRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OpenRequestsByDistrictProvider._internal(
        (ref) => create(ref as OpenRequestsByDistrictRef),
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
  AutoDisposeStreamProviderElement<List<BuyerRequestModel>> createElement() {
    return _OpenRequestsByDistrictProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenRequestsByDistrictProvider &&
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
mixin OpenRequestsByDistrictRef
    on AutoDisposeStreamProviderRef<List<BuyerRequestModel>> {
  /// The parameter `district` of this provider.
  String get district;
}

class _OpenRequestsByDistrictProviderElement
    extends AutoDisposeStreamProviderElement<List<BuyerRequestModel>>
    with OpenRequestsByDistrictRef {
  _OpenRequestsByDistrictProviderElement(super.provider);

  @override
  String get district => (origin as OpenRequestsByDistrictProvider).district;
}

String _$urgentRequestsHash() => r'94c9314e1bac5797130638c6a8f9026789f01ffd';

/// Urgent requests (needed within 3 days)
///
/// Copied from [urgentRequests].
@ProviderFor(urgentRequests)
final urgentRequestsProvider =
    AutoDisposeFutureProvider<List<BuyerRequestModel>>.internal(
  urgentRequests,
  name: r'urgentRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$urgentRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UrgentRequestsRef
    = AutoDisposeFutureProviderRef<List<BuyerRequestModel>>;
String _$openRequestsByCategoryHash() =>
    r'b8683753bf7066f7e1fad9b162690efbde07152e';

/// Open requests by category
///
/// Copied from [openRequestsByCategory].
@ProviderFor(openRequestsByCategory)
const openRequestsByCategoryProvider = OpenRequestsByCategoryFamily();

/// Open requests by category
///
/// Copied from [openRequestsByCategory].
class OpenRequestsByCategoryFamily
    extends Family<AsyncValue<List<BuyerRequestModel>>> {
  /// Open requests by category
  ///
  /// Copied from [openRequestsByCategory].
  const OpenRequestsByCategoryFamily();

  /// Open requests by category
  ///
  /// Copied from [openRequestsByCategory].
  OpenRequestsByCategoryProvider call(
    ProductCategory category,
  ) {
    return OpenRequestsByCategoryProvider(
      category,
    );
  }

  @override
  OpenRequestsByCategoryProvider getProviderOverride(
    covariant OpenRequestsByCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'openRequestsByCategoryProvider';
}

/// Open requests by category
///
/// Copied from [openRequestsByCategory].
class OpenRequestsByCategoryProvider
    extends AutoDisposeFutureProvider<List<BuyerRequestModel>> {
  /// Open requests by category
  ///
  /// Copied from [openRequestsByCategory].
  OpenRequestsByCategoryProvider(
    ProductCategory category,
  ) : this._internal(
          (ref) => openRequestsByCategory(
            ref as OpenRequestsByCategoryRef,
            category,
          ),
          from: openRequestsByCategoryProvider,
          name: r'openRequestsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$openRequestsByCategoryHash,
          dependencies: OpenRequestsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              OpenRequestsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  OpenRequestsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final ProductCategory category;

  @override
  Override overrideWith(
    FutureOr<List<BuyerRequestModel>> Function(
            OpenRequestsByCategoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OpenRequestsByCategoryProvider._internal(
        (ref) => create(ref as OpenRequestsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BuyerRequestModel>> createElement() {
    return _OpenRequestsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenRequestsByCategoryProvider &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OpenRequestsByCategoryRef
    on AutoDisposeFutureProviderRef<List<BuyerRequestModel>> {
  /// The parameter `category` of this provider.
  ProductCategory get category;
}

class _OpenRequestsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<BuyerRequestModel>>
    with OpenRequestsByCategoryRef {
  _OpenRequestsByCategoryProviderElement(super.provider);

  @override
  ProductCategory get category =>
      (origin as OpenRequestsByCategoryProvider).category;
}

String _$allBuyerRequestsHash() => r'7965b2e0205605bf4f8e79826ce06449eeccce86';

/// All requests (for admin)
///
/// Copied from [allBuyerRequests].
@ProviderFor(allBuyerRequests)
final allBuyerRequestsProvider =
    AutoDisposeStreamProvider<List<BuyerRequestModel>>.internal(
  allBuyerRequests,
  name: r'allBuyerRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allBuyerRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllBuyerRequestsRef
    = AutoDisposeStreamProviderRef<List<BuyerRequestModel>>;
String _$openRequestsCountHash() => r'045545601607848a096a572fcd6185f12191fdc4';

/// Open requests count
///
/// Copied from [openRequestsCount].
@ProviderFor(openRequestsCount)
final openRequestsCountProvider = AutoDisposeFutureProvider<int>.internal(
  openRequestsCount,
  name: r'openRequestsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$openRequestsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OpenRequestsCountRef = AutoDisposeFutureProviderRef<int>;
String _$myRequestsCountHash() => r'4d9a670f44a55aa607b56451bf2690bc5f724354';

/// My requests count
///
/// Copied from [myRequestsCount].
@ProviderFor(myRequestsCount)
final myRequestsCountProvider = AutoDisposeFutureProvider<int>.internal(
  myRequestsCount,
  name: r'myRequestsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myRequestsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyRequestsCountRef = AutoDisposeFutureProviderRef<int>;
String _$fulfilledCountByFarmHash() =>
    r'c94c560e4074dd6ff59da6a5682804edd7d12068';

/// Fulfilled requests count by farm
///
/// Copied from [fulfilledCountByFarm].
@ProviderFor(fulfilledCountByFarm)
const fulfilledCountByFarmProvider = FulfilledCountByFarmFamily();

/// Fulfilled requests count by farm
///
/// Copied from [fulfilledCountByFarm].
class FulfilledCountByFarmFamily extends Family<AsyncValue<int>> {
  /// Fulfilled requests count by farm
  ///
  /// Copied from [fulfilledCountByFarm].
  const FulfilledCountByFarmFamily();

  /// Fulfilled requests count by farm
  ///
  /// Copied from [fulfilledCountByFarm].
  FulfilledCountByFarmProvider call(
    String farmId,
  ) {
    return FulfilledCountByFarmProvider(
      farmId,
    );
  }

  @override
  FulfilledCountByFarmProvider getProviderOverride(
    covariant FulfilledCountByFarmProvider provider,
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
  String? get name => r'fulfilledCountByFarmProvider';
}

/// Fulfilled requests count by farm
///
/// Copied from [fulfilledCountByFarm].
class FulfilledCountByFarmProvider extends AutoDisposeFutureProvider<int> {
  /// Fulfilled requests count by farm
  ///
  /// Copied from [fulfilledCountByFarm].
  FulfilledCountByFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => fulfilledCountByFarm(
            ref as FulfilledCountByFarmRef,
            farmId,
          ),
          from: fulfilledCountByFarmProvider,
          name: r'fulfilledCountByFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fulfilledCountByFarmHash,
          dependencies: FulfilledCountByFarmFamily._dependencies,
          allTransitiveDependencies:
              FulfilledCountByFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  FulfilledCountByFarmProvider._internal(
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
    FutureOr<int> Function(FulfilledCountByFarmRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FulfilledCountByFarmProvider._internal(
        (ref) => create(ref as FulfilledCountByFarmRef),
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
  AutoDisposeFutureProviderElement<int> createElement() {
    return _FulfilledCountByFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FulfilledCountByFarmProvider && other.farmId == farmId;
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
mixin FulfilledCountByFarmRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _FulfilledCountByFarmProviderElement
    extends AutoDisposeFutureProviderElement<int> with FulfilledCountByFarmRef {
  _FulfilledCountByFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as FulfilledCountByFarmProvider).farmId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
