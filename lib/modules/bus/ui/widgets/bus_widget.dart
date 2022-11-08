import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/facility.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../../hotel/model/hotel.dart';
import '../../model/bus.dart';
import '../../model/bus_booking_detail_parameters.dart';

class BusWidget extends StatelessWidget {
  final Bus? bus;

  const BusWidget({Key? key, this.bus}) : super(key: key);

  String getCancString() {
    BusBookingDetailParameters parameters =
        locator<BusBookingDetailParameters>();

    DateTime departureTime = parameters.departureDate!.add(Duration(
      hours: DateTimeFormatter.formatTimeWithAmPm(bus!.boardingTime.toString())
          .hour,
      minutes:
          DateTimeFormatter.formatTimeWithAmPm(bus!.boardingTime.toString())
              .minute,
    ));

    DateTime refundableDate = departureTime.subtract(
        Duration(hours: int.parse(bus!.cancellationPolicy!.hour.toString())));

    bool canBeRefunded;

    if (DateTime.now().isBefore(refundableDate)) {
      canBeRefunded = true;
    } else {
      canBeRefunded = false;
    }

    if (canBeRefunded) {
      return "${bus?.cancellationPolicy?.cancellationType}, if cancelled before ${DateTimeFormatter.formatTime(refundableDate.toIso8601String().split("T").last)}, ${DateTimeFormatter.formatDate(refundableDate)}.";
    } else {
      return "Non-refundable";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BusBookingDetailParameters parameters =
            locator<BusBookingDetailParameters>();
        parameters.selectedBusId = bus?.busDailyId;
        parameters.selectedBusDailyUpdatedStatus = bus?.busDailyUpdatedStatus;
        Get.toNamed("/busDetail");
      },
      child: Container(
        // padding: EdgeInsets.all(10),
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(backendServerUrlImage +
                              bus!.vehicleInventory!.galleryList![0].image
                                  .toString())),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 125,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(1.0),
                              Colors.black.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                bus!.busTag.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                AutoSizeText(
                                  "Rs. ${bus?.price.toString()}",
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                bus!.offer!.offerAvailableStatus!
                                    ? AutoSizeText(
                                        bus?.offer?.discountPricingType ==
                                                "rate"
                                            ? "${bus?.offer?.rate}% off"
                                            : "Rs. ${bus?.offer?.amount} off",
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " ${bus?.seatDetail?.availableSeat} Seats Available",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.5, bottom: 3.5, right: 50),
                          child: LinearPercentIndicator(
                            percent: bus!.seatDetail!.availableSeat! /
                                bus!.seatDetail!.totalSeatCount!,
                            progressColor: Theme.of(context).primaryColor,
                            lineHeight: 7.5,
                          ),
                        ),
                        Text(
                          " ${bus?.seatDetail?.totalSeatCount} Total Seats",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      Text(DateTimeFormatter.formatTime(
                          bus!.boardingTime.toString())),
                      Text(
                        "${bus?.busShift?.titleCase} shift",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // if (bus.cancellationPolicy != null)
            //   Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: Text(
            //       bus.cancellationPolicy.cancellationType,
            //       style: TextStyle(fontSize: 15.0),
            //     ),
            //   ),

            if (bus?.cancellationPolicy != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  bus?.cancellationPolicy?.cancellationType == "Non-refundable"
                      ? bus!.cancellationPolicy!.cancellationType.toString()
                      : getCancString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    bus!.facilitiesList!.isEmpty
                        ? const SizedBox()
                        : Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: bus?.facilitiesList?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Facility(
                                  facility: HotelFacility(
                                    name: bus?.facilitiesList?[index]
                                        .vehicleFacilities?.name,
                                    image: bus?.facilitiesList?[index]
                                        .vehicleFacilities?.image,
                                  ),
                                );
                              },
                            ),
                          ),
                    const SizedBox(width: 5),
                    if (bus?.vehicleInventory?.review != null)
                      RatingBarIndicator(
                        rating: bus?.vehicleInventory?.review
                                ?.averageReviewRating ??
                            0.0,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                        direction: Axis.horizontal,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
