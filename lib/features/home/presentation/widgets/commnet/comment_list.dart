import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/commnet/comment_item.dart';

class CommentList extends StatelessWidget {
  final PostModel initialPost;

  const CommentList({super.key, required this.initialPost});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PostModel>(
      stream: homeCubit.getPostStream(initialPost.postId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final post = snapshot.data!;
          return ListView.builder(
            itemCount: post.comments.length,
            itemBuilder: (context, index) {
              return CommentItem(
                postId: post.postId,
                comment: post.comments[index],
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
