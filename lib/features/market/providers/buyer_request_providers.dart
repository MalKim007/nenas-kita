import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/market/models/buyer_request_model.dart';
import 'package:nenas_kita/features/market/repositories/buyer_request_repository.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

part 'buyer_request_providers.g.dart';

// ============ REPOSITORY ============

/// Buyer request repository provider
@Riverpod(keepAlive: true)
BuyerRequestRepository buyerRequestRepository(BuyerRequestRepositoryRef ref) {
  return BuyerRequestRepository();
}

// ============ SINGLE REQUEST ============

/// Get buyer request by ID
@riverpod
Stream<BuyerRequestModel?> buyerRequestById(
  BuyerRequestByIdRef ref,
  String requestId,
) {
  return ref.watch(buyerRequestRepositoryProvider).watchRequest(requestId);
}

// ============ MY REQUESTS ============

/// Current user's buyer requests
@riverpod
Stream<List<BuyerRequestModel>> myBuyerRequests(MyBuyerRequestsRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(buyerRequestRepositoryProvider).watchRequestsByBuyer(userId);
}

// ============ OPEN REQUESTS ============

/// All open requests
@riverpod
Stream<List<BuyerRequestModel>> openBuyerRequests(OpenBuyerRequestsRef ref) {
  return ref.watch(buyerRequestRepositoryProvider).watchOpenRequests();
}

/// Open requests by district
@riverpod
Stream<List<BuyerRequestModel>> openRequestsByDistrict(
  OpenRequestsByDistrictRef ref,
  String district,
) {
  return ref.watch(buyerRequestRepositoryProvider).watchOpenByDistrict(district);
}

/// Urgent requests (needed within 3 days)
@riverpod
Future<List<BuyerRequestModel>> urgentRequests(UrgentRequestsRef ref) async {
  return ref.watch(buyerRequestRepositoryProvider).getUrgentRequests();
}

// ============ REQUESTS BY CATEGORY ============

/// Open requests by category
@riverpod
Future<List<BuyerRequestModel>> openRequestsByCategory(
  OpenRequestsByCategoryRef ref,
  ProductCategory category,
) async {
  return ref.watch(buyerRequestRepositoryProvider).getOpenByCategory(category);
}

// ============ ALL REQUESTS ============

/// All requests (for admin)
@riverpod
Stream<List<BuyerRequestModel>> allBuyerRequests(AllBuyerRequestsRef ref) {
  return ref.watch(buyerRequestRepositoryProvider).watchAllRequests();
}

// ============ REQUEST STATS ============

/// Open requests count
@riverpod
Future<int> openRequestsCount(OpenRequestsCountRef ref) async {
  return ref.watch(buyerRequestRepositoryProvider).getOpenCount();
}

/// My requests count
@riverpod
Future<int> myRequestsCount(MyRequestsCountRef ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return 0;
  return ref.watch(buyerRequestRepositoryProvider).getCountByBuyer(userId);
}

/// Fulfilled requests count by farm
@riverpod
Future<int> fulfilledCountByFarm(
  FulfilledCountByFarmRef ref,
  String farmId,
) async {
  return ref.watch(buyerRequestRepositoryProvider).getFulfilledCountByFarm(farmId);
}
