import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/admin/models/audit_log_model.dart';
import 'package:nenas_kita/features/admin/repositories/audit_log_repository.dart';

part 'audit_log_providers.g.dart';

// ============ REPOSITORY ============

/// Audit log repository provider
@Riverpod(keepAlive: true)
AuditLogRepository auditLogRepository(AuditLogRepositoryRef ref) {
  return AuditLogRepository();
}

// ============ RECENT LOGS ============

/// Recent audit logs
@riverpod
Stream<List<AuditLogModel>> recentAuditLogs(
  RecentAuditLogsRef ref, {
  int limit = 100,
}) {
  return ref.watch(auditLogRepositoryProvider).watchRecent(limit: limit);
}

// ============ LOGS BY FARM ============

/// Audit logs for a specific farm
@riverpod
Stream<List<AuditLogModel>> auditLogsByFarm(
  AuditLogsByFarmRef ref,
  String farmId,
) {
  return ref.watch(auditLogRepositoryProvider).watchByFarm(farmId);
}

/// Latest audit log for a farm
@riverpod
Future<AuditLogModel?> latestAuditLogForFarm(
  LatestAuditLogForFarmRef ref,
  String farmId,
) async {
  return ref.watch(auditLogRepositoryProvider).getLatestForFarm(farmId);
}

// ============ LOGS BY ADMIN ============

/// Audit logs by admin
@riverpod
Stream<List<AuditLogModel>> auditLogsByAdmin(
  AuditLogsByAdminRef ref,
  String adminId,
) {
  return ref.watch(auditLogRepositoryProvider).watchByAdmin(adminId);
}

// ============ LOGS BY ACTION ============

/// Audit logs by action type
@riverpod
Stream<List<AuditLogModel>> auditLogsByAction(
  AuditLogsByActionRef ref,
  AuditAction action,
) {
  return ref.watch(auditLogRepositoryProvider).watchByAction(action);
}

/// Approval logs
@riverpod
Stream<List<AuditLogModel>> approvalLogs(ApprovalLogsRef ref) {
  return ref.watch(auditLogRepositoryProvider).watchByAction(AuditAction.approved);
}

/// Rejection logs
@riverpod
Stream<List<AuditLogModel>> rejectionLogs(RejectionLogsRef ref) {
  return ref.watch(auditLogRepositoryProvider).watchByAction(AuditAction.rejected);
}

/// Inspection logs
@riverpod
Stream<List<AuditLogModel>> inspectionLogs(InspectionLogsRef ref) {
  return ref.watch(auditLogRepositoryProvider).watchByAction(AuditAction.inspection);
}

// ============ STATS ============

/// Total audit logs count
@riverpod
Future<int> totalAuditLogsCount(TotalAuditLogsCountRef ref) async {
  return ref.watch(auditLogRepositoryProvider).getTotalCount();
}

/// Audit logs count by action
@riverpod
Future<int> auditLogsCountByAction(
  AuditLogsCountByActionRef ref,
  AuditAction action,
) async {
  return ref.watch(auditLogRepositoryProvider).getCountByAction(action);
}

/// Audit logs count for last N days
@riverpod
Future<int> auditLogsCountForDays(
  AuditLogsCountForDaysRef ref,
  int days,
) async {
  return ref.watch(auditLogRepositoryProvider).getCountForDays(days);
}
