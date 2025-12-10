import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Settings box name for Hive storage
const String _settingsBoxName = 'settings';
const String _authBoxName = 'auth';

/// Keys for settings values
class SettingsKeys {
  static const String notificationsEnabled = 'notifications_enabled';
}

/// Initialize Hive for settings storage
Future<void> initSettingsStorage() async {
  await Hive.initFlutter();
  if (!Hive.isBoxOpen(_settingsBoxName)) {
    await Hive.openBox(_settingsBoxName);
  }
  if (!Hive.isBoxOpen(_authBoxName)) {
    await Hive.openBox(_authBoxName);
  }
}

/// Provider for the settings Hive box
@riverpod
Box settingsBox(Ref ref) {
  return Hive.box(_settingsBoxName);
}

/// Notifications enabled state with persistence
@riverpod
class NotificationsEnabled extends _$NotificationsEnabled {
  @override
  bool build() {
    final box = ref.watch(settingsBoxProvider);
    return box.get(SettingsKeys.notificationsEnabled, defaultValue: true) as bool;
  }

  Future<void> toggle() async {
    final box = ref.read(settingsBoxProvider);
    final newValue = !state;
    await box.put(SettingsKeys.notificationsEnabled, newValue);
    state = newValue;
  }

  Future<void> setEnabled(bool value) async {
    final box = ref.read(settingsBoxProvider);
    await box.put(SettingsKeys.notificationsEnabled, value);
    state = value;
  }
}

/// App version info provider
@riverpod
String appVersion(Ref ref) {
  // TODO: Get from package_info_plus if needed
  return '1.0.0';
}
