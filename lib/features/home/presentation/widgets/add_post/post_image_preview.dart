import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';

class PostImagePreview extends StatelessWidget {
  const PostImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomePickPostImageState ||
          current is HomeRemovePostImageState,
      builder: (context, state) {
        if (homeCubit.postImage == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorsManager.outline.withValues(alpha: 0.3),
                  ),
                  image: DecorationImage(
                    image: FileImage(homeCubit.postImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => homeCubit.removePostImage(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
