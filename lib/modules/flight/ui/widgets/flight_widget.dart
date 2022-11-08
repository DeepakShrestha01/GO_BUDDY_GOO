import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../model/flight_search_parameters.dart';
import '../../model/flightsearchresultdata.dart';

class FlightDetailWidget extends StatefulWidget {
  final Bound? flight;
  final bool isSelected;
  const FlightDetailWidget({
    Key? key,
    required this.flight,
    required this.isSelected,
  }) : super(key: key);

  @override
  _FlightDetailWidgetState createState() => _FlightDetailWidgetState();
}

class _FlightDetailWidgetState extends State<FlightDetailWidget> {
  Bound? flight;

  FlightSearchParameters? params;

  showFlightDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black12.withOpacity(0.75),
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Flight Details"),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          CupertinoIcons.multiply_circle_fill,
                          color: MyTheme.primaryColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "${flight?.departureCity} to ${flight?.arrivalCity}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "${flight?.agency}, ${DateTimeFormatter.formatDateServer(flight?.flightDate)}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "${flight?.departureTime} - ${flight?.arrivalTime}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Flight No",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            flight!.flightNo.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Class",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            flight!.classCode.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Free Baggage",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            flight!.baggage.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Refundable",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            flight!.refundable.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (flight?.cancellation != null)
                        if (flight?.cancellation?.before24Hours != null &&
                            flight!.cancellation!.before24Hours!.isNotEmpty &&
                            flight?.cancellation?.after24Hours != null &&
                            flight!.cancellation!.after24Hours!.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Cancellation",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2.0),
                              if (flight!
                                  .cancellation!.before24Hours!.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "  Before 24 hours",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      flight!.cancellation!.before24Hours
                                          .toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 2.0),
                              if (flight!
                                  .cancellation!.after24Hours!.isNotEmpty)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "  After 24 hours",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      flight!.cancellation!.after24Hours
                                          .toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Adult Fare",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "${"Rs. ${flight?.airFare?.adultFare}"} x ${params?.adults}",
                            //  +
                            // " x " +
                            // parameters.adults.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      if (flight?.airFare?.adultDiscount != "0.0" &&
                          flight?.airFare?.adultDiscount != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Adult Discount (Airline)${params?.adults}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "${"Rs. ${flight?.airFare?.adultDiscount}"} x ${params?.adults}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      if (flight?.airFare?.gbgAdultDiscount != "0.0" &&
                          flight?.airFare?.gbgAdultDiscount != null)
                        const SizedBox(height: 5.0),

                      if (flight?.airFare?.gbgAdultDiscount != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Adult Discount (Platform)",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              flight?.airFare?.gbgDiscountType?.toLowerCase() ==
                                      "percentage"
                                  ? "${flight?.airFare?.gbgAdultDiscount}%"
                                  : "${"Rs. ${flight?.airFare?.gbgAdultDiscount}"} x ${params?.adults}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      if (flight?.airFare?.gbgAdultDiscount != "0.0" &&
                          flight?.airFare?.gbgAdultDiscount != null)
                        const SizedBox(height: 5.0),

