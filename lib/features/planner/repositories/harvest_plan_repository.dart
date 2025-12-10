import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';

/// Repository for harvest plan data operations in Firestore
class HarvestPlanRepository {
  final FirebaseFirestore _firestore;

  HarvestPlanRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('harvestPlans');

  // ============ CREATE ============

  /// Create a new harvest plan and return the generated ID
  Future<String> create(HarvestPlanModel plan) async {
    final docRef = _collection.doc();
    final planWithId = plan.copyWith(id: docRef.id);
    await docRef.set(planWithId.toFirestore());
    return docRef.id;
  }

  // ============ READ ============

  /// Get harvest plan by ID
  Future<HarvestPlanModel?> getById(String planId) async {
    final doc = await _collection.doc(planId).get();
    if (!doc.exists) return null;
    return HarvestPlanModel.fromFirestore(doc);
  }

  /// Get all plans by owner
  Future<List<HarvestPlanModel>> getByOwner(String ownerId) async {
    final snapshot = await _collection
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('expectedHarvestDate')
        .get();

    return snapshot.docs
        .map((doc) => HarvestPlanModel.fromFirestore(doc))
        .toList();
  }

  /// Get all plans by farm
  Future<List<HarvestPlanModel>> getByFarm(String farmId) async {
    final snapshot = await _collection
        .where('farmId', isEqualTo: farmId)
        .orderBy('expectedHarvestDate')
        .get();

    return snapshot.docs
        .map((doc) => HarvestPlanModel.fromFirestore(doc))
        .toList();
  }

