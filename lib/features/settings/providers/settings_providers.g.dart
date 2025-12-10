// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsBoxHash() => r'95cb5b1ed35fd59cc091f10a1ae5d9538a6a00fa';

/// Provider for the settings Hive box
///
/// Copied from [settingsBox].
@ProviderFor(settingsBox)
final settingsBoxProvider = AutoDisposeProvider<Box>.internal(
  settingsBox,
  name: r'settingsBoxProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsBoxRef = AutoDisposeProviderRef<Box>;
String _$appVersionHash() => r'0c30e6c7150456c44f403b85070b580ece180d49';

/// App version info provider
///
/// Copied from [appVersion].
@ProviderFor(appVersion)
final appVersionProvider = AutoDisposeProvider<String>.internal(
  appVersion,
  name: r'appVersionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appVersionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppVersionRef = AutoDisposeProviderRef<String>;
String _$notificationsEnabledHash() =>
    r'04bcd269b521d3f9ecbcafdbdafebe9fae851839';

/// Notifications enabled state with persistence
///
/// Copied from [NotificationsEnabled].
@ProviderFor(NotificationsEnabled)
final notificationsEnabledProvider =
    AutoDisposeNotifierProvider<NotificationsEnabled, bool>.internal(
  NotificationsEnabled.new,
  name: r'notificationsEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsEnabled = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
