import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_action_button.dart';

class PostActions extends StatelessWidget {
  final PostModel post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likes.contains(homeCubit.userModel?.uid);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              PostActionButton(
                icon: isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                count: post.likes.length,
                activeColor: ColorsManager.error,
                isActive: isLiked,
                onTap: () => homeCubit.togglePostLike(post),
              ),
              horizontalSpace16,
              PostActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                count: post.comments.length,
                activeColor: ColorsManager.primary,
                isActive: false,
                onTap: () => context.push(Routes.comments, arguments: post),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              // Share logic
            },
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(32, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Icon(
              Icons.share_outlined,
              size: 20,
              color: ColorsManager.textSecondaryColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
