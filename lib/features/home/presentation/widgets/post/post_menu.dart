import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_menu_item.dart';

class PostMenu extends StatelessWidget {
  final PostModel post;
  final bool isOwner;

  const PostMenu({
    super.key,
    required this.post,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: ColorsManager.textSecondaryColor.withValues(alpha: 0.8),
      ),
      position: PopupMenuPosition.under,
      color: ColorsManager.cardColor,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) => _handleMenuSelection(context, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'copy',
          height: 40,
          child: PostMenuItem(
            icon: Icons.copy_all_rounded,
            text: appTranslation().get('copy'),
          ),
        ),
        if (isOwner) ...[
          PopupMenuItem(
            value: 'edit',
            height: 40,
            child: PostMenuItem(
              icon: Icons.edit_note_rounded,
              text: appTranslation().get('edit_post'),
            ),
          ),
          const PopupMenuDivider(height: 1),
          PopupMenuItem(
            value: 'delete',
            height: 40,
            child: PostMenuItem(
              icon: Icons.delete_sweep_rounded,
              text: appTranslation().get('delete_post'),
              color: ColorsManager.error,
            ),
          ),
        ],
      ],
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'copy':
        Clipboard.setData(ClipboardData(text: post.text ?? ''));
        break;
      case 'edit':
        context.push(Routes.editPost, arguments: post.postId);
        break;
      case 'delete':
        homeCubit.deletePost(post.postId);
        break;
    }
  }
}
