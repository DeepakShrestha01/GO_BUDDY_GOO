import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/functions/guest_string.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel_booking_detail.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import '../../model/hotel_inventory.dart';

class HotelRoom extends StatefulWidget {
  final HotelInventory? room;

  const HotelRoom({Key? key, this.room}) : super(key: key);

  @override
  _HotelRoomState createState() => _HotelRoomState();
}

class _HotelRoomState extends State<HotelRoom> {
  bool? roomAdded;
  @override
  void initState() {
    super.initState();
    roomAdded = false;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;

    String features = "";
    for (var x in widget.room!.inventoryFacilities!) {
      features = "$features, ${x.name}";
    }

    if (features.isNotEmpty) features = features.substring(2, features.length);

    double europeanPrice =
        double.parse(widget.room!.inventoryEuropeanPlan.toString());
    double bAndBPrice =
        double.parse(widget.room!.inventoryBedAndBreakfastPlan.toString());

    double price;

    if (europeanPrice < bAndBPrice) {
      price = europeanPrice;
    } else {
      price = bAndBPrice;
    }

    if (price == 0.0) {
      if (europeanPrice > bAndBPrice) {
        price = europeanPrice;
      } else {
        price = bAndBPrice;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // HotelBookingDetailParameters parameters =
              //     locator<HotelBookingDetailParameters>();
              // parameters.roomId = room.inventoryId;
              // parameters.roomName = room.inventoryType;
              Get.toNamed("/roomDetail", arguments: widget.room);
            },
            child: Column(
              children: [
                Material(
                  elevation: 10,
                  child: Container(
                    height: height * 0.155,
                    // width: width * 0.9,
                    // margin: EdgeInsets.only(bottom: 30),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: height * 0.155,
                          width: width * 0.30,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              showNetworkImage(
                                  widget.room!.inventoryImage.toString()),
                              if (widget.room?.offerRate != 0.0)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5, horizontal: 5),
                                    decoration: const BoxDecoration(
                                      color: MyTheme.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: AutoSizeText(
                                      widget.room!.percentage!
                                          ? "${widget.room?.offerRate?.toStringAsFixed(2)} %off"
                                          : "${"Rs. ${widget.room?.offerRate?.toStringAsFixed(0)}"} off",
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${widget.room?.inventoryType}, ${widget.room?.inventoryName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  "Max Guests: ${getGuestString(widget.room!.noOfAdult!, widget.room!.noOfChild!)}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Rs. ${price.toStringAsFixed(0)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                              color: MyTheme.primaryColor,
                                              fontSize: 16,
                                            ),
                                      ),
                                      TextSpan(
                                        text: " per room per night",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                              color: MyTheme.primaryColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  features.isEmpty ? "" : "- $features",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: widget.room!.addedToBooking,
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return Checkbox(
                                activeColor: MyTheme.primaryColor,
                                value: widget.room?.addedToBooking.value,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity:
                                    const VisualDensity(horizontal: 0),
                                onChanged: (_) {
                                  HotelBookingDetailParameters parameters =
                                      locator<HotelBookingDetailParameters>();

                                  parameters.addBooking(HotelBookingDetail(
                                    checkInDate: DateTimeFormatter.stringToDate(
                                        parameters.dateRange?.start),
                                    checkOutDate:
                                        DateTimeFormatter.stringToDate(
                                            parameters.dateRange?.end),
                                    hotelId: parameters.hotel?.hotelId,
                                    hotelName: parameters.hotel?.hotelName,
                                    // noOfDays: DateTimeFormatter.getNoOfDays(
                                    //     parameters.dateRange.start,
                                    //     parameters.dateRange.end),
                                    room: widget.room,
                                    maxAdults: ValueNotifier<int>(
                                        parameters.maxAdults!),
                                    maxChildren: ValueNotifier<int>(
                                        parameters.maxChildren!),
                                    noOfRooms: ValueNotifier<int>(
                                        parameters.noOfRooms!),
                                  ));

                                  roomAdded = !roomAdded!;

                                  setState(() {});
                                });
                          },
                        ),
                       
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
