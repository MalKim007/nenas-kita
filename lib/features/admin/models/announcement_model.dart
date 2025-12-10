import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/utils/firestore_converters.dart';

part 'announcement_model.freezed.dart';
part 'announcement_model.g.dart';

@freezed
class AnnouncementModel with _$AnnouncementModel {
  const factory AnnouncementModel({
    required String id,
    required String title,
    required String body,
    required AnnouncementType type,
    @Default([]) List<String> targetRoles,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? expiresAt,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);

  factory AnnouncementModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AnnouncementModel.fromJson({...data, 'id': doc.id});
  }
}

extension AnnouncementModelExtension on AnnouncementModel {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  /// Check if announcement is expired
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());

  /// Check if announcement is active (not expired)
  bool get isActive => !isExpired;

  /// Check if announcement targets a specific role
  bool targetsRole(UserRole role) =>
      targetRoles.isEmpty || targetRoles.contains(role.name);

  /// Check if announcement is for all users
  bool get isForAllUsers => targetRoles.isEmpty;

  /// Get type-based priority (warning > promo > info)
  int get priority {
    switch (type) {
      case AnnouncementType.warning:
        return 3;
      case AnnouncementType.promo:
        return 2;
      case AnnouncementType.info:
        return 1;
    }
  }
}
