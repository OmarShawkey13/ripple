import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class CommentActionButtons extends StatelessWidget {
  final DateTime timestamp;
  final bool isReply;
  final bool isReplying;
  final VoidCallback onReplyTap;

  const CommentActionButtons({
    super.key,
    required this.timestamp,
    required this.isReply,
    required this.isReplying,
    required this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _formatTimestamp(timestamp),
          style: TextStylesManager.regular12.copyWith(
            color: ColorsManager.textSecondaryColor.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        horizontalSpace16,
        GestureDetector(
          onTap: onReplyTap,
          child: Text(
            isReplying
                ? appTranslation().get('cancel')
                : appTranslation().get('reply'),
            style: TextStylesManager.bold12.copyWith(
              color: isReplying
                  ? ColorsManager.error.withValues(alpha: 0.8)
                  : ColorsManager.textSecondaryColor.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ),
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
