import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DotIndicatorWidget extends StatelessWidget {
  int dotCount;
  final ValueNotifier currentIndex;
  final Color activeColor;
  final Color color;

  DotIndicatorWidget({
    Key? key,
    required this.dotCount,
    required this.currentIndex,
    required this.activeColor,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (dotCount == null) {
      dotCount = 1;
    } else {
      if (dotCount == 0) dotCount++;
    }
    return ValueListenableBuilder(
      builder: (BuildContext context, value, Widget? child) {
        return DotsIndicator(
          dotsCount: dotCount,
          position: currentIndex.value.toDouble(),
          decorator: DotsDecorator(
            activeColor: activeColor,
            color: color,
            spacing: const EdgeInsets.all(2),
            activeSize: const Size.square(5),
            size: const Size.square(5),
          ),
        );
      },
      valueListenable: currentIndex,
    );
  }
}