                      if (params?.children != 0)
                        Column(
                          children: [
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Child Fare",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${"Rs. ${flight?.airFare?.childFare}"} x ${params?.children}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            if (flight?.airFare?.childDiscount != "0" &&
                                flight?.airFare?.childDiscount != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Child Discount (Airline)",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${"Rs. ${flight?.airFare?.childDiscount}"} x ${params?.children}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            if (flight?.airFare?.childDiscount != "0.0")
                              const SizedBox(height: 5.0),
                            if (flight?.airFare?.gbgChildDiscount != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Child Discount (Platform)",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    flight?.airFare?.gbgDiscountType
                                                ?.toLowerCase() ==
                                            "percentage"
                                        ? "${flight?.airFare?.gbgChildDiscount}%"
                                        : "${"Rs. ${flight?.airFare?.gbgChildDiscount}"} x ${params?.children}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            if (flight?.airFare?.gbgChildDiscount != null)
                              const SizedBox(height: 5.0),
                          ],
                        ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tax",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "${"Rs. ${flight?.airFare?.taxAmount}"} x ${params!.adults! + params!.children!}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Fuel Surcharge",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "${"Rs. ${flight?.airFare?.surcharge}"} x ${params!.adults! + params!.children!}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),

                      const Divider(),

                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Text(
                      //     "* Prices are exclusive of taxes and surcharges",
                      //     style: TextStyle(fontSize: 14),
                      //   ),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       "Total Amount",
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //     ),
                      //     Text(
                      //       "Rs. " + "flight.airFare.adultFare",
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 10.0),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    flight = widget.flight;

    bool hasGbgDiscount = flight?.airFare?.totalPriceAfterDiscount !=
        flight?.airFare?.totalPriceBeforeDiscount;

    params = locator<FlightSearchParameters>();

    String discountAmount = "0.0";

    if (flight?.airFare?.gbgDiscountType?.toLowerCase() != "percentage") {
      discountAmount = (double.parse(
                  flight!.airFare!.totalPriceBeforeDiscount.toString()) -
              double.parse(flight!.airFare!.totalPriceAfterDiscount.toString()))
          .toStringAsFixed(2);
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 25, left: 20.0, right: 20.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color:
              widget.isSelected ? MyTheme.primaryColor : Colors.grey.shade300,
          width: widget.isSelected ? 2.0 : 0.5,
        ),
        boxShadow: widget.isSelected
            ? [
                const BoxShadow(
                  color: Colors.grey,
                  offset: Offset(5, 5),
                  blurRadius: 100,
                  spreadRadius: 10,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(10, 10),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight!.departureCity!.titleCase,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: MyTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: showNetworkImageNoFit(flight!.vendorImage.toString()),
                ),
              ),
              const SizedBox(width: 5.0),
              Text(
                flight!.arrivalCity!.titleCase,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: MyTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${"(${flight?.sectorPair?.split("-").first}"})",
                style: TextStyle(
                  fontSize: 16.0,
                  color: MyTheme.primaryColor.withOpacity(0.65),
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Center(
                  child: Text(
                    flight!.flightNo.toString(),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              Text(
                "${"(${flight?.sectorPair?.split("-").last}"})",
                style: TextStyle(
                  fontSize: 16.0,
                  color: MyTheme.primaryColor.withOpacity(0.65),
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              "Class - ${flight?.classCode}",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Departure Time",
                style: TextStyle(
                  fontSize: 14.0,
                  color: MyTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 5.0),
              Text(
                "Arrival Time",
                style: TextStyle(
                  fontSize: 14.0,
                  color: MyTheme.secondaryColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight!.departureTime.toString(),
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    flight!.flightDuration.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: MyTheme.secondaryColor,
                    ),
                  ),
                ),
              ),
              Text(
                flight!.arrivalTime.toString(),
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Image.asset(
            "assets/images/flight_display.png",
            height: 40,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Policy: ",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: MyTheme.secondaryColor,
                    ),
                  ),
                  Text(
                    flight?.refundable?.toLowerCase() == "yes"
                        ? "Refundable"
                        : "Non-Refundable",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(width: 15.0),
              if (flight!.baggage!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Free Baggage: ",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: MyTheme.secondaryColor,
                      ),
                    ),
                    Text(
                      flight!.baggage.toString(),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Rs. ${flight?.airFare?.totalPriceAfterDiscount}",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (hasGbgDiscount) const SizedBox(width: 10.0),
                  if (hasGbgDiscount)
                    Text(
                      "Rs. ${flight?.airFare?.totalPriceBeforeDiscount}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: MyTheme.secondaryColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (hasGbgDiscount)
            Text(
              flight?.airFare?.gbgDiscountType?.toLowerCase() == "percentage"
                  ? "${flight?.airFare?.gbgAdultDiscount}% discount"
                  : "Rs. $discountAmount discount",
              style: TextStyle(
                fontSize: 16.0,
                color: MyTheme.secondaryColor,
              ),
            ),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showFlightDetail(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 50,
                ),
                child: Text(
                  "View Details",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: MyTheme.primaryColor.withOpacity(0.65),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
