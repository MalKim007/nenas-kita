// Stub implementation for non-web platforms
// These functions are no-ops on mobile/desktop

/// Check if PWA is installed (always false on non-web)
bool isPwaInstalled() => false;

/// Check if install prompt is available (always false on non-web)
bool isPwaInstallAvailable() => false;

/// Prompt PWA install (no-op on non-web)
Future<String> promptPwaInstall() async => 'unavailable';

/// Listen for install prompt (no-op on non-web)
void listenForInstallPrompt(void Function(bool) callback) {}
