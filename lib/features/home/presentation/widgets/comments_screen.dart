import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/emoji_picker_container.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/commnet/comment_input_bar.dart';
import 'package:ripple/features/home/presentation/widgets/commnet/comment_list.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool isEmojiVisible = false;
  final FocusNode inputFocusNode = FocusNode();

  void toggleEmojiPicker() {
    setState(() => isEmojiVisible = !isEmojiVisible);
  }

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
            child: CommentList(initialPost: initialPost),
          ),
          CommentInputBar(
            isEmojiVisible: isEmojiVisible,
            focusNode: inputFocusNode,
            onEmojiToggle: toggleEmojiPicker,
            post: initialPost,
          ),
          EmojiPickerContainer(
            isVisible: isEmojiVisible,
            controller: homeCubit.commentController,
          ),
        ],
      ),
    );
  }
}

