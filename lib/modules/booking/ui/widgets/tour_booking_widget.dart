import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/widgets/network_image.dart';
import '../../model/tour_booking.dart';

class TourBookingWidget extends StatelessWidget {
  final TourBooking booking;
  final int flag;
  final Function onTap;

  const TourBookingWidget(
      {Key? key,
      required this.booking,
      required this.flag,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    return GestureDetector(
      onTap: () {
        Get.toNamed("/tourBookedDetail", arguments: [booking, flag])
            ?.whenComplete(() {
          onTap();
        });
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
                      booking.package!.packagedetail!.packageName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.grey[700],
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            booking
                                .package!.packagedetail!.destinationCity!.name
                                .toString(),
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
                            "${DateTimeFormatter.formatDate(booking.bookedDate!)} - ${DateTimeFormatter.formatDate(
                              booking.bookedDate!.add(
                                Duration(
                                    days: booking
                                            .package!.packagedetail!.dayCount! -
                                        1),
                              ),
                            )}",
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
                child: showNetworkImage(
                    booking.package!.packagedetail!.bannerImage.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
