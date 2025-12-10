import 'package:nenas_kita/core/constants/enums.dart';

/// Utility class for calculating harvest status and related information
/// for pineapple harvest plans.
///
/// This class provides static methods to determine the current status of a
/// harvest plan based on planting and expected harvest dates, as well as
/// helper methods for displaying progress and status information.
class HarvestStatusCalculator {
  // Private constructor to prevent instantiation
  HarvestStatusCalculator._();

  /// Calculate harvest status based on planting and expected harvest dates.
  ///
  /// Status calculation rules:
  /// - If [plantingDate] is null OR in the future → [HarvestStatus.planned]
  /// - If [plantingDate] is in the past AND today < [expectedHarvestDate] → [HarvestStatus.growing]
  /// - If today >= [expectedHarvestDate] → [HarvestStatus.ready]
  /// - [HarvestStatus.harvested] must be set manually (not calculated here)
  ///
  /// Parameters:
  /// - [plantingDate]: The date when pineapples were/will be planted (nullable)
  /// - [expectedHarvestDate]: The expected harvest date
  /// - [referenceDate]: The date to use as "today" (defaults to DateTime.now(), useful for testing)
  ///
  /// Returns: The calculated [HarvestStatus]
  static HarvestStatus calculateStatus({
    required DateTime? plantingDate,
    required DateTime expectedHarvestDate,
    DateTime? referenceDate,
  }) {
    // Use provided reference date or current date
    final now = referenceDate ?? DateTime.now();

    // Normalize dates (strip time component for accurate day-level comparisons)
    final today = DateTime(now.year, now.month, now.day);
    final normalizedExpectedHarvest = DateTime(
      expectedHarvestDate.year,
      expectedHarvestDate.month,
      expectedHarvestDate.day,
    );

    // If no planting date, status is planned
    if (plantingDate == null) {
      return HarvestStatus.planned;
    }

    final normalizedPlantingDate = DateTime(
      plantingDate.year,
      plantingDate.month,
      plantingDate.day,
    );

    // If planting date is in the future, status is planned
    if (normalizedPlantingDate.isAfter(today)) {
      return HarvestStatus.planned;
    }

    // If today is on or after expected harvest date, status is ready
    if (today.isAfter(normalizedExpectedHarvest) ||
        today.isAtSameMomentAs(normalizedExpectedHarvest)) {
      return HarvestStatus.ready;
    }

    // If planting date is today or in the past, and before harvest date, status is growing
    return HarvestStatus.growing;
  }

  /// Get a human-readable description for each harvest status.
  ///
  /// Parameters:
  /// - [status]: The harvest status to describe
  ///
  /// Returns: A user-friendly status description string
  static String getStatusDescription(HarvestStatus status) {
    switch (status) {
      case HarvestStatus.planned:
        return 'Not yet planted - planning stage';
      case HarvestStatus.growing:
        return 'Currently growing - monitor progress';
      case HarvestStatus.ready:
        return 'Ready to harvest - harvest as soon as possible';
      case HarvestStatus.harvested:
        return 'Harvested and completed';
    }
  }

