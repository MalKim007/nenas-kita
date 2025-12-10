import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';

/// Error display widget with retry option
class AppError extends StatelessWidget {
  const AppError({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.error,
            ),
            AppSpacing.vGapM,
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.vGapS,
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              AppSpacing.vGapL,
              AppButton(
                onPressed: onRetry,
                label: retryLabel,
                icon: Icons.refresh,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Full screen error
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.onRetry,
    this.onGoHome,
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingXL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.error,
              ),
              AppSpacing.vGapL,
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                AppSpacing.vGapS,
                Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              AppSpacing.vGapXL,
              if (onRetry != null)
                AppButton(
                  onPressed: onRetry,
                  label: 'Try Again',
                  icon: Icons.refresh,
                ),
              if (onGoHome != null) ...[
                AppSpacing.vGapM,
                AppButton(
                  onPressed: onGoHome,
                  label: 'Go Home',
                  variant: AppButtonVariant.secondary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Network error display
class NetworkError extends StatelessWidget {
  const NetworkError({
    super.key,
    this.onRetry,
  });

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppError(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

/// Not found error (404)
class NotFoundError extends StatelessWidget {
  const NotFoundError({
    super.key,
    this.itemName = 'Item',
    this.onGoBack,
  });

  final String itemName;
  final VoidCallback? onGoBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            AppSpacing.vGapM,
            Text(
              '$itemName Not Found',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapS,
            Text(
              'The $itemName you\'re looking for doesn\'t exist or has been removed.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onGoBack != null) ...[
              AppSpacing.vGapL,
              AppButton(
                onPressed: onGoBack,
                label: 'Go Back',
                variant: AppButtonVariant.secondary,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Permission denied error
class PermissionDeniedError extends StatelessWidget {
  const PermissionDeniedError({
    super.key,
    this.message,
    this.onGoBack,
  });

  final String? message;
  final VoidCallback? onGoBack;

  @override
  Widget build(BuildContext context) {
    return AppError(
      title: 'Access Denied',
      message: message ?? 'You don\'t have permission to access this content.',
      icon: Icons.lock,
      onRetry: onGoBack,
      retryLabel: 'Go Back',
    );
  }
}
