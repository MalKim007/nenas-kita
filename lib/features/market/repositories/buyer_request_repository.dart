import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/market/models/buyer_request_model.dart';

/// Repository for buyer request data operations in Firestore
class BuyerRequestRepository {
  final FirebaseFirestore _firestore;

  BuyerRequestRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('buyerRequests');

  // ============ CREATE ============

  /// Create a new buyer request and return the generated ID
  Future<String> create(BuyerRequestModel request) async {
    final docRef = _collection.doc();
    final requestWithId = request.copyWith(id: docRef.id);
    await docRef.set(requestWithId.toFirestore());
    return docRef.id;
  }

  // ============ READ ============

  /// Get buyer request by ID
  Future<BuyerRequestModel?> getById(String requestId) async {
    final doc = await _collection.doc(requestId).get();
    if (!doc.exists) return null;
    return BuyerRequestModel.fromFirestore(doc);
  }

  /// Get all open requests
  Future<List<BuyerRequestModel>> getOpenRequests() async {
    final snapshot = await _collection
        .where('status', isEqualTo: RequestStatus.open.name)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BuyerRequestModel.fromFirestore(doc))
        .toList();
  }

  /// Get requests by buyer
  Future<List<BuyerRequestModel>> getByBuyer(String buyerId) async {
    final snapshot = await _collection
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BuyerRequestModel.fromFirestore(doc))
        .toList();
  }

  /// Get open requests by district
  Future<List<BuyerRequestModel>> getOpenByDistrict(String district) async {
    final snapshot = await _collection
        .where('status', isEqualTo: RequestStatus.open.name)
        .where('deliveryDistrict', isEqualTo: district)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BuyerRequestModel.fromFirestore(doc))
        .toList();
  }

  /// Get open requests by category
  Future<List<BuyerRequestModel>> getOpenByCategory(ProductCategory category) async {
    final snapshot = await _collection
        .where('status', isEqualTo: RequestStatus.open.name)
        .where('category', isEqualTo: category.name)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BuyerRequestModel.fromFirestore(doc))
        .toList();
  }

  /// Get urgent requests (needed within 3 days)
  Future<List<BuyerRequestModel>> getUrgentRequests() async {
    final now = DateTime.now();
    final threeDaysLater = now.add(const Duration(days: 3));

    final snapshot = await _collection
        .where('status', isEqualTo: RequestStatus.open.name)
        .where('neededByDate', isLessThanOrEqualTo: Timestamp.fromDate(threeDaysLater))
        .where('neededByDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('neededByDate')
        .get();

    return snapshot.docs
        .map((doc) => BuyerRequestModel.fromFirestore(doc))
        .toList();
  }

  // ============ STREAMS ============

  /// Watch all open requests
  Stream<List<BuyerRequestModel>> watchOpenRequests() {
    return _collection
        .where('status', isEqualTo: RequestStatus.open.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BuyerRequestModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch requests by buyer
  Stream<List<BuyerRequestModel>> watchRequestsByBuyer(String buyerId) {
    return _collection
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BuyerRequestModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch open requests by district
  Stream<List<BuyerRequestModel>> watchOpenByDistrict(String district) {
    return _collection
        .where('status', isEqualTo: RequestStatus.open.name)
        .where('deliveryDistrict', isEqualTo: district)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BuyerRequestModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch a single request
  Stream<BuyerRequestModel?> watchRequest(String requestId) {
    return _collection.doc(requestId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return BuyerRequestModel.fromFirestore(doc);
    });
  }

  /// Watch all requests (for admin)
  Stream<List<BuyerRequestModel>> watchAllRequests() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BuyerRequestModel.fromFirestore(doc))
              .toList(),
        );
  }

  // ============ UPDATE ============

  /// Update buyer request
  Future<void> update(BuyerRequestModel request) async {
    await _collection.doc(request.id).set(request.toFirestore());
  }

  /// Fulfill request (farmer marks it as fulfilled)
  Future<void> fulfillRequest(
    String requestId, {
    required String farmId,
    required String farmName,
  }) async {
    await _collection.doc(requestId).update({
      'status': RequestStatus.fulfilled.name,
      'fulfilledByFarmId': farmId,
      'fulfilledByFarmName': farmName,
      'fulfilledAt': FieldValue.serverTimestamp(),
    });
  }

  /// Close request (buyer closes without fulfillment)
  Future<void> closeRequest(String requestId) async {
    await _collection.doc(requestId).update({
      'status': RequestStatus.closed.name,
    });
  }

  /// Reopen request
  Future<void> reopenRequest(String requestId) async {
    await _collection.doc(requestId).update({
      'status': RequestStatus.open.name,
      'fulfilledByFarmId': null,
      'fulfilledByFarmName': null,
      'fulfilledAt': null,
    });
  }

  /// Update needed by date
  Future<void> updateNeededByDate(String requestId, DateTime date) async {
    await _collection.doc(requestId).update({
      'neededByDate': Timestamp.fromDate(date),
    });
  }

  /// Update quantity
  Future<void> updateQuantity(String requestId, double quantityKg) async {
    await _collection.doc(requestId).update({
      'quantityKg': quantityKg,
    });
  }

  // ============ DELETE ============

  /// Delete buyer request
  Future<void> delete(String requestId) async {
    await _collection.doc(requestId).delete();
  }

  /// Delete all requests by buyer
  Future<void> deleteAllByBuyer(String buyerId) async {
    final snapshot = await _collection
        .where('buyerId', isEqualTo: buyerId)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ============ UTILITIES ============

  /// Get open requests count
  Future<int> getOpenCount() async {
    final snapshot = await _collection
        .where('status', isEqualTo: RequestStatus.open.name)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  /// Get requests count by buyer
  Future<int> getCountByBuyer(String buyerId) async {
    final snapshot = await _collection
        .where('buyerId', isEqualTo: buyerId)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  /// Get fulfilled requests count by farm
  Future<int> getFulfilledCountByFarm(String farmId) async {
    final snapshot = await _collection
        .where('fulfilledByFarmId', isEqualTo: farmId)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
