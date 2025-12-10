import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_text_field.dart';

/// Search header with view toggle for market screen
/// Displays search field and list/map view switcher
class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.onClear,
    required this.isListView,
    required this.onViewToggle,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClear;
  final bool isListView;
  final ValueChanged<bool> onViewToggle;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            // Search field
            Expanded(
              child: SearchTextField(
                controller: controller,
                hint: 'Search businesses...',
                onChanged: onSearchChanged,
                onClear: onClear,
                autofocus: autofocus,
              ),
            ),
            const SizedBox(width: 12),

            // View toggle
            _ViewToggle(
              isListView: isListView,
              onViewToggle: onViewToggle,
            ),
          ],
        ),
      ),
    );
  }
}

/// View toggle widget for list/map view
/// Min 48dp touch targets for accessibility compliance
class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.isListView,
    required this.onViewToggle,
  });

  final bool isListView;
  final ValueChanged<bool> onViewToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Increased from 44 for accessibility
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewToggleButton(
            icon: Icons.view_list,
            isSelected: isListView,
            semanticLabel: 'List view',
            onTap: () {
              if (!isListView) {
                HapticFeedback.selectionClick();
                onViewToggle(true);
              }
            },
          ),
          _ViewToggleButton(
            icon: Icons.map_outlined,
            isSelected: !isListView,
            semanticLabel: 'Map view',
            onTap: () {
              if (isListView) {
                HapticFeedback.selectionClick();
                onViewToggle(false);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Individual toggle button with min 48dp touch target
class _ViewToggleButton extends StatelessWidget {
  const _ViewToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$semanticLabel${isSelected ? ', selected' : ''}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Container(
            width: 48, // Increased from 44 for accessibility (min 48dp)
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
