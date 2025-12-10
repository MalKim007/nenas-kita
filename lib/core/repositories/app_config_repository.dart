import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/core/models/app_config_model.dart';

/// Repository for app configuration data operations in Firestore
/// Uses a single document: appConfig/settings
class AppConfigRepository {
  final FirebaseFirestore _firestore;

  AppConfigRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get _document =>
      _firestore.collection('appConfig').doc('settings');

  // ============ READ ============

  /// Get app configuration
  Future<AppConfigModel> get() async {
    final doc = await _document.get();
    if (!doc.exists) {
      // Return defaults if document doesn't exist
      return AppConfigModel.defaults();
    }
    return AppConfigModel.fromFirestore(doc);
  }

  // ============ STREAM ============

  /// Watch app configuration for real-time updates
  Stream<AppConfigModel> watch() {
    return _document.snapshots().map((doc) {
      if (!doc.exists) {
        return AppConfigModel.defaults();
      }
      return AppConfigModel.fromFirestore(doc);
    });
  }

  // ============ UPDATE ============

  /// Update entire app configuration
  Future<void> update(AppConfigModel config) async {
    await _document.set(config.toFirestore());
  }

  /// Update minimum app version
  Future<void> updateMinAppVersion(String version) async {
    await _document.update({
      'minAppVersion': version,
    });
  }

  /// Update varieties list
  Future<void> updateVarieties(List<String> varieties) async {
    await _document.update({
      'varieties': varieties,
    });
  }

  /// Add a variety
  Future<void> addVariety(String variety) async {
    await _document.update({
      'varieties': FieldValue.arrayUnion([variety]),
    });
  }

  /// Remove a variety
  Future<void> removeVariety(String variety) async {
    await _document.update({
      'varieties': FieldValue.arrayRemove([variety]),
    });
  }

  /// Update districts list
  Future<void> updateDistricts(List<String> districts) async {
    await _document.update({
      'districts': districts,
    });
  }

  /// Update categories list
  Future<void> updateCategories(List<String> categories) async {
    await _document.update({
      'categories': categories,
    });
  }

  // ============ INITIALIZATION ============

  /// Initialize default configuration if it doesn't exist
  Future<void> initializeDefaults() async {
    final doc = await _document.get();
    if (!doc.exists) {
      await _document.set(AppConfigModel.defaults().toFirestore());
    }
  }

  /// Reset configuration to defaults
  Future<void> resetToDefaults() async {
    await _document.set(AppConfigModel.defaults().toFirestore());
  }
}
