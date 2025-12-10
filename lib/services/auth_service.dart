import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/auth/models/user_model.dart';

/// Service for email/password authentication using Firebase Auth
/// Uses Firebase Auth for authentication, Firestore for user data, and Hive for local session
class AuthService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _authBoxName = 'auth';
  static const String _userIdKey = 'userId';

  AuthService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // ============ SESSION MANAGEMENT ============

  /// Get current user ID from local storage
  String? get currentUserId {
    final box = Hive.box(_authBoxName);
    return box.get(_userIdKey) as String?;
  }

  /// Check if user is authenticated (has stored userId)
  bool get isAuthenticated => currentUserId != null;

  /// Save user ID to local storage
  Future<void> _saveUserId(String userId) async {
    final box = Hive.box(_authBoxName);
    await box.put(_userIdKey, userId);
  }

  /// Clear user ID from local storage
  Future<void> _clearUserId() async {
    final box = Hive.box(_authBoxName);
    await box.delete(_userIdKey);
  }

  // ============ EMAIL HELPERS ============

  /// Basic email format validation
  bool isValidEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed);
  }

  // ============ AUTHENTICATION ============

  /// Login with email and password using Firebase Auth
  /// Returns user if login successful, null if credentials invalid
  Future<UserModel?> loginWithPassword(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      // Sign in with Firebase Auth
      final credential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      if (credential.user == null) {
        return null;
      }

      // Get user document directly by Firebase Auth UID (document ID = Firebase Auth UID)
      final firebaseUid = credential.user!.uid;
      final doc = await _usersCollection.doc(firebaseUid).get();

      if (!doc.exists) {
        // Fallback: find by firebaseUid field (for backwards compatibility)
        final snapshot = await _usersCollection
            .where('firebaseUid', isEqualTo: firebaseUid)
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          await _auth.signOut();
          return null;
        }

        final user = UserModel.fromFirestore(snapshot.docs.first);
        await _saveUserId(user.id);
        return user;
      }

      final user = UserModel.fromFirestore(doc);
      await _saveUserId(user.id);
      return user;
    } on FirebaseAuthException {
      return null; // Invalid credentials
    }
  }

  /// Register a new user with password
  /// Creates Firebase Auth account and Firestore user document
  /// Throws exception if email already registered
  Future<UserModel> registerWithPassword({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    // Note: Firebase Auth handles duplicate email check automatically
    // and throws 'email-already-in-use' error which we handle below

    try {
      // Create Firebase Auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Failed to create authentication account');
      }

      // Create new user document using Firebase Auth UID as document ID
      // This ensures ownerId matches request.auth.uid in security rules
      final firebaseUid = credential.user!.uid;
      final docRef = _usersCollection.doc(firebaseUid);
      final user = UserModel(
        id: firebaseUid,
        name: name,
        email: normalizedEmail,
        role: role,
        createdAt: DateTime.now(),
        firebaseUid: firebaseUid,
        hasPassword: true,
      );

      try {
        // Save to Firestore with server timestamp
        await docRef.set({
          ...user.toFirestore(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Save userId to local storage
        await _saveUserId(user.id);

        return user;
      } catch (firestoreError) {
        // Rollback: delete Firebase Auth account if Firestore write fails
        await credential.user?.delete();
        rethrow;
      }
    } on FirebaseAuthException catch (e) {
      // Surface known auth errors (like duplicate email) to the UI layer
      throw FirebaseAuthException(
        code: e.code,
        message: e.message,
        email: normalizedEmail,
      );
    }
  }

  /// Change password for current user
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('Not authenticated');
    }

    // Re-authenticate with current password
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);

    // Update password
    await user.updatePassword(newPassword);
  }

  /// Check if email is registered
  Future<bool> isEmailRegistered(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final snapshot = await _usersCollection
        .where('email', isEqualTo: normalizedEmail)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// Get current user from Firestore
  Future<UserModel?> getCurrentUser() async {
    final userId = currentUserId;
    if (userId == null) return null;

    final doc = await _usersCollection.doc(userId).get();
    if (!doc.exists) {
      // User document doesn't exist, clear local storage
      await _clearUserId();
      return null;
    }

    return UserModel.fromFirestore(doc);
  }

  /// Watch current user (real-time updates)
  Stream<UserModel?> watchCurrentUser() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value(null);
    }

    return _usersCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Sign out - clear local storage and Firebase Auth
  Future<void> signOut() async {
    await _auth.signOut();
    await _clearUserId();
  }
}
