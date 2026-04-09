import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/emoji_picker_container.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_input_bar.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_list.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final initialPost = context.getArg() as PostModel;
    final focusNode = FocusNode();

    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) => current is HomeToggleEmojiPickerState,
      builder: (context, state) {
        final isEmojiVisible = homeCubit.isEmojiVisible;

        return Scaffold(
          appBar: _buildAppBar(context),
          body: Column(
            children: [
              Expanded(
                child: CommentList(initialPost: initialPost),
              ),
              CommentInputBar(
                isEmojiVisible: isEmojiVisible,
                focusNode: focusNode,
                onEmojiToggle: homeCubit.toggleEmojiPicker,
                post: initialPost,
              ),
              EmojiPickerContainer(
                isVisible: isEmojiVisible,
                controller: homeCubit.commentController,
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ColorsManager.textColor,
          size: 20,
        ),
        onPressed: () => context.pop,
      ),
      title: Text(
        appTranslation().get('comments'),
        style: TextStylesManager.bold18.copyWith(
          color: ColorsManager.textColor,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 0.5,
          color: ColorsManager.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
