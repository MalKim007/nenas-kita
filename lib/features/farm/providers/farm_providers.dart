import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/features/farm/models/farm_model.dart';
import 'package:nenas_kita/features/farm/repositories/farm_repository.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

part 'farm_providers.g.dart';

// ============ REPOSITORY ============

/// Farm repository provider
@Riverpod(keepAlive: true)
FarmRepository farmRepository(FarmRepositoryRef ref) {
  return FarmRepository();
}

// ============ SINGLE FARM ============

/// Get farm by ID
@riverpod
Stream<FarmModel?> farmById(FarmByIdRef ref, String farmId) {
  return ref.watch(farmRepositoryProvider).watchFarm(farmId);
}

// ============ MY FARMS ============

/// Current user's farms
@riverpod
Stream<List<FarmModel>> myFarms(MyFarmsRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(farmRepositoryProvider).watchFarmsByOwner(userId);
}

/// Current user's first farm (for single-farm users)
@riverpod
Stream<FarmModel?> myPrimaryFarm(MyPrimaryFarmRef ref) {
  // Watch the stream from myFarmsProvider and project to the first farm (or null)
  return ref
      .watch(myFarmsProvider.stream)
      .map((farms) => farms.isNotEmpty ? farms.first : null);
}

// ============ FARM LISTS ============

/// All active farms
@riverpod
Stream<List<FarmModel>> allFarms(AllFarmsRef ref) {
  return ref.watch(farmRepositoryProvider).watchAllFarms();
}

/// Farms by district
@riverpod
Stream<List<FarmModel>> farmsByDistrict(
  FarmsByDistrictRef ref,
  String district,
) {
  return ref.watch(farmRepositoryProvider).watchFarmsByDistrict(district);
}

/// Farms by owner
@riverpod
Stream<List<FarmModel>> farmsByOwner(FarmsByOwnerRef ref, String ownerId) {
  return ref.watch(farmRepositoryProvider).watchFarmsByOwner(ownerId);
}

/// Verified farms only
@riverpod
Stream<List<FarmModel>> verifiedFarms(VerifiedFarmsRef ref) {
  return ref.watch(farmRepositoryProvider).watchVerifiedFarms();
}

/// Unverified farms (pending verification - for admin)
@riverpod
Stream<List<FarmModel>> unverifiedFarms(UnverifiedFarmsRef ref) {
  return ref.watch(farmRepositoryProvider).watchUnverifiedFarms();
}

// ============ FARM SEARCH ============

/// Search farms by name
@riverpod
Future<List<FarmModel>> searchFarms(SearchFarmsRef ref, String query) async {
  if (query.isEmpty) return [];
  return ref.watch(farmRepositoryProvider).searchByName(query);
}

// ============ FARM STATS ============

/// Total farms count
@riverpod
Future<int> totalFarmsCount(TotalFarmsCountRef ref) async {
  return ref.watch(farmRepositoryProvider).getTotalCount();
}

/// Verified farms count
@riverpod
Future<int> verifiedFarmsCount(VerifiedFarmsCountRef ref) async {
  return ref.watch(farmRepositoryProvider).getVerifiedCount();
}

/// Farms count by district
@riverpod
Future<int> farmsCountByDistrict(
  FarmsCountByDistrictRef ref,
  String district,
) async {
  return ref.watch(farmRepositoryProvider).getCountByDistrict(district);
}

// ============ FARMER TYPE DETECTION ============

/// Check if current user is an actual farmer (has farm with land, not just a seller)
/// Returns false if: no farm exists, farm has no size, or size is 0
/// Used to determine access to Harvest Planner feature
@riverpod
bool isActualFarmer(IsActualFarmerRef ref) {
  final farmAsync = ref.watch(myPrimaryFarmProvider);
  final farm = farmAsync.value;
  if (farm == null) return false;
  return farm.farmSizeHectares != null && farm.farmSizeHectares! > 0;
}