  /// Get upcoming harvests for owner (next 30 days)
  Future<List<HarvestPlanModel>> getUpcomingHarvests(String ownerId) async {
    final now = DateTime.now();
    final thirtyDaysLater = now.add(const Duration(days: 30));

    final snapshot = await _collection
        .where('ownerId', isEqualTo: ownerId)
        .where(
          'status',
          whereIn: [
            HarvestStatus.planned.name,
            HarvestStatus.growing.name,
            HarvestStatus.ready.name,
          ],
        )
        .where('expectedHarvestDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .where('expectedHarvestDate', isLessThanOrEqualTo: Timestamp.fromDate(thirtyDaysLater))
        .orderBy('expectedHarvestDate')
        .get();

    return snapshot.docs
        .map((doc) => HarvestPlanModel.fromFirestore(doc))
        .toList();
  }

  /// Get overdue plans for owner
  Future<List<HarvestPlanModel>> getOverduePlans(String ownerId) async {
    final now = DateTime.now();

    final snapshot = await _collection
        .where('ownerId', isEqualTo: ownerId)
        .where('status', whereIn: [HarvestStatus.growing.name, HarvestStatus.ready.name])
        .where('expectedHarvestDate', isLessThan: Timestamp.fromDate(now))
        .get();

    return snapshot.docs
        .map((doc) => HarvestPlanModel.fromFirestore(doc))
        .toList();
  }

  /// Get plans needing reminder (7 days or less until harvest, reminder not sent)
  Future<List<HarvestPlanModel>> getPlansNeedingReminder() async {
    final now = DateTime.now();
    final sevenDaysLater = now.add(const Duration(days: 7));

    final snapshot = await _collection
        .where('status', isEqualTo: HarvestStatus.growing.name)
        .where('reminderSent', isEqualTo: false)
        .where('expectedHarvestDate', isLessThanOrEqualTo: Timestamp.fromDate(sevenDaysLater))
        .where('expectedHarvestDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .get();

    return snapshot.docs
        .map((doc) => HarvestPlanModel.fromFirestore(doc))
        .toList();
  }

  // ============ STREAMS ============

  /// Watch plans by owner
  Stream<List<HarvestPlanModel>> watchPlansByOwner(String ownerId) {
    return _collection
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('expectedHarvestDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HarvestPlanModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch plans by farm
  Stream<List<HarvestPlanModel>> watchPlansByFarm(String farmId) {
    return _collection
        .where('farmId', isEqualTo: farmId)
        .orderBy('expectedHarvestDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HarvestPlanModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch upcoming harvests for owner
  Stream<List<HarvestPlanModel>> watchUpcomingHarvests(String ownerId) {
    final now = DateTime.now();

    return _collection
        .where('ownerId', isEqualTo: ownerId)
        .where(
          'status',
          whereIn: [
            HarvestStatus.planned.name,
            HarvestStatus.growing.name,
            HarvestStatus.ready.name,
          ],
        )
        .where('expectedHarvestDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('expectedHarvestDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HarvestPlanModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch a single plan
  Stream<HarvestPlanModel?> watchPlan(String planId) {
    return _collection.doc(planId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return HarvestPlanModel.fromFirestore(doc);
    });
  }

  /// Watch all plans (for admin/calendar view)
  Stream<List<HarvestPlanModel>> watchAllPlans() {
    return _collection
        .orderBy('expectedHarvestDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HarvestPlanModel.fromFirestore(doc))
              .toList(),
        );
  }

  // ============ UPDATE ============

  /// Update harvest plan
  Future<void> update(HarvestPlanModel plan) async {
    await _collection.doc(plan.id).set(plan.toFirestore());
  }

  /// Update status
  Future<void> updateStatus(String planId, HarvestStatus status) async {
    final updateData = <String, dynamic>{
      'status': status.name,
    };

    if (status == HarvestStatus.harvested) {
      updateData['actualHarvestDate'] = FieldValue.serverTimestamp();
    }

    await _collection.doc(planId).update(updateData);
  }

  /// Mark reminder as sent
  Future<void> markReminderSent(String planId) async {
    await _collection.doc(planId).update({
      'reminderSent': true,
    });
  }

  /// Update expected harvest date
  Future<void> updateExpectedDate(String planId, DateTime date) async {
    await _collection.doc(planId).update({
      'expectedHarvestDate': Timestamp.fromDate(date),
    });
  }

  /// Update quantity
  Future<void> updateQuantity(String planId, double quantityKg) async {
    await _collection.doc(planId).update({
      'quantityKg': quantityKg,
    });
  }

  /// Add notes
  Future<void> updateNotes(String planId, String? notes) async {
    await _collection.doc(planId).update({
      'notes': notes,
    });
  }

  // ============ DELETE ============

  /// Delete harvest plan
  Future<void> delete(String planId) async {
    await _collection.doc(planId).delete();
  }

  /// Delete all plans for a farm
  Future<void> deleteAllByFarm(String farmId) async {
    final snapshot = await _collection
        .where('farmId', isEqualTo: farmId)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ============ UTILITIES ============

  /// Get total planned quantity for upcoming harvests by district
  Future<Map<String, double>> getUpcomingQuantityByDistrict() async {
    final now = DateTime.now();
    final thirtyDaysLater = now.add(const Duration(days: 30));

    // This requires getting farms to know districts, which requires a join
    // For simplicity, we can denormalize district into harvest plan or use client-side processing
    final snapshot = await _collection
        .where('status', whereIn: [HarvestStatus.growing.name, HarvestStatus.ready.name])
        .where('expectedHarvestDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .where('expectedHarvestDate', isLessThanOrEqualTo: Timestamp.fromDate(thirtyDaysLater))
        .get();

    // For now, aggregate by variety as a placeholder
    final plans = snapshot.docs.map((doc) => HarvestPlanModel.fromFirestore(doc)).toList();

    final result = <String, double>{};
    for (final plan in plans) {
      result[plan.variety] = (result[plan.variety] ?? 0) + plan.quantityKg;
    }
    return result;
  }

  /// Get count of active plans by owner
  Future<int> getActiveCountByOwner(String ownerId) async {
    final snapshot = await _collection
        .where('ownerId', isEqualTo: ownerId)
        .where('status', whereIn: [
          HarvestStatus.planned.name,
          HarvestStatus.growing.name,
          HarvestStatus.ready.name,
        ])
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
