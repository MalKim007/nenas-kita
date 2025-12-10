import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/utils/password_utils.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/core/widgets/password_text_field.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Screen for changing user password
///
/// Features:
/// - Current password verification
/// - New password with strength requirements
/// - Confirm password matching
/// - Real-time validation
/// - Loading state during password change
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validate empty fields
    if (currentPassword.isEmpty) {
      AppSnackbar.showError(context, 'Sila masukkan kata laluan semasa');
      return;
    }

    if (newPassword.isEmpty) {
      AppSnackbar.showError(context, 'Sila masukkan kata laluan baharu');
      return;
    }

    // Validate new password strength
    final validationResult = PasswordUtils.validate(newPassword);
    if (!validationResult.isValid) {
      AppSnackbar.showError(context, validationResult.firstError ?? 'Kata laluan tidak sah');
      return;
    }

    // Check passwords match
    if (newPassword != confirmPassword) {
      AppSnackbar.showError(context, 'Kata laluan tidak sama');
      return;
    }

    // Check new password is different from current
    if (newPassword == currentPassword) {
      AppSnackbar.showError(context, 'Kata laluan baharu mestilah berbeza');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (mounted) {
        AppSnackbar.showSuccess(
          context,
          'Kata laluan berjaya ditukar',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Gagal menukar kata laluan';

        // Parse Firebase error messages
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('wrong-password') ||
            errorString.contains('invalid-credential')) {
          errorMessage = 'Kata laluan semasa tidak betul';
        } else if (errorString.contains('too-many-requests')) {
          errorMessage = 'Terlalu banyak percubaan. Sila cuba lagi kemudian';
        } else if (errorString.contains('network')) {
          errorMessage = 'Tiada sambungan internet';
        } else if (errorString.contains('not authenticated')) {
          errorMessage = 'Sila log masuk semula';
        }

        AppSnackbar.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tukar Kata Laluan'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pagePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Card
                Container(
                  padding: AppSpacing.paddingM,
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: 20,
                      ),
                      AppSpacing.hGapS,
                      Expanded(
                        child: Text(
                          'Kata laluan baharu mesti mempunyai sekurang-kurangnya 8 aksara dengan huruf besar, huruf kecil, dan nombor',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.info,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.vGapL,

                // Current Password Field
                PasswordTextField(
                  controller: _currentPasswordController,
                  label: 'Kata Laluan Semasa',
                  hint: 'Masukkan kata laluan semasa anda',
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.next,
                  errorText: null,
                ),
                AppSpacing.vGapM,

                // New Password Field
                PasswordTextField(
                  controller: _newPasswordController,
                  label: 'Kata Laluan Baharu',
                  hint: 'Masukkan kata laluan baharu',
                  helperText: 'Min. 8 aksara dengan huruf besar, kecil & nombor',
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.next,
                  errorText: null,
                ),
                AppSpacing.vGapM,

                // Confirm Password Field
                PasswordTextField(
                  controller: _confirmPasswordController,
                  label: 'Sahkan Kata Laluan Baharu',
                  hint: 'Masukkan semula kata laluan baharu',
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleChangePassword(),
                  errorText: null,
                ),
                AppSpacing.vGapXL,

                // Submit Button
                AppButton(
                  onPressed: _isLoading ? null : _handleChangePassword,
                  label: 'Tukar Kata Laluan',
                  isLoading: _isLoading,
                  isFullWidth: true,
                ),
                AppSpacing.vGapM,

                // Cancel Button
                AppButton(
                  onPressed: _isLoading ? null : () => context.pop(),
                  label: 'Batal',
                  variant: AppButtonVariant.secondary,
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
