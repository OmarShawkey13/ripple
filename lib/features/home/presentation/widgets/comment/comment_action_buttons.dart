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
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
      child: Row(
        children: [
          Text(
            _formatTimestamp(timestamp),
            style: TextStylesManager.regular12.copyWith(
              color: ColorsManager.textSecondaryColor.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
          if (!isReply) ...[
            horizontalSpace16,
            InkWell(
              onTap: onReplyTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  isReplying
                      ? appTranslation().get('cancel')
                      : appTranslation().get('reply'),
                  style: TextStylesManager.bold12.copyWith(
                    color: isReplying
                        ? ColorsManager.error
                        : ColorsManager.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
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
