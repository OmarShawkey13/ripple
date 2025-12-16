import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ripple/core/network/post_repository.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/main.dart';

class NotificationHandler {
  // ============================
  //   INITIALIZATION
  // ============================
  static Future<void> initialize() async {
    // CLICK EVENT HANDLER
    OneSignal.Notifications.addClickListener((event) async {
      final data = event.notification.additionalData;
      if (data == null) return;

      final type = data['type'] as String?;
      final senderId = data['senderId'] as String?;
      final postId = data['postId'] as String?;

      // Navigate based on notification type
      if (type == 'follow' && senderId != null) {
        navigatorKey.currentState?.pushNamed(
          Routes.profile,
          arguments: senderId,
        );
      } else if ((type == 'like' || type == 'comment') && postId != null) {
        try {
          final post = await PostRepository().getPostStream(postId).first;
          navigatorKey.currentState?.pushNamed(
            Routes.comments,
            arguments: post,
          );
        } catch (e) {
          // Post might be deleted, do nothing.
          debugPrint('Error navigating to post: $e');
        }
      }
    });
  }
}
