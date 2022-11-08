import 'package:flutter/material.dart';

import '../../../../configs/theme.dart';

class XButtonWidget extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Function onTap;
  const XButtonWidget({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? MyTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(7.5),
          border: Border.all(
            width: isSelected ? 0.0 : 0.5,
            color: isSelected ? Colors.transparent : Colors.blueGrey,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
