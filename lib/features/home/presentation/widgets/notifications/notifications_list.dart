import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/features/home/presentation/widgets/notifications/notification_item.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final notifications = homeCubit.notifications;

        return ConditionalBuilder(
          loadingState:
              state is HomeGetNotificationsLoadingState &&
              notifications.isEmpty,
          emptyState: notifications.isEmpty,
          emptyBuilder: (context) => Center(
            child: Text(
              appTranslation().get('no_notifications'),
              style: TextStylesManager.regular16,
            ),
          ),
          successBuilder: (context) => ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationItem(
                notification: notifications[index],
              );
            },
          ),
        );
      },
    );
  }
}
