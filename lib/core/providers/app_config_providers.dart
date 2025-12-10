import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nenas_kita/core/models/app_config_model.dart';
import 'package:nenas_kita/core/repositories/app_config_repository.dart';

part 'app_config_providers.g.dart';

// ============ REPOSITORY ============

/// App config repository provider
@Riverpod(keepAlive: true)
AppConfigRepository appConfigRepository(AppConfigRepositoryRef ref) {
  return AppConfigRepository();
}

// ============ APP CONFIG ============

/// App configuration stream
@riverpod
Stream<AppConfigModel> appConfig(AppConfigRef ref) {
  return ref.watch(appConfigRepositoryProvider).watch();
}

/// App configuration (one-time fetch)
@riverpod
Future<AppConfigModel> appConfigFuture(AppConfigFutureRef ref) async {
  return ref.watch(appConfigRepositoryProvider).get();
}

// ============ CONFIG VALUES ============

/// Available pineapple varieties
@riverpod
List<String> availableVarieties(AvailableVarietiesRef ref) {
  return ref.watch(appConfigProvider).value?.varieties ??
      ['Morris', 'Josapine', 'MD2', 'Sarawak', 'Yankee'];
}

/// Available districts
@riverpod
List<String> availableDistricts(AvailableDistrictsRef ref) {
  return ref.watch(appConfigProvider).value?.districts ??
      ['Melaka Tengah', 'Alor Gajah', 'Jasin'];
}

/// Available product categories
@riverpod
List<String> availableCategories(AvailableCategoriesRef ref) {
  return ref.watch(appConfigProvider).value?.categories ??
      ['fresh', 'processed'];
}

/// Minimum required app version
@riverpod
String minAppVersion(MinAppVersionRef ref) {
  return ref.watch(appConfigProvider).value?.minAppVersion ?? '1.0.0';
}

// ============ VERSION CHECK ============

/// Check if current version is supported
@riverpod
bool isVersionSupported(IsVersionSupportedRef ref, String currentVersion) {
  final config = ref.watch(appConfigProvider).value;
  if (config == null) return true; // Default to supported if config not loaded
  return config.isVersionSupported(currentVersion);
}