  /// Get countdown or progress information as a human-readable string.
  ///
  /// Examples:
  /// - "Planting in 5 days"
  /// - "Growing for 45 days"
  /// - "Ready to harvest!"
  /// - "12 days overdue"
  ///
  /// Parameters:
  /// - [plantingDate]: The date when pineapples were/will be planted (nullable)
  /// - [expectedHarvestDate]: The expected harvest date
  /// - [currentStatus]: The current harvest status (note: uses computed status for accuracy)
  /// - [referenceDate]: The date to use as "today" (defaults to DateTime.now(), useful for testing)
  ///
  /// Returns: A descriptive status change information string
  static String getStatusChangeInfo({
    required DateTime? plantingDate,
    required DateTime expectedHarvestDate,
    required HarvestStatus currentStatus,
    DateTime? referenceDate,
  }) {
    // Use provided reference date or current date
    final now = referenceDate ?? DateTime.now();

    // Normalize dates
    final today = DateTime(now.year, now.month, now.day);
    final normalizedExpectedHarvest = DateTime(
      expectedHarvestDate.year,
      expectedHarvestDate.month,
      expectedHarvestDate.day,
    );

    // Use computed status for accurate info text (unless harvested which is manual)
    final effectiveStatus = currentStatus == HarvestStatus.harvested
        ? HarvestStatus.harvested
        : calculateStatus(
            plantingDate: plantingDate,
            expectedHarvestDate: expectedHarvestDate,
            referenceDate: referenceDate,
          );

    switch (effectiveStatus) {
      case HarvestStatus.planned:
        if (plantingDate == null) {
          // Calculate days until expected harvest
          final daysUntilHarvest = normalizedExpectedHarvest
              .difference(today)
              .inDays;
          return 'Expected harvest in $daysUntilHarvest days';
        }

        final normalizedPlantingDate = DateTime(
          plantingDate.year,
          plantingDate.month,
          plantingDate.day,
        );

        final daysUntilPlanting = normalizedPlantingDate
            .difference(today)
            .inDays;
        return 'Planting in $daysUntilPlanting ${daysUntilPlanting == 1 ? 'day' : 'days'}';

      case HarvestStatus.growing:
        if (plantingDate == null) {
          return 'Currently growing';
        }

        final normalizedPlantingDate = DateTime(
          plantingDate.year,
          plantingDate.month,
          plantingDate.day,
        );

        final daysSincePlanting = today
            .difference(normalizedPlantingDate)
            .inDays;
        final daysUntilHarvest = normalizedExpectedHarvest
            .difference(today)
            .inDays;

        return 'Growing for $daysSincePlanting ${daysSincePlanting == 1 ? 'day' : 'days'} ($daysUntilHarvest ${daysUntilHarvest == 1 ? 'day' : 'days'} until harvest)';

      case HarvestStatus.ready:
        final daysOverdue = today.difference(normalizedExpectedHarvest).inDays;

        if (daysOverdue == 0) {
          return 'Ready to harvest today!';
        } else if (daysOverdue > 0) {
          return '$daysOverdue ${daysOverdue == 1 ? 'day' : 'days'} overdue';
        } else {
          return 'Ready to harvest!';
        }

      case HarvestStatus.harvested:
        return 'Harvest completed';
    }
  }

  /// Calculate the growing progress as a percentage (0.0 to 1.0).
  ///
  /// This represents how far along the pineapples are in their growing cycle.
  /// - 0.0 = just planted or not yet planted
  /// - 0.5 = halfway through growing period
  /// - 1.0 = ready to harvest or overdue
  ///
  /// Parameters:
  /// - [plantingDate]: The date when pineapples were/will be planted (nullable)
  /// - [expectedHarvestDate]: The expected harvest date
  /// - [referenceDate]: The date to use as "today" (defaults to DateTime.now(), useful for testing)
  ///
  /// Returns: Progress value between 0.0 and 1.0
  static double calculateGrowingProgress({
    required DateTime? plantingDate,
    required DateTime expectedHarvestDate,
    DateTime? referenceDate,
  }) {
    // Use provided reference date or current date
    final now = referenceDate ?? DateTime.now();

    // Normalize dates
    final today = DateTime(now.year, now.month, now.day);
    final normalizedExpectedHarvest = DateTime(
      expectedHarvestDate.year,
      expectedHarvestDate.month,
      expectedHarvestDate.day,
    );

    // If no planting date, progress is 0%
    if (plantingDate == null) {
      return 0.0;
    }

    final normalizedPlantingDate = DateTime(
      plantingDate.year,
      plantingDate.month,
      plantingDate.day,
    );

    // If planting date is in the future, progress is 0%
    if (normalizedPlantingDate.isAfter(today)) {
      return 0.0;
    }

    // If today is on or after expected harvest date, progress is 100%
    if (today.isAfter(normalizedExpectedHarvest) ||
        today.isAtSameMomentAs(normalizedExpectedHarvest)) {
      return 1.0;
    }

    // Calculate progress as ratio of elapsed time to total growing time
    final totalGrowingDays = normalizedExpectedHarvest
        .difference(normalizedPlantingDate)
        .inDays;
    final daysSincePlanting = today.difference(normalizedPlantingDate).inDays;

    // Prevent division by zero
    if (totalGrowingDays <= 0) {
      return 1.0;
    }

    // Calculate and clamp progress between 0.0 and 1.0
    final progress = daysSincePlanting / totalGrowingDays;
    return progress.clamp(0.0, 1.0);
  }
}
