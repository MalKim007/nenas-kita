import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/utils/password_utils.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_snackbar.dart';
import 'package:nenas_kita/core/widgets/app_text_field.dart';
import 'package:nenas_kita/core/widgets/password_text_field.dart';
import 'package:nenas_kita/features/auth/providers/auth_flow_providers.dart';
import 'package:nenas_kita/features/auth/widgets/role_card.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Registration screen with role selection and profile info in one screen
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserRole? _selectedRole;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _selectRole(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  Future<void> _register() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      AppSnackbar.showError(context, 'Please fill in all fields');
      return;
    }

    // Check if role is selected
    if (_selectedRole == null) {
      AppSnackbar.showError(context, 'Please select your role');
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate name
    if (name.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your name');
      return;
    }

    final authService = ref.read(authServiceProvider);

    // Validate email format
    if (!authService.isValidEmail(email)) {
      AppSnackbar.showError(context, 'Please enter a valid email address');
      return;
    }

    // Validate password
    final passwordValidation = PasswordUtils.validate(password);
    if (!passwordValidation.isValid) {
      AppSnackbar.showError(context, passwordValidation.firstError ?? 'Invalid password');
      return;
    }

    // Validate password confirmation
    if (password != confirmPassword) {
      AppSnackbar.showError(context, 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Register user with password
      await authService.registerWithPassword(
        name: name,
        email: email,
        password: password,
        role: _selectedRole!,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Store selected role
      ref.read(selectedRoleProvider.notifier).state = _selectedRole;

      // Show success message first
      AppSnackbar.showSuccess(context, 'Account created successfully!');

      // Navigate to profile setup
      context.go(RouteNames.profileSetup);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered. Please login instead.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Please use a stronger password.';
          break;
        default:
          errorMessage = 'Failed to create account. Please try again.';
      }

      AppSnackbar.showError(context, errorMessage);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Handle specific error messages
      String errorMessage;
      final error = e.toString();
      if (error.contains('already registered')) {
        errorMessage = 'This email is already registered. Please login instead.';
      } else if (error.contains('email-already-in-use')) {
        errorMessage = 'This email is already registered. Please login instead.';
      } else if (error.contains('weak-password')) {
        errorMessage = 'Password is too weak. Please use a stronger password.';
      } else {
        errorMessage = 'Failed to create account. Please try again.';
      }

      AppSnackbar.showError(context, errorMessage);
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFCFA),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Top bar with back button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _isLoading ? null : () => context.go(RouteNames.login),
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                      ),
                      AppSpacing.vGapS,
                      // Subtitle
                      Text(
                        'Enter your details to get started',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      AppSpacing.vGapXL,
                      // Name field
                      AppTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        enabled: !_isLoading,
                        textCapitalization: TextCapitalization.words,
                        validator: _validateName,
                      ),
                      AppSpacing.vGapM,
                      // Email field
                      EmailTextField(
                        controller: _emailController,
                        label: 'Email',
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
                      ),
                      AppSpacing.vGapM,
                      // Password field
                      PasswordTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Min 8 chars, 1 upper, 1 lower, 1 digit',
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
                      ),
                      AppSpacing.vGapM,
                      // Confirm password field
                      PasswordTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Re-enter your password',
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.done,
                      ),
                      AppSpacing.vGapXL,
                      // Role selection header
                      Text(
                        'I am a...',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      AppSpacing.vGapS,
                      Text(
                        'Select your role to personalize your experience',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      AppSpacing.vGapM,
                      // Role cards
                      RoleCard(
                        icon: Icons.agriculture,
                        title: 'Farmer / Seller',
                        description: 'I grow / sell products',
                        isSelected: _selectedRole == UserRole.farmer,
                        onTap: () => _selectRole(UserRole.farmer),
                      ),
                      AppSpacing.vGapM,
                      RoleCard(
                        icon: Icons.shopping_cart,
                        title: 'Buyer',
                        description: 'I want to purchase pineapples',
                        isSelected: _selectedRole == UserRole.buyer,
                        onTap: () => _selectRole(UserRole.buyer),
                      ),
                      AppSpacing.vGapM,
                      RoleCard(
                        icon: Icons.store,
                        title: 'Wholesaler',
                        description: 'I buy products in bulk',
                        isSelected: _selectedRole == UserRole.wholesaler,
                        onTap: () => _selectRole(UserRole.wholesaler),
                      ),
                      AppSpacing.vGapXL,
                      // Register button
                      AppButton(
                        onPressed: _isLoading ? null : _register,
                        label: 'Register',
                        isLoading: _isLoading,
                      ),
                      AppSpacing.vGapM,
                      // Login link
                      _buildLoginLink(context),
                      AppSpacing.vGapM,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        GestureDetector(
          onTap: _isLoading ? null : () => context.go(RouteNames.login),
          child: Text(
            'Login',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
