// ignore: must_be_immutable
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel_booking_detail.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import 'filterCard.dart';

class SingleBookingDetail extends StatefulWidget {
  final HotelBookingDetail? hotelBookingDetail;
  final int? index;

  const SingleBookingDetail({Key? key, this.hotelBookingDetail, this.index})
      : super(key: key);

  @override
  _SingleBookingDetailState createState() => _SingleBookingDetailState();
}

class _SingleBookingDetailState extends State<SingleBookingDetail> {
  HotelBookingDetail? hotelBookingDetail;

  DateTime? checkInDated;
  DateTime? checkOutDated;

  DateTime? checkInDate;
  DateTime? checkOutDate;
  // selectDates(BuildContext context) {
  //   DateTime currentDateTime = DateTime.now();
  //   showCustomDateRangePicker(
  //     context,
  //     dismissible: true,
  //     minimumDate: currentDateTime.subtract(const Duration(days: 1)),
  //     maximumDate: currentDateTime.add(const Duration(days: 365 * 2)),
  //     onApplyClick: (startDate, endDate) {
  //       setState(() {});
  //       checkInDated = startDate;
  //       checkOutDated = endDate;
  //       hotelBookingDetail?.updateDates([startDate, endDate]);
  //     },
  //     onCancelClick: () {
  //       setState(() {});
  //       checkInDated = null;
  //       checkOutDated = null;
  //       showToast(text: "Select proper date");
  //       setState(() {});
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    hotelBookingDetail = widget.hotelBookingDetail;
    hotelBookingDetail?.updateTotalAmount();
  }

  final headerTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Colors.grey.shade700,
  );

  final valueTextStyle = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );

  TextStyle priceTextStyle = const TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 15,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }

  String getRoomSizeText() {
    final int? inverntoryId = hotelBookingDetail?.room?.inventoryId;
    final parameters = locator<HotelBookingDetailParameters>();
    final int? minRequiredRoom = parameters.minimumRequiredRoom(inverntoryId!);
    final int? userRoomSize = parameters.noOfRooms;

    if (minRequiredRoom != null) {
      if (userRoomSize! < minRequiredRoom) {
        return "Note: Minimum number of required room is $minRequiredRoom. Please update number of rooms required before procedding.";
      }
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedTileWidget(
      subtitleWidget: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total Amount"),
            Text("Rs. ${hotelBookingDetail?.totalPrice?.toStringAsFixed(2)}"),
          ],
        ),
      ),
      leadingWidget: null,
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: true,
      titlePadding: EdgeInsets.zero,
      titleWidget: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 1,
            horizontal: 17.5,
          ),
          child: Text(
            "Booking ${widget.index! + 1}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      expandedWidgets: [
        ListTile(
          leading: const PNGIconWidget(
            asset: "assets/images/address.png",
            color: MyTheme.primaryColor,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Room Type",
                style: headerTextStyle,
              ),
              Text(
                "${hotelBookingDetail?.room?.inventoryType}, ${hotelBookingDetail?.room?.inventoryName}",
                style: valueTextStyle,
              ),
            ],
          ),
        ),
        _divider(),
        Theme(
          data: Theme.of(context).copyWith(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: MyTheme.primaryColor),
          ),
          child: Builder(
            builder: (context) {
              return ListTile(
                leading: const PNGIconWidget(
                  asset: "assets/images/calendar.png",
                  color: MyTheme.primaryColor,
                ),
                title: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // selectDates(context);

                    DateTime currentDateTime = DateTime.now();
                    showCustomDateRangePicker(
                      context,
                      dismissible: true,
                      startDate: checkInDated ?? currentDateTime,
                      endDate: checkOutDated ??
                          currentDateTime.add(const Duration(days: 1)),
                      minimumDate:
                          currentDateTime.subtract(const Duration(days: 1)),
                      maximumDate:
                          currentDateTime.add(const Duration(days: 365 * 2)),
                      onApplyClick: (startDate, endDate) {
                        setState(() {});
                        checkInDated = startDate;
                        checkOutDated = endDate;
                        hotelBookingDetail?.updateDates([startDate, endDate]);
                      },
                      onCancelClick: () {
                        setState(() {});
                        checkInDated = null;
                        checkOutDated = null;
                        showToast(text: "Select proper date");
                        setState(() {});
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Check-In",
                            style: headerTextStyle,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            DateTimeFormatter.formatDate(
                                hotelBookingDetail!.checkInDate!),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Check-Out",
                            style: headerTextStyle,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            DateTimeFormatter.formatDate(
                                hotelBookingDetail!.checkOutDate!),
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _divider(),
        ListTile(
          leading: const Icon(
            CupertinoIcons.person_2,
            color: MyTheme.primaryColor,
          ),
          title: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              await hotelBookingDetail?.showGuestCounterDialog(context);
              setState(() {});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${hotelBookingDetail!.maxAdults!.value + hotelBookingDetail!.maxChildren!.value} Guests | ${hotelBookingDetail?.noOfRooms?.value} Rooms",
                  style: valueTextStyle,
                ),
                Text(
                  "${hotelBookingDetail?.maxAdults?.value} Adults | ${hotelBookingDetail?.maxChildren?.value} Children",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (getRoomSizeText() != null) _divider(),
        if (getRoomSizeText() != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              getRoomSizeText(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        _divider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 1,
            horizontal: 17.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Price Breakdown"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rate", style: priceTextStyle),
                  Text(hotelBookingDetail!.room!.europeanPlanSelected!
                      ? "Rs. ${double.parse(hotelBookingDetail!.room!.inventoryEuropeanPlan.toString()).toStringAsFixed(2)}"
                      : "Rs. ${double.parse(hotelBookingDetail!.room!.inventoryBedAndBreakfastPlan.toString()).toStringAsFixed(2)}"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Number of Days", style: priceTextStyle),
                  Text("x${hotelBookingDetail?.noOfDays}"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Number of Rooms", style: priceTextStyle),
                  Text("x${hotelBookingDetail?.noOfRooms?.value}"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discount", style: priceTextStyle),
                  Text(
                    hotelBookingDetail!.room!.percentage!
                        ? "${hotelBookingDetail?.room?.offerRate?.toStringAsFixed(2)} %"
                        : "Rs. ${(hotelBookingDetail!.room!.offerRate! * hotelBookingDetail!.noOfRooms!.value).toStringAsFixed(2)}",
                    // : "Rs. ${(hotelBookingDetail!.room!.offerRate! * hotelBookingDetail.noOfDays * hotelBookingDetail!.noOfRooms!.value).toStringAsFixed(2)}",
                  ),
                ],
              ),
              _divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Amount"),
                  Text(
                      "Rs. ${hotelBookingDetail?.totalPrice?.toStringAsFixed(2)}"),
                ],
              ),
            ],
          ),
        ),
        _divider()
      ],
    );
  }
}
