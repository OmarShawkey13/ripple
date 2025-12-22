import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

class PostImagePreview extends StatelessWidget {
  const PostImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    if (homeCubit.postImage == null) return const SizedBox.shrink();

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .25,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: FileImage(homeCubit.postImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        IconButton(
          onPressed: homeCubit.removePostImage,
          icon: const CircleAvatar(
            radius: 20,
            backgroundColor: ColorsManager.primary,
            child: Icon(Icons.close, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
