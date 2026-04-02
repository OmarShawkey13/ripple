import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_item.dart';

class CommentList extends StatelessWidget {
  final PostModel initialPost;

  const CommentList({super.key, required this.initialPost});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PostModel>(
      stream: homeCubit.getPostStream(initialPost.postId),
      builder: (context, snapshot) {
        return ConditionalBuilder(
          loadingState: snapshot.connectionState == ConnectionState.waiting,
          errorState: snapshot.hasError,
          errorBuilder: (context) => Center(
            child: Text('${appTranslation().get('error')}: ${snapshot.error}'),
          ),
          successBuilder: (context) {
            final post = snapshot.data ?? initialPost;
            return ListView.builder(
              itemCount: post.comments.length,
              itemBuilder: (context, index) {
                return CommentItem(
                  postId: post.postId,
                  comment: post.comments[index],
                );
              },
            );
          },
        );
      },
    );
  }
}
