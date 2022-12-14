import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/new_bus_search_result/bus_search_list_cubit.dart';

class BusListTopPart extends StatefulWidget {
  final String from, to;
  final DateTime date;
  final List<Buses>? noOfBuses;
  final String shift;

  const BusListTopPart({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.noOfBuses,
    required this.shift,
  });

  @override
  State<BusListTopPart> createState() => _BusListTopPartState();
}

class _BusListTopPartState extends State<BusListTopPart> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BusSearchListCubit>(context).buses;
  }

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
            "Route: ${widget.from.titleCase}  to  ${widget.to.titleCase}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${DateTimeFormatter.newBusformatDate(widget.date)} | ${widget.noOfBuses?.length} | ${widget.shift.titleCase}',
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
