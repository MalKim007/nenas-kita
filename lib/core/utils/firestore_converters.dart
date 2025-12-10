import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts Firestore Timestamp to DateTime and vice versa
/// Handles null timestamps (e.g., when FieldValue.serverTimestamp() hasn't synced yet)
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    if (timestamp == null) {
      // FieldValue.serverTimestamp() can be null until server sync
      return DateTime.now();
    }
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    // Fallback for unexpected types
    return DateTime.now();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

/// Converts nullable Firestore Timestamp to DateTime and vice versa
class NullableTimestampConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}

/// Converts Firestore GeoPoint for JSON serialization
class GeoPointConverter implements JsonConverter<GeoPoint, GeoPoint> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(GeoPoint geoPoint) => geoPoint;

  @override
  GeoPoint toJson(GeoPoint geoPoint) => geoPoint;
}

/// Converts nullable GeoPoint
class NullableGeoPointConverter implements JsonConverter<GeoPoint?, GeoPoint?> {
  const NullableGeoPointConverter();

  @override
  GeoPoint? fromJson(GeoPoint? geoPoint) => geoPoint;

  @override
  GeoPoint? toJson(GeoPoint? geoPoint) => geoPoint;
}

/// Extension to convert DocumentSnapshot to Map with id
extension DocumentSnapshotExtension on DocumentSnapshot<Map<String, dynamic>> {
  Map<String, dynamic> toMapWithId() {
    final data = this.data() ?? {};
    return {...data, 'id': id};
  }
}

/// Extension for QuerySnapshot
extension QuerySnapshotExtension on QuerySnapshot<Map<String, dynamic>> {
  List<Map<String, dynamic>> toListWithIds() {
    return docs.map((doc) => doc.toMapWithId()).toList();
  }
}
