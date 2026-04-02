import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/features/home/presentation/widgets/post_card.dart';

class ProfilePostsSection extends StatelessWidget {
  final List<PostModel> posts;

  const ProfilePostsSection({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.post_add_rounded,
                size: 64,
                color: ColorsManager.textSecondaryColor.withValues(alpha: 0.2),
              ),
              verticalSpace16,
              Text(
                appTranslation().get('no_posts_yet'),
                style: TextStylesManager.regular16.copyWith(
                  color: ColorsManager.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: ColorsManager.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                horizontalSpace12,
                Text(
                  appTranslation().get('posts'),
                  style: TextStylesManager.bold18.copyWith(
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  '${posts.length}',
                  style: TextStylesManager.medium14.copyWith(
                    color: ColorsManager.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PostCard(post: posts[index]),
              );
            },
            childCount: posts.length,
          ),
        ),
      ],
    );
  }
}
