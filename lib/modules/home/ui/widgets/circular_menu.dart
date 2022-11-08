import 'package:flutter/material.dart';

class CircularWidget extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final IconData? icon;
  final Function()? onTap;
  final Color? backGroundColor;
  final String? title;

  const CircularWidget(
      {Key? key,
      this.top,
      this.bottom,
      this.left,
      this.right,
      this.icon,
      this.onTap,
      this.backGroundColor,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backGroundColor,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
