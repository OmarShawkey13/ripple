import 'package:flutter/material.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_avatar.dart';

class CommentAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool isReply;
  final double radius;

  const CommentAvatar({
    super.key,
    this.imageUrl,
    this.isReply = false,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return PostAvatar(
      userProfilePic: imageUrl,
      userId: '',
      radius: radius,
    );
  }
}
