import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/features/home/presentation/widgets/notifications/notification_item.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
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
            return NotificationItem(
              notification: notifications[index],
            );
          },
        );
      },
    );
  }
}
