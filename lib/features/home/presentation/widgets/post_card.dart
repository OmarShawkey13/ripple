import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_page.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likes.contains(homeCubit.userModel?.uid);
    return Card(
      elevation: 0.6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: ColorsManager.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        context.push(Routes.profile, arguments: post.userId),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: ColorsManager.primary.withValues(
                            alpha: .1,
                          ),
                          backgroundImage: post.userProfilePic.isNotEmpty
                              ? CachedNetworkImageProvider(post.userProfilePic)
                              : null,
                          child: post.userProfilePic.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: ColorsManager.primary,
                                )
                              : null,
                        ),
                        horizontalSpace12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EmojiText(
                                text: post.username,
                                style: TextStylesManager.bold14,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat.yMMMd().add_jm().format(
                                  post.timestamp.toDate(),
                                ),
                                style: TextStylesManager.regular12.copyWith(
                                  color: ColorsManager.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (post.text?.isNotEmpty == true)
                  PopupMenuButton<String>(
                    splashRadius: 18,
                    color: ColorsManager.backgroundColor,
                    onSelected: (value) {
                      if (value == 'copy') {
                        Clipboard.setData(
                          ClipboardData(text: post.text!),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              appTranslation().get('copy_to_clipboard'),
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else if (value == 'edit') {
                        context.push<String>(
                          Routes.editPost,
                          arguments: post.postId,
                        );
                      } else if (value == 'delete') {
                        homeCubit.deletePost(post.postId);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'copy',
                        child: Text(appTranslation().get('copy')),
                      ),
                      if (post.userId == homeCubit.userModel?.uid) ...[
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(appTranslation().get('edit_post')),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(appTranslation().get('delete_post')),
                        ),
                      ],
                    ],
                    icon: const Icon(Icons.more_horiz, size: 20),
                  ),
              ],
            ),
            if (post.text?.isNotEmpty == true) ...[
              verticalSpace12,
              EmojiText(
                text: post.text!,
                style: TextStylesManager.regular16.copyWith(
                  height: 1.5,
                ),
              ),
            ],
            if (post.imageUrl != null) ...[
              verticalSpace12,
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Object>(
                      builder: (context) =>
                          ImagePreviewPage(url: post.imageUrl!),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: ColorsManager.backgroundColor,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      ),
                      errorWidget: (_, _, _) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
            ],
            verticalSpace8,
            Row(
              children: [
                _ActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                  count: post.likes.length,
                  onTap: () => homeCubit.togglePostLike(post),
                ),
                horizontalSpace16,
                _ActionButton(
                  icon: Icons.comment_outlined,
                  count: post.comments.length,
                  onTap: () => context.push(Routes.comments, arguments: post),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final int count;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStylesManager.regular12,
            ),
          ],
        ),
      ),
    );
  }
}
