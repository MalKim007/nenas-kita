import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_empty_state.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/features/market/providers/farm_discovery_providers.dart';
import 'package:nenas_kita/features/market/widgets/farm_list_item.dart';
import 'package:nenas_kita/features/market/widgets/farm_map_view.dart';
import 'package:nenas_kita/features/market/widgets/filter_bottom_sheet.dart';
import 'package:nenas_kita/features/market/widgets/search_header.dart';

/// Farm discovery screen showing searchable, filterable list of all active farms.
///
/// Features:
/// - Search with debounce (300ms)
/// - Distance-based sorting
/// - Multiple filters (district, verified, delivery)
/// - Pull-to-refresh
/// - Active filter chips (dismissible)
/// - List/map toggle (map in Phase B4)
class FarmDiscoveryScreen extends ConsumerStatefulWidget {
  const FarmDiscoveryScreen({
    super.key,
    this.initialDistrict,
    this.startInMapView = false,
  });

  /// Optional initial district filter from query param (e.g., "MelakaTengah")
  final String? initialDistrict;
  final bool startInMapView;

  @override
  ConsumerState<FarmDiscoveryScreen> createState() =>
      _FarmDiscoveryScreenState();
}

class _FarmDiscoveryScreenState extends ConsumerState<FarmDiscoveryScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    _isListView = !widget.startInMapView;
    // Apply initial district filter if provided
    if (widget.initialDistrict != null) {
      final district = District.fromString(widget.initialDistrict!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(farmDiscoveryNotifierProvider.notifier)
            .updateFilter(district: district);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Debounced search (300ms) to avoid excessive provider updates
  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(farmDiscoveryNotifierProvider.notifier).setSearchQuery(query);
    });
  }

  /// Clear search input and filter
  void _onSearchClear() {
    _searchController.clear();
    ref.read(farmDiscoveryNotifierProvider.notifier).setSearchQuery('');
  }

  /// Toggle between list and map view
  void _onViewToggle(bool isListView) {
    setState(() => _isListView = isListView);
  }

  /// Open filter bottom sheet
  void _openFilters() {
    HapticFeedback.lightImpact();
    FilterBottomSheet.show(context);
  }

  /// Navigate to farm detail screen
  void _onFarmTap(String farmId) {
    HapticFeedback.lightImpact();
    context.push(RouteNames.buyerFarmDetailPath(farmId));
  }

  /// Pull-to-refresh handler
  Future<void> _onRefresh() async {
    // Trigger provider refresh by invalidating
    ref.invalidate(filteredFarmsProvider);

    // Wait for new data to load
    await ref.read(filteredFarmsProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final discoveryState = ref.watch(farmDiscoveryNotifierProvider);
    final filter = discoveryState.filter;
    final farmsAsync = ref.watch(filteredFarmsProvider);

    // Check if any filters are active
    final hasActiveFilters = filter.district != null ||
        filter.verifiedOnly ||
        filter.hasDelivery;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Businesses'),
        actions: [
          // Filter button with badge indicator
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _openFilters,
                tooltip: 'Filters',
              ),
              if (hasActiveFilters)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        children: [
          // Search header with list/map toggle
          SearchHeader(
            controller: _searchController,
            onSearchChanged: _onSearchChanged,
            onClear: _onSearchClear,
            isListView: _isListView,
            onViewToggle: _onViewToggle,
          ),

          // Active filter chips (dismissible)
          if (hasActiveFilters) _buildActiveFilterChips(filter),

          // Farm list or empty states
          Expanded(
            child: farmsAsync.when(
              loading: () => const _FarmListSkeleton(),
              error: (error, stack) => AppError(
                message: error.toString(),
                onRetry: () => ref.invalidate(filteredFarmsProvider),
              ),
              data: (farms) {
                if (farms.isEmpty) {
                  // Show different empty state based on search
                  if (discoveryState.searchQuery.isNotEmpty) {
                    return AppEmptyState(
                      icon: Icons.search_off,
                      title: 'No businesses found',
                      message:
                          'No businesses match "${discoveryState.searchQuery}". Try different keywords.',
                      actionLabel: 'Clear Search',
                      onAction: _onSearchClear,
                    );
                  } else {
                    return const AppEmptyState(
                      icon: Icons.agriculture_outlined,
                      title: 'No businesses available',
                      message:
                          'There are currently no active businesses. Check back later.',
                    );
                  }
                }

                // Conditional rendering: List view or Map view
                if (_isListView) {
                  // Farm list with pull-to-refresh
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      itemCount: farms.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                        vertical: AppSpacing.s,
                      ),
                      itemBuilder: (context, index) {
                        final farmWithDistance = farms[index];
                        final farm = farmWithDistance.farm;
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.s,
                          ),
                          child: FarmListItem(
                            farm: farm,
                            distanceKm: farmWithDistance.distanceKm,
                            onTap: () => _onFarmTap(farm.id),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  // Map view
                  return FarmMapView(farms: farms);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build dismissible filter chips for active filters
  Widget _buildActiveFilterChips(FarmDiscoveryFilter filter) {
    final chips = <Widget>[];

    // District chip
    if (filter.district != null) {
      chips.add(
        _FilterChip(
          label: filter.district!.displayName,
          onDismiss: () {
            ref
                .read(farmDiscoveryNotifierProvider.notifier)
                .updateFilter(district: null);
          },
        ),
      );
    }

    // Verified chip
    if (filter.verifiedOnly) {
      chips.add(
        _FilterChip(
          label: 'Verified',
          onDismiss: () {
            ref
                .read(farmDiscoveryNotifierProvider.notifier)
                .updateFilter(verifiedOnly: false);
          },
        ),
      );
    }

    // Delivery chip
    if (filter.hasDelivery) {
      chips.add(
        _FilterChip(
          label: 'Has Delivery',
          onDismiss: () {
            ref
                .read(farmDiscoveryNotifierProvider.notifier)
                .updateFilter(hasDelivery: false);
          },
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: chips,
      ),
    );
  }
}

/// Dismissible filter chip widget
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onDismiss,
  });

  final String label;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onDismiss,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.close,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton loading state for farm list
class _FarmListSkeleton extends StatelessWidget {
  const _FarmListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.s),
        child: ShimmerCard(height: 100),
      ),
    );
  }
}
