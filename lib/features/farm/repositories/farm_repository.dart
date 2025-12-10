import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';

/// Repository for farm data operations in Firestore
class FarmRepository {
  final FirebaseFirestore _firestore;

  FarmRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('farms');

  // ============ CREATE ============

  /// Create a new farm and return the generated ID
  Future<String> create(FarmModel farm) async {
    final docRef = _collection.doc();
    final farmWithId = farm.copyWith(id: docRef.id);
    await docRef.set(farmWithId.toFirestore());
    return docRef.id;
  }

  // ============ READ ============

  /// Get farm by ID
  Future<FarmModel?> getById(String farmId) async {
    final doc = await _collection.doc(farmId).get();
    if (!doc.exists) return null;
    return FarmModel.fromFirestore(doc);
  }

  /// Get all farms by owner
  Future<List<FarmModel>> getByOwner(String ownerId) async {
    final snapshot = await _collection
        .where('ownerId', isEqualTo: ownerId)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => FarmModel.fromFirestore(doc))
        .toList();
  }

  /// Get all verified farms
  Future<List<FarmModel>> getVerifiedFarms() async {
    final snapshot = await _collection
        .where('verifiedByLPNM', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => FarmModel.fromFirestore(doc))
        .toList();
  }

  /// Get all unverified farms (pending verification)
  Future<List<FarmModel>> getUnverifiedFarms() async {
    final snapshot = await _collection
        .where('verifiedByLPNM', isEqualTo: false)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => FarmModel.fromFirestore(doc))
        .toList();
  }

  /// Get farms by district
  Future<List<FarmModel>> getByDistrict(String district) async {
    final snapshot = await _collection
        .where('district', isEqualTo: district)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => FarmModel.fromFirestore(doc))
        .toList();
  }

  /// Search farms by name
  Future<List<FarmModel>> searchByName(String query) async {
    // Firestore doesn't support native text search
    // This is a prefix-based search
    final snapshot = await _collection
        .where('isActive', isEqualTo: true)
        .orderBy('farmName')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => FarmModel.fromFirestore(doc))
        .toList();
  }

  // ============ STREAMS ============

  /// Watch a single farm
  Stream<FarmModel?> watchFarm(String farmId) {
    return _collection.doc(farmId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return FarmModel.fromFirestore(doc);
    });
  }

  /// Watch all active farms
  Stream<List<FarmModel>> watchAllFarms() {
    return _collection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FarmModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch farms by owner
  Stream<List<FarmModel>> watchFarmsByOwner(String ownerId) {
    return _collection
        .where('ownerId', isEqualTo: ownerId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FarmModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch farms by district
  Stream<List<FarmModel>> watchFarmsByDistrict(String district) {
    return _collection
        .where('district', isEqualTo: district)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FarmModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch verified farms only
  Stream<List<FarmModel>> watchVerifiedFarms() {
    return _collection
        .where('verifiedByLPNM', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FarmModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch unverified farms (for admin)
  Stream<List<FarmModel>> watchUnverifiedFarms() {
    return _collection
        .where('verifiedByLPNM', isEqualTo: false)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FarmModel.fromFirestore(doc))
              .toList(),
        );
  }

  // ============ UPDATE ============

  /// Update farm document
  Future<void> update(FarmModel farm) async {
    await _collection.doc(farm.id).update({
      ...farm.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Verify farm (admin action)
  Future<void> verifyFarm(String farmId, bool verified) async {
    await _collection.doc(farmId).update({
      'verifiedByLPNM': verified,
      'verifiedAt': verified ? FieldValue.serverTimestamp() : null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update farm location
  Future<void> updateLocation(
    String farmId,
    GeoPoint location,
    String address,
  ) async {
    await _collection.doc(farmId).update({
      'location': location,
      'address': address,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update farm varieties
  Future<void> updateVarieties(String farmId, List<String> varieties) async {
    await _collection.doc(farmId).update({
      'varieties': varieties,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============ DELETE ============

  /// Soft delete farm (set isActive = false)
  Future<void> delete(String farmId) async {
    await _collection.doc(farmId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Hard delete farm (only for superadmin)
  Future<void> hardDelete(String farmId) async {
    await _collection.doc(farmId).delete();
  }

  // ============ UTILITIES ============

  /// Get total farms count
  Future<int> getTotalCount() async {
    final snapshot = await _collection
        .where('isActive', isEqualTo: true)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  /// Get verified farms count
  Future<int> getVerifiedCount() async {
    final snapshot = await _collection
        .where('verifiedByLPNM', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  /// Get farms count by district
  Future<int> getCountByDistrict(String district) async {
    final snapshot = await _collection
        .where('district', isEqualTo: district)
        .where('isActive', isEqualTo: true)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
