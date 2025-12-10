// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_comparison_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allFarmsMapHash() => r'8224464d373e658c28c80dca9edb289479948db6';

/// Pre-fetches all active farms as a Map for efficient O(1) lookups.
/// Cached and shared across product comparison queries.
///
/// Copied from [allFarmsMap].
@ProviderFor(allFarmsMap)
final allFarmsMapProvider =
    AutoDisposeFutureProvider<Map<String, FarmModel>>.internal(
  allFarmsMap,
  name: r'allFarmsMapProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allFarmsMapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllFarmsMapRef = AutoDisposeFutureProviderRef<Map<String, FarmModel>>;
String _$searchProductsAcrossFarmsHash() =>
    r'bbdfc8967bd736e6db5af134f854d3e6b2e709dd';

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

/// Searches products across all farms with optional category filter.
/// Returns `List<ProductWithFarm>` with farm data and distance calculated.
///
/// - [query]: Search term (min 2 chars, case-insensitive)
/// - [category]: Optional category filter (null = all categories)
///
/// Copied from [searchProductsAcrossFarms].
@ProviderFor(searchProductsAcrossFarms)
const searchProductsAcrossFarmsProvider = SearchProductsAcrossFarmsFamily();

/// Searches products across all farms with optional category filter.
/// Returns `List<ProductWithFarm>` with farm data and distance calculated.
///
/// - [query]: Search term (min 2 chars, case-insensitive)
/// - [category]: Optional category filter (null = all categories)
///
/// Copied from [searchProductsAcrossFarms].
class SearchProductsAcrossFarmsFamily
    extends Family<AsyncValue<List<ProductWithFarm>>> {
  /// Searches products across all farms with optional category filter.
  /// Returns `List<ProductWithFarm>` with farm data and distance calculated.
  ///
  /// - [query]: Search term (min 2 chars, case-insensitive)
  /// - [category]: Optional category filter (null = all categories)
  ///
  /// Copied from [searchProductsAcrossFarms].
  const SearchProductsAcrossFarmsFamily();

  /// Searches products across all farms with optional category filter.
  /// Returns `List<ProductWithFarm>` with farm data and distance calculated.
  ///
  /// - [query]: Search term (min 2 chars, case-insensitive)
  /// - [category]: Optional category filter (null = all categories)
  ///
  /// Copied from [searchProductsAcrossFarms].
  SearchProductsAcrossFarmsProvider call(
    String query, {
    ProductCategory? category,
  }) {
    return SearchProductsAcrossFarmsProvider(
      query,
      category: category,
    );
  }

  @override
  SearchProductsAcrossFarmsProvider getProviderOverride(
    covariant SearchProductsAcrossFarmsProvider provider,
  ) {
    return call(
      provider.query,
      category: provider.category,
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
  String? get name => r'searchProductsAcrossFarmsProvider';
}

/// Searches products across all farms with optional category filter.
/// Returns `List<ProductWithFarm>` with farm data and distance calculated.
///
/// - [query]: Search term (min 2 chars, case-insensitive)
/// - [category]: Optional category filter (null = all categories)
///
/// Copied from [searchProductsAcrossFarms].
class SearchProductsAcrossFarmsProvider
    extends AutoDisposeFutureProvider<List<ProductWithFarm>> {
  /// Searches products across all farms with optional category filter.
  /// Returns `List<ProductWithFarm>` with farm data and distance calculated.
  ///
  /// - [query]: Search term (min 2 chars, case-insensitive)
  /// - [category]: Optional category filter (null = all categories)
  ///
  /// Copied from [searchProductsAcrossFarms].
  SearchProductsAcrossFarmsProvider(
    String query, {
    ProductCategory? category,
  }) : this._internal(
          (ref) => searchProductsAcrossFarms(
            ref as SearchProductsAcrossFarmsRef,
            query,
            category: category,
          ),
          from: searchProductsAcrossFarmsProvider,
          name: r'searchProductsAcrossFarmsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchProductsAcrossFarmsHash,
          dependencies: SearchProductsAcrossFarmsFamily._dependencies,
          allTransitiveDependencies:
              SearchProductsAcrossFarmsFamily._allTransitiveDependencies,
          query: query,
          category: category,
        );

  SearchProductsAcrossFarmsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.category,
  }) : super.internal();

  final String query;
  final ProductCategory? category;

  @override
  Override overrideWith(
    FutureOr<List<ProductWithFarm>> Function(
            SearchProductsAcrossFarmsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchProductsAcrossFarmsProvider._internal(
        (ref) => create(ref as SearchProductsAcrossFarmsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductWithFarm>> createElement() {
    return _SearchProductsAcrossFarmsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProductsAcrossFarmsProvider &&
        other.query == query &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchProductsAcrossFarmsRef
    on AutoDisposeFutureProviderRef<List<ProductWithFarm>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `category` of this provider.
  ProductCategory? get category;
}

class _SearchProductsAcrossFarmsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductWithFarm>>
    with SearchProductsAcrossFarmsRef {
  _SearchProductsAcrossFarmsProviderElement(super.provider);

  @override
  String get query => (origin as SearchProductsAcrossFarmsProvider).query;
  @override
  ProductCategory? get category =>
      (origin as SearchProductsAcrossFarmsProvider).category;
}

String _$productsByComparisonCategoryHash() =>
    r'09fca667b5203c1b00cb79a3dba74bc1ecf5b9d0';

/// Searches products with category filter only (no text query).
/// Useful for browsing all products in a category.
///
/// Copied from [productsByComparisonCategory].
@ProviderFor(productsByComparisonCategory)
const productsByComparisonCategoryProvider =
    ProductsByComparisonCategoryFamily();

/// Searches products with category filter only (no text query).
/// Useful for browsing all products in a category.
///
/// Copied from [productsByComparisonCategory].
class ProductsByComparisonCategoryFamily
    extends Family<AsyncValue<List<ProductWithFarm>>> {
  /// Searches products with category filter only (no text query).
  /// Useful for browsing all products in a category.
  ///
  /// Copied from [productsByComparisonCategory].
  const ProductsByComparisonCategoryFamily();

  /// Searches products with category filter only (no text query).
  /// Useful for browsing all products in a category.
  ///
  /// Copied from [productsByComparisonCategory].
  ProductsByComparisonCategoryProvider call(
    ProductCategory? category,
  ) {
    return ProductsByComparisonCategoryProvider(
      category,
    );
  }

  @override
  ProductsByComparisonCategoryProvider getProviderOverride(
    covariant ProductsByComparisonCategoryProvider provider,
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
  String? get name => r'productsByComparisonCategoryProvider';
}

/// Searches products with category filter only (no text query).
/// Useful for browsing all products in a category.
///
/// Copied from [productsByComparisonCategory].
class ProductsByComparisonCategoryProvider
    extends AutoDisposeFutureProvider<List<ProductWithFarm>> {
  /// Searches products with category filter only (no text query).
  /// Useful for browsing all products in a category.
  ///
  /// Copied from [productsByComparisonCategory].
  ProductsByComparisonCategoryProvider(
    ProductCategory? category,
  ) : this._internal(
          (ref) => productsByComparisonCategory(
            ref as ProductsByComparisonCategoryRef,
            category,
          ),
          from: productsByComparisonCategoryProvider,
          name: r'productsByComparisonCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsByComparisonCategoryHash,
          dependencies: ProductsByComparisonCategoryFamily._dependencies,
          allTransitiveDependencies:
              ProductsByComparisonCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  ProductsByComparisonCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final ProductCategory? category;

  @override
  Override overrideWith(
    FutureOr<List<ProductWithFarm>> Function(
            ProductsByComparisonCategoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductsByComparisonCategoryProvider._internal(
        (ref) => create(ref as ProductsByComparisonCategoryRef),
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
  AutoDisposeFutureProviderElement<List<ProductWithFarm>> createElement() {
    return _ProductsByComparisonCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByComparisonCategoryProvider &&
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
mixin ProductsByComparisonCategoryRef
    on AutoDisposeFutureProviderRef<List<ProductWithFarm>> {
  /// The parameter `category` of this provider.
  ProductCategory? get category;
}

class _ProductsByComparisonCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductWithFarm>>
    with ProductsByComparisonCategoryRef {
  _ProductsByComparisonCategoryProviderElement(super.provider);

  @override
  ProductCategory? get category =>
      (origin as ProductsByComparisonCategoryProvider).category;
}

String _$sortedProductComparisonHash() =>
    r'ccc51195f06a5b3da55ab74099f52fc28a1d83cd';

/// Provider version of sortProductComparison for reactive UI.
///
/// Copied from [sortedProductComparison].
@ProviderFor(sortedProductComparison)
const sortedProductComparisonProvider = SortedProductComparisonFamily();

/// Provider version of sortProductComparison for reactive UI.
///
/// Copied from [sortedProductComparison].
class SortedProductComparisonFamily extends Family<List<ProductWithFarm>> {
  /// Provider version of sortProductComparison for reactive UI.
  ///
  /// Copied from [sortedProductComparison].
  const SortedProductComparisonFamily();

  /// Provider version of sortProductComparison for reactive UI.
  ///
  /// Copied from [sortedProductComparison].
  SortedProductComparisonProvider call(
    List<ProductWithFarm> products,
    ProductSortOption sortBy,
  ) {
    return SortedProductComparisonProvider(
      products,
      sortBy,
    );
  }

  @override
  SortedProductComparisonProvider getProviderOverride(
    covariant SortedProductComparisonProvider provider,
  ) {
    return call(
      provider.products,
      provider.sortBy,
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
  String? get name => r'sortedProductComparisonProvider';
}

/// Provider version of sortProductComparison for reactive UI.
///
/// Copied from [sortedProductComparison].
class SortedProductComparisonProvider
    extends AutoDisposeProvider<List<ProductWithFarm>> {
  /// Provider version of sortProductComparison for reactive UI.
  ///
  /// Copied from [sortedProductComparison].
  SortedProductComparisonProvider(
    List<ProductWithFarm> products,
    ProductSortOption sortBy,
  ) : this._internal(
          (ref) => sortedProductComparison(
            ref as SortedProductComparisonRef,
            products,
            sortBy,
          ),
          from: sortedProductComparisonProvider,
          name: r'sortedProductComparisonProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortedProductComparisonHash,
          dependencies: SortedProductComparisonFamily._dependencies,
          allTransitiveDependencies:
              SortedProductComparisonFamily._allTransitiveDependencies,
          products: products,
          sortBy: sortBy,
        );

  SortedProductComparisonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.products,
    required this.sortBy,
  }) : super.internal();

  final List<ProductWithFarm> products;
  final ProductSortOption sortBy;

  @override
  Override overrideWith(
    List<ProductWithFarm> Function(SortedProductComparisonRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SortedProductComparisonProvider._internal(
        (ref) => create(ref as SortedProductComparisonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        products: products,
        sortBy: sortBy,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<ProductWithFarm>> createElement() {
    return _SortedProductComparisonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortedProductComparisonProvider &&
        other.products == products &&
        other.sortBy == sortBy;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, products.hashCode);
    hash = _SystemHash.combine(hash, sortBy.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SortedProductComparisonRef
    on AutoDisposeProviderRef<List<ProductWithFarm>> {
  /// The parameter `products` of this provider.
  List<ProductWithFarm> get products;

  /// The parameter `sortBy` of this provider.
  ProductSortOption get sortBy;
}

class _SortedProductComparisonProviderElement
    extends AutoDisposeProviderElement<List<ProductWithFarm>>
    with SortedProductComparisonRef {
  _SortedProductComparisonProviderElement(super.provider);

  @override
  List<ProductWithFarm> get products =>
      (origin as SortedProductComparisonProvider).products;
  @override
  ProductSortOption get sortBy =>
      (origin as SortedProductComparisonProvider).sortBy;
}

String _$varietyPriceStatsHash() => r'19f6c2c5df0a02995d5f19ac43b60412c5ccca60';

/// Calculates price statistics for a specific pineapple variety.
/// Returns PriceStats with average, min, max, and data point count.
///
/// Used for price comparison and deal detection.
///
/// Copied from [varietyPriceStats].
@ProviderFor(varietyPriceStats)
const varietyPriceStatsProvider = VarietyPriceStatsFamily();

/// Calculates price statistics for a specific pineapple variety.
/// Returns PriceStats with average, min, max, and data point count.
///
/// Used for price comparison and deal detection.
///
/// Copied from [varietyPriceStats].
class VarietyPriceStatsFamily extends Family<AsyncValue<PriceStats>> {
  /// Calculates price statistics for a specific pineapple variety.
  /// Returns PriceStats with average, min, max, and data point count.
  ///
  /// Used for price comparison and deal detection.
  ///
  /// Copied from [varietyPriceStats].
  const VarietyPriceStatsFamily();

  /// Calculates price statistics for a specific pineapple variety.
  /// Returns PriceStats with average, min, max, and data point count.
  ///
  /// Used for price comparison and deal detection.
  ///
  /// Copied from [varietyPriceStats].
  VarietyPriceStatsProvider call(
    PineappleVariety variety,
  ) {
    return VarietyPriceStatsProvider(
      variety,
    );
  }

  @override
  VarietyPriceStatsProvider getProviderOverride(
    covariant VarietyPriceStatsProvider provider,
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
  String? get name => r'varietyPriceStatsProvider';
}

/// Calculates price statistics for a specific pineapple variety.
/// Returns PriceStats with average, min, max, and data point count.
///
/// Used for price comparison and deal detection.
///
/// Copied from [varietyPriceStats].
class VarietyPriceStatsProvider extends AutoDisposeFutureProvider<PriceStats> {
  /// Calculates price statistics for a specific pineapple variety.
  /// Returns PriceStats with average, min, max, and data point count.
  ///
  /// Used for price comparison and deal detection.
  ///
  /// Copied from [varietyPriceStats].
  VarietyPriceStatsProvider(
    PineappleVariety variety,
  ) : this._internal(
          (ref) => varietyPriceStats(
            ref as VarietyPriceStatsRef,
            variety,
          ),
          from: varietyPriceStatsProvider,
          name: r'varietyPriceStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$varietyPriceStatsHash,
          dependencies: VarietyPriceStatsFamily._dependencies,
          allTransitiveDependencies:
              VarietyPriceStatsFamily._allTransitiveDependencies,
          variety: variety,
        );

  VarietyPriceStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.variety,
  }) : super.internal();

  final PineappleVariety variety;

  @override
  Override overrideWith(
    FutureOr<PriceStats> Function(VarietyPriceStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VarietyPriceStatsProvider._internal(
        (ref) => create(ref as VarietyPriceStatsRef),
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
  AutoDisposeFutureProviderElement<PriceStats> createElement() {
    return _VarietyPriceStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VarietyPriceStatsProvider && other.variety == variety;
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
mixin VarietyPriceStatsRef on AutoDisposeFutureProviderRef<PriceStats> {
  /// The parameter `variety` of this provider.
  PineappleVariety get variety;
}

class _VarietyPriceStatsProviderElement
    extends AutoDisposeFutureProviderElement<PriceStats>
    with VarietyPriceStatsRef {
  _VarietyPriceStatsProviderElement(super.provider);

  @override
  PineappleVariety get variety => (origin as VarietyPriceStatsProvider).variety;
}

String _$allVarietiesPriceStatsHash() =>
    r'75eebfa68cc0b179419df8fb022f386ffab31db3';

/// Calculate price statistics for all varieties.
/// Returns a map of variety -> PriceStats.
///
/// Useful for batch price comparison calculations.
///
/// Copied from [allVarietiesPriceStats].
@ProviderFor(allVarietiesPriceStats)
final allVarietiesPriceStatsProvider =
    AutoDisposeFutureProvider<Map<PineappleVariety, PriceStats>>.internal(
  allVarietiesPriceStats,
  name: r'allVarietiesPriceStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allVarietiesPriceStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllVarietiesPriceStatsRef
    = AutoDisposeFutureProviderRef<Map<PineappleVariety, PriceStats>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
