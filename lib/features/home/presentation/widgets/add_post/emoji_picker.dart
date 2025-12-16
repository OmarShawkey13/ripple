import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/features/home/presentation/widgets/add_post/emoji_category.dart';

class EmojiPicker extends StatefulWidget {
  final void Function(String emoji) onEmojiSelected;

  const EmojiPicker({
    super.key,
    required this.onEmojiSelected,
  });

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  late PageController _pageController;
  int selectedCategory = 0;

  final List<EmojiCategory> availableCategories = emojiCategories
      .where((c) => c.emojis != null)
      .toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedCategory);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onCategoryTapped(int index) {
    setState(() {
      selectedCategory = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.cardColor,
        border: Border(
          top: BorderSide(
            color: ColorsManager.cardColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // CATEGORY BAR
          SizedBox(
            height: 54,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableCategories.length,
              itemBuilder: (_, i) {
                final isActive = i == selectedCategory;
                return GestureDetector(
                  onTap: () => _onCategoryTapped(i),
                  child: Container(
                    width: 48,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? ColorsManager.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: EmojiText(
                        text: availableCategories[i].icon,
                        style: TextStylesManager.regular24.copyWith(
                          fontSize: 26,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // PageView for emojis
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: availableCategories.length,
              onPageChanged: (index) {
                setState(() {
                  selectedCategory = index;
                });
              },
              itemBuilder: (context, index) {
                final category = availableCategories[index];
                return _buildEmojiGrid(
                  category.emojis!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiGrid(List<String> emojis) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: emojis.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (_, i) {
        return GestureDetector(
          onTap: () => widget.onEmojiSelected(emojis[i]),
          child: Center(
            child: EmojiText(
              text: emojis[i],
              style: const TextStyle(fontSize: 28),
            ),
          ),
        );
      },
    );
  }
}
