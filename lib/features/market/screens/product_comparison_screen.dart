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
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/core/widgets/app_text_field.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';
import 'package:nenas_kita/features/market/models/product_with_farm.dart';
import 'package:nenas_kita/features/market/providers/product_comparison_providers.dart';
import 'package:nenas_kita/features/market/widgets/comparison_bottom_sheet.dart';
import 'package:nenas_kita/features/market/widgets/product_comparison_card.dart';

/// Product Comparison Screen for NenasKita
///
/// Allows buyers and wholesalers to compare pineapple product prices across
/// different farms in Melaka. Features category filtering, search with
/// debouncing, and multiple sort options (price, distance, farm name).
///
/// Design optimized for outdoor visibility with high contrast amber/gold
/// and green color scheme matching the pineapple farming theme.
class ProductComparisonScreen extends ConsumerStatefulWidget {
  const ProductComparisonScreen({super.key});

  @override
  ConsumerState<ProductComparisonScreen> createState() =>
      _ProductComparisonScreenState();
}

class _ProductComparisonScreenState
    extends ConsumerState<ProductComparisonScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  ProductCategory? _selectedCategory; // null = All
  ProductSortOption _sortBy = ProductSortOption.priceLowToHigh;
  String _searchQuery = '';

  // Compare mode state
  bool _isCompareMode = false;
  final List<ProductWithFarm> _selectedProducts = [];
  static const int _maxCompareProducts = 3;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _toggleCompareMode() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isCompareMode = !_isCompareMode;
      if (!_isCompareMode) {
        _selectedProducts.clear();
      }
    });
  }

  void _toggleProductSelection(ProductWithFarm product) {
    HapticFeedback.lightImpact();
    setState(() {
      final existingIndex = _selectedProducts.indexWhere(
        (p) => p.product.id == product.product.id && p.farm.id == product.farm.id,
      );

      if (existingIndex >= 0) {
        _selectedProducts.removeAt(existingIndex);
      } else if (_selectedProducts.length < _maxCompareProducts) {
        _selectedProducts.add(product);
      } else {
        // Max reached - show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Maximum $_maxCompareProducts products can be compared'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  bool _isProductSelected(ProductWithFarm product) {
    return _selectedProducts.any(
      (p) => p.product.id == product.product.id && p.farm.id == product.farm.id,
    );
  }

  void _showComparisonSheet() {
    if (_selectedProducts.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least 2 products to compare'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final userRole = ref.read(currentUserRoleProvider);
    final showWholesale = userRole == UserRole.wholesaler ||
        userRole == UserRole.admin ||
        userRole == UserRole.superadmin;

    ComparisonBottomSheet.show(
      context: context,
      products: _selectedProducts,
      showWholesalePrice: showWholesale,
      onProductTap: (product) {
        context.push(
          RouteNames.buyerProductDetailPath(
            product.product.id,
            farmId: product.farm.id,
          ),
        );
      },
      onRemoveProduct: (product) {
        setState(() {
          _selectedProducts.removeWhere(
            (p) => p.product.id == product.product.id && p.farm.id == product.farm.id,
          );
        });
      },
    );
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _searchQuery = query.trim());
      }
    });
  }

  void _onCategoryChanged(ProductCategory? category) {
    setState(() {
      _selectedCategory = category;
      // Reset search when category changes
      if (_searchController.text.isEmpty && _searchQuery.isEmpty) {
        // Force rebuild to show category results
        _searchQuery = '';
      }
    });
  }

  void _onSortChanged(ProductSortOption sortOption) {
    setState(() => _sortBy = sortOption);
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  Future<void> _onRefresh() async {
    // Invalidate providers to refetch data
    ref.invalidate(searchProductsAcrossFarmsProvider);
    ref.invalidate(productsByComparisonCategoryProvider);
    ref.invalidate(allFarmsMapProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Check if user has wholesale access
    final userRole = ref.watch(currentUserRoleProvider);
    final showWholesalePrice = userRole == UserRole.wholesaler ||
        userRole == UserRole.admin ||
        userRole == UserRole.superadmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Prices'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          // Compare mode toggle in app bar
          if (_isCompareMode)
            TextButton.icon(
              onPressed: _toggleCompareMode,
              icon: const Icon(Icons.close, color: AppColors.onPrimary, size: 18),
              label: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.onPrimary),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Compare mode indicator bar
          if (_isCompareMode)
            _CompareModeBar(
              selectedCount: _selectedProducts.length,
              maxCount: _maxCompareProducts,
              onCompare: _showComparisonSheet,
              onCancel: _toggleCompareMode,
            ),

          // Filter Section (Category Chips + Search)
          _FilterSection(
            selectedCategory: _selectedCategory,
            onCategoryChanged: _onCategoryChanged,
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onClearSearch: _onClearSearch,
          ),

          // Results Section
          Expanded(
            child: _ResultsSection(
              searchQuery: _searchQuery,
              selectedCategory: _selectedCategory,
              sortBy: _sortBy,
              onSortChanged: _onSortChanged,
              showWholesalePrice: showWholesalePrice,
              onRefresh: _onRefresh,
              isCompareMode: _isCompareMode,
              selectedProducts: _selectedProducts,
              onToggleSelection: _toggleProductSelection,
              isProductSelected: _isProductSelected,
            ),
          ),
        ],
      ),
      // Floating action button for compare mode
      floatingActionButton: _buildCompareFab(),
    );
  }

  Widget? _buildCompareFab() {
    // Don't show FAB on initial search prompt state
    if (_searchQuery.length < 2 && _selectedCategory == null) {
      return null;
    }

    if (_isCompareMode) {
      // Show "Compare X" button when products selected
      if (_selectedProducts.isEmpty) {
        return null;
      }

      return FloatingActionButton.extended(
        onPressed: _showComparisonSheet,
        backgroundColor: _selectedProducts.length >= 2
            ? AppColors.success
            : AppColors.neutral300,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.compare_arrows_rounded),
        label: Text(
          'Compare ${_selectedProducts.length}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    // Show "Select to Compare" FAB
    return FloatingActionButton.extended(
      onPressed: _toggleCompareMode,
      backgroundColor: AppColors.tertiary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.compare_arrows_rounded),
      label: const Text(
        'Compare',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ============================================================================
// Compare Mode Bar
// ============================================================================

class _CompareModeBar extends StatelessWidget {
  const _CompareModeBar({
    required this.selectedCount,
    required this.maxCount,
    required this.onCompare,
    required this.onCancel,
  });

  final int selectedCount;
  final int maxCount;
  final VoidCallback onCompare;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.tertiary.withValues(alpha: 0.15),
            AppColors.tertiary.withValues(alpha: 0.08),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.tertiary.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.touch_app_rounded,
              size: 18,
              color: AppColors.tertiary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select products to compare',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$selectedCount of $maxCount selected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Selection indicator dots
          Row(
            children: List.generate(maxCount, (index) {
              final isSelected = index < selectedCount;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.tertiary
                      : AppColors.neutral200,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.tertiary
                        : AppColors.neutral300,
                    width: 1.5,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Filter Section
// ============================================================================

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  final ProductCategory? selectedCategory;
  final ValueChanged<ProductCategory?> onCategoryChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category Chips
          _CategoryChips(
            selectedCategory: selectedCategory,
            onCategoryChanged: onCategoryChanged,
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m,
              AppSpacing.s,
              AppSpacing.m,
              AppSpacing.m,
            ),
            child: SearchTextField(
              controller: searchController,
              hint: 'Search products...',
              onChanged: onSearchChanged,
              onClear: onClearSearch,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Category Chips
// ============================================================================

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final ProductCategory? selectedCategory;
  final ValueChanged<ProductCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // "All" chip
            _CategoryChip(
              label: 'All',
              isSelected: selectedCategory == null,
              onTap: () => onCategoryChanged(null),
            ),
            AppSpacing.hGapS,

            // "Fresh" chip
            _CategoryChip(
              label: 'Fresh',
              icon: Icons.eco,
              isSelected: selectedCategory == ProductCategory.fresh,
              onTap: () => onCategoryChanged(ProductCategory.fresh),
            ),
            AppSpacing.hGapS,

            // "Processed" chip
            _CategoryChip(
              label: 'Processed',
              icon: Icons.inventory_2,
              isSelected: selectedCategory == ProductCategory.processed,
              onTap: () => onCategoryChanged(ProductCategory.processed),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.onPrimaryContainer : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.onPrimaryContainer : AppColors.textPrimary,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryContainer,
      backgroundColor: AppColors.neutral100,
      checkmarkColor: AppColors.primary,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.outline,
        width: isSelected ? 1.5 : 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      elevation: isSelected ? 2 : 0,
    );
  }
}

// ============================================================================
// Results Section
// ============================================================================

class _ResultsSection extends ConsumerWidget {
  const _ResultsSection({
    required this.searchQuery,
    required this.selectedCategory,
    required this.sortBy,
    required this.onSortChanged,
    required this.showWholesalePrice,
    required this.onRefresh,
    this.isCompareMode = false,
    this.selectedProducts = const [],
    this.onToggleSelection,
    this.isProductSelected,
  });

  final String searchQuery;
  final ProductCategory? selectedCategory;
  final ProductSortOption sortBy;
  final ValueChanged<ProductSortOption> onSortChanged;
  final bool showWholesalePrice;
  final Future<void> Function() onRefresh;
  final bool isCompareMode;
  final List<ProductWithFarm> selectedProducts;
  final void Function(ProductWithFarm)? onToggleSelection;
  final bool Function(ProductWithFarm)? isProductSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine which provider to use based on search query
    final AsyncValue<List<ProductWithFarm>> resultsAsync;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    if (searchQuery.length >= 2) {
      // Search mode - use search provider
      resultsAsync = ref.watch(
        searchProductsAcrossFarmsProvider(
          searchQuery,
          category: selectedCategory,
        ),
      );
    } else if (selectedCategory != null) {
      // Category filter mode - show all products in category
      resultsAsync = ref.watch(
        productsByComparisonCategoryProvider(selectedCategory),
      );
    } else {
      // Initial state - show prompt
      return SingleChildScrollView(
        padding: AppSpacing.pagePadding.copyWith(bottom: AppSpacing.l + bottomInset),
        child: _SearchPromptState(
          onGetStarted: () {
            // Scroll to search field (user can start typing)
          },
        ),
      );
    }

    return resultsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return SingleChildScrollView(
            padding: AppSpacing.pagePadding.copyWith(bottom: AppSpacing.l + bottomInset),
            child: _NoResultsState(
              query: searchQuery.isNotEmpty ? searchQuery : null,
              category: selectedCategory,
              onClearSearch: () => onSortChanged(sortBy), // No-op, just trigger rebuild
            ),
          );
        }

        // Sort products
        final sortedProducts = sortProductComparison(products, sortBy);

        return RefreshIndicator(
          onRefresh: onRefresh,
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: Column(
            children: [
              // Results Header (count + sort)
              _ResultsHeader(
                count: sortedProducts.length,
                sortBy: sortBy,
                onSortChanged: onSortChanged,
              ),

              // Product List
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.m,
                    AppSpacing.s,
                    AppSpacing.m,
                    // Extra padding at bottom for FAB
                    AppSpacing.m + bottomInset + (isCompareMode ? 80 : 60),
                  ),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: sortedProducts.length,
                  separatorBuilder: (_, __) => AppSpacing.vGapM,
                  itemBuilder: (context, index) {
                    final item = sortedProducts[index];
                    final isSelected = isProductSelected?.call(item) ?? false;

                    return Stack(
                      children: [
                        // Product Card
                        ProductComparisonCard(
                          productWithFarm: item,
                          showWholesalePrice: showWholesalePrice,
                          onTap: () {
                            if (isCompareMode) {
                              onToggleSelection?.call(item);
                            } else {
                              context.push(
                                RouteNames.buyerProductDetailPath(
                                  item.product.id,
                                  farmId: item.farm.id,
                                ),
                              );
                            }
                          },
                        ),

                        // Selection overlay and checkbox (compare mode only)
                        if (isCompareMode)
                          Positioned.fill(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.tertiary.withValues(alpha: 0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.tertiary,
                                        width: 2.5,
                                      )
                                    : null,
                              ),
                            ),
                          ),

                        // Checkbox
                        if (isCompareMode)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: GestureDetector(
                              onTap: () => onToggleSelection?.call(item),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.tertiary
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.tertiary
                                        : AppColors.outline,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _LoadingState(),
      error: (error, stack) => Center(
        child: Padding(
          padding: AppSpacing.paddingL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              AppSpacing.vGapM,
              Text(
                'Failed to load products',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              AppSpacing.vGapS,
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Results Header (Count + Sort Dropdown)
// ============================================================================

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({
    required this.count,
    required this.sortBy,
    required this.onSortChanged,
  });

  final int count;
  final ProductSortOption sortBy;
  final ValueChanged<ProductSortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Results count
          Text(
            'Found $count ${count == 1 ? 'result' : 'results'}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),

          // Sort dropdown
          _SortDropdown(
            sortBy: sortBy,
            onSortChanged: onSortChanged,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Sort Dropdown
// ============================================================================

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({
    required this.sortBy,
    required this.onSortChanged,
  });

  final ProductSortOption sortBy;
  final ValueChanged<ProductSortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProductSortOption>(
      initialValue: sortBy,
      onSelected: onSortChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sort,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              sortBy.displayName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => ProductSortOption.values.map((option) {
        final isSelected = option == sortBy;
        return PopupMenuItem<ProductSortOption>(
          value: option,
          child: Row(
            children: [
              Icon(
                _getSortIcon(option),
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                option.displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                const Icon(
                  Icons.check,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getSortIcon(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.priceLowToHigh:
        return Icons.arrow_upward;
      case ProductSortOption.priceHighToLow:
        return Icons.arrow_downward;
      case ProductSortOption.distance:
        return Icons.near_me;
      case ProductSortOption.farmName:
        return Icons.sort_by_alpha;
    }
  }
}

// ============================================================================
// Empty States
// ============================================================================

/// Initial prompt state - shown when no search/filter is active
class _SearchPromptState extends StatelessWidget {
  const _SearchPromptState({
    required this.onGetStarted,
  });

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.vGapL,
            Text(
              'Compare Pineapple Prices',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapS,
            Text(
              'Search for a product or select a category to compare prices across different businesses in Melaka',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapXL,
            _FeatureBadge(
              icon: Icons.verified,
              label: 'LPNM Verified Businesses',
              color: AppColors.secondary,
            ),
            AppSpacing.vGapM,
            _FeatureBadge(
              icon: Icons.location_on,
              label: 'Distance Tracking',
              color: AppColors.tertiary,
            ),
            AppSpacing.vGapM,
            _FeatureBadge(
              icon: Icons.trending_down,
              label: 'Best Price Guarantee',
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// No results state - shown when search returns empty
class _NoResultsState extends StatelessWidget {
  const _NoResultsState({
    required this.query,
    required this.category,
    required this.onClearSearch,
  });

  final String? query;
  final ProductCategory? category;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    String message;
    if (query != null && query!.isNotEmpty) {
      message = 'No products found matching "$query"';
      if (category != null) {
        message += ' in ${category!.name} category';
      }
    } else if (category != null) {
      message = 'No ${category!.name} products available';
    } else {
      message = 'No products found';
    }

    return AppEmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: message,
    );
  }
}

/// Loading state with shimmer cards
class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: AppSpacing.m,
        right: AppSpacing.m,
        top: AppSpacing.m,
        bottom: AppSpacing.m + MediaQuery.of(context).viewInsets.bottom,
      ),
      itemCount: 5,
      separatorBuilder: (_, __) => AppSpacing.vGapM,
      itemBuilder: (_, __) => const ShimmerCard(height: 100),
    );
  }
}
