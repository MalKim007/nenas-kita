import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';

/// Repository for product data operations in Firestore
/// Products are stored as subcollection: farms/{farmId}/products/{productId}
class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get products collection for a specific farm
  CollectionReference<Map<String, dynamic>> _productsCollection(String farmId) =>
      _firestore.collection('farms').doc(farmId).collection('products');

  /// Get all products across all farms (collection group query)
  Query<Map<String, dynamic>> get _allProductsQuery =>
      _firestore.collectionGroup('products');

  // ============ CREATE ============

  /// Create a new product and return the generated ID
  Future<String> create(String farmId, ProductModel product) async {
    final docRef = _productsCollection(farmId).doc();
    final productWithId = product.copyWith(id: docRef.id, farmId: farmId);
    await docRef.set(productWithId.toFirestore());
    return docRef.id;
  }

  // ============ READ ============

  /// Get product by ID
  Future<ProductModel?> getById(String farmId, String productId) async {
    final doc = await _productsCollection(farmId).doc(productId).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
  }

  /// Get all products for a farm
  Future<List<ProductModel>> getByFarm(String farmId) async {
    final snapshot = await _productsCollection(farmId).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
    }).toList();
  }

  /// Get available products for a farm
  Future<List<ProductModel>> getAvailableByFarm(String farmId) async {
    final snapshot = await _productsCollection(farmId)
        .where('stockStatus', isEqualTo: StockStatus.available.name)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
    }).toList();
  }

  /// Get all products by category (across all farms)
  Future<List<ProductModel>> getAllByCategory(ProductCategory category) async {
    final snapshot = await _allProductsQuery
        .where('category', isEqualTo: category.name)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      // Extract farmId from document path
      final farmId = doc.reference.parent.parent?.id ?? '';
      return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
    }).toList();
  }

  /// Get all products by variety (across all farms)
  Future<List<ProductModel>> getAllByVariety(String variety) async {
    final snapshot = await _allProductsQuery
        .where('variety', isEqualTo: variety)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final farmId = doc.reference.parent.parent?.id ?? '';
      return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
    }).toList();
  }

  // ============ STREAMS ============

  /// Watch products by farm
  Stream<List<ProductModel>> watchProductsByFarm(String farmId) {
    return _productsCollection(farmId).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
      }).toList(),
    );
  }

  /// Watch available products by farm
  Stream<List<ProductModel>> watchAvailableProducts(String farmId) {
    return _productsCollection(farmId)
        .where('stockStatus', isEqualTo: StockStatus.available.name)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
          }).toList(),
        );
  }

  /// Watch all products (across all farms)
  Stream<List<ProductModel>> watchAllProducts() {
    return _allProductsQuery.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        final farmId = doc.reference.parent.parent?.id ?? '';
        return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
      }).toList(),
    );
  }

  /// Watch all available products (across all farms)
  Stream<List<ProductModel>> watchAllAvailableProducts() {
    return _allProductsQuery
        .where('stockStatus', isEqualTo: StockStatus.available.name)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final farmId = doc.reference.parent.parent?.id ?? '';
            return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
          }).toList(),
        );
  }

  /// Watch a single product
  Stream<ProductModel?> watchProduct(String farmId, String productId) {
    return _productsCollection(farmId).doc(productId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data()!;
      return ProductModel.fromJson({...data, 'id': doc.id, 'farmId': farmId});
    });
  }

  // ============ UPDATE ============

  /// Update product document
  Future<void> update(String farmId, ProductModel product) async {
    await _productsCollection(farmId).doc(product.id).update({
      ...product.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update stock status
  Future<void> updateStockStatus(
    String farmId,
    String productId,
    StockStatus status,
  ) async {
    await _productsCollection(farmId).doc(productId).update({
      'stockStatus': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update price (also triggers price history via Cloud Function if set up)
  Future<void> updatePrice(
    String farmId,
    String productId, {
    required double price,
    double? wholesalePrice,
  }) async {
    final updateData = <String, dynamic>{
      'price': price,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (wholesalePrice != null) {
      updateData['wholesalePrice'] = wholesalePrice;
    }

    await _productsCollection(farmId).doc(productId).update(updateData);
  }

  /// Update product images
  Future<void> updateImages(
    String farmId,
    String productId,
    List<String> images,
  ) async {
    await _productsCollection(farmId).doc(productId).update({
      'images': images,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Add image to product
  Future<void> addImage(
    String farmId,
    String productId,
    String imageUrl,
  ) async {
    await _productsCollection(farmId).doc(productId).update({
      'images': FieldValue.arrayUnion([imageUrl]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove image from product
  Future<void> removeImage(
    String farmId,
    String productId,
    String imageUrl,
  ) async {
    await _productsCollection(farmId).doc(productId).update({
      'images': FieldValue.arrayRemove([imageUrl]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============ DELETE ============

  /// Delete product
  Future<void> delete(String farmId, String productId) async {
    await _productsCollection(farmId).doc(productId).delete();
  }

  /// Delete all products for a farm
  Future<void> deleteAllByFarm(String farmId) async {
    final snapshot = await _productsCollection(farmId).get();
    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // ============ UTILITIES ============

  /// Get product count for a farm
  Future<int> getCountByFarm(String farmId) async {
    final snapshot = await _productsCollection(farmId).count().get();
    return snapshot.count ?? 0;
  }

  /// Get available product count for a farm
  Future<int> getAvailableCountByFarm(String farmId) async {
    final snapshot = await _productsCollection(farmId)
        .where('stockStatus', isEqualTo: StockStatus.available.name)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
