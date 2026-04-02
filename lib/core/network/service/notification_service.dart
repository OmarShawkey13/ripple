import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/main.dart';

class NotificationService {
  static const String _projectId = 'ripple-bdb2b';
  static String? _cachedAccessToken;
  static DateTime? _tokenExpiry;

  static final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  // Initialize Local Notifications
  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);
          log("Local notification clicked with payload: $data");
          if (navigatorKey.currentContext != null) {
            handleNotification(navigatorKey.currentContext!, data);
          }
        }
      },
    );

    if (Platform.isAndroid) {
      await localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'high_importance_channel',
              'High Importance Notifications',
              description: 'This channel is used for important notifications.',
              importance: Importance.max,
              playSound: true,
            ),
          );
    }
  }

  // Show local notification when app is in foreground
  static Future<void> showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static Future<String> getAccessToken() async {
    if (_cachedAccessToken != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
      return _cachedAccessToken!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/firebase/ripple-bdb2b-a82900c2a752.json',
      );

      final accountCredentials = auth.ServiceAccountCredentials.fromJson(
        jsonString,
      );
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = await auth.clientViaServiceAccount(
        accountCredentials,
        scopes,
      );

      _cachedAccessToken = client.credentials.accessToken.data;
      _tokenExpiry = client.credentials.accessToken.expiry;

      return _cachedAccessToken!;
    } catch (e) {
      log('Error getting FCM access token: $e');
      rethrow;
    }
  }

  static Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    if (token.isEmpty) return;

    try {
      final String accessToken = await getAccessToken();
      const String fcmUrl =
          'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': data,
            'android': {
              'priority': 'high',
              'notification': {
                'sound': 'default',
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'channel_id': 'high_importance_channel',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'default',
                  'content-available': 1,
                },
              },
            },
          },
        }),
      );

      if (response.statusCode != 200) {
        log('FCM Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Notification push failed: $e');
    }
  }

  static Future<void> send({
    required String receiverId,
    required String title,
    required Map<String, String> contents,
    required Map<String, dynamic> data,
  }) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();
      if (!userDoc.exists) return;

      final user = UserModel.fromMap(userDoc.data()!, receiverId);
      final token = user.fcmToken;

      if (token != null && token.isNotEmpty) {
        final body = contents['en'] ?? contents.values.first;
        final stringData = data.map(
          (key, value) => MapEntry(key, value.toString()),
        );

        await sendNotification(
          token: token,
          title: title,
          body: body,
          data: stringData,
        );
      }
    } catch (e) {
      log("Notification preparation error: $e");
    }
  }

  static Future<void> handleNotification(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final String? type = data['type'];
    final String? postId = data['postId'];
    final String? senderId = data['senderId'];

    if (!context.mounted) return;
    if (type == 'like' && postId != null) {
      final doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();
      if (doc.exists && context.mounted) {
        final post = PostModel.fromMap(doc.data()!, doc.id);
        context.push<PostModel>(Routes.postDetails, arguments: post);
      }
    } else if (type == 'comment' && postId != null) {
      final doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();
      if (doc.exists && context.mounted) {
        final post = PostModel.fromMap(doc.data()!, doc.id);
        context.push<PostModel>(Routes.comments, arguments: post);
      }
    } else if (type == 'follow' && senderId != null) {
      context.push<String>(Routes.profile, arguments: senderId);
    }
  }
}
