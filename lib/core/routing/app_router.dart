import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/routing/route_guards.dart';
import 'package:nenas_kita/core/routing/page_transitions.dart';
import 'package:nenas_kita/core/widgets/farmer_shell.dart';
import 'package:nenas_kita/core/widgets/buyer_shell.dart';
// Buyer screens
import 'package:nenas_kita/features/market/screens/buyer_discover_screen.dart';
import 'package:nenas_kita/features/market/screens/farm_discovery_screen.dart';
import 'package:nenas_kita/features/market/screens/buyer_farm_detail_screen.dart';
import 'package:nenas_kita/features/market/screens/buyer_farm_products_screen.dart';
import 'package:nenas_kita/features/market/screens/product_comparison_screen.dart';
import 'package:nenas_kita/features/market/screens/buyer_settings_screen.dart';
import 'package:nenas_kita/features/market/screens/buyer_product_detail_screen.dart';
import 'package:nenas_kita/features/market/screens/price_history_screen.dart';
import 'package:nenas_kita/features/product/models/product_model.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/auth/screens/splash_screen.dart';
import 'package:nenas_kita/features/auth/screens/login_screen.dart';
import 'package:nenas_kita/features/auth/screens/register_screen.dart';
import 'package:nenas_kita/features/auth/screens/profile_setup_screen.dart';
// Farmer screens
import 'package:nenas_kita/features/farm/screens/farmer_home_screen.dart';
import 'package:nenas_kita/features/farm/screens/farm_profile_screen.dart';
import 'package:nenas_kita/features/farm/screens/farm_setup_screen.dart';
import 'package:nenas_kita/features/farm/screens/farm_edit_screen.dart';
import 'package:nenas_kita/features/product/screens/products_list_screen.dart';
import 'package:nenas_kita/features/product/screens/product_add_screen.dart';
import 'package:nenas_kita/features/product/screens/product_edit_screen.dart';
import 'package:nenas_kita/features/product/screens/product_detail_screen.dart';
// Settings screens
import 'package:nenas_kita/features/settings/screens/farmer_settings_screen.dart';
import 'package:nenas_kita/features/settings/screens/about_screen.dart';
import 'package:nenas_kita/features/settings/screens/change_password_screen.dart';
// Planner screens
import 'package:nenas_kita/features/planner/screens/planner_list_screen.dart';
import 'package:nenas_kita/features/planner/screens/planner_add_screen.dart';
import 'package:nenas_kita/features/planner/screens/planner_detail_screen.dart';
import 'package:nenas_kita/features/planner/screens/planner_edit_screen.dart';
import 'package:nenas_kita/features/planner/screens/planner_calendar_screen.dart';

part 'app_router.g.dart';

// Navigator keys for StatefulShellRoute branches
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _farmerHomeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'farmerHome',
);
final _farmerProductsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'farmerProducts',
);
final _farmerPlannerNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'farmerPlanner',
);
final _farmerSettingsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'farmerSettings',
);

// Buyer navigator keys
final _buyerDiscoverNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'buyerDiscover',
);
final _buyerMarketNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'buyerMarket',
);
final _buyerSettingsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'buyerSettings',
);

