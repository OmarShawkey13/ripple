import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripple/core/models/comment_model.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/features/home/data/model/context_menu.dart';
import 'package:ripple/features/home/presentation/widgets/commnet/ios_style_context_menu.dart';

class CommentContextMenu extends StatelessWidget {
  final bool isMe;
  final String postId;
  final CommentModel comment;
  final Widget child;

  const CommentContextMenu({
    super.key,
    required this.isMe,
    required this.postId,
    required this.comment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog<Object>(
          context: context,
          builder: (_) => IosStyleContextMenu(
            menuAlignment: Alignment.centerRight,
            actions: [
              ContextMenuAndroid(
                icon: Icons.copy,
                label: appTranslation().get('copy'),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: comment.text),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(appTranslation().get('copied')),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              if (isMe)
                ContextMenuAndroid(
                  icon: Icons.delete,
                  label: appTranslation().get('delete'),
                  onTap: () {
                    homeCubit.deleteComment(postId, comment);
                  },
                ),
            ],
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
