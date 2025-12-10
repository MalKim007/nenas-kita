import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nenas_kita/core/constants/enums.dart';

// NOTE: currentUserIdProvider and isAuthenticatedProvider are defined in
// lib/services/providers/service_providers.dart - do not duplicate here

/// Selected role during signup flow (temporary state)
final selectedRoleProvider = StateProvider<UserRole?>((ref) => null);

/// Phone number being entered during login/register (temporary state)
final pendingPhoneProvider = StateProvider<String?>((ref) => null);

/// Whether auth operation is in progress
final isAuthLoadingProvider = StateProvider<bool>((ref) => false);

/// Notifier to trigger auth state refresh after login/logout
/// Increment this to force providers to re-read from Hive
final authRefreshNotifierProvider = StateProvider<int>((ref) => 0);

/// Helper to refresh auth state after login/register/logout
void refreshAuthState(WidgetRef ref) {
  ref.read(authRefreshNotifierProvider.notifier).state++;
}
