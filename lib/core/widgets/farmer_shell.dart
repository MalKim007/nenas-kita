import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';

/// Bottom navigation shell for farmer screens
/// Uses IndexedStack to preserve state across tabs
/// Enhanced with haptic feedback and badge support
///
/// Dynamically shows 3 or 4 tabs based on whether the user is an actual farmer:
/// - Actual farmer (has farm with acres): Home, Products, Planner, Settings
/// - Seller only (no farm or no acres): Home, Products, Settings
class FarmerShell extends ConsumerWidget {
  const FarmerShell({
    super.key,
    required this.navigationShell,
    this.notificationCount = 0,
    this.plannerBadgeCount = 0,
  });

  final StatefulNavigationShell navigationShell;

  /// Badge count for notifications (shown on Home tab)
  final int notificationCount;

  /// Badge count for planner items needing attention
  final int plannerBadgeCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch whether user is an actual farmer (has farm with acres)
    final isActualFarmer = ref.watch(isActualFarmerProvider);

    // Build destinations list based on farmer type
    final destinations = _buildDestinations(isActualFarmer);

    // Calculate the correct selected index
    // For non-farmers, we need to map the shell's index to our reduced tab count
    final selectedIndex = _getSelectedIndex(isActualFarmer);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppSpacing.animationFast,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onTap(context, index, isActualFarmer),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        animationDuration: AppSpacing.animationNormal,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: destinations,
      ),
    );
  }

  /// Build navigation destinations based on whether user is an actual farmer
  List<NavigationDestination> _buildDestinations(bool isActualFarmer) {
    final destinations = <NavigationDestination>[
      // Home with notification badge (always shown)
      NavigationDestination(
        icon: _buildBadgedIcon(
          icon: const Icon(Icons.home_outlined),
          count: notificationCount,
        ),
        selectedIcon: _buildBadgedIcon(
          icon: const Icon(Icons.home),
          count: notificationCount,
        ),
        label: 'Home',
      ),
      // Products (always shown)
      const NavigationDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2),
        label: 'Products',
      ),
    ];

    // Only show Planner tab for actual farmers (with farm acres)
    if (isActualFarmer) {
      destinations.add(
        NavigationDestination(
          icon: _buildBadgedIcon(
            icon: const Icon(Icons.calendar_month_outlined),
            count: plannerBadgeCount,
          ),
          selectedIcon: _buildBadgedIcon(
            icon: const Icon(Icons.calendar_month),
            count: plannerBadgeCount,
          ),
          label: 'Planner',
        ),
      );
    }

    // Settings (always shown)
    destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
    );

    return destinations;
  }

  /// Get the correct selected index based on farmer type
  /// For non-farmers (3 tabs): Home=0, Products=1, Settings=2
  /// For farmers (4 tabs): Home=0, Products=1, Planner=2, Settings=3
  int _getSelectedIndex(bool isActualFarmer) {
    final shellIndex = navigationShell.currentIndex;

    if (isActualFarmer) {
      // Full 4 tabs - direct mapping
      return shellIndex;
    } else {
      // 3 tabs (no Planner) - map shell index 3 (Settings) to display index 2
      // Shell indices: 0=Home, 1=Products, 2=Planner, 3=Settings
      // Display indices: 0=Home, 1=Products, 2=Settings
      if (shellIndex >= 3) {
        return 2; // Settings
      } else if (shellIndex == 2) {
        // User somehow on Planner route but shouldn't be - default to Home
        return 0;
      }
      return shellIndex;
    }
  }

  Widget _buildBadgedIcon({required Widget icon, required int count}) {
    if (count <= 0) return icon;

    return Badge(
      label: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
      backgroundColor: AppColors.error,
      child: icon,
    );
  }

  void _onTap(BuildContext context, int index, bool isActualFarmer) {
    // Provide haptic feedback on tab change
    final currentDisplayIndex = _getSelectedIndex(isActualFarmer);
    if (index != currentDisplayIndex) {
      HapticFeedback.selectionClick();
    }

    // Map display index to shell branch index
    int branchIndex;
    if (isActualFarmer) {
      // Full 4 tabs - direct mapping
      branchIndex = index;
    } else {
      // 3 tabs (no Planner)
      // Display: 0=Home, 1=Products, 2=Settings
      // Branch: 0=Home, 1=Products, 3=Settings (skip 2=Planner)
      if (index == 2) {
        branchIndex = 3; // Settings is branch 3
      } else {
        branchIndex = index;
      }
    }

    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }
}

