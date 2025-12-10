import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// firebase_storage removed - using Cloudinary instead (see storage_service.dart)

/// Singleton service for Firebase instances and configuration
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;
  // storage removed - using Cloudinary instead (see storage_service.dart)
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  /// Configure Firestore settings for offline persistence
  Future<void> configureFirestore() async {
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // Auth convenience getters
  User? get currentUser => auth.currentUser;
  String? get currentUserId => currentUser?.uid;
  bool get isAuthenticated => currentUser != null;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Get a reference to a collection
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      firestore.collection(path);

  /// Get a reference to a document
  DocumentReference<Map<String, dynamic>> doc(String path) =>
      firestore.doc(path);

  /// Create a batch write
  WriteBatch batch() => firestore.batch();

  /// Run a transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler,
  ) =>
      firestore.runTransaction(transactionHandler);
}
