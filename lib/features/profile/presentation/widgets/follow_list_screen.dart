import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/features/profile/presentation/widgets/user_list_tile.dart';
import 'package:ripple/features/profile/presentation/widgets/empty_users_state.dart';

class FollowListScreen extends StatelessWidget {
  const FollowListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = context.getArg<Map<String, dynamic>>();
    final String title = args?['title'] ?? '';
    final List<String> uids = (args?['uids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorsManager.backgroundColor,
        elevation: 0,
        title: Text(
          title,
          style: TextStylesManager.bold18,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop,
        ),
      ),
      body: ConditionalBuilder(
        loadingState: uids.isNotEmpty,
        successBuilder: (context) => ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: uids.length,
          separatorBuilder: (context, index) => verticalSpace12,
          itemBuilder: (context, index) => UserListTile(uid: uids[index]),
        ),
        emptyBuilder: (context) => const EmptyUsersState(),
      ),
    );
  }
}
