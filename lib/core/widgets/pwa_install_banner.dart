import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Banner that prompts users to install the PWA (web only)
/// Always shown on web until the app is installed
class PwaInstallBanner extends ConsumerWidget {
  const PwaInstallBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only show on web
    if (!kIsWeb) return const SizedBox.shrink();

    final isInstalled = ref.watch(isPwaInstalledProvider);

    // Hide once already installed
    if (isInstalled) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Install NenasKita app for quick access',
      button: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.m),
        padding: AppSpacing.paddingM,
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: const Border(
            left: BorderSide(color: AppColors.primary, width: 4),
          ),
          boxShadow: AppSpacing.shadowSmall,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(AppSpacing.s),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.install_mobile_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            AppSpacing.hGapM,
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Install NenasKita',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.vGapXXS,
                  Text(
                    'Add to your home screen for quick access',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimaryContainer.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Install button
            FilledButton(
              onPressed: () => _handleInstall(context, ref),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Install'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleInstall(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();

    final pwaService = ref.read(pwaServiceProvider);
    final result = await pwaService.promptInstall();

    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    if (result == 'accepted') {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('NenasKita is installing...'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (result == 'dismissed') {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Install dismissed. You can add NenasKita from your browser menu.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Install option not available. Try "Add to Home Screen" from your browser menu.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
