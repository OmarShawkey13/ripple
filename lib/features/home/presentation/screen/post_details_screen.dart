import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/post_card.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = context.getArg() as PostModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(appTranslation().get('post')),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop,
        ),
      ),
      body: SingleChildScrollView(
        child: PostCard(post: post),
      ),
    );
  }
}
