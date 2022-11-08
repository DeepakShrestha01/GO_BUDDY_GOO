import 'package:flutter/material.dart';

import '../../../../configs/theme.dart';

class SingleTile extends StatelessWidget {
  final IconData? icon;
  final String? header;
  final String? value;

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  SingleTile({
    Key? key,
    this.icon,
    this.header,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
          Text(
            value.toString(),
            style: valueTextStyle,
          )
        ],
      ),
    );
  }
}
