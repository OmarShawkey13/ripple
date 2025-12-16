import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/features/home/presentation/widgets/post_card.dart';

class ProfilePostsSection extends StatelessWidget {
  final List<PostModel> posts;

  const ProfilePostsSection({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              appTranslation().get('posts'),
              style: TextStylesManager.bold18,
            ),
          ),
        ),
        verticalSpace8,
        if (posts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              appTranslation().get('no_posts_yet'),
              style: TextStylesManager.regular16.copyWith(
                color: ColorsManager.textSecondaryColor,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: PostCard(post: posts[index]),
              );
            },
          ),
      ],
    );
  }
}
