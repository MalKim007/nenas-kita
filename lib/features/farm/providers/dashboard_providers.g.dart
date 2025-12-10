// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$latestHarvestPlanHash() => r'c182146fe61edcba87ca43b05cc79a4b74f60539';

/// Get the latest (most recent) harvest plan for current user
/// Returns null if user has no harvest plans
///
/// Copied from [latestHarvestPlan].
@ProviderFor(latestHarvestPlan)
final latestHarvestPlanProvider =
    AutoDisposeFutureProvider<HarvestPlanModel?>.internal(
  latestHarvestPlan,
  name: r'latestHarvestPlanProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestHarvestPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LatestHarvestPlanRef = AutoDisposeFutureProviderRef<HarvestPlanModel?>;
String _$myAverageProductPriceHash() =>
    r'93ed89469959827b34dfb65430c209b63e420119';

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

/// Calculate average price across all products for a specific farm
/// Returns 0.0 if farm has no products
///
/// Copied from [myAverageProductPrice].
@ProviderFor(myAverageProductPrice)
const myAverageProductPriceProvider = MyAverageProductPriceFamily();

/// Calculate average price across all products for a specific farm
/// Returns 0.0 if farm has no products
///
/// Copied from [myAverageProductPrice].
class MyAverageProductPriceFamily extends Family<AsyncValue<double>> {
  /// Calculate average price across all products for a specific farm
  /// Returns 0.0 if farm has no products
  ///
  /// Copied from [myAverageProductPrice].
  const MyAverageProductPriceFamily();

  /// Calculate average price across all products for a specific farm
  /// Returns 0.0 if farm has no products
  ///
  /// Copied from [myAverageProductPrice].
  MyAverageProductPriceProvider call(
    String farmId,
  ) {
    return MyAverageProductPriceProvider(
      farmId,
    );
  }

  @override
  MyAverageProductPriceProvider getProviderOverride(
    covariant MyAverageProductPriceProvider provider,
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
  String? get name => r'myAverageProductPriceProvider';
}

/// Calculate average price across all products for a specific farm
/// Returns 0.0 if farm has no products
///
/// Copied from [myAverageProductPrice].
class MyAverageProductPriceProvider extends AutoDisposeFutureProvider<double> {
  /// Calculate average price across all products for a specific farm
  /// Returns 0.0 if farm has no products
  ///
  /// Copied from [myAverageProductPrice].
  MyAverageProductPriceProvider(
    String farmId,
  ) : this._internal(
          (ref) => myAverageProductPrice(
            ref as MyAverageProductPriceRef,
            farmId,
          ),
          from: myAverageProductPriceProvider,
          name: r'myAverageProductPriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myAverageProductPriceHash,
          dependencies: MyAverageProductPriceFamily._dependencies,
          allTransitiveDependencies:
              MyAverageProductPriceFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  MyAverageProductPriceProvider._internal(
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
    FutureOr<double> Function(MyAverageProductPriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyAverageProductPriceProvider._internal(
        (ref) => create(ref as MyAverageProductPriceRef),
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
  AutoDisposeFutureProviderElement<double> createElement() {
    return _MyAverageProductPriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyAverageProductPriceProvider && other.farmId == farmId;
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
mixin MyAverageProductPriceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _MyAverageProductPriceProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with MyAverageProductPriceRef {
  _MyAverageProductPriceProviderElement(super.provider);

  @override
  String get farmId => (origin as MyAverageProductPriceProvider).farmId;
}

String _$marketAveragePriceHash() =>
    r'69c8d1af1331e43586b329b9e0fd7b667e28402b';

/// Get market average price for a specific variety
/// Returns null if no price data available for the variety
/// Uses 30-day window by default
///
/// Copied from [marketAveragePrice].
@ProviderFor(marketAveragePrice)
const marketAveragePriceProvider = MarketAveragePriceFamily();

/// Get market average price for a specific variety
/// Returns null if no price data available for the variety
/// Uses 30-day window by default
///
/// Copied from [marketAveragePrice].
class MarketAveragePriceFamily extends Family<AsyncValue<double?>> {
  /// Get market average price for a specific variety
  /// Returns null if no price data available for the variety
  /// Uses 30-day window by default
  ///
  /// Copied from [marketAveragePrice].
  const MarketAveragePriceFamily();

  /// Get market average price for a specific variety
  /// Returns null if no price data available for the variety
  /// Uses 30-day window by default
  ///
  /// Copied from [marketAveragePrice].
  MarketAveragePriceProvider call(
    String variety,
  ) {
    return MarketAveragePriceProvider(
      variety,
    );
  }

  @override
  MarketAveragePriceProvider getProviderOverride(
    covariant MarketAveragePriceProvider provider,
  ) {
    return call(
      provider.variety,
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
  String? get name => r'marketAveragePriceProvider';
}

/// Get market average price for a specific variety
/// Returns null if no price data available for the variety
/// Uses 30-day window by default
///
/// Copied from [marketAveragePrice].
class MarketAveragePriceProvider extends AutoDisposeFutureProvider<double?> {
  /// Get market average price for a specific variety
  /// Returns null if no price data available for the variety
  /// Uses 30-day window by default
  ///
  /// Copied from [marketAveragePrice].
  MarketAveragePriceProvider(
    String variety,
  ) : this._internal(
          (ref) => marketAveragePrice(
            ref as MarketAveragePriceRef,
            variety,
          ),
          from: marketAveragePriceProvider,
          name: r'marketAveragePriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$marketAveragePriceHash,
          dependencies: MarketAveragePriceFamily._dependencies,
          allTransitiveDependencies:
              MarketAveragePriceFamily._allTransitiveDependencies,
          variety: variety,
        );

  MarketAveragePriceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.variety,
  }) : super.internal();

  final String variety;

  @override
  Override overrideWith(
    FutureOr<double?> Function(MarketAveragePriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarketAveragePriceProvider._internal(
        (ref) => create(ref as MarketAveragePriceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        variety: variety,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _MarketAveragePriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketAveragePriceProvider && other.variety == variety;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, variety.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarketAveragePriceRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `variety` of this provider.
  String get variety;
}

class _MarketAveragePriceProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with MarketAveragePriceRef {
  _MarketAveragePriceProviderElement(super.provider);

  @override
  String get variety => (origin as MarketAveragePriceProvider).variety;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
