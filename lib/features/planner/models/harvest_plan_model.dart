import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/utils/firestore_converters.dart';
import 'package:nenas_kita/features/planner/utils/harvest_status_calculator.dart';

part 'harvest_plan_model.freezed.dart';
part 'harvest_plan_model.g.dart';

@freezed
class HarvestPlanModel with _$HarvestPlanModel {
  const factory HarvestPlanModel({
    required String id,
    required String farmId,
    required String farmName,
    required String ownerId,
    required String variety,
    required double quantityKg,
    @NullableTimestampConverter() DateTime? plantingDate,
    @TimestampConverter() required DateTime expectedHarvestDate,
    @NullableTimestampConverter() DateTime? actualHarvestDate,
    required HarvestStatus status,
    String? notes,
    @Default(false) bool reminderSent,
    @TimestampConverter() required DateTime createdAt,
  }) = _HarvestPlanModel;

  factory HarvestPlanModel.fromJson(Map<String, dynamic> json) =>
      _$HarvestPlanModelFromJson(json);

  factory HarvestPlanModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return HarvestPlanModel.fromJson({...data, 'id': doc.id});
  }
}

extension HarvestPlanModelExtension on HarvestPlanModel {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  /// Days until expected harvest
  int get daysUntilHarvest =>
      expectedHarvestDate.difference(DateTime.now()).inDays;

  /// Check if harvest is overdue
  bool get isOverdue =>
      status != HarvestStatus.harvested &&
      expectedHarvestDate.isBefore(DateTime.now());

  /// Check if ready for reminder (7 days before)
  bool get shouldSendReminder =>
      !reminderSent &&
      status == HarvestStatus.growing &&
      daysUntilHarvest <= 7 &&
      daysUntilHarvest >= 0;

  /// Check if harvest is completed
  bool get isCompleted => status == HarvestStatus.harvested;

  /// Calculate what status should be based on dates (auto-calculated)
  HarvestStatus get computedStatus {
    return HarvestStatusCalculator.calculateStatus(
      plantingDate: plantingDate,
      expectedHarvestDate: expectedHarvestDate,
    );
  }

  /// Check if current status differs from computed status (manual override)
  bool get hasManualOverride {
    return status != HarvestStatus.harvested && status != computedStatus;
  }

  /// Get countdown/progress info text
  String get statusChangeInfo {
    return HarvestStatusCalculator.getStatusChangeInfo(
      plantingDate: plantingDate,
      expectedHarvestDate: expectedHarvestDate,
      currentStatus: status,
    );
  }

  /// Get growing progress as percentage (0.0 to 1.0)
  double get growingProgress {
    return HarvestStatusCalculator.calculateGrowingProgress(
      plantingDate: plantingDate,
      expectedHarvestDate: expectedHarvestDate,
    );
  }
}
