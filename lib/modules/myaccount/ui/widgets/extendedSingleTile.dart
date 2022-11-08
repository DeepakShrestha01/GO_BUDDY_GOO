import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

import '../../../../configs/theme.dart';

class ExtendedSingleTile extends StatelessWidget {
  final IconData? icon;
  final String? header;
  final TextEditingController? controller;
  final String? hintText;
  final String? tag;
  final Key? shakeKey;
  final Function(String)? onChanged;

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  ExtendedSingleTile({
    Key? key,
    this.icon,
    this.header,
    this.controller,
    this.hintText,
    this.tag,
    this.onChanged,
    this.shakeKey,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shake(
      preferences:
          const AnimationPreferences(autoPlay: AnimationPlayStates.None),
      key: shakeKey,
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: MyTheme.primaryColor,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header.toString(),
              style: headerTextStyle,
            ),
            TextField(
              controller: controller,
              cursorColor: MyTheme.primaryColor,
              style: valueTextStyle,
              keyboardType:
                  tag == "contact" ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hintText,
                contentPadding: const EdgeInsets.all(0),
              ),
              onChanged: onChanged,
            )
          ],
        ),
      ),
    );
  }
}
