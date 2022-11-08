import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/functions/guest_string.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/dotIndicators.dart';
import '../../../../common/widgets/facility.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel.dart';
import '../../model/hotel_booking_detail.dart';
import '../../model/hotel_booking_detail_parameters.dart';
import '../../model/hotel_inventory.dart';
import 'hotelDetail.dart';

// show HotelDetailTop;

class RoomDetailLoadedWidget extends StatefulWidget {
  final HotelInventory? room;

  const RoomDetailLoadedWidget({Key? key, this.room}) : super(key: key);
  @override
  _RoomDetailLoadedWidgetState createState() => _RoomDetailLoadedWidgetState();
}

class _RoomDetailLoadedWidgetState extends State<RoomDetailLoadedWidget> {
  HotelInventory? room;

  HotelBookingDetailParameters? parameters;
  List<String> galleryUrls = [];
  ValueNotifier<int>? currentIndexGalleryCarousel;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    parameters = locator<HotelBookingDetailParameters>();
    currentIndexGalleryCarousel = ValueNotifier(0);
    for (var x in room!.inventoryGallery!) {
      galleryUrls.add(x.image.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPrice = room!.europeanPlanSelected!
        ? room?.inventoryEuropeanPlan
        : room?.inventoryBedAndBreakfastPlan;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              HotelDetailTop(
                hotel: parameters?.hotel,
                inventoryReviews: room!.inventoryReviews,
                rating: room!.inventoryRatingByUser,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 7.5),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        margin: const EdgeInsets.symmetric(horizontal: 7.5),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  "/photoView",
                                  arguments: galleryUrls,
                                );
                              },
                              child: CarouselSlider(
                                items: List<Widget>.generate(
                                  galleryUrls.length,
                                  (i) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: showNetworkImage(galleryUrls[i]),
                                  ),
                                ),
                                options: CarouselOptions(
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {
                                    currentIndexGalleryCarousel?.value = index;
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 3,
                              child: Container(
                                alignment: Alignment.center,
                                child: DotIndicatorWidget(
                                  dotCount: galleryUrls.length,
                                  currentIndex: currentIndexGalleryCarousel!,
                                  activeColor: MyTheme.primaryColor,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RoomDetailButtom(
                        room: room!,
                        onEuropeanSelected: (bool? value) {
                          widget.room?.europeanPlanSelected = true;
                          setState(() {});
                        },
                        onBnBSelected: (bool? value) {
                          widget.room?.europeanPlanSelected = false;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              // height: 75,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border(
                  top: BorderSide(width: 1, color: Colors.grey.shade400),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rs. ${double.parse(selectedPrice.toString()).toInt()} / NIGHT",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      parameters?.addBooking(HotelBookingDetail(
                        checkInDate: DateTimeFormatter.stringToDate(
                            parameters?.dateRange?.start),
                        checkOutDate: DateTimeFormatter.stringToDate(
                            parameters?.dateRange?.end),
                        hotelId: parameters?.hotel?.hotelId,
                        hotelName: parameters?.hotel?.hotelName,
                        noOfDays: ValueNotifier<int>(
                            DateTimeFormatter.getNoOfDays(
                                parameters?.dateRange?.start,
                                parameters?.dateRange?.end)),
                        // noOfDays: DateTimeFormatter.getNoOfDays(
                        //     parameters.dateRange.start,
                        //     parameters.dateRange.end),
                        room: widget.room,
                        maxAdults: ValueNotifier<int>(parameters!.maxAdults!),
                        maxChildren:
                            ValueNotifier<int>(parameters!.maxChildren!),
                        noOfRooms: ValueNotifier<int>(parameters!.noOfRooms!),
                      ));

                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: MyTheme.primaryColor,
                    ),
                    child: ValueListenableBuilder(
                      builder: (BuildContext context, value, Widget? child) {
                        return Text(
                          room!.addedToBooking.value
                              ? "Remove from booking".toUpperCase()
                              : "Add to booking".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        );
                      },
                      valueListenable: room!.addedToBooking,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomDetailButtom extends StatefulWidget {
  final HotelInventory room;
  final Function(bool?) onEuropeanSelected;
  final Function(bool?) onBnBSelected;

  const RoomDetailButtom({
    Key? key,
    required this.room,
    required this.onEuropeanSelected,
    required this.onBnBSelected,
  }) : super(key: key);

  @override
  _RoomDetailButtomState createState() => _RoomDetailButtomState();
}

class _RoomDetailButtomState extends State<RoomDetailButtom> {
  HotelBookingDetailParameters? parameters;

  @override
  void initState() {
    super.initState();
    parameters = locator<HotelBookingDetailParameters>();
  }

  getHotelCancString(int hours, String checkInDate, String checkInTime) {
    DateTime refundableDate = DateTimeFormatter.stringToDateWithTime(
      checkInDate,
      checkInTime,
    ).subtract(Duration(hours: hours));

    bool canBeRefunded;

    if (DateTime.now().isBefore(refundableDate)) {
      canBeRefunded = true;
    } else {
      canBeRefunded = false;
    }

    if (canBeRefunded) {
      return "${"Fully-refundable, if cancelled before ${DateTimeFormatter.formatTime(refundableDate.toString().split(" ").last)}, ${DateTimeFormatter.formatDate(refundableDate)}"}.";
    } else {
      return "Non-refundable";
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
    );

    List<InventoryIty> freeFacilities = [];
    List<InventoryIty> paidFacilities = [];

    widget.room.inventoryFacilities?.forEach((facility) {
      if (!facility.chargeable!) {
        freeFacilities.add(facility);
      } else {
        paidFacilities.add(facility);
      }
    });

    List<InventoryIty> amenities = [];

    widget.room.inventoryAmenities?.forEach((a) {
      amenities.add(a);
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${widget.room.inventoryType}, ${widget.room.inventoryName}"),
                            Text(
                              getGuestString(widget.room.noOfAdult!,
                                  widget.room.noOfChild!),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.room.offerRate != 0.0)
                        Text(
                          widget.room.percentage!
                              ? "${widget.room.offerRate?.toStringAsFixed(2)} %off"
                              : "Rs. ${widget.room.offerRate?.toStringAsFixed(0)} off",
                          style: const TextStyle(
                            color: MyTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey, height: 15, thickness: 1),
          double.parse(widget.room.inventoryEuropeanPlan.toString()) != 0.0
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                          "European Plan (Rs. ${double.parse(widget.room.inventoryEuropeanPlan.toString()).toInt()})"),
                    ),
                    Checkbox(
                      activeColor: MyTheme.primaryColor,
                      onChanged: widget.onEuropeanSelected,
                      value: widget.room.europeanPlanSelected,
                    ),
                  ],
                )
              : const SizedBox(),
          double.parse(widget.room.inventoryBedAndBreakfastPlan.toString()) !=
                  0.0
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                          "Bed & Breakfast Plan (Rs. ${double.parse(widget.room.inventoryBedAndBreakfastPlan.toString()).toInt()})"),
                    ),
                    Checkbox(
                      activeColor: MyTheme.primaryColor,
                      onChanged: widget.onBnBSelected,
                      value: !widget.room.europeanPlanSelected!,
                    ),
                  ],
                )
              : const SizedBox(),
          const Divider(color: Colors.grey, height: 15, thickness: 1),
          const Text(
            "About Room",
            style: headerTextStyle,
          ),
          const SizedBox(height: 5),
          Text(
            widget.room.inventoryDescription.toString(),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10),
          const Text(
            "Bed Type",
            style: headerTextStyle,
          ),
          const SizedBox(height: 5),
          Text(
            widget.room.inventoryBed!.map((e) => e.name).toList().join(", "),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10),
          freeFacilities.isEmpty
              ? Container()
              : const Text("Facilities", style: headerTextStyle),
          freeFacilities.isEmpty
              ? Container()
              : SizedBox(
                  height: 50,
                  child: Center(
                    child: ListView.separated(
                      itemCount: freeFacilities.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Facility(
                          facility: HotelFacility(
                            name: freeFacilities[i].name,
                            image: freeFacilities[i].image,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 10);
                      },
                    ),
                  ),
                ),
          const SizedBox(height: 5),
          paidFacilities.isEmpty
              ? Container()
              : const Text("Paid Facilities", style: headerTextStyle),
          paidFacilities.isEmpty
              ? Container()
              : SizedBox(
                  height: 50,
                  child: Center(
                    child: ListView.separated(
                      itemCount: paidFacilities.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Facility(
                          facility: HotelFacility(
                            name: paidFacilities[i].name,
                            image: paidFacilities[i].image,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 10);
                      },
                    ),
                  ),
                ),
          if (amenities.isNotEmpty)
            const Text("Amenities", style: headerTextStyle),
          if (amenities.isNotEmpty)
            SizedBox(
              height: 50,
              child: Center(
                child: ListView.separated(
                  itemCount: amenities.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return Facility(
                      facility: HotelFacility(
                        name: amenities[i].name,
                        image: amenities[i].image,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10);
                  },
                ),
              ),
            ),
          const SizedBox(height: 5),
          widget.room.inventoryFeature!.isEmpty
              ? Container()
              : const Text("Room Features", style: headerTextStyle),
          const SizedBox(height: 5),
          widget.room.inventoryFeature!.isEmpty
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(widget.room.inventoryFeature!.length,
                      (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: BulletItemWidget(
                          text: widget.room.inventoryFeature?[index].name),
                    );
                  }),
                ),
          const SizedBox(height: 5),
          widget.room.cancellationType == null
              ? Container()
              : Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Cancellation Policy: ",
                        style: headerTextStyle,
                      ),
                      TextSpan(
                        text: widget.room.cancellationType == "Non-refundable"
                            ? widget.room.cancellationType
                            : getHotelCancString(
                                int.parse(
                                    widget.room.cancellationHour.toString()),
                                parameters?.dateRange?.start,
                                widget.room.checkIn ?? "",
                              ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class GalleryWithCarousel extends StatelessWidget {
  final List<String> gallery;

  GalleryWithCarousel({Key? key, required this.gallery}) : super(key: key);

  ValueNotifier<int> currentIndexGalleryCarousel = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(
              "/photoView",
              arguments: gallery,
            );
          },
          child: CarouselSlider(
            items: List<Widget>.generate(
              gallery.length,
              (i) => Container(
                height: MediaQuery.of(context).size.height * 0.25,
                margin: const EdgeInsets.symmetric(horizontal: 7.5),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5),
                ),
                child: showNetworkImage(gallery[i]),
              ),
            ),
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                currentIndexGalleryCarousel.value = index;
              },
            ),
          ),
        ),
        Positioned(
          bottom: 3,
          child: Container(
            alignment: Alignment.center,
            child: DotIndicatorWidget(
              dotCount: gallery.length,
              currentIndex: currentIndexGalleryCarousel,
              activeColor: MyTheme.primaryColor,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
