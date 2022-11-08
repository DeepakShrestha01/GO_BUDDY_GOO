import 'dart:convert';

// import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/functions/format_date.dart';
import 'hotel_inventory.dart';

class HotelBookingDetail {
  String? hotelName;
  int? hotelId;

  DateTime? checkInDate;
  DateTime? checkOutDate;

  ValueNotifier<int>? maxAdults;
  ValueNotifier<int>? maxChildren;
  ValueNotifier<int>? noOfRooms;
  ValueNotifier<int>? noOfDays;

  double? totalPrice;

  HotelInventory? room;

  HotelBookingDetail({
    this.hotelName,
    this.hotelId,
    this.checkInDate,
    this.checkOutDate,
    this.maxAdults,
    this.maxChildren,
    this.noOfRooms,
    this.noOfDays,
    this.totalPrice,
    this.room,
  }) {
    updateTotalAmount();
  }

  HotelBookingDetail copyWith({
    String? hotelName,
    int? hotelId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    ValueNotifier<int>? maxAdults,
    ValueNotifier<int>? maxChildren,
    ValueNotifier<int>? noOfRooms,
    ValueNotifier<int>? noOfDays,
    double? roomRate,
    double? totalPrice,
    HotelInventory? room,
  }) {
    return HotelBookingDetail(
      hotelName: hotelName ?? this.hotelName,
      hotelId: hotelId ?? this.hotelId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      maxAdults: maxAdults ?? this.maxAdults,
      maxChildren: maxChildren ?? this.maxChildren,
      noOfRooms: noOfRooms ?? this.noOfRooms,
      noOfDays: noOfDays ?? this.noOfDays,
      totalPrice: totalPrice ?? this.totalPrice,
      room: room ?? this.room,
    );
  }

  factory HotelBookingDetail.fromMap(Map<String, dynamic> map) {
    return HotelBookingDetail(
      hotelName: map['hotelName'],
      hotelId: map['hotelId'],
      checkInDate: DateTime.fromMillisecondsSinceEpoch(map['checkInDate']),
      checkOutDate: DateTime.fromMillisecondsSinceEpoch(map['checkOutDate']),
      maxAdults: ValueNotifier<int>(map['maxAdults']),
      maxChildren: ValueNotifier<int>(map['maxChildren']),
      noOfRooms: ValueNotifier<int>(map['noOfRooms']),
      noOfDays: map['noOfDays'],
      totalPrice: map['totalPrice'],
      room: HotelInventory.fromJson(map['room']),
    );
  }

