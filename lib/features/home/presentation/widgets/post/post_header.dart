import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_menu.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;
  final bool isOwner;

  const PostHeader({
    super.key,
    required this.post,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmojiText(
                text: post.username,
                style: TextStylesManager.bold14.copyWith(
                  color: ColorsManager.textColor,
                  letterSpacing: 0.1,
                ),
              ),
              verticalSpace2,
              Text(
                _formatTimestamp(post.timestamp.toDate()),
                style: TextStylesManager.regular12.copyWith(
                  color: ColorsManager.textSecondaryColor.withValues(
                    alpha: 0.7,
                  ),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        PostMenu(post: post, isOwner: isOwner),
      ],
    );
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) return DateFormat.yMMMd().format(date);
    if (difference.inDays >= 1) return '${difference.inDays}d';
    if (difference.inHours >= 1) return '${difference.inHours}h';
    if (difference.inMinutes >= 1) return '${difference.inMinutes}m';
    return appTranslation().get('now');
  }
}