/// Simple farmer shell without StatefulNavigationShell
/// Used when not using shell routes
/// Enhanced with haptic feedback and badge support
class SimpleFarmerShell extends ConsumerStatefulWidget {
  const SimpleFarmerShell({
    super.key,
    required this.child,
    this.notificationCount = 0,
    this.plannerBadgeCount = 0,
  });

  final Widget child;

  /// Badge count for notifications (shown on Home tab)
  final int notificationCount;

  /// Badge count for planner items needing attention
  final int plannerBadgeCount;

  @override
  ConsumerState<SimpleFarmerShell> createState() => _SimpleFarmerShellState();
}

class _SimpleFarmerShellState extends ConsumerState<SimpleFarmerShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Watch whether user is an actual farmer (has farm with acres)
    final isActualFarmer = ref.watch(isActualFarmerProvider);

    // Build destinations list based on farmer type
    final destinations = _buildDestinations(isActualFarmer);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppSpacing.animationFast,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: widget.child,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => _onTap(index, isActualFarmer),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        animationDuration: AppSpacing.animationNormal,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: destinations,
      ),
    );
  }

  /// Build navigation destinations based on whether user is an actual farmer
  List<NavigationDestination> _buildDestinations(bool isActualFarmer) {
    final destinations = <NavigationDestination>[
      // Home with notification badge (always shown)
      NavigationDestination(
        icon: _buildBadgedIcon(
          icon: const Icon(Icons.home_outlined),
          count: widget.notificationCount,
        ),
        selectedIcon: _buildBadgedIcon(
          icon: const Icon(Icons.home),
          count: widget.notificationCount,
        ),
        label: 'Home',
      ),
      // Products (always shown)
      const NavigationDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2),
        label: 'Products',
      ),
    ];

    // Only show Planner tab for actual farmers (with farm acres)
    if (isActualFarmer) {
      destinations.add(
        NavigationDestination(
          icon: _buildBadgedIcon(
            icon: const Icon(Icons.calendar_month_outlined),
            count: widget.plannerBadgeCount,
          ),
          selectedIcon: _buildBadgedIcon(
            icon: const Icon(Icons.calendar_month),
            count: widget.plannerBadgeCount,
          ),
          label: 'Planner',
        ),
      );
    }

    // Settings (always shown)
    destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
    );

    return destinations;
  }

  Widget _buildBadgedIcon({required Widget icon, required int count}) {
    if (count <= 0) return icon;

    return Badge(
      label: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
      backgroundColor: AppColors.error,
      child: icon,
    );
  }

  void _onTap(int index, bool isActualFarmer) {
    if (index == _currentIndex) return;

    // Provide haptic feedback on tab change
    HapticFeedback.selectionClick();

    setState(() {
      _currentIndex = index;
    });

    if (isActualFarmer) {
      // Full 4 tabs
      switch (index) {
        case 0:
          context.go(RouteNames.farmerHome);
          break;
        case 1:
          context.go(RouteNames.farmerProducts);
          break;
        case 2:
          context.go(RouteNames.farmerPlanner);
          break;
        case 3:
          context.go(RouteNames.farmerSettings);
          break;
      }
    } else {
      // 3 tabs (no Planner)
      switch (index) {
        case 0:
          context.go(RouteNames.farmerHome);
          break;
        case 1:
          context.go(RouteNames.farmerProducts);
          break;
        case 2:
          context.go(RouteNames.farmerSettings);
          break;
      }
    }
  }
}
