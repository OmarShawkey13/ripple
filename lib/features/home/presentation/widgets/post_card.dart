import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_actions.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_avatar.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_content.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_header.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isOwner = post.userId == homeCubit.userModel?.uid;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostAvatar(
                    userProfilePic: post.userProfilePic,
                    userId: post.userId,
                  ),
                  horizontalSpace12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostHeader(post: post, isOwner: isOwner),
                        verticalSpace8,
                        PostContent(post: post),
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpace8,
              Padding(
                padding: const EdgeInsets.only(left: 52),
                child: PostActions(post: post),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: ColorsManager.outline.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}
