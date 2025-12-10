import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/admin/models/announcement_model.dart';

/// Repository for announcement data operations in Firestore
class AnnouncementRepository {
  final FirebaseFirestore _firestore;

  AnnouncementRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('announcements');

  // ============ CREATE ============

  /// Create a new announcement and return the generated ID
  Future<String> create(AnnouncementModel announcement) async {
    final docRef = _collection.doc();
    final announcementWithId = announcement.copyWith(id: docRef.id);
    await docRef.set(announcementWithId.toFirestore());
    return docRef.id;
  }

  // ============ READ ============

  /// Get announcement by ID
  Future<AnnouncementModel?> getById(String announcementId) async {
    final doc = await _collection.doc(announcementId).get();
    if (!doc.exists) return null;
    return AnnouncementModel.fromFirestore(doc);
  }

  /// Get all active announcements (not expired)
  Future<List<AnnouncementModel>> getActive() async {
    final now = DateTime.now();

    // Get announcements with no expiry or expiry in future
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromFirestore(doc))
        .where((a) => a.expiresAt == null || a.expiresAt!.isAfter(now))
        .toList();
  }

  /// Get announcements for a specific role
  Future<List<AnnouncementModel>> getForRole(UserRole role) async {
    final now = DateTime.now();

    // Get all announcements and filter by role
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromFirestore(doc))
        .where((a) {
          // Not expired
          if (a.expiresAt != null && a.expiresAt!.isBefore(now)) return false;
          // Either targets all roles (empty list) or includes this role
          return a.targetRoles.isEmpty || a.targetRoles.contains(role.name);
        })
        .toList();
  }

  /// Get all announcements (including expired, for admin)
  Future<List<AnnouncementModel>> getAll() async {
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromFirestore(doc))
        .toList();
  }

  /// Get announcements by type
  Future<List<AnnouncementModel>> getByType(AnnouncementType type) async {
    final snapshot = await _collection
        .where('type', isEqualTo: type.name)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AnnouncementModel.fromFirestore(doc))
        .toList();
  }

  // ============ STREAMS ============

  /// Watch active announcements
  Stream<List<AnnouncementModel>> watchActive() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          return snapshot.docs
              .map((doc) => AnnouncementModel.fromFirestore(doc))
              .where((a) => a.expiresAt == null || a.expiresAt!.isAfter(now))
              .toList();
        });
  }

  /// Watch announcements for a role
  Stream<List<AnnouncementModel>> watchForRole(UserRole role) {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          return snapshot.docs
              .map((doc) => AnnouncementModel.fromFirestore(doc))
              .where((a) {
                if (a.expiresAt != null && a.expiresAt!.isBefore(now)) return false;
                return a.targetRoles.isEmpty || a.targetRoles.contains(role.name);
              })
              .toList();
        });
  }

  /// Watch all announcements (for admin)
  Stream<List<AnnouncementModel>> watchAll() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AnnouncementModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch a single announcement
  Stream<AnnouncementModel?> watchAnnouncement(String announcementId) {
    return _collection.doc(announcementId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AnnouncementModel.fromFirestore(doc);
    });
  }

  // ============ UPDATE ============

  /// Update announcement
  Future<void> update(AnnouncementModel announcement) async {
    await _collection.doc(announcement.id).set(announcement.toFirestore());
  }

  /// Update announcement title and body
  Future<void> updateContent(
    String announcementId, {
    required String title,
    required String body,
  }) async {
    await _collection.doc(announcementId).update({
      'title': title,
      'body': body,
    });
  }

  /// Update target roles
  Future<void> updateTargetRoles(
    String announcementId,
    List<String> targetRoles,
  ) async {
    await _collection.doc(announcementId).update({
      'targetRoles': targetRoles,
    });
  }

  /// Update expiry date
  Future<void> updateExpiry(
    String announcementId,
    DateTime? expiresAt,
  ) async {
    await _collection.doc(announcementId).update({
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt) : null,
    });
  }

  /// Expire announcement immediately
  Future<void> expireNow(String announcementId) async {
    await _collection.doc(announcementId).update({
      'expiresAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // ============ DELETE ============

  /// Delete announcement
  Future<void> delete(String announcementId) async {
    await _collection.doc(announcementId).delete();
  }

  /// Delete all expired announcements (cleanup)
  Future<int> deleteExpired() async {
    final now = DateTime.now();
    final snapshot = await _collection
        .where('expiresAt', isLessThan: Timestamp.fromDate(now))
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    return snapshot.docs.length;
  }

  // ============ UTILITIES ============

  /// Get active announcement count
  Future<int> getActiveCount() async {
    final active = await getActive();
    return active.length;
  }

  /// Get total announcement count
  Future<int> getTotalCount() async {
    final snapshot = await _collection.count().get();
    return snapshot.count ?? 0;
  }
}
