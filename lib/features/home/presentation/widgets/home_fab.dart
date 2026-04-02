import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.push<Object>(Routes.addPost);
      },
      backgroundColor: ColorsManager.primary,
      foregroundColor: ColorsManager.lightCard,
      child: const Icon(Icons.add),
    );
  }
}
