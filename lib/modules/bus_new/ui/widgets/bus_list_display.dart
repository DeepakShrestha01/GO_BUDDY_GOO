import 'package:flutter/material.dart';

import '../../model/new_bus_search_list_response.dart';

class BusListDisplay extends StatelessWidget {
  final NewBusSearchListResponse bus;
  const BusListDisplay({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            // child: Text(),
          )
        ],
      ),
    );
  }
}
