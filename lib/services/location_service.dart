import 'dart:math';

import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

/// Service for device location and geolocation utilities
class LocationService {
  LocationService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Check and request location permission
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current device position
  Future<Position?> getCurrentPosition() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  /// Get last known position (faster, might be outdated)
  Future<Position?> getLastKnownPosition() async {
    return await Geolocator.getLastKnownPosition();
  }

  /// Convert Position to Firestore GeoPoint
  GeoPoint? positionToGeoPoint(Position? position) {
    if (position == null) return null;
    return GeoPoint(position.latitude, position.longitude);
  }

  /// Convert GeoPoint to coordinates map
  Map<String, double>? geoPointToMap(GeoPoint? geoPoint) {
    if (geoPoint == null) return null;
    return {
      'latitude': geoPoint.latitude,
      'longitude': geoPoint.longitude,
    };
  }

  /// Calculate distance between two points in kilometers
  double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(
          startLat,
          startLng,
          endLat,
          endLng,
        ) /
        1000; // Convert meters to km
  }

  /// Calculate distance from GeoPoints
  double calculateDistanceFromGeoPoints(GeoPoint start, GeoPoint end) {
    return calculateDistance(
      startLat: start.latitude,
      startLng: start.longitude,
      endLat: end.latitude,
      endLng: end.longitude,
    );
  }

  /// Get position stream for real-time updates
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// Open device location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings (for permission denied forever)
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Get bearing between two points
  double getBearing({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.bearingBetween(startLat, startLng, endLat, endLng);
  }

  /// Check if location is within Melaka region (approximate bounds)
  bool isWithinMelaka(double lat, double lng) {
    // Approximate Melaka bounds
    const double minLat = 2.0;
    const double maxLat = 2.6;
    const double minLng = 102.0;
    const double maxLng = 102.6;

    return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
  }

  /// Get district name from coordinates (simple bounds check)
  String? getDistrictFromCoordinates(double lat, double lng) {
    // Simplified district detection for Melaka
    // Alor Gajah: North-West
    if (lat > 2.3 && lng < 102.25) {
      return 'Alor Gajah';
    }
    // Jasin: East
    if (lng > 102.35) {
      return 'Jasin';
    }
    // Melaka Tengah: Central/South
    if (isWithinMelaka(lat, lng)) {
      return 'Melaka Tengah';
    }
    return null;
  }

  /// Calculate bounding box for a given center and radius (in km)
  Map<String, double> getBoundingBox({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  }) {
    // Earth radius in km
    const double earthRadius = 6371;

    final latDelta = (radiusKm / earthRadius) * (180 / pi);
    final lngDelta =
        (radiusKm / (earthRadius * cos(centerLat * pi / 180))) * (180 / pi);

    return {
      'minLat': centerLat - latDelta,
      'maxLat': centerLat + latDelta,
      'minLng': centerLng - lngDelta,
      'maxLng': centerLng + lngDelta,
    };
  }

  /// Reverse geocode coordinates to address using Nominatim (OpenStreetMap)
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1',
      );

      final response = await _dio.getUri<Map<String, dynamic>>(
        url,
        options: Options(
          headers: const {
            'User-Agent': 'NenasKita/1.0 (contact@nenaskita.my)',
            'Accept-Language': 'en',
          },
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!['display_name'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
