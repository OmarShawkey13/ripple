import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';

class PostText extends StatefulWidget {
  final String text;

  const PostText({super.key, required this.text});

  @override
  State<PostText> createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {
  bool isExpanded = false;
  static const int _maxChars = 180;

  @override
  Widget build(BuildContext context) {
    final bool isLongText = widget.text.length > _maxChars;
    final String displayText = isLongText && !isExpanded
        ? '${widget.text.substring(0, _maxChars)}...'
        : widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmojiText(
          text: displayText,
          style: TextStylesManager.regular16.copyWith(
            height: 1.6,
            color: ColorsManager.textColor.withValues(alpha: 0.95),
            letterSpacing: -0.2,
          ),
        ),
        if (isLongText)
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                isExpanded ? 'عرض أقل' : 'قراءة المزيد',
                style: TextStylesManager.bold14.copyWith(
                  color: ColorsManager.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
