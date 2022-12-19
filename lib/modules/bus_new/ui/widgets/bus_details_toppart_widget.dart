// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../configs/theme.dart';

class BusDetailsTopPartWidget extends StatelessWidget {
  String operatorName;
  String from;
  String to;
  DateTime? date;
  String shift;
  BusDetailsTopPartWidget({
    Key? key,
    required this.operatorName,
    required this.from,
    required this.to,
    required this.date,
    required this.shift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: MyTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Text(
            operatorName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            '$from to $to | ${DateTimeFormatter.formatDate(date!)} | ${shift.titleCase} Shift',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
