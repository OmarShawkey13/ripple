import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/models/comment_model.dart';
import 'package:ripple/core/utils/constants/primary/loading_indicator.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_item.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';

class CommentList extends StatelessWidget {
  final PostModel initialPost;

  const CommentList({super.key, required this.initialPost});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentModel>>(
      stream: homeCubit.postRepo.getCommentsStream(initialPost.postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: LoadingIndicator());
        }

        final comments = snapshot.data ?? [];

        if (comments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 48,
                  color: ColorsManager.textSecondaryColor.withValues(
                    alpha: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  appTranslation().get('no_comments_yet'),
                  style: TextStyle(
                    color: ColorsManager.textSecondaryColor.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: comments.length,
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            indent: 64,
            endIndent: 16,
            thickness: 0.1,
          ),
          itemBuilder: (context, index) {
            return CommentItem(
              comment: comments[index],
              postId: initialPost.postId,
              postOwnerId: initialPost.userId,
              isLast: index == comments.length - 1,
            );
          },
        );
      },
    );
  }
}
