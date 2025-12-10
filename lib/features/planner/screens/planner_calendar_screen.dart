import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/routing/route_names.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/widgets/app_error.dart';
import 'package:nenas_kita/features/planner/models/harvest_plan_model.dart';
import 'package:nenas_kita/features/planner/providers/harvest_plan_providers.dart';
import 'package:nenas_kita/features/planner/widgets/harvest_plan_card.dart';

/// Calendar view for harvest plans with month view and daily list
class PlannerCalendarScreen extends ConsumerStatefulWidget {
  const PlannerCalendarScreen({super.key});

  @override
  ConsumerState<PlannerCalendarScreen> createState() =>
      _PlannerCalendarScreenState();
}

class _PlannerCalendarScreenState
    extends ConsumerState<PlannerCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  /// Check if two dates are on the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get plans for a specific date
  List<HarvestPlanModel> _getPlansForDay(
    DateTime day,
    List<HarvestPlanModel> allPlans,
  ) {
    return allPlans.where((plan) {
      return _isSameDay(plan.expectedHarvestDate, day);
    }).toList();
  }

  /// Get marker color based on plan status
  Color _getMarkerColor(HarvestStatus status) {
    switch (status) {
      case HarvestStatus.planned:
        return AppColors.info;
      case HarvestStatus.growing:
        return AppColors.success;
      case HarvestStatus.ready:
        return AppColors.warning;
      case HarvestStatus.harvested:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(myHarvestPlansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harvest Calendar'),
      ),
      body: plansAsync.when(
        data: (plans) {
          // Filter out completed harvests for cleaner calendar view
          final activePlans = plans
              .where((p) => p.status != HarvestStatus.harvested)
              .toList();

          final selectedDayPlans = _getPlansForDay(_selectedDay, plans);

          return Column(
            children: [
              // Calendar Widget
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  // Styling
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 3,
                    canMarkersOverflow: true,
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                  ),
                  // Event markers
                  eventLoader: (day) {
                    return _getPlansForDay(day, activePlans);
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return null;

                      return Positioned(
                        bottom: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: events.take(3).map((event) {
                            final plan = event as HarvestPlanModel;
                            return Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: _getMarkerColor(plan.status),
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Plans for selected date
              Expanded(
                child: selectedDayPlans.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_available,
                              size: 64,
                              color: AppColors.textDisabled,
                            ),
                            AppSpacing.vGapM,
                            Text(
                              'No harvests planned',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMMM d, yyyy').format(_selectedDay),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.m),
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.outlineVariant,
                                ),
                              ),
                            ),
                            child: Text(
                              DateFormat('EEEE, MMMM d, yyyy')
                                  .format(_selectedDay),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          // Plans list
                          Expanded(
                            child: ListView.builder(
                              padding: AppSpacing.pagePadding,
                              itemCount: selectedDayPlans.length,
                              itemBuilder: (context, index) {
                                final plan = selectedDayPlans[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.m,
                                  ),
                                  child: HarvestPlanCard(
                                    plan: plan,
                                    onTap: () {
                                      context.push(
                                        RouteNames.farmerPlannerEditPath(
                                          plan.id,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => AppError(
          message: 'Failed to load harvest plans',
          onRetry: () => ref.invalidate(myHarvestPlansProvider),
        ),
      ),
    );
  }
}
