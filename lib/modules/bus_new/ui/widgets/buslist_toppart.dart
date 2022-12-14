import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../configs/theme.dart';

class BusListTopPart extends StatelessWidget {
  final String from, to;
  final DateTime date;
  const BusListTopPart(
      {super.key, required this.from, required this.to, required this.date});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Route: ${from.titleCase}  to  ${to.titleCase}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateTimeFormatter.formatDate(date),
          ),
        ],
      ),
    );
  }
}
