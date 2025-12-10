import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/animated_checkmark.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/features/auth/providers/auth_flow_providers.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Profile setup screen for new users (optional - can be skipped)
/// Allows users to add profile picture after registration
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  bool _isLoading = false;
  bool _showSuccess = false;
  String? _destinationRoute;
  String? _avatarUrl;

  void _navigateToHome({bool showSuccess = true}) {
    // Get user role from Firestore (primary) or fallback to selected role
    final currentUser = ref.read(currentAppUserProvider).value;
    final role = currentUser?.role ?? ref.read(selectedRoleProvider) ?? UserRole.buyer;

    final destination = switch (role) {
      UserRole.farmer => RouteNames.farmerHome,
      UserRole.admin || UserRole.superadmin => RouteNames.adminDashboard,
      _ => RouteNames.buyerHome,
    };

    if (showSuccess) {
      setState(() {
        _showSuccess = true;
        _destinationRoute = destination;
      });
    } else {
      // Navigate immediately without success animation
      context.go(destination);
    }
  }

  Future<void> _skip() async {
    // Skip directly without success overlay to avoid race condition with route guards
    _navigateToHome(showSuccess: false);
  }

  Future<void> _saveAvatar() async {
    if (_avatarUrl == null || _avatarUrl!.isEmpty) {
      AppSnackbar.showError(context, 'Please select a profile picture');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user ID from Hive
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUserId;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Update avatar URL in Firestore
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.updateAvatarUrl(userId, _avatarUrl);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _navigateToHome();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      AppSnackbar.showError(context, 'Failed to save avatar. Please try again.');
    }
  }

  Future<void> _pickAvatar() async {
    // TODO: Implement image picker and Cloudinary upload
    // For now, show a placeholder message
    AppSnackbar.showInfo(context, 'Avatar upload coming soon');
  }

  @override
  Widget build(BuildContext context) {
    // Show success overlay
    if (_showSuccess && _destinationRoute != null) {
      return Scaffold(
        body: SuccessOverlay(
          message: 'Welcome!',
          onComplete: () {
            if (mounted) context.go(_destinationRoute!);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Skip button at top right
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _isLoading ? null : _skip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              AppSpacing.vGapL,
              // Title
              Text(
                'Add profile picture',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              AppSpacing.vGapS,
              Text(
                'Optional - you can add this later in settings',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              AppSpacing.vGapXL,
              // Avatar picker
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _pickAvatar,
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.outline,
                            width: 2,
                          ),
                          image: _avatarUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(_avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _avatarUrl == null
                            ? Icon(
                                Icons.person,
                                size: 64,
                                color: AppColors.textDisabled,
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.vGapM,
              Center(
                child: Text(
                  'Tap to add photo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
              const Spacer(),
              // Save button
              AppButton(
                onPressed: _avatarUrl != null && !_isLoading ? _saveAvatar : null,
                label: 'Save & Continue',
                isLoading: _isLoading,
              ),
              AppSpacing.vGapM,
              // Skip text button
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _skip,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              AppSpacing.vGapM,
            ],
          ),
        ),
      ),
    );
  }
}
