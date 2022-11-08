import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../model/flight_booking.dart';

class FlightBookingWidget extends StatelessWidget {
  final FlightBooking booking;
  final int flag;

  const FlightBookingWidget({
    Key? key,
    required this.booking,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return GestureDetector(
      onTap: () {
        Get.toNamed("/flightBookedDetail", arguments: [booking, flag]);
      },
      child: Container(
        height: height * 0.175,
        width: width * 0.9,
        margin: const EdgeInsets.only(bottom: 20),
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Material(
              elevation: 10,
              child: Container(
                height: height * 0.155,
                width: width,
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: width * 0.4,
                  right: 4,
                  top: 5,
                  bottom: 5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "${booking.flightDetails?.first.sectorFrom}- ${booking.flightDetails?.first.sectorTo}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: PNGIconWidget(
                            asset: "assets/images/flight.png",
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            booking.flightDetails!.single.airline.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.calendar,
                          color: Colors.grey[700],
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            DateTimeFormatter.formatDate(
                              booking.flightDetails!.first.flightDate!,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: PNGIconWidget(
                            asset: "assets/images/flight.png",
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            booking.flightDetails!.first.flightNumber.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 15,
              child: Container(
                height: height * 0.175,
                color: Colors.white,
                width: width * 0.35,
                child: showNetworkImageNoFit(booking.flightDetails!.single.logo.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
