import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/market/providers/farm_discovery_providers.dart';

/// Modal bottom sheet for filtering and sorting farm discovery results
class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  /// Shows the filter bottom sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  // Local state for pending changes
  District? _selectedDistrict;
  bool _verifiedOnly = false;
  bool _hasDelivery = false;
  FarmSortOption _sortBy = FarmSortOption.distance;

  @override
  void initState() {
    super.initState();
    // Initialize from current filter state
    final currentFilter = ref.read(farmDiscoveryNotifierProvider).filter;
    _selectedDistrict = currentFilter.district;
    _verifiedOnly = currentFilter.verifiedOnly;
    _hasDelivery = currentFilter.hasDelivery;
    _sortBy = currentFilter.sortBy;
  }

  void _resetFilters() {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedDistrict = null;
      _verifiedOnly = false;
      _hasDelivery = false;
      _sortBy = FarmSortOption.distance;
    });
  }

  void _applyFilters() {
    HapticFeedback.mediumImpact();
    ref.read(farmDiscoveryNotifierProvider.notifier).updateFilter(
          district: _selectedDistrict,
          verifiedOnly: _verifiedOnly,
          hasDelivery: _hasDelivery,
          sortBy: _sortBy,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.7,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const _DragHandle(),
            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Filter Businesses',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // District section
                    _DistrictSection(
                      selectedDistrict: _selectedDistrict,
                      onDistrictChanged: (district) {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedDistrict = district);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Switch section
                    _SwitchSection(
                      verifiedOnly: _verifiedOnly,
                      hasDelivery: _hasDelivery,
                      onVerifiedChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _verifiedOnly = value);
                      },
                      onDeliveryChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _hasDelivery = value);
                      },
                    ),
                    const SizedBox(height: 24),

                    const Divider(),
                    const SizedBox(height: 16),

                    // Sort section
                    _SortSection(
                      sortBy: _sortBy,
                      onSortChanged: (sort) {
                        HapticFeedback.selectionClick();
                        setState(() => _sortBy = sort);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Action buttons
            _ActionButtons(
              onReset: _resetFilters,
              onApply: _applyFilters,
            ),
          ],
        ),
      ),
    );
  }
}

/// Drag handle widget
class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// District filter section
class _DistrictSection extends StatelessWidget {
  const _DistrictSection({
    required this.selectedDistrict,
    required this.onDistrictChanged,
  });

  final District? selectedDistrict;
  final ValueChanged<District?> onDistrictChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'District',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'All',
              selected: selectedDistrict == null,
              onSelected: (_) => onDistrictChanged(null),
            ),
            _FilterChip(
              label: 'Melaka Tengah',
              selected: selectedDistrict == District.melakaTengah,
              onSelected: (_) => onDistrictChanged(District.melakaTengah),
            ),
            _FilterChip(
              label: 'Alor Gajah',
              selected: selectedDistrict == District.alorGajah,
              onSelected: (_) => onDistrictChanged(District.alorGajah),
            ),
            _FilterChip(
              label: 'Jasin',
              selected: selectedDistrict == District.jasin,
              onSelected: (_) => onDistrictChanged(District.jasin),
            ),
          ],
        ),
      ],
    );
  }
}

/// Switch options section
class _SwitchSection extends StatelessWidget {
  const _SwitchSection({
    required this.verifiedOnly,
    required this.hasDelivery,
    required this.onVerifiedChanged,
    required this.onDeliveryChanged,
  });

  final bool verifiedOnly;
  final bool hasDelivery;
  final ValueChanged<bool> onVerifiedChanged;
  final ValueChanged<bool> onDeliveryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          secondary: Icon(
            Icons.verified_user,
            color: Colors.green.shade600,
          ),
          title: const Text('Verified businesses only'),
          subtitle: const Text('LPNM verified businesses'),
          value: verifiedOnly,
          onChanged: onVerifiedChanged,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          secondary: Icon(
            Icons.local_shipping,
            color: Colors.teal.shade600,
          ),
          title: const Text('Has delivery'),
          subtitle: const Text('Businesses that offer delivery'),
          value: hasDelivery,
          onChanged: onDeliveryChanged,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

/// Sort options section
class _SortSection extends StatelessWidget {
  const _SortSection({
    required this.sortBy,
    required this.onSortChanged,
  });

  final FarmSortOption sortBy;
  final ValueChanged<FarmSortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Sort by',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'Distance',
              selected: sortBy == FarmSortOption.distance,
              onSelected: (_) => onSortChanged(FarmSortOption.distance),
            ),
            _FilterChip(
              label: 'Name A-Z',
              selected: sortBy == FarmSortOption.name,
              onSelected: (_) => onSortChanged(FarmSortOption.name),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom filter chip widget
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: selected
          ? BorderSide.none
          : BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

/// Action buttons at the bottom
class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onReset,
    required this.onApply,
  });

  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    // Add safe area for notched devices (home indicator)
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onReset,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Reset'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