  factory HotelBookingDetail.fromJson(String source) =>
      HotelBookingDetail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HotelBookingDetail(hotelName: $hotelName, hotelId: $hotelId, checkInDate: $checkInDate, checkOutDate: $checkOutDate, maxAdults: $maxAdults, maxChildren: $maxChildren, noOfRooms: $noOfRooms, noOfDays: $noOfDays, totalPrice: $totalPrice, room: $room)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HotelBookingDetail &&
        other.hotelName == hotelName &&
        other.hotelId == hotelId &&
        other.checkInDate == checkInDate &&
        other.checkOutDate == checkOutDate &&
        other.maxAdults == maxAdults &&
        other.maxChildren == maxChildren &&
        other.noOfRooms == noOfRooms &&
        other.noOfDays == noOfDays &&
        other.totalPrice == totalPrice &&
        other.room == room;
  }

  @override
  int get hashCode {
    return hotelName.hashCode ^
        hotelId.hashCode ^
        checkInDate.hashCode ^
        checkOutDate.hashCode ^
        maxAdults.hashCode ^
        maxChildren.hashCode ^
        noOfRooms.hashCode ^
        noOfDays.hashCode ^
        totalPrice.hashCode ^
        room.hashCode;
  }

  void updateDates(List<DateTime> selectedDates) {
    checkInDate = selectedDates[0];
    checkOutDate = selectedDates[1];

    noOfDays = DateTimeFormatter.getNoOfDays(checkInDate, checkOutDate)
        as ValueNotifier<int>?;

    updateTotalAmount();
  }

  updateTotalAmount() {
    try {
      if (room!.europeanPlanSelected!) {
        if (room!.percentage!) {
          totalPrice = double.parse(room!.inventoryEuropeanPlan!) *
              // noOfDays *
              noOfRooms!.value *
              (1 - (room!.offerRate! / 100));
        } else {
          totalPrice =
              (double.parse(room!.inventoryEuropeanPlan!) - room!.offerRate!) *
                  // noOfDays *
                  noOfRooms!.value;
        }
      } else {
        if (room!.percentage!) {
          totalPrice = double.parse(room!.inventoryBedAndBreakfastPlan!) *
              // noOfDays *
              noOfRooms!.value *
              (1 - (room!.offerRate! / 100));
        } else {
          totalPrice = (double.parse(room!.inventoryBedAndBreakfastPlan!) -
                  room!.offerRate!) *
              // noOfDays *
              noOfRooms!.value;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // selectDates(BuildContext context) async {
  //   DateTime currentDateTime = DateTime.now();
  //   // List<DateTime> selectedDates = await DateRangePicker.showDatePicker(
  //   //   context: context,
  //   //   initialFirstDate: checkInDate ?? currentDateTime,
  //   //   initialLastDate:
  //   //       checkOutDate ?? currentDateTime.add(const Duration(days: 1)),
  //   //   firstDate: currentDateTime.subtract(const Duration(days: 1)),
  //   //   lastDate: currentDateTime.add(const Duration(days: 365 * 2)),
  //   // );

  //   if (selectedDates != null) {
  //     if (selectedDates.length == 2 &&
  //         selectedDates[0].isBefore(selectedDates[1])) {
  //       updateDates(selectedDates);
  //     } else {
  //       showToast(text: "Select proper date");
  //     }
  //   } else {
  //     showToast(text: "Select proper date");
  //   }
  // }

  increaseMaxAdult() {
    maxAdults?.value++;

    if (maxAdults!.value > room!.noOfAdult!) {
      noOfRooms!.value++;
    }

    checkRoomCapacity();
  }

  decreaseMaxAdult() {
    if (maxAdults!.value > 1) {
      maxAdults!.value--;
    }

    checkRoomCapacity();
  }

  increaseMaxChildren() {
    maxChildren!.value++;
    checkRoomCapacity();
  }

  decreaseMaxChildren() {
    if (maxChildren!.value > 0) {
      maxChildren!.value--;
    }
    checkRoomCapacity();
  }

  increaseNoOfRooms() {
    noOfRooms!.value++;
    updateTotalAmount();
  }

  decreaseNoOfRooms() {
    int maxRoomsAccAdult = (maxAdults!.value / room!.noOfAdult!).ceil();
    int maxRoomsAccChildren;

    try {
      maxRoomsAccChildren = (maxChildren!.value / room!.noOfChild!).ceil();
    } catch (e) {
      maxRoomsAccChildren = 1;
    }
    if (noOfRooms!.value > 1 &&
        noOfRooms!.value > maxRoomsAccAdult &&
        noOfRooms!.value > maxRoomsAccChildren) {
      noOfRooms!.value--;
    }
    updateTotalAmount();
  }

  checkRoomCapacity() {
    int maxRoomsAccAdult = (maxAdults!.value / room!.noOfAdult!).ceil();
    int maxRoomsAccChildren;

    try {
      maxRoomsAccChildren = (maxChildren!.value / room!.noOfChild!).ceil();
    } catch (e) {
      maxRoomsAccChildren = 1;
    }

    noOfRooms?.value = maxRoomsAccAdult >= maxRoomsAccChildren
        ? maxRoomsAccAdult
        : maxRoomsAccChildren;

    updateTotalAmount();
  }

  showGuestCounterDialog(BuildContext context) async {
    await showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Adults"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: increaseMaxAdult,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(maxAdults!.value.toString()),
                            ),
                          );
                        },
                        valueListenable: maxAdults as ValueNotifier,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: decreaseMaxAdult,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Children"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: increaseMaxChildren,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(maxChildren!.value.toString()),
                            ),
                          );
                        },
                        valueListenable: maxChildren as ValueNotifier,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: decreaseMaxChildren,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
                thickness: 1,
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Rooms"),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: increaseNoOfRooms,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.green,
                            size: 25,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return SizedBox(
                            width: 28,
                            child: Center(
                              child: Text(noOfRooms!.value.toString()),
                            ),
                          );
                        },
                        valueListenable: noOfRooms as ValueNotifier,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: decreaseNoOfRooms,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.minus_circle,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      context: context,
      barrierDismissible: true,
    );
  }
}
