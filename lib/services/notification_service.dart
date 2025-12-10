import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nenas_kita/services/firebase_service.dart';

/// Service for Firebase Cloud Messaging (FCM) push notifications
class NotificationService {
  final FirebaseService _firebaseService;

  NotificationService({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  FirebaseMessaging get _messaging => _firebaseService.messaging;

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    // Request permission for iOS
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Get initial token
      await getToken();
    }
  }

  /// Get FCM token for this device
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Listen to token refresh events
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    // Sanitize topic name (FCM topic rules)
    final sanitizedTopic = _sanitizeTopic(topic);
    await _messaging.subscribeToTopic(sanitizedTopic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    final sanitizedTopic = _sanitizeTopic(topic);
    await _messaging.unsubscribeFromTopic(sanitizedTopic);
  }

  /// Subscribe to district topic for local announcements
  Future<void> subscribeToDistrict(String district) async {
    final topic = 'district_${_sanitizeTopic(district)}';
    await subscribeToTopic(topic);
  }

  /// Unsubscribe from district topic
  Future<void> unsubscribeFromDistrict(String district) async {
    final topic = 'district_${_sanitizeTopic(district)}';
    await unsubscribeFromTopic(topic);
  }

  /// Subscribe to role-based topic
  Future<void> subscribeToRole(String role) async {
    await subscribeToTopic(role);
  }

  /// Unsubscribe from role-based topic
  Future<void> unsubscribeFromRole(String role) async {
    await unsubscribeFromTopic(role);
  }

  /// Subscribe to all users topic
  Future<void> subscribeToAllUsers() async {
    await subscribeToTopic('all_users');
  }

  /// Get notification settings
  Future<NotificationSettings> getSettings() async {
    return await _messaging.getNotificationSettings();
  }

  /// Handle foreground messages
  void onForegroundMessage(void Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessage.listen(handler);
  }

  /// Handle background message tap (when app is in background)
  void onMessageOpenedApp(void Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen(handler);
  }

  /// Get initial message (when app is opened from terminated state via notification)
  Future<RemoteMessage?> getInitialMessage() async {
    return await _messaging.getInitialMessage();
  }

  /// Sanitize topic name for FCM
  /// Topics must match: [a-zA-Z0-9-_.~%]+
  String _sanitizeTopic(String topic) {
    return topic
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9\-_.~%]'), '');
  }
}
