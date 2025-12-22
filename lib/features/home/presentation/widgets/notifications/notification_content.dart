import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ripple/core/models/notification_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class NotificationContent extends StatelessWidget {
  final NotificationModel notification;

  const NotificationContent({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          DateFormat.yMMMd()
              .add_jm()
              .format(notification.timestamp.toDate()),
          style: TextStylesManager.regular12.copyWith(
            color: ColorsManager.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
