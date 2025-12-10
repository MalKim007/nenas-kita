import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

part 'farm_discovery_providers.freezed.dart';
part 'farm_discovery_providers.g.dart';

// ============================================================================
// Enums
// ============================================================================

enum FarmSortOption { distance, name }

// ============================================================================
// Models
// ============================================================================

@freezed
class FarmDiscoveryFilter with _$FarmDiscoveryFilter {
  const factory FarmDiscoveryFilter({
    @Default(null) District? district,
    @Default(false) bool verifiedOnly,
    @Default(false) bool hasDelivery,
    @Default(FarmSortOption.distance) FarmSortOption sortBy,
  }) = _FarmDiscoveryFilter;
}

@freezed
class FarmDiscoveryState with _$FarmDiscoveryState {
  const factory FarmDiscoveryState({
    @Default('') String searchQuery,
    @Default(FarmDiscoveryFilter()) FarmDiscoveryFilter filter,
  }) = _FarmDiscoveryState;
}

class FarmWithDistance {
  final FarmModel farm;
  final double? distanceKm;

  FarmWithDistance(this.farm, this.distanceKm);
}

// ============================================================================
// Providers
// ============================================================================

@riverpod
class FarmDiscoveryNotifier extends _$FarmDiscoveryNotifier {
  @override
  FarmDiscoveryState build() {
    return const FarmDiscoveryState();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilter(FarmDiscoveryFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void updateFilter({
    District? district,
    bool? verifiedOnly,
    bool? hasDelivery,
    FarmSortOption? sortBy,
  }) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        district: district,
        verifiedOnly: verifiedOnly ?? state.filter.verifiedOnly,
        hasDelivery: hasDelivery ?? state.filter.hasDelivery,
        sortBy: sortBy ?? state.filter.sortBy,
      ),
    );
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  void resetFilter() {
    state = state.copyWith(filter: const FarmDiscoveryFilter());
  }

  bool get hasActiveFilters {
    return state.filter.district != null ||
        state.filter.verifiedOnly ||
        state.filter.hasDelivery ||
        state.searchQuery.isNotEmpty;
  }

  int get activeFilterCount {
    int count = 0;
    if (state.filter.district != null) count++;
    if (state.filter.verifiedOnly) count++;
    if (state.filter.hasDelivery) count++;
    if (state.searchQuery.isNotEmpty) count++;
    return count;
  }
}

@riverpod
Future<Position?> cachedUserLocation(CachedUserLocationRef ref) async {
  // Keep alive for 5 minutes
  final link = ref.keepAlive();
  Timer? timer;

  ref.onDispose(() {
    timer?.cancel();
  });

  // Set up 5-minute cache expiration
  timer = Timer(const Duration(minutes: 5), () {
    link.close();
  });

  try {
    final locationService = ref.read(locationServiceProvider);
    final position = await locationService.getCurrentPosition();
    return position;
  } catch (e) {
    // Return null if location is unavailable
    return null;
  }
}

@riverpod
Future<List<FarmWithDistance>> filteredFarms(FilteredFarmsRef ref) async {
  final discoveryState = ref.watch(farmDiscoveryNotifierProvider);
  final searchQuery = discoveryState.searchQuery;
  final filter = discoveryState.filter;

  // Step 1: Get base list of farms
  List<FarmModel> farms;

  if (searchQuery.isNotEmpty) {
    // Use search if query is present
    farms = await ref.watch(searchFarmsProvider(searchQuery).future);
  } else if (filter.district != null) {
    // Filter by district if set
    farms = await ref.watch(
      farmsByDistrictProvider(filter.district!.displayName).future,
    );
  } else {
    // Get all farms
    farms = await ref.watch(allFarmsProvider.future);
  }

  // Step 2: Apply client-side filters
  if (filter.verifiedOnly) {
    farms = farms.where((farm) => farm.verifiedByLPNM).toList();
  }

  if (filter.hasDelivery) {
    farms = farms.where((farm) => farm.deliveryAvailable).toList();
  }

  // Step 3: Get user position for distance calculation
  final userPosition = await ref.watch(cachedUserLocationProvider.future);
  final locationService = ref.read(locationServiceProvider);

  // Step 4: Calculate distance for each farm
  final farmsWithDistance = farms.map((farm) {
    double? distanceKm;

    if (userPosition != null && farm.location != null) {
      try {
        distanceKm = locationService.calculateDistanceFromGeoPoints(
          GeoPoint(userPosition.latitude, userPosition.longitude),
          farm.location!,
        );
      } catch (e) {
        // Distance calculation failed, leave as null
        distanceKm = null;
      }
    }

    return FarmWithDistance(farm, distanceKm);
  }).toList();

  // Step 5: Sort based on selected option
  if (filter.sortBy == FarmSortOption.distance) {
    farmsWithDistance.sort((a, b) {
      // Nulls at the end
      if (a.distanceKm == null && b.distanceKm == null) return 0;
      if (a.distanceKm == null) return 1;
      if (b.distanceKm == null) return -1;
      return a.distanceKm!.compareTo(b.distanceKm!);
    });
  } else {
    // Sort by name
    farmsWithDistance.sort((a, b) {
      return a.farm.farmName
          .toLowerCase()
          .compareTo(b.farm.farmName.toLowerCase());
    });
  }

  return farmsWithDistance;
}

/// Get nearby farms (max 2)
/// If user has location: sort by distance and take 2 nearest
/// If no location: pick 2 random active farms
@riverpod
Future<List<FarmWithDistance>> nearbyFarms(NearbyFarmsRef ref) async {
  // Get all active farms
  final allFarmsList = await ref.watch(allFarmsProvider.future);

  // Filter only active farms
  final activeFarms = allFarmsList.where((farm) => farm.isActive).toList();

  if (activeFarms.isEmpty) {
    return [];
  }

  // Get user position
  final userPosition = await ref.watch(cachedUserLocationProvider.future);
  final locationService = ref.read(locationServiceProvider);

  if (userPosition != null) {
    // User has location: calculate distances and sort by nearest
    final farmsWithDistance = activeFarms.map((farm) {
      double? distanceKm;

      if (farm.location != null) {
        try {
          distanceKm = locationService.calculateDistanceFromGeoPoints(
            GeoPoint(userPosition.latitude, userPosition.longitude),
            farm.location!,
          );
        } catch (e) {
          // Distance calculation failed, leave as null
          distanceKm = null;
        }
      }

      return FarmWithDistance(farm, distanceKm);
    }).toList();

    // Sort by distance (nulls at the end)
    farmsWithDistance.sort((a, b) {
      if (a.distanceKm == null && b.distanceKm == null) return 0;
      if (a.distanceKm == null) return 1;
      if (b.distanceKm == null) return -1;
      return a.distanceKm!.compareTo(b.distanceKm!);
    });

    // Return top 2
    return farmsWithDistance.take(2).toList();
  } else {
    // No location: pick 2 random farms
    activeFarms.shuffle();
    return activeFarms
        .take(2)
        .map((farm) => FarmWithDistance(farm, null))
        .toList();
  }
}
