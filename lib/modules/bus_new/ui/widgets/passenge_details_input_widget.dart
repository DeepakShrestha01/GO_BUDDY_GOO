// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';

import '../../../../common/widgets/divider.dart';

class PassengerDetailInputWidget extends StatelessWidget {
  String labelText;
  String hintText;
  TextEditingController? controller;
  String? Function(String?)? validator;
  TextInputType? keyboardType;

  PassengerDetailInputWidget(
      {Key? key,
      required this.labelText,
      required this.hintText,
      this.controller,
      this.keyboardType,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: Colors.grey.shade700,
    );

    const valueTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 17,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: headerTextStyle,
        ),
        TextFormField(
          controller: controller,
          style: valueTextStyle,
          cursorColor: MyTheme.primaryColor,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            errorStyle: const TextStyle(fontSize: 12),
          ),
        ),
        divider(),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
