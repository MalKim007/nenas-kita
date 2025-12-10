// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$priceHistoryRepositoryHash() =>
    r'1282aea78970957b4142d5c2432ba36bf161c361';

/// Price history repository provider
///
/// Copied from [priceHistoryRepository].
@ProviderFor(priceHistoryRepository)
final priceHistoryRepositoryProvider =
    Provider<PriceHistoryRepository>.internal(
  priceHistoryRepository,
  name: r'priceHistoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$priceHistoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PriceHistoryRepositoryRef = ProviderRef<PriceHistoryRepository>;
String _$recentPriceHistoryHash() =>
    r'd3d279563b02eb87e43075ac9e255491bc72cd34';

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

/// Recent price history (all products)
///
/// Copied from [recentPriceHistory].
@ProviderFor(recentPriceHistory)
const recentPriceHistoryProvider = RecentPriceHistoryFamily();

/// Recent price history (all products)
///
/// Copied from [recentPriceHistory].
class RecentPriceHistoryFamily
    extends Family<AsyncValue<List<PriceHistoryModel>>> {
  /// Recent price history (all products)
  ///
  /// Copied from [recentPriceHistory].
  const RecentPriceHistoryFamily();

  /// Recent price history (all products)
  ///
  /// Copied from [recentPriceHistory].
  RecentPriceHistoryProvider call({
    int limit = 50,
  }) {
    return RecentPriceHistoryProvider(
      limit: limit,
    );
  }

  @override
  RecentPriceHistoryProvider getProviderOverride(
    covariant RecentPriceHistoryProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'recentPriceHistoryProvider';
}

/// Recent price history (all products)
///
/// Copied from [recentPriceHistory].
class RecentPriceHistoryProvider
    extends AutoDisposeStreamProvider<List<PriceHistoryModel>> {
  /// Recent price history (all products)
  ///
  /// Copied from [recentPriceHistory].
  RecentPriceHistoryProvider({
    int limit = 50,
  }) : this._internal(
          (ref) => recentPriceHistory(
            ref as RecentPriceHistoryRef,
            limit: limit,
          ),
          from: recentPriceHistoryProvider,
          name: r'recentPriceHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentPriceHistoryHash,
          dependencies: RecentPriceHistoryFamily._dependencies,
          allTransitiveDependencies:
              RecentPriceHistoryFamily._allTransitiveDependencies,
          limit: limit,
        );

  RecentPriceHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    Stream<List<PriceHistoryModel>> Function(RecentPriceHistoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentPriceHistoryProvider._internal(
        (ref) => create(ref as RecentPriceHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PriceHistoryModel>> createElement() {
    return _RecentPriceHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentPriceHistoryProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentPriceHistoryRef
    on AutoDisposeStreamProviderRef<List<PriceHistoryModel>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _RecentPriceHistoryProviderElement
    extends AutoDisposeStreamProviderElement<List<PriceHistoryModel>>
    with RecentPriceHistoryRef {
  _RecentPriceHistoryProviderElement(super.provider);

  @override
  int get limit => (origin as RecentPriceHistoryProvider).limit;
}

String _$priceHistoryByProductHash() =>
    r'd11cbc6aa1f1e62e4b625ca59111c5abdd9a4838';

/// Price history for a specific product
///
/// Copied from [priceHistoryByProduct].
@ProviderFor(priceHistoryByProduct)
const priceHistoryByProductProvider = PriceHistoryByProductFamily();

/// Price history for a specific product
///
/// Copied from [priceHistoryByProduct].
class PriceHistoryByProductFamily
    extends Family<AsyncValue<List<PriceHistoryModel>>> {
  /// Price history for a specific product
  ///
  /// Copied from [priceHistoryByProduct].
  const PriceHistoryByProductFamily();

  /// Price history for a specific product
  ///
  /// Copied from [priceHistoryByProduct].
  PriceHistoryByProductProvider call(
    String farmId,
    String productId, {
    int limit = 50,
  }) {
    return PriceHistoryByProductProvider(
      farmId,
      productId,
      limit: limit,
    );
  }

  @override
  PriceHistoryByProductProvider getProviderOverride(
    covariant PriceHistoryByProductProvider provider,
  ) {
    return call(
      provider.farmId,
      provider.productId,
      limit: provider.limit,
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
  String? get name => r'priceHistoryByProductProvider';
}

/// Price history for a specific product
///
/// Copied from [priceHistoryByProduct].
class PriceHistoryByProductProvider
    extends AutoDisposeStreamProvider<List<PriceHistoryModel>> {
  /// Price history for a specific product
  ///
  /// Copied from [priceHistoryByProduct].
  PriceHistoryByProductProvider(
    String farmId,
    String productId, {
    int limit = 50,
  }) : this._internal(
          (ref) => priceHistoryByProduct(
            ref as PriceHistoryByProductRef,
            farmId,
            productId,
            limit: limit,
          ),
          from: priceHistoryByProductProvider,
          name: r'priceHistoryByProductProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceHistoryByProductHash,
          dependencies: PriceHistoryByProductFamily._dependencies,
          allTransitiveDependencies:
              PriceHistoryByProductFamily._allTransitiveDependencies,
          farmId: farmId,
          productId: productId,
          limit: limit,
        );

  PriceHistoryByProductProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
    required this.productId,
    required this.limit,
  }) : super.internal();

  final String farmId;
  final String productId;
  final int limit;

  @override
  Override overrideWith(
    Stream<List<PriceHistoryModel>> Function(PriceHistoryByProductRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceHistoryByProductProvider._internal(
        (ref) => create(ref as PriceHistoryByProductRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
        productId: productId,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PriceHistoryModel>> createElement() {
    return _PriceHistoryByProductProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceHistoryByProductProvider &&
        other.farmId == farmId &&
        other.productId == productId &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PriceHistoryByProductRef
    on AutoDisposeStreamProviderRef<List<PriceHistoryModel>> {
  /// The parameter `farmId` of this provider.
  String get farmId;

  /// The parameter `productId` of this provider.
  String get productId;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _PriceHistoryByProductProviderElement
    extends AutoDisposeStreamProviderElement<List<PriceHistoryModel>>
    with PriceHistoryByProductRef {
  _PriceHistoryByProductProviderElement(super.provider);

  @override
  String get farmId => (origin as PriceHistoryByProductProvider).farmId;
  @override
  String get productId => (origin as PriceHistoryByProductProvider).productId;
  @override
  int get limit => (origin as PriceHistoryByProductProvider).limit;
}

String _$priceHistoryByVarietyHash() =>
    r'42e1b69c1ddcbe36d1155a2af61a43bd05562145';

/// Price history by variety
///
/// Copied from [priceHistoryByVariety].
@ProviderFor(priceHistoryByVariety)
const priceHistoryByVarietyProvider = PriceHistoryByVarietyFamily();

/// Price history by variety
///
/// Copied from [priceHistoryByVariety].
class PriceHistoryByVarietyFamily
    extends Family<AsyncValue<List<PriceHistoryModel>>> {
  /// Price history by variety
  ///
  /// Copied from [priceHistoryByVariety].
  const PriceHistoryByVarietyFamily();

  /// Price history by variety
  ///
  /// Copied from [priceHistoryByVariety].
  PriceHistoryByVarietyProvider call(
    String variety, {
    int limit = 100,
  }) {
    return PriceHistoryByVarietyProvider(
      variety,
      limit: limit,
    );
  }

  @override
  PriceHistoryByVarietyProvider getProviderOverride(
    covariant PriceHistoryByVarietyProvider provider,
  ) {
    return call(
      provider.variety,
      limit: provider.limit,
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
  String? get name => r'priceHistoryByVarietyProvider';
}

/// Price history by variety
///
/// Copied from [priceHistoryByVariety].
class PriceHistoryByVarietyProvider
    extends AutoDisposeStreamProvider<List<PriceHistoryModel>> {
  /// Price history by variety
  ///
  /// Copied from [priceHistoryByVariety].
  PriceHistoryByVarietyProvider(
    String variety, {
    int limit = 100,
  }) : this._internal(
          (ref) => priceHistoryByVariety(
            ref as PriceHistoryByVarietyRef,
            variety,
            limit: limit,
          ),
          from: priceHistoryByVarietyProvider,
          name: r'priceHistoryByVarietyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceHistoryByVarietyHash,
          dependencies: PriceHistoryByVarietyFamily._dependencies,
          allTransitiveDependencies:
              PriceHistoryByVarietyFamily._allTransitiveDependencies,
          variety: variety,
          limit: limit,
        );

  PriceHistoryByVarietyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.variety,
    required this.limit,
  }) : super.internal();

  final String variety;
  final int limit;

  @override
  Override overrideWith(
    Stream<List<PriceHistoryModel>> Function(PriceHistoryByVarietyRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceHistoryByVarietyProvider._internal(
        (ref) => create(ref as PriceHistoryByVarietyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        variety: variety,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PriceHistoryModel>> createElement() {
    return _PriceHistoryByVarietyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceHistoryByVarietyProvider &&
        other.variety == variety &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, variety.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PriceHistoryByVarietyRef
    on AutoDisposeStreamProviderRef<List<PriceHistoryModel>> {
  /// The parameter `variety` of this provider.
  String get variety;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _PriceHistoryByVarietyProviderElement
    extends AutoDisposeStreamProviderElement<List<PriceHistoryModel>>
    with PriceHistoryByVarietyRef {
  _PriceHistoryByVarietyProviderElement(super.provider);

  @override
  String get variety => (origin as PriceHistoryByVarietyProvider).variety;
  @override
  int get limit => (origin as PriceHistoryByVarietyProvider).limit;
}

String _$averagePriceByVarietyHash() =>
    r'7c471cb3eeb72d25d603c3a7cc5ca2aefb189080';

/// Average price for a variety
///
/// Copied from [averagePriceByVariety].
@ProviderFor(averagePriceByVariety)
const averagePriceByVarietyProvider = AveragePriceByVarietyFamily();

/// Average price for a variety
///
/// Copied from [averagePriceByVariety].
class AveragePriceByVarietyFamily extends Family<AsyncValue<double?>> {
  /// Average price for a variety
  ///
  /// Copied from [averagePriceByVariety].
  const AveragePriceByVarietyFamily();

  /// Average price for a variety
  ///
  /// Copied from [averagePriceByVariety].
  AveragePriceByVarietyProvider call(
    String variety, {
    int days = 30,
  }) {
    return AveragePriceByVarietyProvider(
      variety,
      days: days,
    );
  }

  @override
  AveragePriceByVarietyProvider getProviderOverride(
    covariant AveragePriceByVarietyProvider provider,
  ) {
    return call(
      provider.variety,
      days: provider.days,
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
  String? get name => r'averagePriceByVarietyProvider';
}

/// Average price for a variety
///
/// Copied from [averagePriceByVariety].
class AveragePriceByVarietyProvider extends AutoDisposeFutureProvider<double?> {
  /// Average price for a variety
  ///
  /// Copied from [averagePriceByVariety].
  AveragePriceByVarietyProvider(
    String variety, {
    int days = 30,
  }) : this._internal(
          (ref) => averagePriceByVariety(
            ref as AveragePriceByVarietyRef,
            variety,
            days: days,
          ),
          from: averagePriceByVarietyProvider,
          name: r'averagePriceByVarietyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$averagePriceByVarietyHash,
          dependencies: AveragePriceByVarietyFamily._dependencies,
          allTransitiveDependencies:
              AveragePriceByVarietyFamily._allTransitiveDependencies,
          variety: variety,
          days: days,
        );

  AveragePriceByVarietyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.variety,
    required this.days,
  }) : super.internal();

  final String variety;
  final int days;

  @override
  Override overrideWith(
    FutureOr<double?> Function(AveragePriceByVarietyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AveragePriceByVarietyProvider._internal(
        (ref) => create(ref as AveragePriceByVarietyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        variety: variety,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _AveragePriceByVarietyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AveragePriceByVarietyProvider &&
        other.variety == variety &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, variety.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AveragePriceByVarietyRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `variety` of this provider.
  String get variety;

  /// The parameter `days` of this provider.
  int get days;
}

class _AveragePriceByVarietyProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with AveragePriceByVarietyRef {
  _AveragePriceByVarietyProviderElement(super.provider);

  @override
  String get variety => (origin as AveragePriceByVarietyProvider).variety;
  @override
  int get days => (origin as AveragePriceByVarietyProvider).days;
}

String _$priceRangeByVarietyHash() =>
    r'f6d999f871f37bedcddaefe2c95ae2ebe3f6ed3a';

/// Price range (min/max/avg) for a variety
///
/// Copied from [priceRangeByVariety].
@ProviderFor(priceRangeByVariety)
const priceRangeByVarietyProvider = PriceRangeByVarietyFamily();

/// Price range (min/max/avg) for a variety
///
/// Copied from [priceRangeByVariety].
class PriceRangeByVarietyFamily
    extends Family<AsyncValue<Map<String, double>?>> {
  /// Price range (min/max/avg) for a variety
  ///
  /// Copied from [priceRangeByVariety].
  const PriceRangeByVarietyFamily();

  /// Price range (min/max/avg) for a variety
  ///
  /// Copied from [priceRangeByVariety].
  PriceRangeByVarietyProvider call(
    String variety, {
    int days = 30,
  }) {
    return PriceRangeByVarietyProvider(
      variety,
      days: days,
    );
  }

  @override
  PriceRangeByVarietyProvider getProviderOverride(
    covariant PriceRangeByVarietyProvider provider,
  ) {
    return call(
      provider.variety,
      days: provider.days,
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
  String? get name => r'priceRangeByVarietyProvider';
}

/// Price range (min/max/avg) for a variety
///
/// Copied from [priceRangeByVariety].
class PriceRangeByVarietyProvider
    extends AutoDisposeFutureProvider<Map<String, double>?> {
  /// Price range (min/max/avg) for a variety
  ///
  /// Copied from [priceRangeByVariety].
  PriceRangeByVarietyProvider(
    String variety, {
    int days = 30,
  }) : this._internal(
          (ref) => priceRangeByVariety(
            ref as PriceRangeByVarietyRef,
            variety,
            days: days,
          ),
          from: priceRangeByVarietyProvider,
          name: r'priceRangeByVarietyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceRangeByVarietyHash,
          dependencies: PriceRangeByVarietyFamily._dependencies,
          allTransitiveDependencies:
              PriceRangeByVarietyFamily._allTransitiveDependencies,
          variety: variety,
          days: days,
        );

  PriceRangeByVarietyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.variety,
    required this.days,
  }) : super.internal();

  final String variety;
  final int days;

  @override
  Override overrideWith(
    FutureOr<Map<String, double>?> Function(PriceRangeByVarietyRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceRangeByVarietyProvider._internal(
        (ref) => create(ref as PriceRangeByVarietyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        variety: variety,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, double>?> createElement() {
    return _PriceRangeByVarietyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceRangeByVarietyProvider &&
        other.variety == variety &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, variety.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PriceRangeByVarietyRef
    on AutoDisposeFutureProviderRef<Map<String, double>?> {
  /// The parameter `variety` of this provider.
  String get variety;

  /// The parameter `days` of this provider.
  int get days;
}

class _PriceRangeByVarietyProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, double>?>
    with PriceRangeByVarietyRef {
  _PriceRangeByVarietyProviderElement(super.provider);

  @override
  String get variety => (origin as PriceRangeByVarietyProvider).variety;
  @override
  int get days => (origin as PriceRangeByVarietyProvider).days;
}

String _$priceTrendByVarietyHash() =>
    r'94f169242c5fe11bde235ff7f1c94d7f37bbee9a';

/// Price trend for a variety (percentage change)
///
/// Copied from [priceTrendByVariety].
@ProviderFor(priceTrendByVariety)
const priceTrendByVarietyProvider = PriceTrendByVarietyFamily();

/// Price trend for a variety (percentage change)
///
/// Copied from [priceTrendByVariety].
class PriceTrendByVarietyFamily extends Family<AsyncValue<double?>> {
  /// Price trend for a variety (percentage change)
  ///
  /// Copied from [priceTrendByVariety].
  const PriceTrendByVarietyFamily();

  /// Price trend for a variety (percentage change)
  ///
  /// Copied from [priceTrendByVariety].
  PriceTrendByVarietyProvider call(
    String variety, {
    int days = 7,
  }) {
    return PriceTrendByVarietyProvider(
      variety,
      days: days,
    );
  }

  @override
  PriceTrendByVarietyProvider getProviderOverride(
    covariant PriceTrendByVarietyProvider provider,
  ) {
    return call(
      provider.variety,
      days: provider.days,
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
  String? get name => r'priceTrendByVarietyProvider';
}

/// Price trend for a variety (percentage change)
///
/// Copied from [priceTrendByVariety].
class PriceTrendByVarietyProvider extends AutoDisposeFutureProvider<double?> {
  /// Price trend for a variety (percentage change)
  ///
  /// Copied from [priceTrendByVariety].
  PriceTrendByVarietyProvider(
    String variety, {
    int days = 7,
  }) : this._internal(
          (ref) => priceTrendByVariety(
            ref as PriceTrendByVarietyRef,
            variety,
            days: days,
          ),
          from: priceTrendByVarietyProvider,
          name: r'priceTrendByVarietyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceTrendByVarietyHash,
          dependencies: PriceTrendByVarietyFamily._dependencies,
          allTransitiveDependencies:
              PriceTrendByVarietyFamily._allTransitiveDependencies,
          variety: variety,
          days: days,
        );

  PriceTrendByVarietyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.variety,
    required this.days,
  }) : super.internal();

  final String variety;
  final int days;

  @override
  Override overrideWith(
    FutureOr<double?> Function(PriceTrendByVarietyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceTrendByVarietyProvider._internal(
        (ref) => create(ref as PriceTrendByVarietyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        variety: variety,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _PriceTrendByVarietyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceTrendByVarietyProvider &&
        other.variety == variety &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, variety.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PriceTrendByVarietyRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `variety` of this provider.
  String get variety;

  /// The parameter `days` of this provider.
  int get days;
}

class _PriceTrendByVarietyProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with PriceTrendByVarietyRef {
  _PriceTrendByVarietyProviderElement(super.provider);

  @override
  String get variety => (origin as PriceTrendByVarietyProvider).variety;
  @override
  int get days => (origin as PriceTrendByVarietyProvider).days;
}

String _$dailyPriceAveragesHash() =>
    r'237f08c5f617d8a94d5976ec591f7fca4842f53a';

/// Daily average prices for charts
///
/// Copied from [dailyPriceAverages].
@ProviderFor(dailyPriceAverages)
const dailyPriceAveragesProvider = DailyPriceAveragesFamily();

/// Daily average prices for charts
///
/// Copied from [dailyPriceAverages].
class DailyPriceAveragesFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Daily average prices for charts
  ///
  /// Copied from [dailyPriceAverages].
  const DailyPriceAveragesFamily();

  /// Daily average prices for charts
  ///
  /// Copied from [dailyPriceAverages].
  DailyPriceAveragesProvider call(
    String variety, {
    int days = 30,
  }) {
    return DailyPriceAveragesProvider(
      variety,
      days: days,
    );
  }

  @override
  DailyPriceAveragesProvider getProviderOverride(
    covariant DailyPriceAveragesProvider provider,
  ) {
    return call(
      provider.variety,
      days: provider.days,
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
  String? get name => r'dailyPriceAveragesProvider';
}

/// Daily average prices for charts
///
/// Copied from [dailyPriceAverages].
class DailyPriceAveragesProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Daily average prices for charts
  ///
  /// Copied from [dailyPriceAverages].
  DailyPriceAveragesProvider(
    String variety, {
    int days = 30,
  }) : this._internal(
          (ref) => dailyPriceAverages(
            ref as DailyPriceAveragesRef,
            variety,
            days: days,
          ),
          from: dailyPriceAveragesProvider,
          name: r'dailyPriceAveragesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyPriceAveragesHash,
          dependencies: DailyPriceAveragesFamily._dependencies,
          allTransitiveDependencies:
              DailyPriceAveragesFamily._allTransitiveDependencies,
          variety: variety,
          days: days,
        );

  DailyPriceAveragesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.variety,
    required this.days,
  }) : super.internal();

  final String variety;
  final int days;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            DailyPriceAveragesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyPriceAveragesProvider._internal(
        (ref) => create(ref as DailyPriceAveragesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        variety: variety,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _DailyPriceAveragesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyPriceAveragesProvider &&
        other.variety == variety &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, variety.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyPriceAveragesRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `variety` of this provider.
  String get variety;

  /// The parameter `days` of this provider.
  int get days;
}

class _DailyPriceAveragesProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with DailyPriceAveragesRef {
  _DailyPriceAveragesProviderElement(super.provider);

  @override
  String get variety => (origin as DailyPriceAveragesProvider).variety;
  @override
  int get days => (origin as DailyPriceAveragesProvider).days;
}

String _$totalPriceUpdatesCountHash() =>
    r'40dbe4553242a490bd01a3f01d63a284ed71377a';

/// Total price updates count
///
/// Copied from [totalPriceUpdatesCount].
@ProviderFor(totalPriceUpdatesCount)
final totalPriceUpdatesCountProvider = AutoDisposeFutureProvider<int>.internal(
  totalPriceUpdatesCount,
  name: r'totalPriceUpdatesCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalPriceUpdatesCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalPriceUpdatesCountRef = AutoDisposeFutureProviderRef<int>;
String _$priceUpdatesCountForDaysHash() =>
    r'b1d3df532c44c8d8baead20584181869c084bf11';

/// Price updates count for last N days
///
/// Copied from [priceUpdatesCountForDays].
@ProviderFor(priceUpdatesCountForDays)
const priceUpdatesCountForDaysProvider = PriceUpdatesCountForDaysFamily();

/// Price updates count for last N days
///
/// Copied from [priceUpdatesCountForDays].
class PriceUpdatesCountForDaysFamily extends Family<AsyncValue<int>> {
  /// Price updates count for last N days
  ///
  /// Copied from [priceUpdatesCountForDays].
  const PriceUpdatesCountForDaysFamily();

  /// Price updates count for last N days
  ///
  /// Copied from [priceUpdatesCountForDays].
  PriceUpdatesCountForDaysProvider call(
    int days,
  ) {
    return PriceUpdatesCountForDaysProvider(
      days,
    );
  }

  @override
  PriceUpdatesCountForDaysProvider getProviderOverride(
    covariant PriceUpdatesCountForDaysProvider provider,
  ) {
    return call(
      provider.days,
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
  String? get name => r'priceUpdatesCountForDaysProvider';
}

/// Price updates count for last N days
///
/// Copied from [priceUpdatesCountForDays].
class PriceUpdatesCountForDaysProvider extends AutoDisposeFutureProvider<int> {
  /// Price updates count for last N days
  ///
  /// Copied from [priceUpdatesCountForDays].
  PriceUpdatesCountForDaysProvider(
    int days,
  ) : this._internal(
          (ref) => priceUpdatesCountForDays(
            ref as PriceUpdatesCountForDaysRef,
            days,
          ),
          from: priceUpdatesCountForDaysProvider,
          name: r'priceUpdatesCountForDaysProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceUpdatesCountForDaysHash,
          dependencies: PriceUpdatesCountForDaysFamily._dependencies,
          allTransitiveDependencies:
              PriceUpdatesCountForDaysFamily._allTransitiveDependencies,
          days: days,
        );

  PriceUpdatesCountForDaysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    FutureOr<int> Function(PriceUpdatesCountForDaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceUpdatesCountForDaysProvider._internal(
        (ref) => create(ref as PriceUpdatesCountForDaysRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _PriceUpdatesCountForDaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceUpdatesCountForDaysProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PriceUpdatesCountForDaysRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `days` of this provider.
  int get days;
}

class _PriceUpdatesCountForDaysProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with PriceUpdatesCountForDaysRef {
  _PriceUpdatesCountForDaysProviderElement(super.provider);

  @override
  int get days => (origin as PriceUpdatesCountForDaysProvider).days;
}

String _$productPriceHistoryForDaysHash() =>
    r'b2206750675d01ad8dc9f4fc5d8f653f06d83b29';

/// Price history for a specific product filtered by days
/// Used for price history chart with time range toggle (7/30/90 days)
///
/// Copied from [productPriceHistoryForDays].
@ProviderFor(productPriceHistoryForDays)
const productPriceHistoryForDaysProvider = ProductPriceHistoryForDaysFamily();

/// Price history for a specific product filtered by days
/// Used for price history chart with time range toggle (7/30/90 days)
///
/// Copied from [productPriceHistoryForDays].
class ProductPriceHistoryForDaysFamily
    extends Family<AsyncValue<List<PriceHistoryModel>>> {
  /// Price history for a specific product filtered by days
  /// Used for price history chart with time range toggle (7/30/90 days)
  ///
  /// Copied from [productPriceHistoryForDays].
  const ProductPriceHistoryForDaysFamily();

  /// Price history for a specific product filtered by days
  /// Used for price history chart with time range toggle (7/30/90 days)
  ///
  /// Copied from [productPriceHistoryForDays].
  ProductPriceHistoryForDaysProvider call(
    String farmId,
    String productId,
    int days,
  ) {
    return ProductPriceHistoryForDaysProvider(
      farmId,
      productId,
      days,
    );
  }

  @override
  ProductPriceHistoryForDaysProvider getProviderOverride(
    covariant ProductPriceHistoryForDaysProvider provider,
  ) {
    return call(
      provider.farmId,
      provider.productId,
      provider.days,
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
  String? get name => r'productPriceHistoryForDaysProvider';
}

/// Price history for a specific product filtered by days
/// Used for price history chart with time range toggle (7/30/90 days)
///
/// Copied from [productPriceHistoryForDays].
class ProductPriceHistoryForDaysProvider
    extends AutoDisposeStreamProvider<List<PriceHistoryModel>> {
  /// Price history for a specific product filtered by days
  /// Used for price history chart with time range toggle (7/30/90 days)
  ///
  /// Copied from [productPriceHistoryForDays].
  ProductPriceHistoryForDaysProvider(
    String farmId,
    String productId,
    int days,
  ) : this._internal(
          (ref) => productPriceHistoryForDays(
            ref as ProductPriceHistoryForDaysRef,
            farmId,
            productId,
            days,
          ),
          from: productPriceHistoryForDaysProvider,
          name: r'productPriceHistoryForDaysProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productPriceHistoryForDaysHash,
          dependencies: ProductPriceHistoryForDaysFamily._dependencies,
          allTransitiveDependencies:
              ProductPriceHistoryForDaysFamily._allTransitiveDependencies,
          farmId: farmId,
          productId: productId,
          days: days,
        );

  ProductPriceHistoryForDaysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
    required this.productId,
    required this.days,
  }) : super.internal();

  final String farmId;
  final String productId;
  final int days;

  @override
  Override overrideWith(
    Stream<List<PriceHistoryModel>> Function(
            ProductPriceHistoryForDaysRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductPriceHistoryForDaysProvider._internal(
        (ref) => create(ref as ProductPriceHistoryForDaysRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
        productId: productId,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PriceHistoryModel>> createElement() {
    return _ProductPriceHistoryForDaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductPriceHistoryForDaysProvider &&
        other.farmId == farmId &&
        other.productId == productId &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductPriceHistoryForDaysRef
    on AutoDisposeStreamProviderRef<List<PriceHistoryModel>> {
  /// The parameter `farmId` of this provider.
  String get farmId;

  /// The parameter `productId` of this provider.
  String get productId;

  /// The parameter `days` of this provider.
  int get days;
}

class _ProductPriceHistoryForDaysProviderElement
    extends AutoDisposeStreamProviderElement<List<PriceHistoryModel>>
    with ProductPriceHistoryForDaysRef {
  _ProductPriceHistoryForDaysProviderElement(super.provider);

  @override
  String get farmId => (origin as ProductPriceHistoryForDaysProvider).farmId;
  @override
  String get productId =>
      (origin as ProductPriceHistoryForDaysProvider).productId;
  @override
  int get days => (origin as ProductPriceHistoryForDaysProvider).days;
}

String _$productHistoricalAverageHash() =>
    r'15f4c90db3bef80fef08d160576309363dd303af';

/// Calculate historical average price for a specific product
/// Returns null if no history available
///
/// Copied from [productHistoricalAverage].
@ProviderFor(productHistoricalAverage)
const productHistoricalAverageProvider = ProductHistoricalAverageFamily();

/// Calculate historical average price for a specific product
/// Returns null if no history available
///
/// Copied from [productHistoricalAverage].
class ProductHistoricalAverageFamily extends Family<AsyncValue<double?>> {
  /// Calculate historical average price for a specific product
  /// Returns null if no history available
  ///
  /// Copied from [productHistoricalAverage].
  const ProductHistoricalAverageFamily();

  /// Calculate historical average price for a specific product
  /// Returns null if no history available
  ///
  /// Copied from [productHistoricalAverage].
  ProductHistoricalAverageProvider call(
    String farmId,
    String productId, {
    int days = 30,
  }) {
    return ProductHistoricalAverageProvider(
      farmId,
      productId,
      days: days,
    );
  }

  @override
  ProductHistoricalAverageProvider getProviderOverride(
    covariant ProductHistoricalAverageProvider provider,
  ) {
    return call(
      provider.farmId,
      provider.productId,
      days: provider.days,
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
  String? get name => r'productHistoricalAverageProvider';
}

/// Calculate historical average price for a specific product
/// Returns null if no history available
///
/// Copied from [productHistoricalAverage].
class ProductHistoricalAverageProvider
    extends AutoDisposeFutureProvider<double?> {
  /// Calculate historical average price for a specific product
  /// Returns null if no history available
  ///
  /// Copied from [productHistoricalAverage].
  ProductHistoricalAverageProvider(
    String farmId,
    String productId, {
    int days = 30,
  }) : this._internal(
          (ref) => productHistoricalAverage(
            ref as ProductHistoricalAverageRef,
            farmId,
            productId,
            days: days,
          ),
          from: productHistoricalAverageProvider,
          name: r'productHistoricalAverageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productHistoricalAverageHash,
          dependencies: ProductHistoricalAverageFamily._dependencies,
          allTransitiveDependencies:
              ProductHistoricalAverageFamily._allTransitiveDependencies,
          farmId: farmId,
          productId: productId,
          days: days,
        );

  ProductHistoricalAverageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
    required this.productId,
    required this.days,
  }) : super.internal();

  final String farmId;
  final String productId;
  final int days;

  @override
  Override overrideWith(
    FutureOr<double?> Function(ProductHistoricalAverageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductHistoricalAverageProvider._internal(
        (ref) => create(ref as ProductHistoricalAverageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
        productId: productId,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _ProductHistoricalAverageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductHistoricalAverageProvider &&
        other.farmId == farmId &&
        other.productId == productId &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductHistoricalAverageRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `farmId` of this provider.
  String get farmId;

  /// The parameter `productId` of this provider.
  String get productId;

  /// The parameter `days` of this provider.
  int get days;
}

class _ProductHistoricalAverageProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ProductHistoricalAverageRef {
  _ProductHistoricalAverageProviderElement(super.provider);

  @override
  String get farmId => (origin as ProductHistoricalAverageProvider).farmId;
  @override
  String get productId =>
      (origin as ProductHistoricalAverageProvider).productId;
  @override
  int get days => (origin as ProductHistoricalAverageProvider).days;
}

String _$productPriceStatsHash() => r'f359f8cf5b23a96cb30554b99db85a1a52ab19b1';

/// Get price statistics (min, max, avg) for a specific product
///
/// Copied from [productPriceStats].
@ProviderFor(productPriceStats)
const productPriceStatsProvider = ProductPriceStatsFamily();

/// Get price statistics (min, max, avg) for a specific product
///
/// Copied from [productPriceStats].
class ProductPriceStatsFamily extends Family<AsyncValue<PriceStats>> {
  /// Get price statistics (min, max, avg) for a specific product
  ///
  /// Copied from [productPriceStats].
  const ProductPriceStatsFamily();

  /// Get price statistics (min, max, avg) for a specific product
  ///
  /// Copied from [productPriceStats].
  ProductPriceStatsProvider call(
    String farmId,
    String productId,
    int days,
  ) {
    return ProductPriceStatsProvider(
      farmId,
      productId,
      days,
    );
  }

  @override
  ProductPriceStatsProvider getProviderOverride(
    covariant ProductPriceStatsProvider provider,
  ) {
    return call(
      provider.farmId,
      provider.productId,
      provider.days,
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
  String? get name => r'productPriceStatsProvider';
}

/// Get price statistics (min, max, avg) for a specific product
///
/// Copied from [productPriceStats].
class ProductPriceStatsProvider extends AutoDisposeFutureProvider<PriceStats> {
  /// Get price statistics (min, max, avg) for a specific product
  ///
  /// Copied from [productPriceStats].
  ProductPriceStatsProvider(
    String farmId,
    String productId,
    int days,
  ) : this._internal(
          (ref) => productPriceStats(
            ref as ProductPriceStatsRef,
            farmId,
            productId,
            days,
          ),
          from: productPriceStatsProvider,
          name: r'productPriceStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productPriceStatsHash,
          dependencies: ProductPriceStatsFamily._dependencies,
          allTransitiveDependencies:
              ProductPriceStatsFamily._allTransitiveDependencies,
          farmId: farmId,
          productId: productId,
          days: days,
        );

  ProductPriceStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
    required this.productId,
    required this.days,
  }) : super.internal();

  final String farmId;
  final String productId;
  final int days;

  @override
  Override overrideWith(
    FutureOr<PriceStats> Function(ProductPriceStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductPriceStatsProvider._internal(
        (ref) => create(ref as ProductPriceStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
        productId: productId,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PriceStats> createElement() {
    return _ProductPriceStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductPriceStatsProvider &&
        other.farmId == farmId &&
        other.productId == productId &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductPriceStatsRef on AutoDisposeFutureProviderRef<PriceStats> {
  /// The parameter `farmId` of this provider.
  String get farmId;

  /// The parameter `productId` of this provider.
  String get productId;

  /// The parameter `days` of this provider.
  int get days;
}

class _ProductPriceStatsProviderElement
    extends AutoDisposeFutureProviderElement<PriceStats>
    with ProductPriceStatsRef {
  _ProductPriceStatsProviderElement(super.provider);

  @override
  String get farmId => (origin as ProductPriceStatsProvider).farmId;
  @override
  String get productId => (origin as ProductPriceStatsProvider).productId;
  @override
  int get days => (origin as ProductPriceStatsProvider).days;
}

String _$productPriceComparisonHash() =>
    r'a700ad1be3ad8fa86aa0eaff8cf28fabfaa85e0b';

/// Compare current price against historical average
/// Returns comparison with "X% below/above avg" data
///
/// Copied from [productPriceComparison].
@ProviderFor(productPriceComparison)
const productPriceComparisonProvider = ProductPriceComparisonFamily();

/// Compare current price against historical average
/// Returns comparison with "X% below/above avg" data
///
/// Copied from [productPriceComparison].
class ProductPriceComparisonFamily
    extends Family<AsyncValue<PriceComparison?>> {
  /// Compare current price against historical average
  /// Returns comparison with "X% below/above avg" data
  ///
  /// Copied from [productPriceComparison].
  const ProductPriceComparisonFamily();

  /// Compare current price against historical average
  /// Returns comparison with "X% below/above avg" data
  ///
  /// Copied from [productPriceComparison].
  ProductPriceComparisonProvider call(
    String farmId,
    String productId,
    double currentPrice,
  ) {
    return ProductPriceComparisonProvider(
      farmId,
      productId,
      currentPrice,
    );
  }

  @override
  ProductPriceComparisonProvider getProviderOverride(
    covariant ProductPriceComparisonProvider provider,
  ) {
    return call(
      provider.farmId,
      provider.productId,
      provider.currentPrice,
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
  String? get name => r'productPriceComparisonProvider';
}

/// Compare current price against historical average
/// Returns comparison with "X% below/above avg" data
///
/// Copied from [productPriceComparison].
class ProductPriceComparisonProvider
    extends AutoDisposeFutureProvider<PriceComparison?> {
  /// Compare current price against historical average
  /// Returns comparison with "X% below/above avg" data
  ///
  /// Copied from [productPriceComparison].
  ProductPriceComparisonProvider(
    String farmId,
    String productId,
    double currentPrice,
  ) : this._internal(
          (ref) => productPriceComparison(
            ref as ProductPriceComparisonRef,
            farmId,
            productId,
            currentPrice,
          ),
          from: productPriceComparisonProvider,
          name: r'productPriceComparisonProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productPriceComparisonHash,
          dependencies: ProductPriceComparisonFamily._dependencies,
          allTransitiveDependencies:
              ProductPriceComparisonFamily._allTransitiveDependencies,
          farmId: farmId,
          productId: productId,
          currentPrice: currentPrice,
        );

  ProductPriceComparisonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
    required this.productId,
    required this.currentPrice,
  }) : super.internal();

  final String farmId;
  final String productId;
  final double currentPrice;

  @override
  Override overrideWith(
    FutureOr<PriceComparison?> Function(ProductPriceComparisonRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductPriceComparisonProvider._internal(
        (ref) => create(ref as ProductPriceComparisonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
        productId: productId,
        currentPrice: currentPrice,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PriceComparison?> createElement() {
    return _ProductPriceComparisonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductPriceComparisonProvider &&
        other.farmId == farmId &&
        other.productId == productId &&
        other.currentPrice == currentPrice;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);
    hash = _SystemHash.combine(hash, currentPrice.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductPriceComparisonRef
    on AutoDisposeFutureProviderRef<PriceComparison?> {
  /// The parameter `farmId` of this provider.
  String get farmId;

  /// The parameter `productId` of this provider.
  String get productId;

  /// The parameter `currentPrice` of this provider.
  double get currentPrice;
}

class _ProductPriceComparisonProviderElement
    extends AutoDisposeFutureProviderElement<PriceComparison?>
    with ProductPriceComparisonRef {
  _ProductPriceComparisonProviderElement(super.provider);

  @override
  String get farmId => (origin as ProductPriceComparisonProvider).farmId;
  @override
  String get productId => (origin as ProductPriceComparisonProvider).productId;
  @override
  double get currentPrice =>
      (origin as ProductPriceComparisonProvider).currentPrice;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
