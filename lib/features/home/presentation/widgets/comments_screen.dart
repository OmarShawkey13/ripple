import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/data/model/context_menu.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/emoji_picker.dart';
import 'package:ripple/features/home/presentation/widgets/commnet/ios_style_context_menu.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool isEmojiVisible = false;

  void toggleEmojiPicker() {
    setState(() => isEmojiVisible = !isEmojiVisible);
  }

  final FocusNode inputFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final initialPost = context.getArg() as PostModel;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop,
        ),
        title: Text(appTranslation().get('comments')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<PostModel>(
              stream: homeCubit.getPostStream(initialPost.postId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final post = snapshot.data!;
                  return ListView.builder(
                    itemCount: post.comments.length,
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];
                      final isMe = homeCubit.userModel?.uid == comment.userId;

                      // Extract the card content widget to reuse it in context menu
                      Widget commentCardContent() {
                        return Card(
                          elevation: 0.2,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          color: ColorsManager.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      comment.userProfilePic.isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          comment.userProfilePic,
                                        )
                                      : null,
                                  child: comment.userProfilePic.isEmpty
                                      ? const Icon(Icons.person, size: 18)
                                      : null,
                                ),
                                horizontalSpace12,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          EmojiText(
                                            text: comment.username,
                                            style: TextStylesManager.bold14,
                                          ),
                                        ],
                                      ),
                                      if (!isMe) verticalSpace4,
                                      EmojiText(
                                        text: comment.text,
                                        style: TextStylesManager.regular14,
                                      ),
                                      verticalSpace4,
                                      Text(
                                        DateFormat.yMMMd().add_jm().format(
                                          comment.timestamp.toDate(),
                                        ),
                                        style: TextStylesManager.regular12
                                            .copyWith(
                                              color: ColorsManager
                                                  .textSecondaryColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onLongPress: () {
                          showDialog<Object>(
                            context: context,
                            builder: (context) => IosStyleContextMenu(
                              menuAlignment: Alignment.centerRight,
                              actions: [
                                ContextMenuAndroid(
                                  icon: Icons.copy,
                                  label: appTranslation().get('copy'),
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: comment.text),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          appTranslation().get('copied'),
                                        ),
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                                if (isMe)
                                  ContextMenuAndroid(
                                    icon: Icons.delete,
                                    label: appTranslation().get('delete'),
                                    onTap: () {
                                      homeCubit.deleteComment(
                                        post.postId,
                                        comment,
                                      );
                                    },
                                  ),
                              ],
                              child: commentCardContent(),
                            ),
                          );
                        },
                        child: commentCardContent(),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          BlocBuilder<HomeCubit, HomeStates>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
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
                    Expanded(
                      child: TextFormField(
                        focusNode: inputFocusNode,
                        controller: homeCubit.commentController,
                        decoration: InputDecoration(
                          hintText: appTranslation().get('add_comment'),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace8,
                    IconButton(
                      onPressed: () {
                        if (homeCubit.commentController.text.isNotEmpty) {
                          homeCubit.addComment(
                            initialPost.postId,
                            initialPost.userId,
                          );
                        }
                      },
                      icon: const Icon(Icons.send),
                      color: ColorsManager.primary,
                    ),
                  ],
                ),
              );
            },
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            height: isEmojiVisible ? 320 : 0,
            child: isEmojiVisible
                ? EmojiPicker(
                    onEmojiSelected: (emoji) {
                      homeCubit.commentController.text += emoji;
                      homeCubit.commentController.selection =
                          TextSelection.fromPosition(
                            TextPosition(
                              offset: homeCubit.commentController.text.length,
                            ),
                          );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
