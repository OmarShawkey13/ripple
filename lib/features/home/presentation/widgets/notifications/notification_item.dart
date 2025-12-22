import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/models/notification_model.dart';
import 'package:ripple/core/network/service/notification_service.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/notifications/notification_content.dart';
import 'package:ripple/features/home/presentation/widgets/notifications/notification_icon.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          homeCubit.markNotificationAsRead(
            notification.notificationId,
          );
        }

        NotificationService.handleNotification(context, {
          'type': notification.type,
          'postId': notification.postId,
          'senderId': notification.senderId,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        color: notification.isRead
            ? Colors.transparent
            : ColorsManager.primary.withValues(alpha: 0.05),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: notification.senderProfilePic.isNotEmpty
                  ? CachedNetworkImageProvider(
                notification.senderProfilePic,
              )
                  : null,
              child: notification.senderProfilePic.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            horizontalSpace12,
            Expanded(
              child: NotificationContent(notification: notification),
            ),
            NotificationIcon(type: notification.type),
          ],
        ),
      ),
    );
  }
}
