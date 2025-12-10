import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

@freezed
class AppConfigModel with _$AppConfigModel {
  const factory AppConfigModel({
    @Default(['Morris', 'Josapine', 'MD2', 'Sarawak', 'Yankee'])
    List<String> varieties,
    @Default(['Melaka Tengah', 'Alor Gajah', 'Jasin']) List<String> districts,
    @Default(['fresh', 'processed']) List<String> categories,
    @Default('1.0.0') String minAppVersion,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);

  factory AppConfigModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppConfigModel.fromJson(data);
  }

  /// Default config when Firestore document doesn't exist
  factory AppConfigModel.defaults() => const AppConfigModel();
}

extension AppConfigModelExtension on AppConfigModel {
  Map<String, dynamic> toFirestore() => toJson();

  /// Check if app version meets minimum requirement
  bool isVersionSupported(String currentVersion) {
    final minParts = minAppVersion.split('.').map(int.parse).toList();
    final currentParts = currentVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < minParts.length && i < currentParts.length; i++) {
      if (currentParts[i] > minParts[i]) return true;
      if (currentParts[i] < minParts[i]) return false;
    }
    return true;
  }
}
