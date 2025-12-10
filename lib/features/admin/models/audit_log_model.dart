import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/utils/firestore_converters.dart';

part 'audit_log_model.freezed.dart';
part 'audit_log_model.g.dart';

@freezed
class AuditLogModel with _$AuditLogModel {
  const factory AuditLogModel({
    required String id,
    required String adminId,
    required String adminName,
    String? farmId,
    String? farmName,
    required AuditAction action,
    String? notes,
    @Default([]) List<String> attachments,
    @TimestampConverter() required DateTime timestamp,
  }) = _AuditLogModel;

  factory AuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AuditLogModelFromJson(json);

  factory AuditLogModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AuditLogModel.fromJson({...data, 'id': doc.id});
  }
}

extension AuditLogModelExtension on AuditLogModel {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  /// Get action display text
  String get actionDisplayText {
    switch (action) {
      case AuditAction.inspection:
        return 'Inspection conducted';
      case AuditAction.approved:
        return 'Farm approved';
      case AuditAction.rejected:
        return 'Farm rejected';
      case AuditAction.pending:
        return 'Pending review';
    }
  }

  /// Check if action is positive (approved)
  bool get isPositiveAction => action == AuditAction.approved;

  /// Check if action is negative (rejected)
  bool get isNegativeAction => action == AuditAction.rejected;

  /// Check if has attachments
  bool get hasAttachments => attachments.isNotEmpty;
}
