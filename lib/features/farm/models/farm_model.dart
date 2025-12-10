import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/core/utils/firestore_converters.dart';

part 'farm_model.freezed.dart';
part 'farm_model.g.dart';

@freezed
class FarmModel with _$FarmModel {
  const factory FarmModel({
    required String id,
    required String ownerId,
    required String ownerName,
    String? ownerPhone,
    required String farmName,
    String? description,
    @NullableGeoPointConverter() GeoPoint? location,
    String? address,
    required String district,
    String? licenseNumber,
    @NullableTimestampConverter() DateTime? licenseExpiry,
    double? farmSizeHectares,
    @Default([]) List<String> varieties,
    @Default({}) Map<String, String> socialLinks,
    @Default(false) bool deliveryAvailable,
    @Default(false) bool verifiedByLPNM,
    @NullableTimestampConverter() DateTime? verifiedAt,
    @Default(true) bool isActive,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _FarmModel;

  factory FarmModel.fromJson(Map<String, dynamic> json) =>
      _$FarmModelFromJson(json);

  factory FarmModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return FarmModel.fromJson({...data, 'id': doc.id});
  }
}

extension FarmModelExtension on FarmModel {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  /// Get WhatsApp link if available
  String? get whatsappLink => socialLinks['whatsapp'];

  /// Get Facebook link if available
  String? get facebookLink => socialLinks['facebook'];

  /// Get Instagram link if available
  String? get instagramLink => socialLinks['instagram'];

  /// Effective WhatsApp: socialLinks['whatsapp'] > ownerPhone fallback
  String? get effectiveWhatsAppNumber {
    final explicit = socialLinks['whatsapp'];
    if (explicit != null && explicit.isNotEmpty) return explicit;
    return ownerPhone;
  }

  /// Check if WhatsApp available
  bool get hasWhatsAppContact =>
      effectiveWhatsAppNumber != null && effectiveWhatsAppNumber!.isNotEmpty;

  /// Check if Facebook available
  bool get hasFacebookContact =>
      facebookLink != null && facebookLink!.isNotEmpty;

  /// Check if Instagram available
  bool get hasInstagramContact =>
      instagramLink != null && instagramLink!.isNotEmpty;

  /// Check if license is expired
  bool get isLicenseExpired =>
      licenseExpiry != null && licenseExpiry!.isBefore(DateTime.now());

  /// Check if farm is verified and active
  bool get isVerifiedAndActive => verifiedByLPNM && isActive;
}
