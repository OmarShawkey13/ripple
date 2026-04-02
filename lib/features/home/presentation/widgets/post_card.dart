import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_actions.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_content.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilePicture(context),
              horizontalSpace12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostHeader(post: post, isOwner: isOwner),
                    verticalSpace4,
                    PostContent(post: post),
                    verticalSpace12,
                    PostActions(post: post),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: ColorsManager.surfaceContainer.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.profile, arguments: post.userId),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ColorsManager.surfaceContainer,
            width: 1,
          ),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: ColorsManager.surfaceContainer,
          backgroundImage: post.userProfilePic.isNotEmpty
              ? CachedNetworkImageProvider(post.userProfilePic)
              : null,
          child: post.userProfilePic.isEmpty
              ? Icon(
                  Icons.person_rounded,
                  color: ColorsManager.textSecondaryColor,
                  size: 24,
                )
              : null,
        ),
      ),
    );
  }
}
