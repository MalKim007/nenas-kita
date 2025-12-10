import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';
import 'package:nenas_kita/features/product/repositories/product_repository.dart';

part 'product_providers.g.dart';

// ============ REPOSITORY ============

/// Product repository provider
@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository();
}

// ============ SINGLE PRODUCT ============

/// Get product by farm ID and product ID
@riverpod
Stream<ProductModel?> productById(
  ProductByIdRef ref,
  String farmId,
  String productId,
) {
  return ref.watch(productRepositoryProvider).watchProduct(farmId, productId);
}

// ============ PRODUCTS BY FARM ============

/// All products for a farm
@riverpod
Stream<List<ProductModel>> productsByFarm(ProductsByFarmRef ref, String farmId) {
  return ref.watch(productRepositoryProvider).watchProductsByFarm(farmId);
}

/// Available products for a farm
@riverpod
Stream<List<ProductModel>> availableProductsByFarm(
  AvailableProductsByFarmRef ref,
  String farmId,
) {
  return ref.watch(productRepositoryProvider).watchAvailableProducts(farmId);
}

// ============ ALL PRODUCTS ============

/// All products across all farms
@riverpod
Stream<List<ProductModel>> allProducts(AllProductsRef ref) {
  return ref.watch(productRepositoryProvider).watchAllProducts();
}

/// All available products across all farms
@riverpod
Stream<List<ProductModel>> allAvailableProducts(AllAvailableProductsRef ref) {
  return ref.watch(productRepositoryProvider).watchAllAvailableProducts();
}

// ============ PRODUCTS BY CATEGORY ============

/// Products by category (across all farms)
@riverpod
Future<List<ProductModel>> productsByCategory(
  ProductsByCategoryRef ref,
  ProductCategory category,
) async {
  return ref.watch(productRepositoryProvider).getAllByCategory(category);
}

/// Fresh products
@riverpod
Future<List<ProductModel>> freshProducts(FreshProductsRef ref) async {
  return ref.watch(productRepositoryProvider).getAllByCategory(ProductCategory.fresh);
}

/// Processed products
@riverpod
Future<List<ProductModel>> processedProducts(ProcessedProductsRef ref) async {
  return ref.watch(productRepositoryProvider).getAllByCategory(ProductCategory.processed);
}

// ============ PRODUCTS BY VARIETY ============

/// Products by variety (across all farms)
@riverpod
Future<List<ProductModel>> productsByVariety(
  ProductsByVarietyRef ref,
  String variety,
) async {
  return ref.watch(productRepositoryProvider).getAllByVariety(variety);
}

// ============ PRODUCT STATS ============

/// Product count for a farm
@riverpod
Future<int> productCountByFarm(ProductCountByFarmRef ref, String farmId) async {
  return ref.watch(productRepositoryProvider).getCountByFarm(farmId);
}

/// Available product count for a farm
@riverpod
Future<int> availableProductCountByFarm(
  AvailableProductCountByFarmRef ref,
  String farmId,
) async {
  return ref.watch(productRepositoryProvider).getAvailableCountByFarm(farmId);
}

// ============ RANDOM PRODUCTS ============

/// Get random PROCESSED products (max 4) for discover screen
/// Only shows processed products (spread, jam, juice, etc.), not fresh fruits
@riverpod
Stream<List<ProductModel>> randomProducts(RandomProductsRef ref) {
  final repository = ref.watch(productRepositoryProvider);

  // Watch all products and filter for processed category only
  return repository.watchAllProducts().map((allProductsList) {
    if (allProductsList.isEmpty) {
      return <ProductModel>[];
    }

    // Filter for processed products only
    final processedProducts = allProductsList
        .where((p) => p.category == ProductCategory.processed)
        .toList();

    if (processedProducts.isEmpty) {
      return <ProductModel>[];
    }

    // Shuffle and return max 4 random processed products
    processedProducts.shuffle();
    return processedProducts.take(4).toList();
  });
}
