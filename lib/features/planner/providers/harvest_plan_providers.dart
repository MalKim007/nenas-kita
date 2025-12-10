import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/repositories/harvest_plan_repository.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

part 'harvest_plan_providers.g.dart';

// ============ REPOSITORY ============

/// Harvest plan repository provider
@Riverpod(keepAlive: true)
HarvestPlanRepository harvestPlanRepository(HarvestPlanRepositoryRef ref) {
  return HarvestPlanRepository();
}

// ============ SINGLE PLAN ============

/// Get harvest plan by ID
@riverpod
Stream<HarvestPlanModel?> harvestPlanById(HarvestPlanByIdRef ref, String planId) {
  return ref.watch(harvestPlanRepositoryProvider).watchPlan(planId);
}

// ============ MY PLANS ============

/// Current user's harvest plans
@riverpod
Stream<List<HarvestPlanModel>> myHarvestPlans(MyHarvestPlansRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(harvestPlanRepositoryProvider).watchPlansByOwner(userId);
}

/// Current user's upcoming harvests
@riverpod
Stream<List<HarvestPlanModel>> myUpcomingHarvests(MyUpcomingHarvestsRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(harvestPlanRepositoryProvider).watchUpcomingHarvests(userId);
}

/// Current user's overdue plans
@riverpod
Future<List<HarvestPlanModel>> myOverduePlans(MyOverduePlansRef ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(harvestPlanRepositoryProvider).getOverduePlans(userId);
}

// ============ PLANS BY FARM ============

/// Harvest plans for a specific farm
@riverpod
Stream<List<HarvestPlanModel>> harvestPlansByFarm(
  HarvestPlansByFarmRef ref,
  String farmId,
) {
  return ref.watch(harvestPlanRepositoryProvider).watchPlansByFarm(farmId);
}

// ============ ALL PLANS ============

/// All harvest plans (for admin/calendar view)
@riverpod
Stream<List<HarvestPlanModel>> allHarvestPlans(AllHarvestPlansRef ref) {
  return ref.watch(harvestPlanRepositoryProvider).watchAllPlans();
}

// ============ PLANS NEEDING ATTENTION ============

/// Plans needing reminder (7 days or less)
@riverpod
Future<List<HarvestPlanModel>> plansNeedingReminder(PlansNeedingReminderRef ref) async {
  return ref.watch(harvestPlanRepositoryProvider).getPlansNeedingReminder();
}

// ============ HARVEST STATS ============

/// Active harvest plans count for current user
@riverpod
Future<int> myActiveHarvestCount(MyActiveHarvestCountRef ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return 0;
  return ref.watch(harvestPlanRepositoryProvider).getActiveCountByOwner(userId);
}

/// Upcoming quantity by variety (aggregate)
@riverpod
Future<Map<String, double>> upcomingHarvestQuantity(
  UpcomingHarvestQuantityRef ref,
) async {
  return ref.watch(harvestPlanRepositoryProvider).getUpcomingQuantityByDistrict();
}
