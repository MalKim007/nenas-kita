import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/auth/models/user_model.dart';

/// Repository for user data operations in Firestore
class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users');

  // ============ CREATE ============

  /// Create a new user document
  Future<void> create(UserModel user) async {
    final data = {
      ...user.toFirestore(),
      // Use server timestamps to satisfy security rules (createdAt == request.time)
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _collection.doc(user.id).set(data);
  }

  // ============ READ ============

  /// Get user by ID
  Future<UserModel?> getById(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Get user by email
  Future<UserModel?> getByEmail(String email) async {
    final snapshot = await _collection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return UserModel.fromFirestore(snapshot.docs.first);
  }

  /// Get all users by role
  Future<List<UserModel>> getByRole(UserRole role) async {
    final snapshot = await _collection
        .where('role', isEqualTo: role.name)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();
  }

  /// Get all users by district
  Future<List<UserModel>> getByDistrict(String district) async {
    final snapshot = await _collection
        .where('district', isEqualTo: district)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();
  }

  /// Get all farmers
  Future<List<UserModel>> getFarmers() async {
    return getByRole(UserRole.farmer);
  }

  /// Get all admins
  Future<List<UserModel>> getAdmins() async {
    final admins = await getByRole(UserRole.admin);
    final superAdmins = await getByRole(UserRole.superadmin);
    return [...admins, ...superAdmins];
  }

  // ============ STREAMS ============

  /// Watch user by ID (real-time updates)
  Stream<UserModel?> watchUser(String userId) {
    return _collection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Watch all users
  Stream<List<UserModel>> watchAllUsers() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList(),
    );
  }

  /// Watch users by role
  Stream<List<UserModel>> watchByRole(UserRole role) {
    return _collection
        .where('role', isEqualTo: role.name)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch users by district
  Stream<List<UserModel>> watchByDistrict(String district) {
    return _collection
        .where('district', isEqualTo: district)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .toList(),
        );
  }

  // ============ UPDATE ============

  /// Update user document
  Future<void> update(UserModel user) async {
    await _collection.doc(user.id).update({
      ...user.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update FCM token for push notifications
  Future<void> updateFcmToken(String userId, String? token) async {
    await _collection.doc(userId).update({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update user verification status
  Future<void> updateVerificationStatus(String userId, bool isVerified) async {
    await _collection.doc(userId).update({
      'isVerified': isVerified,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update user avatar URL
  Future<void> updateAvatarUrl(String userId, String? avatarUrl) async {
    await _collection.doc(userId).update({
      'avatarUrl': avatarUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update user district (for FCM topic management)
  Future<void> updateDistrict(String userId, String district) async {
    await _collection.doc(userId).update({
      'district': district,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============ DELETE ============

  /// Delete user document (hard delete - use with caution)
  Future<void> delete(String userId) async {
    await _collection.doc(userId).delete();
  }

  // ============ UTILITIES ============

  /// Check if email is already registered
  Future<bool> isEmailRegistered(String email) async {
    final user = await getByEmail(email);
    return user != null;
  }

  /// Get users count by role
  Future<int> getCountByRole(UserRole role) async {
    final snapshot = await _collection
        .where('role', isEqualTo: role.name)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
