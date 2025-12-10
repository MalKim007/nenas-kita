import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/auth/models/user_model.dart';
import 'package:nenas_kita/features/auth/repositories/user_repository.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

part 'user_providers.g.dart';

// ============ REPOSITORY ============

/// User repository provider
@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository();
}

// ============ CURRENT USER ============

/// Current app user (from Firestore, not Firebase Auth)
@riverpod
Stream<UserModel?> currentAppUser(CurrentAppUserRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUser(userId);
}

/// Current user role
@riverpod
UserRole? currentUserRole(CurrentUserRoleRef ref) {
  return ref.watch(currentAppUserProvider).value?.role;
}

/// Is current user admin
@riverpod
bool isCurrentUserAdmin(IsCurrentUserAdminRef ref) {
  return ref.watch(currentAppUserProvider).value?.isAdmin ?? false;
}

/// Is current user farmer
@riverpod
bool isCurrentUserFarmer(IsCurrentUserFarmerRef ref) {
  return ref.watch(currentUserRoleProvider) == UserRole.farmer;
}

/// Is current user buyer
@riverpod
bool isCurrentUserBuyer(IsCurrentUserBuyerRef ref) {
  final role = ref.watch(currentUserRoleProvider);
  return role == UserRole.buyer || role == UserRole.wholesaler;
}

/// Is current user wholesaler
@riverpod
bool isCurrentUserWholesaler(IsCurrentUserWholesalerRef ref) {
  return ref.watch(currentUserRoleProvider) == UserRole.wholesaler;
}

/// Can current user view wholesale prices
@riverpod
bool canViewWholesalePrices(CanViewWholesalePricesRef ref) {
  return ref.watch(currentAppUserProvider).value?.canViewWholesalePrices ?? false;
}

// ============ USER BY ID ============

/// Get user by ID
@riverpod
Stream<UserModel?> userById(UserByIdRef ref, String userId) {
  return ref.watch(userRepositoryProvider).watchUser(userId);
}

// ============ USER LISTS ============

/// All users stream
@riverpod
Stream<List<UserModel>> allUsers(AllUsersRef ref) {
  return ref.watch(userRepositoryProvider).watchAllUsers();
}

/// Users by role
@riverpod
Stream<List<UserModel>> usersByRole(UsersByRoleRef ref, UserRole role) {
  return ref.watch(userRepositoryProvider).watchByRole(role);
}

/// Users by district
@riverpod
Stream<List<UserModel>> usersByDistrict(UsersByDistrictRef ref, String district) {
  return ref.watch(userRepositoryProvider).watchByDistrict(district);
}

/// All farmers
@riverpod
Stream<List<UserModel>> allFarmers(AllFarmersRef ref) {
  return ref.watch(userRepositoryProvider).watchByRole(UserRole.farmer);
}

/// All buyers (including wholesalers)
@riverpod
Stream<List<UserModel>> allBuyers(AllBuyersRef ref) async* {
  final repo = ref.watch(userRepositoryProvider);
  await for (final buyers in repo.watchByRole(UserRole.buyer)) {
    await for (final wholesalers in repo.watchByRole(UserRole.wholesaler)) {
      yield [...buyers, ...wholesalers];
    }
  }
}

// ============ USER STATS ============

/// User count by role
@riverpod
Future<int> userCountByRole(UserCountByRoleRef ref, UserRole role) async {
  return ref.watch(userRepositoryProvider).getCountByRole(role);
}
