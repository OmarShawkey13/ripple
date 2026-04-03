import 'package:flutter/material.dart';
import 'package:ripple/core/theme/emoji_data.dart';

class EmojiTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (text.isEmpty) return const TextSpan();

    final List<InlineSpan> children = [];
    final characters = text.characters;
    final double fontSize = style?.fontSize ?? 16.0;

    String currentText = "";

    for (var char in characters) {
      final assetPath = EmojiData.getEmojiPath(char);

      if (assetPath != null) {
        // Add pending text first
        if (currentText.isNotEmpty) {
          children.add(TextSpan(text: currentText, style: style));
          currentText = "";
        }

        // Add emoji
        children.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Image.asset(
              assetPath,
              width: fontSize * 1.3,
              height: fontSize * 1.3,
              cacheWidth: 64, // Fix cache size to avoid large memory usage
              filterQuality:
                  FilterQuality.low, // Lower quality for better performance
            ),
          ),
        );
      } else {
        currentText += char;
      }
    }

    if (currentText.isNotEmpty) {
      children.add(TextSpan(text: currentText, style: style));
    }

    return TextSpan(style: style, children: children);
  }
}
