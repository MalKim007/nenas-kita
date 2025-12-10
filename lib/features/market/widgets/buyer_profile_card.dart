import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/auth/models/user_model.dart';

/// Profile card showing buyer/wholesaler info
class BuyerProfileCard extends StatelessWidget {
  const BuyerProfileCard({super.key, required this.userAsync});

  final AsyncValue<UserModel?> userAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        side: BorderSide(color: AppColors.outline.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not logged in'));
            }
            return Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryContainer,
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.m),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      if (user.phone != null && user.phone!.isNotEmpty)
                        Text(
                          '+60${user.phone}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      if (user.district != null &&
                          user.district!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.district!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Role chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: user.role == UserRole.wholesaler
                              ? AppColors.secondaryContainer
                              : AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusS,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.role == UserRole.wholesaler
                                  ? Icons.store_outlined
                                  : Icons.shopping_bag_outlined,
                              size: 14,
                              color: user.role == UserRole.wholesaler
                                  ? AppColors.onSecondaryContainer
                                  : AppColors.onPrimaryContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              user.role == UserRole.wholesaler
                                  ? 'Wholesaler'
                                  : 'Buyer',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: user.role == UserRole.wholesaler
                                        ? AppColors.onSecondaryContainer
                                        : AppColors.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit button
                IconButton(
                  onPressed: () {
                    // TODO: Navigate to profile edit screen when implemented
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile editing coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                  color: AppColors.textSecondary,
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
