import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/auth/providers/auth_flow_providers.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';
import 'package:nenas_kita/features/market/widgets/buyer_profile_card.dart';
import 'package:nenas_kita/features/settings/providers/settings_providers.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Buyer/Wholesaler settings screen with profile, notifications, and logout
class BuyerSettingsScreen extends ConsumerWidget {
  const BuyerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentAppUserProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final appVersion = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          // Profile Card
          BuyerProfileCard(userAsync: userAsync),
          const SizedBox(height: AppSpacing.l),

          // Settings Section
          _SettingsSection(
            children: [
              // Notifications Toggle
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Receive push notifications',
                trailing: Switch.adaptive(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    ref
                        .read(notificationsEnabledProvider.notifier)
                        .setEnabled(value);
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              const Divider(height: 1),

              // Clear Cache
              _SettingsTile(
                icon: Icons.cleaning_services_outlined,
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () => _clearCache(context),
              ),
              const Divider(height: 1),

              // Change Password
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your password',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () =>
                    context.push('${RouteNames.buyerSettings}/change-password'),
              ),
              const Divider(height: 1),

              // About
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App information',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
                onTap: () => context.push('${RouteNames.buyerSettings}/about'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Logout Button
          FilledButton.icon(
            onPressed: () => _showLogoutDialog(context, ref),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // App Version
          Center(
            child: Text(
              'Version $appVersion',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textDisabled),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }

  Future<void> _clearCache(BuildContext context) async {
    final settingsBox = Hive.box('settings');
    await settingsBox.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache cleared'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Sign out from Firebase Auth and clear Hive local storage
      await ref.read(authServiceProvider).signOut();

      // Invalidate cached providers to clear stale user data
      ref.invalidate(currentUserIdProvider);
      ref.invalidate(currentAppUserProvider);
      ref.invalidate(userRepositoryProvider);

      // Force providers to re-read from Hive
      refreshAuthState(ref);

      // Navigate to login
      if (context.mounted) {
        context.go(RouteNames.login);
      }
    }
  }
}

/// Container for settings tiles
class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        side: BorderSide(color: AppColors.outline.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

/// Individual settings tile
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
