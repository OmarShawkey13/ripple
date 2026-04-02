import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_page.dart';
import 'package:ripple/core/utils/constants/primary/loading_indicator.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/post_action_button.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likes.contains(homeCubit.userModel?.uid);
    final isOwner = post.userId == homeCubit.userModel?.uid;

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
                          child: ConditionalBuilder(
                            loadingState: post.userProfilePic.isEmpty,
                            successBuilder: (context) =>
                                const SizedBox.shrink(),
                            loadingBuilder: (context) => const Icon(
                              Icons.person,
                              color: ColorsManager.primary,
                            ),
                          ),
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
                              verticalSpace2,
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
                PopupMenuButton<String>(
                  splashRadius: 18,
                  color: ColorsManager.backgroundColor,
                  onSelected: (value) {
                    _handleMenuSelection(context, value);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'copy',
                      child: Text(appTranslation().get('copy')),
                    ),
                    if (isOwner) ...[
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
            ConditionalBuilder(
              loadingState: post.text?.isEmpty ?? true,
              successBuilder: (context) => Column(
                children: [
                  verticalSpace12,
                  EmojiText(
                    text: post.text!,
                    style: TextStylesManager.regular16.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              loadingBuilder: (context) => const SizedBox.shrink(),
            ),
            ConditionalBuilder(
              loadingState: post.imageUrl == null,
              successBuilder: (context) => Column(
                children: [
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
                              child: LoadingIndicator(strokeWidth: 1.5),
                            ),
                          ),
                          errorWidget: (_, _, _) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              loadingBuilder: (context) => const SizedBox.shrink(),
            ),
            verticalSpace8,
            Row(
              children: [
                PostActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? ColorsManager.error : null,
                  count: post.likes.length,
                  onTap: () => homeCubit.togglePostLike(post),
                ),
                horizontalSpace16,
                PostActionButton(
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

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'copy':
        Clipboard.setData(ClipboardData(text: post.text ?? ''));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appTranslation().get('copy_to_clipboard')),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'edit':
        context.push<String>(Routes.editPost, arguments: post.postId);
        break;
      case 'delete':
        homeCubit.deletePost(post.postId);
        break;
    }
  }
}
