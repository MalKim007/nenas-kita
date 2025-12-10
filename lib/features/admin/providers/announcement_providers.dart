import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/features/admin/models/announcement_model.dart';
import 'package:nenas_kita/features/admin/repositories/announcement_repository.dart';
import 'package:nenas_kita/features/auth/providers/user_providers.dart';

part 'announcement_providers.g.dart';

// ============ REPOSITORY ============

/// Announcement repository provider
@Riverpod(keepAlive: true)
AnnouncementRepository announcementRepository(AnnouncementRepositoryRef ref) {
  return AnnouncementRepository();
}

// ============ SINGLE ANNOUNCEMENT ============

/// Get announcement by ID
@riverpod
Stream<AnnouncementModel?> announcementById(
  AnnouncementByIdRef ref,
  String announcementId,
) {
  return ref.watch(announcementRepositoryProvider).watchAnnouncement(announcementId);
}

// ============ ACTIVE ANNOUNCEMENTS ============

/// All active announcements
@riverpod
Stream<List<AnnouncementModel>> activeAnnouncements(ActiveAnnouncementsRef ref) {
  return ref.watch(announcementRepositoryProvider).watchActive();
}

/// Active announcements for current user's role
@riverpod
Stream<List<AnnouncementModel>> myAnnouncements(MyAnnouncementsRef ref) {
  final role = ref.watch(currentUserRoleProvider);
  if (role == null) return Stream.value([]);
  return ref.watch(announcementRepositoryProvider).watchForRole(role);
}

/// Announcements for a specific role
@riverpod
Stream<List<AnnouncementModel>> announcementsForRole(
  AnnouncementsForRoleRef ref,
  UserRole role,
) {
  return ref.watch(announcementRepositoryProvider).watchForRole(role);
}

// ============ ALL ANNOUNCEMENTS ============

/// All announcements (for admin)
@riverpod
Stream<List<AnnouncementModel>> allAnnouncements(AllAnnouncementsRef ref) {
  return ref.watch(announcementRepositoryProvider).watchAll();
}

// ============ STATS ============

/// Active announcements count
@riverpod
Future<int> activeAnnouncementsCount(ActiveAnnouncementsCountRef ref) async {
  return ref.watch(announcementRepositoryProvider).getActiveCount();
}

/// Total announcements count
@riverpod
Future<int> totalAnnouncementsCount(TotalAnnouncementsCountRef ref) async {
  return ref.watch(announcementRepositoryProvider).getTotalCount();
}
