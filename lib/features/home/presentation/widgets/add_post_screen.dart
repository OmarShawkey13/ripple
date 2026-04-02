import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/constants/primary/emoji_picker_container.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/add_post_actions.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/add_post_app_bar.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/post_image_preview.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/post_text_field.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/user_header.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode inputFocusNode = FocusNode();
    return BlocConsumer<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeAddPostLoadingState ||
          current is HomeAddPostSuccessState ||
          current is HomeAddPostErrorState ||
          current is HomePickPostImageState ||
          current is HomeRemovePostImageState ||
          current is HomeToggleEmojiPickerState,
      listener: (context, state) {
        if (state is HomeAddPostSuccessState) {
          context.pop;
          homeCubit.postTextController.clear();
          homeCubit.postImage = null;
        } else if (state is HomeAddPostErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const AddPostAppBar(),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ConditionalBuilder(
                        loadingState: state is HomeAddPostLoadingState,
                        successBuilder: (context) => const SizedBox.shrink(),
                        loadingBuilder: (context) => Column(
                          children: [
                            const LinearProgressIndicator(),
                            verticalSpace12,
                          ],
                        ),
                      ),
                      const UserHeader(),
                      const PostTextField(),
                      const PostImagePreview(),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              AddPostActions(
                isEmojiVisible: homeCubit.isEmojiVisible,
                focusNode: inputFocusNode,
                onEmojiToggle: homeCubit.toggleEmojiPicker,
              ),
              EmojiPickerContainer(
                isVisible: homeCubit.isEmojiVisible,
                controller: homeCubit.postTextController,
              ),
            ],
          ),
        );
      },
    );
  }
}
