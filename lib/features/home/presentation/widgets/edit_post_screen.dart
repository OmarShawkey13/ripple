import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/constants/primary/emoji_picker_container.dart';
import 'package:ripple/core/utils/constants/primary/primary_text_field.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/add_post_actions.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
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
          current is HomeRemoveEditPostImageState ||
          current is HomeAddPostLoadingState ||
          current is HomeToggleEmojiPickerState ||
          current is HomeInitEditPostState,
      listener: (context, state) {
        if (state is HomeUpdatePostSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(appTranslation().get('post_updated')),
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
        return ConditionalBuilder(
          loadingState: state is HomeUpdatePostLoadingState,
          successBuilder: (context) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => context.pop,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: Text(appTranslation().get('edit_post')),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () => homeCubit.updatePost(postId: arg),
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
                        PrimaryTextField(
                          controller: homeCubit.editPostController,
                          focusNode: inputFocusNode,
                          maxLines: null,
                          useCardDecoration: false,
                        ),
                        verticalSpace16,
                        if ((homeCubit.editPostImageUrls?.isNotEmpty ??
                                false) ||
                            homeCubit.editPostImages.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                if (homeCubit.editPostImageUrls != null)
                                  ...homeCubit.editPostImageUrls!
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) => _buildImageItem(
                                          image: NetworkImage(e.value),
                                          onRemove: () =>
                                              homeCubit.removeEditPostImage(
                                                e.key,
                                                isUrl: true,
                                              ),
                                        ),
                                      ),
                                ...homeCubit.editPostImages.asMap().entries.map(
                                  (e) => _buildImageItem(
                                    image: FileImage(e.value),
                                    onRemove: () =>
                                        homeCubit.removeEditPostImage(e.key),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                AddPostActions(
                  isEmojiVisible: homeCubit.isEmojiVisible,
                  focusNode: inputFocusNode,
                  onEmojiToggle: homeCubit.toggleEmojiPicker,
                  onTapImage: homeCubit.pickEditPostImage,
                ),
                EmojiPickerContainer(
                  isVisible: homeCubit.isEmojiVisible,
                  controller: homeCubit.editPostController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageItem({
    required ImageProvider image,
    required VoidCallback onRemove,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: ColorsManager.primary,
              child: Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
