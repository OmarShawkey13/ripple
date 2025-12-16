import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/emoji_picker.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  bool isEmojiVisible = false;

  void toggleEmojiPicker() {
    setState(() => isEmojiVisible = !isEmojiVisible);
  }

  final FocusNode inputFocusNode = FocusNode();

  late String arg;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      arg = context.getArg() as String;
      homeCubit.initEditPost(
        homeCubit.posts.firstWhere((p) => p.postId == arg),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeUpdatePostLoadingState ||
          current is HomeUpdatePostSuccessState ||
          current is HomeUpdatePostErrorState ||
          current is HomeRemoveEditPostImageState,
      listener: (context, state) {
        if (state is HomeUpdatePostSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                appTranslation().get('post_updated'),
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: ColorsManager.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop;
        }
        if (state is HomeUpdatePostErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: ColorsManager.error,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is HomeUpdatePostLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.pop,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            title: Text(appTranslation().get('edit_post')),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  homeCubit.updatePost(postId: arg);
                },
                child: Text(
                  appTranslation().get('save'),
                  style: TextStylesManager.bold14.copyWith(
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
                      TextFormField(
                        controller: homeCubit.editPostController,
                        focusNode: inputFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                      if (homeCubit.editPostImage != null ||
                          homeCubit.editPostImageUrl != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: homeCubit.editPostImage != null
                                      ? FileImage(homeCubit.editPostImage!)
                                      : NetworkImage(
                                              homeCubit.editPostImageUrl!,
                                            )
                                            as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                homeCubit.removeEditPostImage();
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
                          homeCubit.editPostController.text += emoji;
                          homeCubit
                              .editPostController
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: homeCubit.editPostController.text.length,
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
