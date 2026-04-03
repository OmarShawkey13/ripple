import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/network/user_repository.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/features/profile/presentation/widgets/user_list_tile_loading.dart';

class UserListTile extends StatelessWidget {
  final String uid;
  const UserListTile({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    // Note: In a full refactor, this Future should come from a Cubit
    return FutureBuilder<UserModel?>(
      future: UserRepository().getUser(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const UserListTileLoading();
        }
        final user = snapshot.data;
        if (user == null) return const SizedBox.shrink();

        return InkWell(
          onTap: () {
            context.push(Routes.profile, arguments: user.uid);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorsManager.surfaceContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  backgroundColor: ColorsManager.primary.withValues(alpha: 0.1),
                  child: user.photoUrl == null || user.photoUrl!.isEmpty
                      ? const Icon(Icons.person, color: ColorsManager.primary)
                      : null,
                ),
                horizontalSpace12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username ?? appTranslation().get('unknown'),
                        style: TextStylesManager.bold14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (user.bio != null && user.bio!.isNotEmpty) ...[
                        verticalSpace4,
                        Text(
                          user.bio!,
                          style: TextStylesManager.regular12.copyWith(
                            color: ColorsManager.textSecondaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: ColorsManager.textSecondaryColor,
                ),
                horizontalSpace4,
              ],
            ),
          ),
        );
      },
    );
  }
}
