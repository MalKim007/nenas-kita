import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';

/// Reusable section header with optional icon and trailing widget
/// Replaces inline ALL CAPS text headers with cleaner sentence case styling
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.showDivider = false,
  });

  /// Section title (sentence case, not uppercase)
  final String title;

  /// Optional leading icon (displayed in colored container)
  final IconData? icon;

  /// Optional trailing widget (e.g., "See All" button)
  final Widget? trailing;

  /// Show divider line below header
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: AppColors.outline.withValues(alpha: 0.3),
          ),
        ],
      ],
    );
  }
}
