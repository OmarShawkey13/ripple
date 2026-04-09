import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_page.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_image.dart';

class PostImagesList extends StatelessWidget {
  final List<String> imageUrls;
  final String postId;

  const PostImagesList({
    super.key,
    required this.imageUrls,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.sizeOf(context).width - 84;
    return SizedBox(
      height: 300,
      child: ListView.separated(
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (context, index) => horizontalSpace12,
        itemBuilder: (context, index) {
          return SizedBox(
            width: availableWidth,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<Object>(
                  builder: (context) => ImagePreviewPage(
                    urls: imageUrls,
                    initialIndex: index,
                  ),
                ),
              ),
              child: PostImage(
                imageUrl: imageUrls[index],
                postId: postId,
                allImageUrls: imageUrls,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}
