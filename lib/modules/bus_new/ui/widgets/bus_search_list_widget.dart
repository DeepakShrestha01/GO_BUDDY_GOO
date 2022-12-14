import 'package:flutter/material.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';

class BusSeachlistWidget extends StatelessWidget {
  final Buses data;
  const BusSeachlistWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyTheme.primaryColor,
      child: SizedBox(
        height: 190,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Operature Name :  ${data.operatorName}',
              ),
              Text(
                'Bus Type : ${data.busType}',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rs.${data.ticketPrice}'),
                ],
              ),
              Text('Departure Time : ${data.departureTime}'),
              Text('Journey Time : ${data.journeyHour}'),
              Center(
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text('Book Now')))
            ],
          ),
        ),
      ),
    );
  }
}
