import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';
import 'package:nenas_kita/core/widgets/app_card.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/pwa_install_banner.dart';
import 'package:nenas_kita/core/widgets/skeletons/skeletons.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';
import 'package:nenas_kita/features/farm/providers/farm_providers.dart';
import 'package:nenas_kita/features/farm/providers/dashboard_providers.dart';
import 'package:nenas_kita/features/farm/widgets/home/home_widgets.dart';
import 'package:nenas_kita/features/product/providers/product_providers.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';

/// Farmer home dashboard screen
class FarmerHomeScreen extends ConsumerStatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  ConsumerState<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends ConsumerState<FarmerHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    // Haptic feedback on pull-to-refresh
    await HapticFeedback.lightImpact();

    // Invalidate all relevant providers
    ref.invalidate(myPrimaryFarmProvider);
    ref.invalidate(myOverduePlansProvider);
    ref.invalidate(myUpcomingHarvestsProvider);

    // Invalidate product and price providers if farm exists
    final farm = ref.read(myPrimaryFarmProvider).valueOrNull;
    if (farm != null) {
      ref.invalidate(productsByFarmProvider(farm.id));
      ref.invalidate(myAverageProductPriceProvider(farm.id));
      if (farm.varieties.isNotEmpty) {
        ref.invalidate(marketAveragePriceProvider(farm.varieties.first));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentAppUserProvider);
    final farmAsync = ref.watch(myPrimaryFarmProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NenasKita'),
        centerTitle: false,
        actions: [
          Semantics(
            label: 'Notifications',
            button: true,
            child: IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                // TODO: Navigate to notifications in Phase 9
              },
              icon: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Please log in'));
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PWA Install Banner (web only)
                  const PwaInstallBanner(),

                  // Welcome message with fade-in animation
                  _AnimatedFadeSlide(
                    controller: _animationController,
                    delay: 0.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          semanticsLabel: 'Welcome back, ${user.name}',
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vGapL,

                  // Farm card or setup CTA
                  farmAsync.when(
                    data: (farm) {
                      if (farm == null) {
                        return _AnimatedFadeSlide(
                          controller: _animationController,
                          delay: 0.1,
                          child: _NoFarmCTA(
                            onCreateFarm: () {
                              HapticFeedback.mediumImpact();
                              context.push(RouteNames.farmerFarmSetup);
                            },
                          ),
                        );
                      }

                      // Check if user is an actual farmer (has farm with land)
                      final isActualFarmer = ref.watch(isActualFarmerProvider);

                      // Watch overdue plans for conditional banner
                      final overduePlansAsync = ref.watch(myOverduePlansProvider);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Overdue Harvest Banner (only for actual farmers)
                          if (isActualFarmer)
                            overduePlansAsync.when(
                              data: (overduePlans) {
                                if (overduePlans.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return _AnimatedFadeSlide(
                                  controller: _animationController,
                                  delay: 0.05,
                                  child: const Column(
                                    children: [
                                      OverdueHarvestBanner(),
                                      AppSpacing.vGapL,
                                    ],
                                  ),
                                );
                              },
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),

                          // Farm Info Compact Card
                          _AnimatedFadeSlide(
                            controller: _animationController,
                            delay: 0.1,
                            child: Column(
                              children: [
                                FarmInfoCompactCard(
                                  farm: farm,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    context.push(RouteNames.farmerFarm);
                                  },
                                ),
                                AppSpacing.vGapL,
                              ],
                            ),
                          ),

                          // Latest Harvest Card (only for actual farmers)
                          if (isActualFarmer)
                            _AnimatedFadeSlide(
                              controller: _animationController,
                              delay: 0.15,
                              child: const Column(
                                children: [
                                  LatestHarvestCard(),
                                  AppSpacing.vGapL,
                                ],
                              ),
                            ),

                          // TODO: Business Snapshot Card - will be used/changed/reconsidered in the future
                          // See: lib/features/farm/widgets/home/business_snapshot_card.dart
                          // _AnimatedFadeSlide(
                          //   controller: _animationController,
                          //   delay: 0.2,
                          //   child: Column(
                          //     children: [
                          //       BusinessSnapshotCard(
                          //         farmId: farm.id,
                          //         primaryVariety: farm.varieties.isNotEmpty
                          //             ? farm.varieties.first
                          //             : 'Morris',
                          //       ),
                          //       AppSpacing.vGapL,
                          //     ],
                          //   ),
                          // ),

                          // Quick Actions (View Planner only for actual farmers)
                          _AnimatedFadeSlide(
                            controller: _animationController,
                            delay: 0.3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Semantics(
                                    label: 'Add new product',
                                    button: true,
                                    child: AppButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        context.push(RouteNames.farmerProductAdd);
                                      },
                                      label: 'Add Product',
                                      icon: Icons.add,
                                      isFullWidth: true,
                                    ),
                                  ),
                                ),
                                if (isActualFarmer) ...[
                                  AppSpacing.hGapM,
                                  Expanded(
                                    child: Semantics(
                                      label: 'View harvest planner',
                                      button: true,
                                      child: AppButton(
                                        onPressed: () {
                                          HapticFeedback.selectionClick();
                                          context.go(RouteNames.farmerPlanner);
                                        },
                                        label: 'View Planner',
                                        variant: AppButtonVariant.secondary,
                                        isFullWidth: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const FarmerHomeSkeleton(),
                    error: (e, _) => AppError(
                      message: 'Failed to load business data',
                      onRetry: () {
                        HapticFeedback.lightImpact();
                        ref.invalidate(myPrimaryFarmProvider);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const FarmerHomeSkeleton(),
        error: (e, _) => AppError(
          message: 'Failed to load user data',
          onRetry: () {
            HapticFeedback.lightImpact();
            ref.invalidate(currentAppUserProvider);
          },
        ),
      ),
    );
  }
}

/// Staggered fade and slide animation widget
class _AnimatedFadeSlide extends StatelessWidget {
  const _AnimatedFadeSlide({
    required this.controller,
    required this.delay,
    required this.child,
  });

  final AnimationController controller;
  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        delay + 0.5,
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

/// CTA banner for farmers without a farm
class _NoFarmCTA extends StatelessWidget {
  const _NoFarmCTA({required this.onCreateFarm});

  final VoidCallback onCreateFarm;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Create your business profile to start selling pineapples',
      button: true,
      child: WarmCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                AppSpacing.hGapM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Your Business Profile',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      AppSpacing.vGapXS,
                      Text(
                        'Set up your business to start selling pineapples',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.vGapM,
            AppButton(
              onPressed: onCreateFarm,
              label: 'Create Business',
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
