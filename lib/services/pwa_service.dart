import 'dart:async';
import 'package:flutter/foundation.dart';
import 'pwa_service_stub.dart'
    if (dart.library.html) 'pwa_service_web.dart' as pwa_impl;

/// Service for PWA functionality (Progressive Web App)
/// Handles install prompts and checks for web platform.
class PwaService {
  PwaService._();
  static final PwaService instance = PwaService._();

  final _installAvailableController = StreamController<bool>.broadcast();
  final _installedController = StreamController<bool>.broadcast();

  /// Stream that emits when install prompt becomes available
  Stream<bool> get onInstallAvailableChanged => _installAvailableController.stream;
  Stream<bool> get onInstalledChanged => _installedController.stream;

  bool _initialized = false;
  bool _isInstallAvailable = false;
  bool _isInstalled = false;

  /// Whether the PWA install prompt is available
  bool get isInstallAvailable => _isInstallAvailable;

  /// Whether the app is running as an installed PWA
  bool get isInstalled {
    if (!kIsWeb) return false;
    return _isInstalled;
  }

  /// Initialize the PWA service (call once at app startup)
  void initialize() {
    if (!kIsWeb || _initialized) return;
    _initialized = true;

    // Seed installed state
    _isInstalled = pwa_impl.isPwaInstalled();
    _installedController.add(_isInstalled);

    // Listen for install availability from JS
    pwa_impl.listenForInstallPrompt((available) {
      _isInstallAvailable = available;
      _installAvailableController.add(available);

      // Update installed state when events fire
      final installedNow = pwa_impl.isPwaInstalled();
      if (installedNow != _isInstalled) {
        _isInstalled = installedNow;
        _installedController.add(_isInstalled);
      }
    });

    // Check initial state
    _isInstallAvailable = pwa_impl.isPwaInstallAvailable();
  }

  /// Prompt the user to install the PWA
  /// Returns 'accepted', 'dismissed', or 'unavailable'
  Future<String> promptInstall() async {
    if (!kIsWeb) {
      return 'unavailable';
    }

    final result = await pwa_impl.promptPwaInstall();
    if (result != 'unavailable') {
      _isInstallAvailable = pwa_impl.isPwaInstallAvailable();
      _installAvailableController.add(_isInstallAvailable);

      final installedNow = pwa_impl.isPwaInstalled();
      if (installedNow != _isInstalled) {
        _isInstalled = installedNow;
        _installedController.add(_isInstalled);
      }
    }
    return result;
  }

  /// Dispose resources
  void dispose() {
    _installAvailableController.close();
    _installedController.close();
  }
}
