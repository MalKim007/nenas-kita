import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/admin/models/audit_log_model.dart';

/// Repository for audit log data operations in Firestore
/// Audit logs are CREATE + READ only (no updates or deletes for integrity)
class AuditLogRepository {
  final FirebaseFirestore _firestore;

  AuditLogRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('auditLogs');

  // ============ CREATE ============

  /// Create a new audit log entry and return the generated ID
  Future<String> create(AuditLogModel log) async {
    final docRef = _collection.doc();
    final logWithId = log.copyWith(id: docRef.id);
    await docRef.set(logWithId.toFirestore());
    return docRef.id;
  }

  /// Log an inspection
  Future<String> logInspection({
    required String adminId,
    required String adminName,
    required String farmId,
    required String farmName,
    String? notes,
    List<String> attachments = const [],
  }) async {
    return create(AuditLogModel(
      id: '',
      adminId: adminId,
      adminName: adminName,
      farmId: farmId,
      farmName: farmName,
      action: AuditAction.inspection,
      notes: notes,
      attachments: attachments,
      timestamp: DateTime.now(),
    ));
  }

  /// Log farm approval
  Future<String> logApproval({
    required String adminId,
    required String adminName,
    required String farmId,
    required String farmName,
    String? notes,
  }) async {
    return create(AuditLogModel(
      id: '',
      adminId: adminId,
      adminName: adminName,
      farmId: farmId,
      farmName: farmName,
      action: AuditAction.approved,
      notes: notes,
      timestamp: DateTime.now(),
    ));
  }

  /// Log farm rejection
  Future<String> logRejection({
    required String adminId,
    required String adminName,
    required String farmId,
    required String farmName,
    required String reason,
  }) async {
    return create(AuditLogModel(
      id: '',
      adminId: adminId,
      adminName: adminName,
      farmId: farmId,
      farmName: farmName,
      action: AuditAction.rejected,
      notes: reason,
      timestamp: DateTime.now(),
    ));
  }

  // ============ READ ============

  /// Get audit log by ID
  Future<AuditLogModel?> getById(String logId) async {
    final doc = await _collection.doc(logId).get();
    if (!doc.exists) return null;
    return AuditLogModel.fromFirestore(doc);
  }

  /// Get recent audit logs
  Future<List<AuditLogModel>> getRecent({int limit = 100}) async {
    final snapshot = await _collection
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => AuditLogModel.fromFirestore(doc))
        .toList();
  }

  /// Get audit logs by farm
  Future<List<AuditLogModel>> getByFarm(String farmId) async {
    final snapshot = await _collection
        .where('farmId', isEqualTo: farmId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AuditLogModel.fromFirestore(doc))
        .toList();
  }

  /// Get audit logs by admin
  Future<List<AuditLogModel>> getByAdmin(String adminId) async {
    final snapshot = await _collection
        .where('adminId', isEqualTo: adminId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AuditLogModel.fromFirestore(doc))
        .toList();
  }

  /// Get audit logs by action type
  Future<List<AuditLogModel>> getByAction(AuditAction action) async {
    final snapshot = await _collection
        .where('action', isEqualTo: action.name)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AuditLogModel.fromFirestore(doc))
        .toList();
  }

  /// Get audit logs for date range
  Future<List<AuditLogModel>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final snapshot = await _collection
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AuditLogModel.fromFirestore(doc))
        .toList();
  }

  // ============ STREAMS ============

  /// Watch recent audit logs
  Stream<List<AuditLogModel>> watchRecent({int limit = 100}) {
    return _collection
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AuditLogModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch audit logs by farm
  Stream<List<AuditLogModel>> watchByFarm(String farmId) {
    return _collection
        .where('farmId', isEqualTo: farmId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AuditLogModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch audit logs by admin
  Stream<List<AuditLogModel>> watchByAdmin(String adminId) {
    return _collection
        .where('adminId', isEqualTo: adminId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AuditLogModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch audit logs by action
  Stream<List<AuditLogModel>> watchByAction(AuditAction action) {
    return _collection
        .where('action', isEqualTo: action.name)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AuditLogModel.fromFirestore(doc))
              .toList(),
        );
  }

  // ============ UTILITIES ============

  /// Get total audit log count
  Future<int> getTotalCount() async {
    final snapshot = await _collection.count().get();
    return snapshot.count ?? 0;
  }

  /// Get count by action type
  Future<int> getCountByAction(AuditAction action) async {
    final snapshot = await _collection
        .where('action', isEqualTo: action.name)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  /// Get count for last N days
  Future<int> getCountForDays(int days) async {
    final startDate = DateTime.now().subtract(Duration(days: days));

    final snapshot = await _collection
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// Get latest audit action for a farm
  Future<AuditLogModel?> getLatestForFarm(String farmId) async {
    final snapshot = await _collection
        .where('farmId', isEqualTo: farmId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return AuditLogModel.fromFirestore(snapshot.docs.first);
  }
}
