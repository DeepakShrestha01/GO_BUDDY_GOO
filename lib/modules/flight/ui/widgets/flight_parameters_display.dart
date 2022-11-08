import 'package:flutter/material.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../configs/theme.dart';
import '../../model/flight_search_parameters.dart';
import '../../model/no_of_flightnotifier.dart';

class FlightParametersDisplay extends StatelessWidget {
  final FlightSearchParameters? parameter;

  const FlightParametersDisplay({
    Key? key,
    required this.parameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayString1 =
        "${parameter?.fromSector?.sectorCode} - ${parameter?.toSector?.sectorCode} || ";

    String displayString2 = "";

    if (parameter?.tripType == "R") {
      displayString2 +=
          "${"Return || ${DateTimeFormatter.formatDate(parameter!.departureDate!)}"} - ${DateTimeFormatter.formatDate(parameter!.returnDate!)}";
    } else {
      displayString2 +=
          "One-way || ${DateTimeFormatter.formatDate(parameter!.departureDate!)}";
    }

    displayString1 +=
        "${parameter!.adults! + parameter!.children! + parameter!.infants!} travellers";

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
            displayString1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            displayString2,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          ValueListenableBuilder(
            builder: (BuildContext context, v, Widget? child) {
              return ValueListenableBuilder(
                builder: (BuildContext context, value, Widget? child) {
                  return Text(
                    "${v + value} flights found",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  );
                },
                valueListenable: noOfOutboundFlights,
              );
            },
            valueListenable: noOfInboundFlights,
          ),
        ],
      ),
    );
  }
}
