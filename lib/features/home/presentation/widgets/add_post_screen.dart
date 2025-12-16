import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/emoji_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isEmojiVisible = false;

  void toggleEmojiPicker() {
    setState(() => isEmojiVisible = !isEmojiVisible);
  }

  final FocusNode inputFocusNode = FocusNode();

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
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      builder: (context, state) {
        final user = homeCubit.userModel;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop,
            ),
            title: Text(appTranslation().get("add_post")),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  homeCubit.addPost(homeCubit.postTextController.text);
                },
                child: Text(
                  appTranslation().get("post"),
                  style: TextStylesManager.regular14.copyWith(
                    color: ColorsManager.primary,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (state is HomeAddPostLoadingState) ...[
                        const LinearProgressIndicator(),
                        verticalSpace12,
                      ],
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: user?.photoUrl != null
                                ? CachedNetworkImageProvider(user!.photoUrl!)
                                : null,
                            child: user?.photoUrl == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          horizontalSpace16,
                          Expanded(
                            child: EmojiText(
                              text: user?.username ?? 'Loading...',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: homeCubit.postTextController,
                        focusNode: inputFocusNode,
                        decoration: InputDecoration(
                          hintText: appTranslation().get("what_on_your_mind"),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                      if (homeCubit.postImage != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: FileImage(
                                    homeCubit.postImage!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                homeCubit.removePostImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20,
                                backgroundColor: ColorsManager.primary,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo_library),
                      onPressed: () => homeCubit.pickPostImage(),
                      color: ColorsManager.primary,
                    ),
                    IconButton(
                      icon: Icon(
                        isEmojiVisible
                            ? Icons.keyboard
                            : Icons.emoji_emotions_outlined,
                      ),
                      onPressed: () {
                        toggleEmojiPicker();
                        if (isEmojiVisible) {
                          inputFocusNode.unfocus();
                        } else {
                          FocusScope.of(context).requestFocus(inputFocusNode);
                        }
                      },
                      color: ColorsManager.primary,
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                height: isEmojiVisible ? 320 : 0,
                child: isEmojiVisible
                    ? EmojiPicker(
                        onEmojiSelected: (emoji) {
                          homeCubit.postTextController.text += emoji;
                          homeCubit
                              .postTextController
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: homeCubit.postTextController.text.length,
                            ),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
