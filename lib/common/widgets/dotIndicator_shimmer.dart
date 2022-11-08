import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/common/widgets/shimmer.dart';

class DotIndicatorShimmer extends StatelessWidget {
  final int length;

  const DotIndicatorShimmer({Key? key, required this.length}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: DotsIndicator(
        dotsCount: length,
        position: 0,
        decorator: const DotsDecorator(
          activeColor: Color.fromARGB(255, 152, 94, 14),
          color: Colors.white,
          spacing: EdgeInsets.all(2),
          activeSize: Size.square(5),
          size: Size.square(5),
        ),
      ),
    );
  }
}
