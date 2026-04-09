import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_app_bar.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_dots.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_item.dart';

class ImagePreviewPage extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;

  const ImagePreviewPage({
    super.key,
    required this.urls,
    this.initialIndex = 0,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // ضبط شريط الحالة ليكون شفافاً ومتوافقاً مع الخلفية السوداء
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: ImagePreviewAppBar(
        currentIndex: _currentIndex,
        totalCount: widget.urls.length,
        onClose: () => Navigator.pop(context),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.urls.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ImagePreviewItem(imageUrl: widget.urls[index]);
            },
          ),
          ImagePreviewDots(
            currentIndex: _currentIndex,
            totalCount: widget.urls.length,
          ),
        ],
      ),
    );
  }
}
