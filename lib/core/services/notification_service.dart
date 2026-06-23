import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:taxi_app/core/routing/router_generation_config.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/core/widgets/custom_snack_bar.dart';

/// Background/terminated-state message handler. Must be a top-level function
/// annotated with `@pragma('vm:entry-point')` so it survives tree-shaking and
/// can run in its own isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Notification-type messages are rendered by the OS tray automatically.
  // Keep this minimal; heavy work here is discouraged.
  debugPrint('FCM background message: ${message.messageId}');
}

/// Firebase Cloud Messaging (push) integration.
///
/// Decision: push-only (no flutter_local_notifications). Background/terminated
/// notification messages appear in the system tray automatically; foreground
/// messages are surfaced as an in-app snackbar via the root navigator context.
class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Requests permission, wires message handlers, and keeps the stored token
  /// fresh. Call once after `Firebase.initializeApp`.
  static Future<void> init() async {
    await _messaging.requestPermission();

    // iOS: show alerts/badge/sound while the app is in the foreground.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _messaging.onTokenRefresh.listen((token) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Route to the right collection using the persisted role; the refresh
        // callback has no role context of its own.
        _writeToken(user.uid, token, role: Prefs.getUser()?.role);
      }
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) _handleOpenedMessage(initialMessage);
  }

  /// Persists the device FCM token onto the user's Firestore document so a
  /// backend can target this device. [role] selects the collection.
  static Future<void> saveTokenForUser(String uid, String role) async {
    if (uid.isEmpty) return;
    final token = await _messaging.getToken();
    if (token == null) return;
    await _writeToken(uid, token, role: role);
  }

  static Future<void> _writeToken(
    String uid,
    String token, {
    String? role,
  }) async {
    final collection = role == 'driver' ? 'drivers' : 'users';
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(uid)
          .set({'fcmToken': token}, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final context = RouterGenerationConfig.rootNavigatorKey.currentContext;
    if (notification == null || context == null) return;

    final title = notification.title;
    final body = notification.body ?? '';
    customSnackBar(
      context: context,
      message: title != null && title.isNotEmpty ? '$title: $body' : body,
      type: AnimatedSnackBarType.info,
    );
  }

  static void _handleOpenedMessage(RemoteMessage message) {
    // Hook for deep-linking on notification tap (no-op for now).
    debugPrint('FCM opened message: ${message.messageId}');
  }
}
