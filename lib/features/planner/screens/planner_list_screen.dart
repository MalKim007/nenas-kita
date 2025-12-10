import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_empty_state.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/core/widgets/app_loading.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';
import 'package:nenas_kita/features/planner/widgets/harvest_plan_card.dart';

/// Harvest planner list screen with active/completed tabs
class PlannerListScreen extends ConsumerStatefulWidget {
  const PlannerListScreen({super.key});

  @override
  ConsumerState<PlannerListScreen> createState() => _PlannerListScreenState();
}

class _PlannerListScreenState extends ConsumerState<PlannerListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _activeScrollController = ScrollController();
  final ScrollController _completedScrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _activeScrollController.addListener(_onScroll);
    _completedScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _activeScrollController.removeListener(_onScroll);
    _completedScrollController.removeListener(_onScroll);
    _tabController.dispose();
    _activeScrollController.dispose();
    _completedScrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    // Update scroll button visibility when tab changes
    _onScroll();
  }

  void _onScroll() {
    final currentController = _tabController.index == 0
        ? _activeScrollController
        : _completedScrollController;

    final showButton = currentController.hasClients &&
        currentController.offset > 200;
    if (showButton != _showScrollToTop) {
      setState(() => _showScrollToTop = showButton);
    }
  }

  void _scrollToTop() {
    final currentController = _tabController.index == 0
        ? _activeScrollController
        : _completedScrollController;

    currentController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcomingHarvests = ref.watch(myUpcomingHarvestsProvider);

    // Check if any plans need reminder (7 days before harvest)
    bool showReminderBanner = false;
    upcomingHarvests.whenData((plans) {
      showReminderBanner = plans.any((p) => p.shouldSendReminder);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harvest Planner'),
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              context.push(RouteNames.farmerPlannerCalendar);
            },
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Calendar View',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Reminder Banner
          if (showReminderBanner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notification_important,
                    color: AppColors.warning,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Text(
                      'You have upcoming harvests within 7 days!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ActivePlansTab(scrollController: _activeScrollController),
                _CompletedPlansTab(scrollController: _completedScrollController),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scroll to top FAB
          AnimatedScale(
            scale: _showScrollToTop ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: FloatingActionButton.small(
              heroTag: 'scroll_to_top',
              onPressed: _scrollToTop,
              backgroundColor: AppColors.neutral100,
              foregroundColor: AppColors.textPrimary,
              child: const Icon(Icons.arrow_upward),
            ),
          ),
          if (_showScrollToTop) const SizedBox(height: AppSpacing.m),
          // Add Plan FAB
          FloatingActionButton.extended(
            heroTag: 'add_plan',
            onPressed: () {
              HapticFeedback.selectionClick();
              context.push(RouteNames.farmerPlannerAdd);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Plan'),
          ),
        ],
      ),
    );
  }
}

class _ActivePlansTab extends ConsumerWidget {
  const _ActivePlansTab({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(myHarvestPlansProvider);

    return plansAsync.when(
      data: (plans) {
        // Filter active plans (status != harvested)
        final activePlans = plans
            .where((p) => p.status != HarvestStatus.harvested)
            .toList();

        if (activePlans.isEmpty) {
          return NoPlansEmpty(
            onAddPlan: () {
              HapticFeedback.selectionClick();
              context.push(RouteNames.farmerPlannerAdd);
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myHarvestPlansProvider);
          },
          child: ListView.builder(
            controller: scrollController,
            padding: AppSpacing.pagePadding.copyWith(
              bottom: AppSpacing.l + 80, // Extra padding for FABs
            ),
            itemCount: activePlans.length,
            itemBuilder: (context, index) {
              final plan = activePlans[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.m),
                child: HarvestPlanCard(
                  plan: plan,
                  onTap: () {
                    context.push(RouteNames.farmerPlannerDetailPath(plan.id));
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const ShimmerCardList(itemCount: 4),
      error: (e, _) => AppError(
        message: 'Failed to load harvest plans',
        onRetry: () => ref.invalidate(myHarvestPlansProvider),
      ),
    );
  }
}

class _CompletedPlansTab extends ConsumerWidget {
  const _CompletedPlansTab({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(myHarvestPlansProvider);

    return plansAsync.when(
      data: (plans) {
        // Filter completed plans (status == harvested)
        final completedPlans = plans
            .where((p) => p.status == HarvestStatus.harvested)
            .toList();

        if (completedPlans.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.done_all, size: 64, color: AppColors.textDisabled),
                AppSpacing.vGapM,
                Text(
                  'No completed harvests yet',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myHarvestPlansProvider);
          },
          child: ListView.builder(
            controller: scrollController,
            padding: AppSpacing.pagePadding.copyWith(
              bottom: AppSpacing.l + 80, // Extra padding for FABs
            ),
            itemCount: completedPlans.length,
            itemBuilder: (context, index) {
              final plan = completedPlans[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.m),
                child: HarvestPlanCard(
                  plan: plan,
                  onTap: () {
                    context.push(RouteNames.farmerPlannerDetailPath(plan.id));
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const ShimmerCardList(itemCount: 4),
      error: (e, _) => AppError(
        message: 'Failed to load harvest plans',
        onRetry: () => ref.invalidate(myHarvestPlansProvider),
      ),
    );
  }
}
