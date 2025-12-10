// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as web;

/// Web implementation of PWA service using JS interop

/// Check if running as installed PWA
bool isPwaInstalled() {
  return _callJsFunction('isPwaInstalled') ?? false;
}

/// Check if install prompt is available
bool isPwaInstallAvailable() {
  return _callJsFunction('isPwaInstallAvailable') ?? false;
}

/// Trigger the PWA install prompt
Future<String> promptPwaInstall() async {
  final completer = Completer<String>();

  try {
    final result = _callJsPromptInstall();
    if (result != null) {
      // Handle the promise
      result.toDart.then((value) {
        completer.complete(value?.toString() ?? 'unavailable');
      }).catchError((error) {
        completer.complete('unavailable');
      });
    } else {
      completer.complete('unavailable');
    }
  } catch (e) {
    completer.complete('unavailable');
  }

  return completer.future;
}

/// Listen for install prompt availability
void listenForInstallPrompt(void Function(bool) callback) {
  // Listen for custom event from index.html
  web.window.addEventListener(
    'pwa-install-available',
    (web.Event event) {
      callback(true);
    }.toJS,
  );

  web.window.addEventListener(
    'pwa-installed',
    (web.Event event) {
      callback(false);
    }.toJS,
  );
}

/// Helper to call JS functions that return bool
bool? _callJsFunction(String functionName) {
  try {
    final jsWindow = web.window;
    final result = jsWindow.getProperty(functionName.toJS);
    if (result != null && result.isA<JSFunction>()) {
      final fn = result as JSFunction;
      final callResult = fn.callAsFunction();
      if (callResult != null && callResult.isA<JSBoolean>()) {
        return (callResult as JSBoolean).toDart;
      }
    }
  } catch (e) {
    // Function not available
  }
  return null;
}

/// Helper to call promptPwaInstall which returns a Promise
JSPromise<JSString?>? _callJsPromptInstall() {
  try {
    final jsWindow = web.window;
    final result = jsWindow.getProperty('promptPwaInstall'.toJS);
    if (result != null && result.isA<JSFunction>()) {
      final fn = result as JSFunction;
      final callResult = fn.callAsFunction();
      if (callResult != null && callResult.isA<JSPromise>()) {
        return callResult as JSPromise<JSString?>;
      }
    }
  } catch (e) {
    // Function not available
  }
  return null;
}
