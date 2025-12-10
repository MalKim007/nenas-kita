import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nenas_kita/features/market/models/price_history_model.dart';

/// Repository for price history data operations in Firestore
/// This is primarily a READ-ONLY repository.
/// Writes should be done via Cloud Functions when product prices change.
class PriceHistoryRepository {
  final FirebaseFirestore _firestore;

  PriceHistoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('priceHistory');

  // ============ READ ============

  /// Get price history by ID
  Future<PriceHistoryModel?> getById(String historyId) async {
    final doc = await _collection.doc(historyId).get();
    if (!doc.exists) return null;
    return PriceHistoryModel.fromFirestore(doc);
  }

  /// Get recent price history (all products)
  Future<List<PriceHistoryModel>> getRecent({int limit = 50}) async {
    final snapshot = await _collection
        .orderBy('changedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => PriceHistoryModel.fromFirestore(doc))
        .toList();
  }

  /// Get price history by product
  Future<List<PriceHistoryModel>> getByProduct(
    String farmId,
    String productId, {
    int limit = 50,
  }) async {
    final snapshot = await _collection
        .where('farmId', isEqualTo: farmId)
        .where('productId', isEqualTo: productId)
        .orderBy('changedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => PriceHistoryModel.fromFirestore(doc))
        .toList();
  }

  /// Get price history by variety
  Future<List<PriceHistoryModel>> getByVariety(
    String variety, {
    int limit = 100,
  }) async {
    final snapshot = await _collection
        .where('variety', isEqualTo: variety)
        .orderBy('changedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => PriceHistoryModel.fromFirestore(doc))
        .toList();
  }

  /// Get price history for a date range
  Future<List<PriceHistoryModel>> getByDateRange(
    DateTime start,
    DateTime end, {
    String? variety,
    int limit = 500,
  }) async {
    Query<Map<String, dynamic>> query = _collection
        .where('changedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('changedAt', isLessThanOrEqualTo: Timestamp.fromDate(end));

    if (variety != null) {
      query = query.where('variety', isEqualTo: variety);
    }

    final snapshot = await query
        .orderBy('changedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => PriceHistoryModel.fromFirestore(doc))
        .toList();
  }

  // ============ STREAMS ============

  /// Watch recent price history
  Stream<List<PriceHistoryModel>> watchRecent({int limit = 50}) {
    return _collection
        .orderBy('changedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PriceHistoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch price history by product
  Stream<List<PriceHistoryModel>> watchByProduct(
    String farmId,
    String productId, {
    int limit = 50,
  }) {
    return _collection
        .where('farmId', isEqualTo: farmId)
        .where('productId', isEqualTo: productId)
        .orderBy('changedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PriceHistoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Watch price history by variety
  Stream<List<PriceHistoryModel>> watchByVariety(
    String variety, {
    int limit = 100,
  }) {
    return _collection
        .where('variety', isEqualTo: variety)
        .orderBy('changedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PriceHistoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  // ============ ANALYTICS ============

  /// Calculate average price for a variety over specified days
  Future<double?> getAveragePrice(String variety, {int days = 30}) async {
    final startDate = DateTime.now().subtract(Duration(days: days));

    final history = await getByDateRange(
      startDate,
      DateTime.now(),
      variety: variety,
    );

    if (history.isEmpty) return null;

    final sum = history.fold<double>(0, (acc, item) => acc + item.newPrice);
    return sum / history.length;
  }

  /// Get min/max prices for a variety over specified days
  Future<Map<String, double>?> getPriceRange(
    String variety, {
    int days = 30,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));

    final history = await getByDateRange(
      startDate,
      DateTime.now(),
      variety: variety,
    );

    if (history.isEmpty) return null;

    final prices = history.map((h) => h.newPrice).toList();
    prices.sort();

    return {
      'min': prices.first,
      'max': prices.last,
      'avg': prices.reduce((a, b) => a + b) / prices.length,
    };
  }

  /// Get price trend (positive = increasing, negative = decreasing)
  Future<double?> getPriceTrend(String variety, {int days = 7}) async {
    final history = await getByVariety(variety, limit: 20);

    if (history.length < 2) return null;

    // Compare first and last price in the period
    final oldestPrice = history.last.newPrice;
    final newestPrice = history.first.newPrice;

    if (oldestPrice == 0) return null;

    return ((newestPrice - oldestPrice) / oldestPrice) * 100;
  }

  /// Get daily average prices for chart
  Future<List<Map<String, dynamic>>> getDailyAverages(
    String variety, {
    int days = 30,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final history = await getByDateRange(
      startDate,
      DateTime.now(),
      variety: variety,
    );

    // Group by date and calculate averages
    final dailyPrices = <String, List<double>>{};

    for (final item in history) {
      final dateKey = '${item.changedAt.year}-${item.changedAt.month.toString().padLeft(2, '0')}-${item.changedAt.day.toString().padLeft(2, '0')}';
      dailyPrices.putIfAbsent(dateKey, () => []);
      dailyPrices[dateKey]!.add(item.newPrice);
    }

    return dailyPrices.entries.map((entry) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      return {
        'date': entry.key,
        'average': avg,
        'count': entry.value.length,
      };
    }).toList()
      ..sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
  }

  // ============ CREATE (For manual/admin use) ============

  /// Create a price history record (typically done by Cloud Function)
  Future<String> create(PriceHistoryModel history) async {
    final docRef = _collection.doc();
    final historyWithId = history.copyWith(id: docRef.id);
    await docRef.set(historyWithId.toFirestore());
    return docRef.id;
  }

  // ============ UTILITIES ============

  /// Get total price updates count
  Future<int> getTotalCount() async {
    final snapshot = await _collection.count().get();
    return snapshot.count ?? 0;
  }

  /// Get price updates count for last N days
  Future<int> getCountForDays(int days) async {
    final startDate = DateTime.now().subtract(Duration(days: days));

    final snapshot = await _collection
        .where('changedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .count()
        .get();

    return snapshot.count ?? 0;
  }
}
