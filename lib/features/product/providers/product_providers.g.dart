// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productRepositoryHash() => r'4973a0bd99a5033529417521bf9fb70ac700bfdb';

/// Product repository provider
///
/// Copied from [productRepository].
@ProviderFor(productRepository)
final productRepositoryProvider = Provider<ProductRepository>.internal(
  productRepository,
  name: r'productRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductRepositoryRef = ProviderRef<ProductRepository>;
String _$productByIdHash() => r'1e067c8560579717f6aeef9ddbcf896b535b2ebf';

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

/// Get product by farm ID and product ID
///
/// Copied from [productById].
@ProviderFor(productById)
const productByIdProvider = ProductByIdFamily();

/// Get product by farm ID and product ID
///
/// Copied from [productById].
class ProductByIdFamily extends Family<AsyncValue<ProductModel?>> {
  /// Get product by farm ID and product ID
  ///
  /// Copied from [productById].
  const ProductByIdFamily();

  /// Get product by farm ID and product ID
  ///
  /// Copied from [productById].
  ProductByIdProvider call(
    String farmId,
    String productId,
  ) {
    return ProductByIdProvider(
      farmId,
      productId,
    );
  }

  @override
  ProductByIdProvider getProviderOverride(
    covariant ProductByIdProvider provider,
  ) {
    return call(
      provider.farmId,
      provider.productId,
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
  String? get name => r'productByIdProvider';
}

/// Get product by farm ID and product ID
///
/// Copied from [productById].
class ProductByIdProvider extends AutoDisposeStreamProvider<ProductModel?> {
  /// Get product by farm ID and product ID
  ///
  /// Copied from [productById].
  ProductByIdProvider(
    String farmId,
    String productId,
  ) : this._internal(
          (ref) => productById(
            ref as ProductByIdRef,
            farmId,
            productId,
          ),
          from: productByIdProvider,
          name: r'productByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productByIdHash,
          dependencies: ProductByIdFamily._dependencies,
          allTransitiveDependencies:
              ProductByIdFamily._allTransitiveDependencies,
          farmId: farmId,
          productId: productId,
        );

  ProductByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmId,
    required this.productId,
  }) : super.internal();

  final String farmId;
  final String productId;

  @override
  Override overrideWith(
    Stream<ProductModel?> Function(ProductByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductByIdProvider._internal(
        (ref) => create(ref as ProductByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmId: farmId,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ProductModel?> createElement() {
    return _ProductByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductByIdProvider &&
        other.farmId == farmId &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmId.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductByIdRef on AutoDisposeStreamProviderRef<ProductModel?> {
  /// The parameter `farmId` of this provider.
  String get farmId;

  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductByIdProviderElement
    extends AutoDisposeStreamProviderElement<ProductModel?>
    with ProductByIdRef {
  _ProductByIdProviderElement(super.provider);

  @override
  String get farmId => (origin as ProductByIdProvider).farmId;
  @override
  String get productId => (origin as ProductByIdProvider).productId;
}

String _$productsByFarmHash() => r'15c9c57cdc4f2df9ac8af230d941b09843f48689';

/// All products for a farm
///
/// Copied from [productsByFarm].
@ProviderFor(productsByFarm)
const productsByFarmProvider = ProductsByFarmFamily();

/// All products for a farm
///
/// Copied from [productsByFarm].
class ProductsByFarmFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// All products for a farm
  ///
  /// Copied from [productsByFarm].
  const ProductsByFarmFamily();

  /// All products for a farm
  ///
  /// Copied from [productsByFarm].
  ProductsByFarmProvider call(
    String farmId,
  ) {
    return ProductsByFarmProvider(
      farmId,
    );
  }

  @override
  ProductsByFarmProvider getProviderOverride(
    covariant ProductsByFarmProvider provider,
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
  String? get name => r'productsByFarmProvider';
}

/// All products for a farm
///
/// Copied from [productsByFarm].
class ProductsByFarmProvider
    extends AutoDisposeStreamProvider<List<ProductModel>> {
  /// All products for a farm
  ///
  /// Copied from [productsByFarm].
  ProductsByFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => productsByFarm(
            ref as ProductsByFarmRef,
            farmId,
          ),
          from: productsByFarmProvider,
          name: r'productsByFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsByFarmHash,
          dependencies: ProductsByFarmFamily._dependencies,
          allTransitiveDependencies:
              ProductsByFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  ProductsByFarmProvider._internal(
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
    Stream<List<ProductModel>> Function(ProductsByFarmRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductsByFarmProvider._internal(
        (ref) => create(ref as ProductsByFarmRef),
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
  AutoDisposeStreamProviderElement<List<ProductModel>> createElement() {
    return _ProductsByFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByFarmProvider && other.farmId == farmId;
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
mixin ProductsByFarmRef on AutoDisposeStreamProviderRef<List<ProductModel>> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _ProductsByFarmProviderElement
    extends AutoDisposeStreamProviderElement<List<ProductModel>>
    with ProductsByFarmRef {
  _ProductsByFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as ProductsByFarmProvider).farmId;
}

String _$availableProductsByFarmHash() =>
    r'9c25e66cbfb7422e8f2c1bf7d36c0e75b0f883d3';

/// Available products for a farm
///
/// Copied from [availableProductsByFarm].
@ProviderFor(availableProductsByFarm)
const availableProductsByFarmProvider = AvailableProductsByFarmFamily();

/// Available products for a farm
///
/// Copied from [availableProductsByFarm].
class AvailableProductsByFarmFamily
    extends Family<AsyncValue<List<ProductModel>>> {
  /// Available products for a farm
  ///
  /// Copied from [availableProductsByFarm].
  const AvailableProductsByFarmFamily();

  /// Available products for a farm
  ///
  /// Copied from [availableProductsByFarm].
  AvailableProductsByFarmProvider call(
    String farmId,
  ) {
    return AvailableProductsByFarmProvider(
      farmId,
    );
  }

  @override
  AvailableProductsByFarmProvider getProviderOverride(
    covariant AvailableProductsByFarmProvider provider,
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
  String? get name => r'availableProductsByFarmProvider';
}

/// Available products for a farm
///
/// Copied from [availableProductsByFarm].
class AvailableProductsByFarmProvider
    extends AutoDisposeStreamProvider<List<ProductModel>> {
  /// Available products for a farm
  ///
  /// Copied from [availableProductsByFarm].
  AvailableProductsByFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => availableProductsByFarm(
            ref as AvailableProductsByFarmRef,
            farmId,
          ),
          from: availableProductsByFarmProvider,
          name: r'availableProductsByFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableProductsByFarmHash,
          dependencies: AvailableProductsByFarmFamily._dependencies,
          allTransitiveDependencies:
              AvailableProductsByFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  AvailableProductsByFarmProvider._internal(
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
    Stream<List<ProductModel>> Function(AvailableProductsByFarmRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableProductsByFarmProvider._internal(
        (ref) => create(ref as AvailableProductsByFarmRef),
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
  AutoDisposeStreamProviderElement<List<ProductModel>> createElement() {
    return _AvailableProductsByFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableProductsByFarmProvider && other.farmId == farmId;
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
mixin AvailableProductsByFarmRef
    on AutoDisposeStreamProviderRef<List<ProductModel>> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _AvailableProductsByFarmProviderElement
    extends AutoDisposeStreamProviderElement<List<ProductModel>>
    with AvailableProductsByFarmRef {
  _AvailableProductsByFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as AvailableProductsByFarmProvider).farmId;
}

String _$allProductsHash() => r'4aaccda07cfa75ab1f4f53c49515aa91384f42b2';

/// All products across all farms
///
/// Copied from [allProducts].
@ProviderFor(allProducts)
final allProductsProvider =
    AutoDisposeStreamProvider<List<ProductModel>>.internal(
  allProducts,
  name: r'allProductsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllProductsRef = AutoDisposeStreamProviderRef<List<ProductModel>>;
String _$allAvailableProductsHash() =>
    r'd380d88ead254729d94f0f6edfdfd9af7b57e8f9';

/// All available products across all farms
///
/// Copied from [allAvailableProducts].
@ProviderFor(allAvailableProducts)
final allAvailableProductsProvider =
    AutoDisposeStreamProvider<List<ProductModel>>.internal(
  allAvailableProducts,
  name: r'allAvailableProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allAvailableProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllAvailableProductsRef
    = AutoDisposeStreamProviderRef<List<ProductModel>>;
String _$productsByCategoryHash() =>
    r'f0129383fae44f07c32b83e2702e2f4edeaf142f';

/// Products by category (across all farms)
///
/// Copied from [productsByCategory].
@ProviderFor(productsByCategory)
const productsByCategoryProvider = ProductsByCategoryFamily();

/// Products by category (across all farms)
///
/// Copied from [productsByCategory].
class ProductsByCategoryFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// Products by category (across all farms)
  ///
  /// Copied from [productsByCategory].
  const ProductsByCategoryFamily();

  /// Products by category (across all farms)
  ///
  /// Copied from [productsByCategory].
  ProductsByCategoryProvider call(
    ProductCategory category,
  ) {
    return ProductsByCategoryProvider(
      category,
    );
  }

  @override
  ProductsByCategoryProvider getProviderOverride(
    covariant ProductsByCategoryProvider provider,
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
  String? get name => r'productsByCategoryProvider';
}

/// Products by category (across all farms)
///
/// Copied from [productsByCategory].
class ProductsByCategoryProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// Products by category (across all farms)
  ///
  /// Copied from [productsByCategory].
  ProductsByCategoryProvider(
    ProductCategory category,
  ) : this._internal(
          (ref) => productsByCategory(
            ref as ProductsByCategoryRef,
            category,
          ),
          from: productsByCategoryProvider,
          name: r'productsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsByCategoryHash,
          dependencies: ProductsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              ProductsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  ProductsByCategoryProvider._internal(
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
    FutureOr<List<ProductModel>> Function(ProductsByCategoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductsByCategoryProvider._internal(
        (ref) => create(ref as ProductsByCategoryRef),
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
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _ProductsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByCategoryProvider && other.category == category;
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
mixin ProductsByCategoryRef
    on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `category` of this provider.
  ProductCategory get category;
}

class _ProductsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with ProductsByCategoryRef {
  _ProductsByCategoryProviderElement(super.provider);

  @override
  ProductCategory get category =>
      (origin as ProductsByCategoryProvider).category;
}

String _$freshProductsHash() => r'c88503f27679e25e18e39c1ad6995436084e02f1';

/// Fresh products
///
/// Copied from [freshProducts].
@ProviderFor(freshProducts)
final freshProductsProvider =
    AutoDisposeFutureProvider<List<ProductModel>>.internal(
  freshProducts,
  name: r'freshProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$freshProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FreshProductsRef = AutoDisposeFutureProviderRef<List<ProductModel>>;
String _$processedProductsHash() => r'0ee57386804513322ef1c21f3f0b942d0a0b9c87';

/// Processed products
///
/// Copied from [processedProducts].
@ProviderFor(processedProducts)
final processedProductsProvider =
    AutoDisposeFutureProvider<List<ProductModel>>.internal(
  processedProducts,
  name: r'processedProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$processedProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProcessedProductsRef = AutoDisposeFutureProviderRef<List<ProductModel>>;
String _$productsByVarietyHash() => r'21e46a5b03f84b78fa9e8d5a914ee28170a488a7';

/// Products by variety (across all farms)
///
/// Copied from [productsByVariety].
@ProviderFor(productsByVariety)
const productsByVarietyProvider = ProductsByVarietyFamily();

/// Products by variety (across all farms)
///
/// Copied from [productsByVariety].
class ProductsByVarietyFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// Products by variety (across all farms)
  ///
  /// Copied from [productsByVariety].
  const ProductsByVarietyFamily();

  /// Products by variety (across all farms)
  ///
  /// Copied from [productsByVariety].
  ProductsByVarietyProvider call(
    String variety,
  ) {
    return ProductsByVarietyProvider(
      variety,
    );
  }

  @override
  ProductsByVarietyProvider getProviderOverride(
    covariant ProductsByVarietyProvider provider,
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
  String? get name => r'productsByVarietyProvider';
}

/// Products by variety (across all farms)
///
/// Copied from [productsByVariety].
class ProductsByVarietyProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// Products by variety (across all farms)
  ///
  /// Copied from [productsByVariety].
  ProductsByVarietyProvider(
    String variety,
  ) : this._internal(
          (ref) => productsByVariety(
            ref as ProductsByVarietyRef,
            variety,
          ),
          from: productsByVarietyProvider,
          name: r'productsByVarietyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsByVarietyHash,
          dependencies: ProductsByVarietyFamily._dependencies,
          allTransitiveDependencies:
              ProductsByVarietyFamily._allTransitiveDependencies,
          variety: variety,
        );

  ProductsByVarietyProvider._internal(
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
    FutureOr<List<ProductModel>> Function(ProductsByVarietyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductsByVarietyProvider._internal(
        (ref) => create(ref as ProductsByVarietyRef),
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
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _ProductsByVarietyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByVarietyProvider && other.variety == variety;
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
mixin ProductsByVarietyRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `variety` of this provider.
  String get variety;
}

class _ProductsByVarietyProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with ProductsByVarietyRef {
  _ProductsByVarietyProviderElement(super.provider);

  @override
  String get variety => (origin as ProductsByVarietyProvider).variety;
}

String _$productCountByFarmHash() =>
    r'8daa40ab2168a713613438ae606cd07abdeaee92';

/// Product count for a farm
///
/// Copied from [productCountByFarm].
@ProviderFor(productCountByFarm)
const productCountByFarmProvider = ProductCountByFarmFamily();

/// Product count for a farm
///
/// Copied from [productCountByFarm].
class ProductCountByFarmFamily extends Family<AsyncValue<int>> {
  /// Product count for a farm
  ///
  /// Copied from [productCountByFarm].
  const ProductCountByFarmFamily();

  /// Product count for a farm
  ///
  /// Copied from [productCountByFarm].
  ProductCountByFarmProvider call(
    String farmId,
  ) {
    return ProductCountByFarmProvider(
      farmId,
    );
  }

  @override
  ProductCountByFarmProvider getProviderOverride(
    covariant ProductCountByFarmProvider provider,
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
  String? get name => r'productCountByFarmProvider';
}

/// Product count for a farm
///
/// Copied from [productCountByFarm].
class ProductCountByFarmProvider extends AutoDisposeFutureProvider<int> {
  /// Product count for a farm
  ///
  /// Copied from [productCountByFarm].
  ProductCountByFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => productCountByFarm(
            ref as ProductCountByFarmRef,
            farmId,
          ),
          from: productCountByFarmProvider,
          name: r'productCountByFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productCountByFarmHash,
          dependencies: ProductCountByFarmFamily._dependencies,
          allTransitiveDependencies:
              ProductCountByFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  ProductCountByFarmProvider._internal(
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
    FutureOr<int> Function(ProductCountByFarmRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductCountByFarmProvider._internal(
        (ref) => create(ref as ProductCountByFarmRef),
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
    return _ProductCountByFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductCountByFarmProvider && other.farmId == farmId;
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
mixin ProductCountByFarmRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _ProductCountByFarmProviderElement
    extends AutoDisposeFutureProviderElement<int> with ProductCountByFarmRef {
  _ProductCountByFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as ProductCountByFarmProvider).farmId;
}

String _$availableProductCountByFarmHash() =>
    r'6e259ff9998f3e445bbac4573ae78da43b81d52d';

/// Available product count for a farm
///
/// Copied from [availableProductCountByFarm].
@ProviderFor(availableProductCountByFarm)
const availableProductCountByFarmProvider = AvailableProductCountByFarmFamily();

/// Available product count for a farm
///
/// Copied from [availableProductCountByFarm].
class AvailableProductCountByFarmFamily extends Family<AsyncValue<int>> {
  /// Available product count for a farm
  ///
  /// Copied from [availableProductCountByFarm].
  const AvailableProductCountByFarmFamily();

  /// Available product count for a farm
  ///
  /// Copied from [availableProductCountByFarm].
  AvailableProductCountByFarmProvider call(
    String farmId,
  ) {
    return AvailableProductCountByFarmProvider(
      farmId,
    );
  }

  @override
  AvailableProductCountByFarmProvider getProviderOverride(
    covariant AvailableProductCountByFarmProvider provider,
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
  String? get name => r'availableProductCountByFarmProvider';
}

/// Available product count for a farm
///
/// Copied from [availableProductCountByFarm].
class AvailableProductCountByFarmProvider
    extends AutoDisposeFutureProvider<int> {
  /// Available product count for a farm
  ///
  /// Copied from [availableProductCountByFarm].
  AvailableProductCountByFarmProvider(
    String farmId,
  ) : this._internal(
          (ref) => availableProductCountByFarm(
            ref as AvailableProductCountByFarmRef,
            farmId,
          ),
          from: availableProductCountByFarmProvider,
          name: r'availableProductCountByFarmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableProductCountByFarmHash,
          dependencies: AvailableProductCountByFarmFamily._dependencies,
          allTransitiveDependencies:
              AvailableProductCountByFarmFamily._allTransitiveDependencies,
          farmId: farmId,
        );

  AvailableProductCountByFarmProvider._internal(
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
    FutureOr<int> Function(AvailableProductCountByFarmRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableProductCountByFarmProvider._internal(
        (ref) => create(ref as AvailableProductCountByFarmRef),
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
    return _AvailableProductCountByFarmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableProductCountByFarmProvider &&
        other.farmId == farmId;
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
mixin AvailableProductCountByFarmRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `farmId` of this provider.
  String get farmId;
}

class _AvailableProductCountByFarmProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with AvailableProductCountByFarmRef {
  _AvailableProductCountByFarmProviderElement(super.provider);

  @override
  String get farmId => (origin as AvailableProductCountByFarmProvider).farmId;
}

String _$randomProductsHash() => r'022dfa1fa6cf156018428eed5d8edd3bd73bac6a';

/// Get random PROCESSED products (max 4) for discover screen
/// Only shows processed products (spread, jam, juice, etc.), not fresh fruits
///
/// Copied from [randomProducts].
@ProviderFor(randomProducts)
final randomProductsProvider =
    AutoDisposeStreamProvider<List<ProductModel>>.internal(
  randomProducts,
  name: r'randomProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$randomProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RandomProductsRef = AutoDisposeStreamProviderRef<List<ProductModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
