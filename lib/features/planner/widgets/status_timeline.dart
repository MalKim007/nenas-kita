import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';

/// Horizontal visual timeline showing harvest plan progression.
///
/// Displays status progression: Planned → Growing → Ready → Harvested
/// - Filled circles for completed steps
/// - Current step highlighted with primary color (amber) and pulse animation
/// - Shows contextual info text below timeline
/// - Supports auto-calculated status indicator
class StatusTimeline extends StatefulWidget {
  /// The current harvest status.
  final HarvestStatus currentStatus;

  /// Optional contextual info text (e.g., "45 days until harvest")
  final String? infoText;

  /// Whether status is auto-calculated (shows AUTO badge)
  final bool isAutoCalculated;

  const StatusTimeline({
    super.key,
    required this.currentStatus,
    this.infoText,
    this.isAutoCalculated = false,
  });

  @override
  State<StatusTimeline> createState() => _StatusTimelineState();
}

class _StatusTimelineState extends State<StatusTimeline>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      _TimelineStep(
        status: HarvestStatus.planned,
        label: 'Planned',
        icon: Icons.calendar_today,
      ),
      _TimelineStep(
        status: HarvestStatus.growing,
        label: 'Growing',
        icon: Icons.grass,
      ),
      _TimelineStep(
        status: HarvestStatus.ready,
        label: 'Ready',
        icon: Icons.check_circle,
      ),
      _TimelineStep(
        status: HarvestStatus.harvested,
        label: 'Harvested',
        icon: Icons.done_all,
      ),
    ];

    final currentIndex = steps.indexWhere(
      (s) => s.status == widget.currentStatus,
    );

    return Container(
      padding: EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Auto badge row
          if (widget.isAutoCalculated)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: AppColors.info,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'AUTO-CALCULATED',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.info,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // Timeline row
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Connector line
                final lineIndex = index ~/ 2;
                final isCompleted = lineIndex < currentIndex;
                return Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.outline.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              } else {
                // Step circle
                final stepIndex = index ~/ 2;
                final step = steps[stepIndex];
                final isCompleted = stepIndex < currentIndex;
                final isCurrent = stepIndex == currentIndex;

                return _TimelineNode(
                  step: step,
                  isCompleted: isCompleted,
                  isCurrent: isCurrent,
                  pulseAnimation: isCurrent ? _pulseAnimation : null,
                );
              }
            }),
          ),
          // Info text row
          if (widget.infoText != null) ...[
            SizedBox(height: AppSpacing.m),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, size: 14, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    widget.infoText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineStep {
  final HarvestStatus status;
  final String label;
  final IconData icon;

  _TimelineStep({
    required this.status,
    required this.label,
    required this.icon,
  });
}

class _TimelineNode extends StatelessWidget {
  final _TimelineStep step;
  final bool isCompleted;
  final bool isCurrent;
  final Animation<double>? pulseAnimation;

  const _TimelineNode({
    required this.step,
    required this.isCompleted,
    required this.isCurrent,
    this.pulseAnimation,
  });

  Color _getNodeColor() {
    if (isCurrent) return AppColors.primary;
    if (isCompleted) return AppColors.primary;
    return AppColors.outline;
  }

  Color _getIconColor() {
    if (isCurrent) return Colors.white;
    if (isCompleted) return Colors.white;
    return AppColors.textSecondary;
  }

  Color _getTextColor() {
    if (isCurrent) return AppColors.primary;
    if (isCompleted) return AppColors.textPrimary;
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    Widget nodeCircle = Container(
      width: isCurrent ? 48 : 40,
      height: isCurrent ? 48 : 40,
      decoration: BoxDecoration(
        color: (isCurrent || isCompleted) ? _getNodeColor() : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: _getNodeColor(), width: isCurrent ? 3 : 2),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Icon(step.icon, size: isCurrent ? 24 : 20, color: _getIconColor()),
    );

    // Wrap with pulse animation if provided
    if (pulseAnimation != null && isCurrent) {
      nodeCircle = AnimatedBuilder(
        animation: pulseAnimation!,
        builder: (context, child) {
          return Transform.scale(scale: pulseAnimation!.value, child: child);
        },
        child: nodeCircle,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        nodeCircle,
        SizedBox(height: AppSpacing.s),
        SizedBox(
          width: 60,
          child: Text(
            step.label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getTextColor(),
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
