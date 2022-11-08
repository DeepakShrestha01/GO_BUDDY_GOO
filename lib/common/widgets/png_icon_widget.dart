import 'package:flutter/material.dart';
// import 'package:go_buddy_goo/configs/theme.dart';

class PNGIconWidget extends StatelessWidget {
  const PNGIconWidget({Key? key, this.asset, this.color}) : super(key: key);

  final String? asset;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      width: 24.0,
      child: Image.asset(
        asset.toString(),
        color: color ?? Colors.white,
      ),
    );
  }
}
