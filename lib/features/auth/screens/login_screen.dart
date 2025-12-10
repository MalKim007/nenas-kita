import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_text_field.dart';
import 'package:nenas_kita/core/widgets/password_text_field.dart';
import 'package:nenas_kita/core/widgets/pwa_install_banner.dart';
import 'package:nenas_kita/features/auth/providers/auth_flow_providers.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Login screen with email and password
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final authService = ref.read(authServiceProvider);

    // Validate email format
    if (!authService.isValidEmail(email)) {
      setState(() {
        _errorText = 'Enter a valid email address';
      });
      return;
    }

    // Validate password is not empty
    if (password.isEmpty) {
      setState(() {
        _errorText = 'Please enter your password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      // Attempt to login with email and password
      final user = await authService.loginWithPassword(email, password);

      if (!mounted) return;

      if (user == null) {
        // Invalid credentials
        setState(() {
          _isLoading = false;
          _errorText = 'Invalid email or password';
        });
        return;
      }

      // Refresh auth state so providers re-read from Hive
      refreshAuthState(ref);

      // Login successful, navigate based on role
      final home = switch (user.role) {
        UserRole.farmer => RouteNames.farmerHome,
        UserRole.buyer || UserRole.wholesaler => RouteNames.buyerHome,
        UserRole.admin || UserRole.superadmin => RouteNames.adminDashboard,
      };

      if (mounted) {
        context.go(home);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorText = 'Failed to login. Please try again.';
      });
    }
  }

  void _navigateToRegister() {
    context.go(RouteNames.register);
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Password?'),
        content: const Text(
          'Please contact LPNM admin to reset your password.\n\n'
          'Phone: +60-6-232 8300',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFCFA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              padding: AppSpacing.pagePadding.copyWith(
                bottom: AppSpacing.l + bottomInset,
              ),
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      // Logo with shadow
                      Center(
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusL,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusL,
                            ),
                            child: Image.asset(
                              'assets/images/AppIcon.jpeg',
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.vGapL,
                      // Title
                      Text(
                        'Welcome to NenasKita',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.vGapS,
                      // Subtitle
                      Text(
                        'Enter your email and password',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.l),
                      const PwaInstallBanner(),
                      AppSpacing.vGapL,
                      // Email input
                      EmailTextField(
                        controller: _emailController,
                        label: 'Email',
                        autofocus: true,
                        enabled: !_isLoading,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      ),
                      AppSpacing.vGapM,
                      // Password input
                      PasswordTextField(
                        controller: _passwordController,
                        label: 'Password',
                        errorText: _errorText,
                        enabled: !_isLoading,
                        onSubmitted: (_) => _handleLogin(),
                      ),
                      AppSpacing.vGapS,
                      // Forgot password link - min 48dp touch target for accessibility
                      Align(
                        alignment: Alignment.centerRight,
                        child: Semantics(
                          button: true,
                          label: 'Forgot password, tap to contact admin',
                          child: TextButton(
                            onPressed: _isLoading
                                ? null
                                : _showForgotPasswordDialog,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.m,
                                vertical: AppSpacing.s,
                              ),
                              minimumSize: const Size(48, 48),
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.vGapL,
                      // Login button
                      AppButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        label: 'Login',
                        isLoading: _isLoading,
                      ),
                      AppSpacing.vGapL,
                      // Trust indicators
                      _buildTrustIndicators(context),
                      const SizedBox(height: AppSpacing.l),
                      // Register link - min 48dp touch target for accessibility
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          Semantics(
                            button: true,
                            label: 'Register for a new account',
                            child: TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : _navigateToRegister,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.m,
                                  vertical: AppSpacing.s,
                                ),
                                minimumSize: const Size(48, 48),
                              ),
                              child: Text(
                                'Register',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vGapS,
                      // Footer
                      Text(
                        'By continuing, you agree to our Terms of Service',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.vGapM,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrustIndicators(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TrustBadge(
            icon: Icons.verified_user,
            label: 'LPNM Verified',
            color: AppColors.secondary,
          ),
          AppSpacing.hGapM,
          Container(width: 1, height: 24, color: AppColors.outline),
          AppSpacing.hGapM,
          _TrustBadge(
            icon: Icons.lock,
            label: 'Secure',
            color: AppColors.tertiary,
          ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
