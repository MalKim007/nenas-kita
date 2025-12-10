import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/utils/firestore_converters.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? phone,
    required UserRole role,
    String? avatarUrl,
    String? district,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
    @Default(false) bool isVerified,
    String? fcmToken,
    String? firebaseUid,
    @Default(false) bool hasPassword,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel.fromJson({
      ...data,
      'id': doc.id,
      // Backward compatibility for legacy documents without email field
      'email': data['email'] ?? '',
    });
  }
}

extension UserModelExtension on UserModel {
  /// Convert to Firestore document (without id)
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  /// Check if user is admin or superadmin
  bool get isAdmin => role == UserRole.admin || role == UserRole.superadmin;

  /// Check if user is superadmin
  bool get isSuperAdmin => role == UserRole.superadmin;

  /// Check if user can create farms
  bool get canCreateFarm => role == UserRole.farmer;

  /// Check if user can view wholesale prices
  bool get canViewWholesalePrices =>
      role == UserRole.wholesaler ||
      role == UserRole.admin ||
      role == UserRole.superadmin;
}
