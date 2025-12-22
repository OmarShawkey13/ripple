import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/utils/constants/primary/emoji_picker_container.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/add_post_actions.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/add_post_app_bar.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/post_image_preview.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/post_text_field.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/user_header.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isEmojiVisible = false;
  final FocusNode inputFocusNode = FocusNode();

  void toggleEmojiPicker() {
    setState(() => isEmojiVisible = !isEmojiVisible);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
      current is HomeAddPostLoadingState ||
          current is HomeAddPostSuccessState ||
          current is HomeAddPostErrorState ||
          current is HomePickPostImageState ||
          current is HomeRemovePostImageState,
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
                      if (state is HomeAddPostLoadingState) ...[
                        const LinearProgressIndicator(),
                        verticalSpace12,
                      ],
                      const UserHeader(),
                      const PostTextField(),
                      const PostImagePreview(),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              AddPostActions(
                isEmojiVisible: isEmojiVisible,
                focusNode: inputFocusNode,
                onEmojiToggle: toggleEmojiPicker,
              ),
              EmojiPickerContainer(
                isVisible: isEmojiVisible,
                controller: homeCubit.postTextController,
              ),
            ],
          ),
        );
      },
    );
  }
}

