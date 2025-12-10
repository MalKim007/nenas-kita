import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/services/providers/service_providers.dart';

/// Splash screen with auto-login check, gradient background & animated icon
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;

  // Track when screen becomes visible for minimum display time
  late final DateTime _mountTime;
  static const _minDisplayDuration = Duration(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _mountTime = DateTime.now();
    _setupAnimations();
    _checkAuthAndNavigate();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Scale animation for the icon
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    // Fade animation for text
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    // Subtle bounce for the icon
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Perform auth check while animation plays (in parallel)
    final authService = ref.read(authServiceProvider);
    final userId = authService.currentUserId;

    String destination;

    if (userId == null) {
      // Not authenticated - go to login
      destination = RouteNames.login;
    } else {
      // Authenticated - fetch user from Firestore
      final user = await authService.getCurrentUser();

      if (user == null) {
        // User ID in Hive but no Firestore document - clear and go to login
        await authService.signOut();
        destination = RouteNames.login;
      } else {
        // Has profile - go to role-based home
        destination = switch (user.role.name) {
          'farmer' => RouteNames.farmerHome,
          'admin' || 'superadmin' => RouteNames.adminDashboard,
          _ => RouteNames.buyerHome,
        };
      }
    }

    // Ensure minimum display time (2 seconds from mount)
    final elapsed = DateTime.now().difference(_mountTime);
    final remaining = _minDisplayDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    // Navigate to destination
    if (mounted) {
      context.go(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFBEB), // Very light cream
              Color(0xFFFEF3C7), // Warm amber tint
              Color(0xFFFBBF24), // Vibrant amber at bottom
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated pineapple icon
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          -8 * (1 - _bounceAnimation.value),
                        ),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
                              child: Image.asset(
                                'assets/images/AppIcon.jpeg',
                                fit: BoxFit.cover,
                                width: 96,
                                height: 96,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                AppSpacing.vGapL,
                // Animated app name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_fadeAnimation),
                    child: Text(
                      'NenasKita',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ),
                ),
                AppSpacing.vGapS,
                // Animated tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Melaka Pineapple Marketplace',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
                AppSpacing.vGapXL,
                // Loading indicator with fade-in
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const AppLoading(size: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