/// GoRouter provider with auth state refresh
@riverpod
GoRouter appRouter(Ref ref) {
  // Watch current app user to refresh router on auth changes
  final currentAppUser = ref.watch(currentAppUserProvider);
  final authService = ref.watch(authServiceProvider);

  // Watch user's primary farm to determine if they're an actual farmer
  final myFarmAsync = ref.watch(myPrimaryFarmProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    refreshListenable: _RouterRefreshStream(ref),
    redirect: (context, state) {
      // Check if user has stored userId in Hive
      final isAuthenticated = authService.isAuthenticated;
      final location = state.matchedLocation;

      // Handle loading state for authenticated users
      if (currentAppUser.isLoading && isAuthenticated) {
        // If on public route (login/register), redirect to splash to wait for data
        if (RouteGuards.isPublicRoute(location) &&
            location != RouteNames.splash) {
          return RouteNames.splash;
        }
        // For other routes, stay put while loading (prevents flash to profileSetup)
        return null;
      }

      final hasProfile =
          currentAppUser.value != null && currentAppUser.value!.name.isNotEmpty;
      final userRole = currentAppUser.value?.role;

      // Check if user is an actual farmer (has farm with acres > 0)
      final myFarm = myFarmAsync.value;
      final isActualFarmer = myFarm != null &&
          myFarm.farmSizeHectares != null &&
          myFarm.farmSizeHectares! > 0;

      return RouteGuards.redirect(
        context: context,
        state: state,
        isAuthenticated: isAuthenticated,
        hasProfile: hasProfile,
        userRole: userRole,
        isActualFarmer: isActualFarmer,
      );
    },
    routes: [
      // ============ AUTH ROUTES ============
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
          child: const SplashScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => AppPageTransitions.scaleFade(
          child: const LoginScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => AppPageTransitions.slideFromRight(
          child: const RegisterScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: RouteNames.profileSetup,
        name: 'profileSetup',
        pageBuilder: (context, state) => AppPageTransitions.slideFromRight(
          child: const ProfileSetupScreen(),
          state: state,
        ),
      ),

      // ============ FARMER ROUTES (with bottom navigation) ============
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            FarmerShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Home tab
          StatefulShellBranch(
            navigatorKey: _farmerHomeNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.farmerHome,
                name: 'farmerHome',
                pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
                  child: const FarmerHomeScreen(),
                  state: state,
                ),
                routes: [
                  // Farm profile routes (pushed on top, still shows navbar)
                  GoRoute(
                    path: 'farm',
                    name: 'farmerFarm',
                    pageBuilder: (context, state) =>
                        AppPageTransitions.slideFromRight(
                          child: const FarmProfileScreen(),
                          state: state,
                        ),
                    routes: [
                      GoRoute(
                        path: 'setup',
                        name: 'farmerFarmSetup',
                        parentNavigatorKey:
                            _rootNavigatorKey, // Full screen modal
                        pageBuilder: (context, state) =>
                            AppPageTransitions.slideFromBottom(
                              child: const FarmSetupScreen(),
                              state: state,
                            ),
                      ),
                      GoRoute(
                        path: 'edit',
                        name: 'farmerFarmEdit',
                        parentNavigatorKey:
                            _rootNavigatorKey, // Full screen modal
                        pageBuilder: (context, state) =>
                            AppPageTransitions.slideFromBottom(
                              child: const FarmEditScreen(),
                              state: state,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Branch 1: Products tab
          StatefulShellBranch(
            navigatorKey: _farmerProductsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.farmerProducts,
                name: 'farmerProducts',
                pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
                  child: const ProductsListScreen(),
                  state: state,
                ),
                routes: [
                  GoRoute(
                    path: 'add',
                    name: 'farmerProductAdd',
                    parentNavigatorKey: _rootNavigatorKey, // Full screen modal
                    pageBuilder: (context, state) =>
                        AppPageTransitions.slideFromBottom(
                          child: const ProductAddScreen(),
                          state: state,
                        ),
                  ),
                  GoRoute(
                    path: ':productId',
                    name: 'farmerProductDetail',
                    pageBuilder: (context, state) {
                      final productId = state.pathParameters['productId']!;
                      return AppPageTransitions.slideFromRight(
                        child: ProductDetailScreen(productId: productId),
                        state: state,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: 'farmerProductEdit',
                        parentNavigatorKey:
                            _rootNavigatorKey, // Full screen modal
                        pageBuilder: (context, state) {
                          final productId = state.pathParameters['productId']!;
                          return AppPageTransitions.slideFromBottom(
                            child: ProductEditScreen(productId: productId),
                            state: state,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Branch 2: Planner tab
          StatefulShellBranch(
            navigatorKey: _farmerPlannerNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.farmerPlanner,
                name: 'farmerPlanner',
                pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
                  child: const PlannerListScreen(),
                  state: state,
                ),
                routes: [
                  GoRoute(
                    path: 'add',
                    name: 'farmerPlannerAdd',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) =>
                        AppPageTransitions.slideFromBottom(
                          child: const PlannerAddScreen(),
                          state: state,
                        ),
                  ),
                  GoRoute(
                    path: 'calendar',
                    name: 'farmerPlannerCalendar',
                    pageBuilder: (context, state) =>
                        AppPageTransitions.slideFromRight(
                          child: const PlannerCalendarScreen(),
                          state: state,
                        ),
                  ),
                  GoRoute(
                    path: ':planId',
                    name: 'farmerPlannerDetail',
                    pageBuilder: (context, state) {
                      final planId = state.pathParameters['planId']!;
                      return AppPageTransitions.slideFromRight(
                        child: PlannerDetailScreen(planId: planId),
                        state: state,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: 'farmerPlannerEdit',
                        parentNavigatorKey: _rootNavigatorKey,
                        pageBuilder: (context, state) {
                          final planId = state.pathParameters['planId']!;
                          return AppPageTransitions.slideFromBottom(
                            child: PlannerEditScreen(planId: planId),
                            state: state,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Branch 3: Settings tab
          StatefulShellBranch(
            navigatorKey: _farmerSettingsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.farmerSettings,
                name: 'farmerSettings',
                pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
                  child: const FarmerSettingsScreen(),
                  state: state,
                ),
                routes: [
                  GoRoute(
                    path: 'about',
                    name: 'farmerAbout',
                    pageBuilder: (context, state) =>
                        AppPageTransitions.slideFromRight(
                          child: const AboutScreen(),
                          state: state,
                        ),
                  ),
                  GoRoute(
                    path: 'change-password',
                    name: 'farmerChangePassword',
                    pageBuilder: (context, state) =>
                        AppPageTransitions.slideFromRight(
                          child: const ChangePasswordScreen(),
                          state: state,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Farmer requests (separate from tabs - accessed from notifications)
      GoRoute(
        path: RouteNames.farmerRequests,
        name: 'farmerRequests',
        pageBuilder: (context, state) => AppPageTransitions.slideFromRight(
          child: const _PlaceholderScreen(title: 'Buyer Requests'),
          state: state,
        ),
      ),

      // ============ BUYER ROUTES (with bottom navigation) ============
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BuyerShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Discover tab
          StatefulShellBranch(
            navigatorKey: _buyerDiscoverNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.buyerHome,
                name: 'buyerDiscover',
                pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
                  child: const BuyerDiscoverScreen(),
                  state: state,
                ),
                routes: [
                  // Farm discovery list (all farms with search/filter)
                  GoRoute(
                    path: 'farms',
                    name: 'buyerFarmDiscovery',
                    pageBuilder: (context, state) {
                      final district = state.uri.queryParameters['district'];
                      final view = state.uri.queryParameters['view'];
                      final startInMapView = view == 'map';
                      return AppPageTransitions.slideFromRight(
                        child: FarmDiscoveryScreen(
                          initialDistrict: district,
                          startInMapView: startInMapView,
                        ),
                        state: state,
                      );
                    },
                    routes: [
                      // Farm detail (nested under farms)
                      GoRoute(
                        path: ':farmId',
                        name: 'buyerFarmDetail',
                        pageBuilder: (context, state) {
                          final farmId = state.pathParameters['farmId']!;
                          return AppPageTransitions.slideFromRight(
                            child: BuyerFarmDetailScreen(farmId: farmId),
                            state: state,
                          );
                        },
                        routes: [
                          // Farm products full view
                          GoRoute(
                            path: 'products',
                            name: 'buyerFarmProducts',
                            pageBuilder: (context, state) {
                              final farmId = state.pathParameters['farmId']!;
                              return AppPageTransitions.slideFromRight(
                                child: BuyerFarmProductsScreen(farmId: farmId),
                                state: state,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Product detail (nested under discover)
                  GoRoute(
                    path: 'products/:productId',
                    name: 'buyerProductDetail',
                    pageBuilder: (context, state) {
                      final productId = state.pathParameters['productId']!;
                      final farmId = state.uri.queryParameters['farmId'];
                      return AppPageTransitions.slideFromRight(
                        child: BuyerProductDetailScreen(
                          productId: productId,
                          farmId: farmId,
                        ),
                        state: state,
                      );
                    },
                    routes: [
                      // Price history (nested under product detail)
                      GoRoute(
                        path: 'history',
                        name: 'buyerProductHistory',
                        pageBuilder: (context, state) {
                          final productId = state.pathParameters['productId']!;
                          final farmId = state.uri.queryParameters['farmId']!;
                          final product = state.extra as ProductModel;
                          return AppPageTransitions.slideFromRight(
                            child: PriceHistoryScreen(
                              farmId: farmId,
                              productId: productId,
                              product: product,
                            ),
                            state: state,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Branch 1: Market tab (Product Price Comparison)
          StatefulShellBranch(
            navigatorKey: _buyerMarketNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.buyerMarket,
                name: 'buyerMarket',
                pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
                  child: const ProductComparisonScreen(),
                  state: state,
                ),
              ),
            ],
          ),

          // Branch 2: Settings tab
          StatefulShellBranch(
            navigatorKey: _buyerSettingsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.buyerSettings,
                name: 'buyerSettings',
                pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
                  child: const BuyerSettingsScreen(),
                  state: state,
                ),
                routes: [
                  GoRoute(
                    path: 'about',
                    name: 'buyerAbout',
                    pageBuilder: (context, state) =>
                        AppPageTransitions.slideFromRight(
                          child: const AboutScreen(),
                          state: state,
                        ),
                  ),
                  GoRoute(
                    path: 'change-password',
                    name: 'buyerChangePassword',
                    pageBuilder: (context, state) =>
                        AppPageTransitions.slideFromRight(
                          child: const ChangePasswordScreen(),
                          state: state,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ============ ADMIN ROUTES ============
      GoRoute(
        path: RouteNames.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Admin Dashboard'),
        routes: [
          GoRoute(
            path: 'farmers',
            name: 'adminFarmers',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Farmers Registry'),
            routes: [
              GoRoute(
                path: ':farmerId',
                name: 'adminFarmerDetail',
                builder: (context, state) {
                  final farmerId = state.pathParameters['farmerId']!;
                  return _PlaceholderScreen(title: 'Farmer: $farmerId');
                },
              ),
            ],
          ),
          GoRoute(
            path: 'verifications',
            name: 'adminVerifications',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Pending Verifications'),
            routes: [
              GoRoute(
                path: ':farmId',
                name: 'adminVerificationDetail',
                builder: (context, state) {
                  final farmId = state.pathParameters['farmId']!;
                  return _PlaceholderScreen(title: 'Verify Farm: $farmId');
                },
              ),
            ],
          ),
          GoRoute(
            path: 'audits',
            name: 'adminAudits',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Audit Logs'),
          ),
          GoRoute(
            path: 'announcements',
            name: 'adminAnnouncements',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Announcements'),
          ),
          GoRoute(
            path: 'settings',
            name: 'adminSettings',
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Admin Settings'),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

/// Listenable that refreshes router when auth state or farm state changes
class _RouterRefreshStream extends ChangeNotifier {
  _RouterRefreshStream(this.ref) {
    // Listen to user state changes (Firestore user document)
    ref.listen(currentAppUserProvider, (_, __) => notifyListeners());
    // Listen to farm state changes (for planner access control)
    ref.listen(myPrimaryFarmProvider, (_, __) => notifyListeners());
  }

  final Ref ref;
}

/// Placeholder screen for Phase 1 (will be replaced in later phases)
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Coming in next phase',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen for unknown routes
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (error != null)
              Text(
                error.toString(),
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
