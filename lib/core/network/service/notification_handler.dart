import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ripple/core/network/service/notification_service.dart';
import 'package:ripple/main.dart';

class NotificationHandler {
  static Future<void> initFirebaseMessaging() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen to messages when app is in foreground
    FirebaseMessaging.onMessage.listen(handleForegroundMessage);

    // Handle when app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && navigatorKey.currentContext != null) {
        NotificationService.handleNotification(
          navigatorKey.currentContext!,
          message.data,
        );
      }
    });

    // Handle when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (navigatorKey.currentContext != null) {
        NotificationService.handleNotification(
          navigatorKey.currentContext!,
          message.data,
        );
      }
    });
  }

  static Future<void> handleForegroundMessage(RemoteMessage message) async {
    log("Foreground message received: ${message.messageId}");
    // Only show the local notification, do NOT navigate automatically
    await NotificationService.showLocalNotification(message);
  }

  @pragma('vm:entry-point')
  static Future<void> messageHandler(RemoteMessage message) async {
    log('Background message received: ${message.messageId}');
  }
}
