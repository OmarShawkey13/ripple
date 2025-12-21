import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ripple/core/network/service/notification_service.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    homeCubit.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTranslation().get('notifications')),
        centerTitle: true,
      ),
      body: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeGetNotificationsLoadingState &&
              homeCubit.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = homeCubit.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                appTranslation().get('no_notifications'),
                style: TextStylesManager.regular16,
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
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
                        backgroundImage:
                            notification.senderProfilePic.isNotEmpty
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${notification.senderName} ',
                                    style: TextStylesManager.bold14.copyWith(
                                      color: ColorsManager.textColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: notification.text ?? '',
                                    style: TextStylesManager.regular14.copyWith(
                                      color: ColorsManager.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpace4,
                            Text(
                              DateFormat.yMMMd().add_jm().format(
                                notification.timestamp.toDate(),
                              ),
                              style: TextStylesManager.regular12.copyWith(
                                color: ColorsManager.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (notification.type == 'like' ||
                          notification.type == 'comment')
                        const Icon(Icons.post_add, color: ColorsManager.primary)
                      else if (notification.type == 'follow')
                        const Icon(
                          Icons.person_add,
                          color: ColorsManager.primary,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
