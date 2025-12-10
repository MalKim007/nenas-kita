import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/features/settings/providers/settings_providers.dart';

/// About screen with app information
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          const SizedBox(height: AppSpacing.xl),

          // App Logo/Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              ),
              child: const Icon(
                Icons.eco,
                size: 56,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // App Name
          Center(
            child: Text(
              'NenasKita',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Version
          Center(
            child: Text(
              'Version $appVersion',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Description
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Text(
                'Connecting pineapple farmers in Malaysia with buyers. '
                'Empowering farmers with digital tools for better market access.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Links Section
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              side: BorderSide(color: AppColors.outline.withValues(alpha: 0.5)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _AboutTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _launchUrl('https://nenaskita.com/privacy'),
                ),
                const Divider(height: 1),
                _AboutTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => _launchUrl('https://nenaskita.com/terms'),
                ),
                const Divider(height: 1),
                _AboutTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => _launchUrl('https://nenaskita.com/support'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Credits
          Center(
            child: Text(
              'Made with love in Malaysia',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textDisabled,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// About page tile
class _AboutTile extends StatelessWidget {
  const _AboutTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
