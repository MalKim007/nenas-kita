import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';

/// Route guard helper functions for authentication and authorization
class RouteGuards {
  RouteGuards._();

  /// Routes that don't require authentication
  static const List<String> publicRoutes = [
    RouteNames.splash,
    RouteNames.login,
    RouteNames.register,
  ];

  /// Routes that require profile setup completion
  static const List<String> profileSetupRoutes = [
    RouteNames.profileSetup,
  ];

  /// Check if route is public (no auth required)
  static bool isPublicRoute(String location) {
    return publicRoutes.any((route) => location.startsWith(route));
  }

  /// Check if route is a profile setup route
  static bool isProfileSetupRoute(String location) {
    return profileSetupRoutes.any((route) => location.startsWith(route));
  }

  /// Check if route is an admin route
  static bool isAdminRoute(String location) {
    return location.startsWith('/admin');
  }

  /// Check if route is a farmer route
  static bool isFarmerRoute(String location) {
    return location.startsWith('/farmer');
  }

  /// Check if route is a buyer route
  static bool isBuyerRoute(String location) {
    return location.startsWith('/buyer');
  }

  /// Check if route is a planner route (requires actual farmer status)
  static bool isPlannerRoute(String location) {
    return location.startsWith('/farmer/planner');
  }

  /// Get home route based on user role
  static String getHomeRouteForRole(UserRole? role) {
    switch (role) {
      case UserRole.farmer:
        return RouteNames.farmerHome;
      case UserRole.buyer:
      case UserRole.wholesaler:
        return RouteNames.buyerHome;
      case UserRole.admin:
      case UserRole.superadmin:
        return RouteNames.adminDashboard;
      case null:
        return RouteNames.login;
    }
  }

  /// Main redirect logic for the app
  /// Returns null if no redirect needed, or the path to redirect to
  static String? redirect({
    required BuildContext context,
    required GoRouterState state,
    required bool isAuthenticated,
    required bool hasProfile,
    required UserRole? userRole,
    bool isActualFarmer = false,
  }) {
    final location = state.matchedLocation;

    // Allow splash screen always
    if (location == RouteNames.splash) {
      return null;
    }

    // Not authenticated - redirect to login (unless on public route)
    if (!isAuthenticated) {
      if (isPublicRoute(location)) {
        return null;
      }
      return RouteNames.login;
    }

    // Authenticated but no profile - allow navigation (profile setup is optional)
    // Registration flow handles initial profile setup navigation explicitly
    if (!hasProfile) {
      if (isProfileSetupRoute(location)) {
        return null;
      }
      // Don't force redirect to profileSetup - avatar is optional
      // User can add it later in settings
    }

    // Authenticated with profile - check role-based access
    if (isPublicRoute(location) || isProfileSetupRoute(location)) {
      // Already authenticated with profile, go to home
      return getHomeRouteForRole(userRole);
    }

    // Check role-based route access
    if (isAdminRoute(location)) {
      if (userRole != UserRole.admin && userRole != UserRole.superadmin) {
        return getHomeRouteForRole(userRole);
      }
    }

    if (isFarmerRoute(location)) {
      if (userRole != UserRole.farmer) {
        return getHomeRouteForRole(userRole);
      }

      // Check planner access - only for actual farmers (with farm acres)
      if (isPlannerRoute(location) && !isActualFarmer) {
        return RouteNames.farmerHome;
      }
    }

    if (isBuyerRoute(location)) {
      if (userRole != UserRole.buyer && userRole != UserRole.wholesaler) {
        return getHomeRouteForRole(userRole);
      }
    }

    // No redirect needed
    return null;
  }
}

/// Provider for redirect logic that watches auth and user state
String? appRouterRedirect(
  WidgetRef ref,
  BuildContext context,
  GoRouterState state,
) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  final currentAppUser = ref.watch(currentAppUserProvider);

  // Determine if user has completed profile setup
  final hasProfile = currentAppUser.value != null &&
                     currentAppUser.value!.name.isNotEmpty;

  final userRole = currentAppUser.value?.role;

  return RouteGuards.redirect(
    context: context,
    state: state,
    isAuthenticated: isAuthenticated,
    hasProfile: hasProfile,
    userRole: userRole,
  );
}
